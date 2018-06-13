
--
--  Add Stats SQL Script
--
--  Compute and Add statistics to V1.1.0 "stats" tables
--

spool update_all_stats
set serveroutput on size unlimited format wrapped
set linesize 1000
set trimspool on

declare
  test_run_stats_rec    wt_test_run_stats%ROWTYPE;
  l_executable_lines    number;
begin
  --
  for buff in (select id from wt_test_runs)
  loop
    --
    test_run_stats_rec.test_run_id := buff.id;
    --
    select count(*)
          ,sum(case status when 'PASS' then 1 else 0 end)
          ,sum(case status when 'FAIL' then 1 else 0 end)
          ,sum(case status when 'ERR'  then 1 else 0 end)
          ,count(distinct testcase)
          ,min(interval_msecs)
          ,max(interval_msecs)
          ,sum(interval_msecs)
      into test_run_stats_rec.asserts
          ,test_run_stats_rec.passes
          ,test_run_stats_rec.failures
          ,test_run_stats_rec.errors
          ,test_run_stats_rec.testcases
          ,test_run_stats_rec.min_interval_msecs
          ,test_run_stats_rec.max_interval_msecs
          ,test_run_stats_rec.tot_interval_msecs
     from  wt_results
     where test_run_id = buff.id;
    --
    if test_run_stats_rec.asserts = 0
    then
      test_run_stats_rec.test_yield := NULL;
      test_run_stats_rec.avg_interval_msecs := NULL;
    else
      test_run_stats_rec.test_yield := round(test_run_stats_rec.passes /
                                             test_run_stats_rec.asserts, 3);
      test_run_stats_rec.avg_interval_msecs := round(test_run_stats_rec.tot_interval_msecs /
                                                     test_run_stats_rec.asserts, 3);
    end if;
    --
    select count(*)
          ,sum(case status when 'EXEC' then 1 else 0 end)
          ,sum(case status when 'IGNR' then 1 else 0 end)
          ,sum(case status when 'EXCL' then 1 else 0 end)
          ,sum(case status when 'NOTX' then 1 else 0 end)
          ,sum(case status when 'UNKN' then 1 else 0 end)
          ,min(case status when 'EXEC' then min_usecs else 0 end)
          ,max(case status when 'EXEC' then max_usecs else 0 end)
          ,sum(case status when 'EXEC' then total_usecs/total_occur else 0 end)
      into test_run_stats_rec.profiled_lines
          ,test_run_stats_rec.executed_lines
          ,test_run_stats_rec.ignored_lines
          ,test_run_stats_rec.excluded_lines
          ,test_run_stats_rec.notexec_lines
          ,test_run_stats_rec.unknown_lines
          ,test_run_stats_rec.min_executed_usecs
          ,test_run_stats_rec.max_executed_usecs
          ,test_run_stats_rec.tot_executed_usecs
     from  wt_dbout_profiles
     where test_run_id = buff.id;
    --
    l_executable_lines := test_run_stats_rec.executed_lines +
                          test_run_stats_rec.notexec_lines;
    if l_executable_lines = 0
    then
        test_run_stats_rec.code_coverage := NULL;
        test_run_stats_rec.avg_executed_usecs := NULL;
    else
        test_run_stats_rec.code_coverage := round(test_run_stats_rec.executed_lines /
                                                  l_executable_lines, 3);
        test_run_stats_rec.avg_executed_usecs := round(test_run_stats_rec.tot_executed_usecs /
                                                       l_executable_lines, 3);
    end if;
    --
    begin
       delete from wt_test_run_stats
        where test_run_id = buff.id;
       insert into wt_test_run_stats values test_run_stats_rec;
    exception when others then
       dbms_output.put_line(dbms_utility.format_error_stack  ||
                            dbms_utility.format_error_backtrace);
       rollback;
    end;
    --
  end loop;
  --
end;
/


declare
  testcase_stats_rec    wt_testcase_stats%ROWTYPE;
  l_executable_lines    number;
begin
  --
  for buff in (select test_run_id, testcase
                from  wt_results
                group by test_run_id, testcase)
  loop
    --
    testcase_stats_rec.test_run_id := buff.test_run_id;
    testcase_stats_rec.testcase    := buff.testcase;
    --
    select count(*)
          ,sum(case status when 'PASS' then 1 else 0 end)
          ,sum(case status when 'FAIL' then 1 else 0 end)
          ,sum(case status when 'ERR'  then 1 else 0 end)
          ,min(interval_msecs)
          ,max(interval_msecs)
          ,sum(interval_msecs)
      into testcase_stats_rec.asserts
          ,testcase_stats_rec.passes
          ,testcase_stats_rec.failures
          ,testcase_stats_rec.errors
          ,testcase_stats_rec.min_interval_msecs
          ,testcase_stats_rec.max_interval_msecs
          ,testcase_stats_rec.tot_interval_msecs
     from  wt_results
     where test_run_id = buff.test_run_id
      and  testcase    = buff.testcase;
    --
    if testcase_stats_rec.asserts = 0
    then
      testcase_stats_rec.test_yield := NULL;
      testcase_stats_rec.avg_interval_msecs := NULL;
    else
      testcase_stats_rec.test_yield := round(testcase_stats_rec.passes /
                                             testcase_stats_rec.asserts, 3);
      testcase_stats_rec.avg_interval_msecs := round(testcase_stats_rec.tot_interval_msecs /
                                                     testcase_stats_rec.asserts, 3);
    end if;
    --
    begin
       delete from wt_testcase_stats
        where test_run_id = buff.test_run_id
         and  testcase    = buff.testcase;
       insert into wt_testcase_stats values testcase_stats_rec;
    exception when others then
       dbms_output.put_line(dbms_utility.format_error_stack  ||
                            dbms_utility.format_error_backtrace);
       rollback;
    end;
    --
  end loop;
  --
end;
/

spool off
