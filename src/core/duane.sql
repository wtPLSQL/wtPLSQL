
declare
   --runner_name  varchar2(50) := 'WTPLSQL';
   --runner_name  varchar2(50) := 'WT_PROFILER';
   runner_name  varchar2(50) := 'WT_TEST_RUN_STAT';
begin
   --wtplsql.test_run(runner_name);
   wt_text_report.dbms_out(in_runner_name  => runner_name
                          ,in_detail_level => 50);
end;
/

execute wtplsql.test_run('WT_RESULT');
execute wt_text_report.dbms_out(in_runner_name => 'WT_RESULT', in_detail_level => 50);
execute wtplsql.test_run('WT_PROFILER');
execute wt_text_report.dbms_out(in_runner_name => 'WT_PROFILER', in_detail_level => 50);

execute wt_text_report.dbms_out(in_detail_level => 50);
execute wt_text_report.dbms_out;

-- Need to test the new insert_test_runs_summary.
-- Need to create the view that uses this data.

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
