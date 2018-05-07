
--alter system set PLSQL_CCFLAGS = 
--    'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:FALSE'
--    scope=BOTH;
--execute dbms_utility.compile_schema('WTP',TRUE,FALSE);
--grant create synonym to wtp_demo;

-- DBMS_PROFILER has a startup time penalty, see the documentation.
-- "Some PL/SQL operations, such as the first execution of a PL/SQL unit, may involve I/O to catalog tables to load the byte code for the PL/SQL unit being executed. Also, it may take some time executing package initialization code the first time a package procedure or function is called."
-- https://docs.oracle.com/cd/E11882_01/appdev.112/e40758/d_profil.htm#CHDJGHEG

execute wtp.wtplsql.test_all;
execute wt_text_report.dbms_out_all;

execute wtplsql.test_run('TRIGGER_TEST_PKG');
execute wt_text_report.dbms_out('TRIGGER_TEST_PKG',FALSE,FALSE,TRUE,TRUE);

execute wtplsql.test_run('TABLE_TEST_PKG');
execute wt_text_report.dbms_out('TABLE_TEST_PKG',FALSE,FALSE,TRUE,TRUE);

select wtp.wtplsql.show_version from dual;
execute wt_assert.isnull('Test1','');

select * from wt_results;
select * from wt_test_runs;

execute dbms_utility.compile_schema('WTP_DEMO',TRUE,FALSE);

begin
   $IF $$WTPLSQL_ENABLE
   $THEN
      dbms_output.put_line('WTPLSQL_ENABLE is TRUE');
   $END
   dbms_output.put_line('Check WTPLSQL_ENABLE is Done.');
end;
/
