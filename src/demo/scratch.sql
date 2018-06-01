
--alter system set PLSQL_CCFLAGS = 
--    'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:FALSE'
--    scope=BOTH;
--execute dbms_utility.compile_schema('WTP',TRUE,FALSE);
--grant create synonym to wtp_demo;

-- DBMS_PROFILER has a startup time penalty, see the documentation.
-- "Some PL/SQL operations, such as the first execution of a PL/SQL unit, may involve I/O to catalog tables to load the byte code for the PL/SQL unit being executed. Also, it may take some time executing package initialization code the first time a package procedure or function is called."
-- https://docs.oracle.com/cd/E11882_01/appdev.112/e40758/d_profil.htm#CHDJGHEG

execute wtplsql.test_run('TRIGGER_TEST_PKG');
execute wt_text_report.dbms_out(in_runner_name => 'TRIGGER_TEST_PKG', in_detail_level => 50);

execute wtplsql.test_run('TABLE_TEST_PKG');
execute wt_text_report.dbms_out(in_runner_name => 'TABLE_TEST_PKG', in_detail_level => 50);

execute wtplsql.test_run('UT_BETWNSTR');
execute wt_text_report.dbms_out(in_runner_name => 'UT_BETWNSTR', in_detail_level => 50);

execute wtplsql.test_run('UT_CALC_SECS_BETWEEN');
execute wt_text_report.dbms_out(in_runner_name => 'UT_CALC_SECS_BETWEEN', in_detail_level => 50);

select wtp.wtplsql.show_version from dual;
execute wt_assert.isnull('Test1','');

execute wtplsql.test_all;
execute wt_text_report.dbms_out(in_detail_level => 50);

execute dbms_utility.compile_schema('WTP_DEMO',TRUE,FALSE);

begin
   $IF $$WTPLSQL_ENABLE
   $THEN
      dbms_output.put_line('WTPLSQL_ENABLE is TRUE');
   $END
   dbms_output.put_line('Check WTPLSQL_ENABLE is Done.');
end;
/

with q_last_test_run as (
select dbout_owner
      ,dbout_name
      ,dbout_type
      ,max(start_dtm)          MAX_START_DTM
 from  wt_test_runs
 group by dbout_owner
      ,dbout_name
      ,dbout_type
)
select obj.owner
      ,obj.object_type
      ,obj.object_name
      ,ltr.max_start_dtm       LAST_TEST_DTM
      ,run.id                  TEST_RUN_ID
      ,stat.test_yield
      ,stat.code_coverage
 from  all_objects  obj
  left join q_last_test_run  ltr
            on  ltr.dbout_owner = obj.owner
            and ltr.dbout_name  = obj.object_name
            and ltr.dbout_type  = obj.object_type
  left join wt_test_runs  run
            on  run.dbout_owner = ltr.dbout_owner
            and run.dbout_name  = ltr.dbout_name
            and run.dbout_type  = ltr.dbout_type
            and run.start_dtm   = ltr.max_start_dtm
  left join wt_test_run_stats  stat
            on  stat.test_run_id = run.id
 order by obj.owner
      ,obj.object_type
      ,obj.object_name;
