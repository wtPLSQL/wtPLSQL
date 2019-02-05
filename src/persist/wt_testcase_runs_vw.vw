
--
--  Test Cases Statistics View Installation
--

create or replace force view wt_testcase_runs_vw as
select tcr.test_run_id
      ,tcr.testcase_id
      ,tc.testcase
      ,run.test_runner_id
      ,tr.owner                TEST_RUNNER_OWNER
      ,tr.name                 TEST_RUNNER_NAME
      ,run.is_last_run
      ,run.error_message
      ,tcr.asrt_yield_pct
      ,tcr.asrt_cnt
      ,tcr.asrt_fail
      ,tcr.asrt_pass
      ,tcr.asrt_min_msecs
      ,tcr.asrt_avg_msecs
      ,tcr.asrt_max_msecs
      ,tcr.asrt_tot_msecs
 from  wt_testcase_runs  tcr
       join wt_testcases  tc
            on  tc.id = tcr.testcase_id
       join wt_test_runs  run
            on  run.id = tcr.test_run_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

comment on table wt_testcase_runs_vw is 'Test Run data statistics for each testcase in the execution of a Test Runner.';
comment on column wt_testcase_runs_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_testcase_runs_vw.testcase_id is 'Primary (Surrogate) Key for each Test Case';
comment on column wt_testcase_runs_vw.testcase is 'The Test Case name';
comment on column wt_testcase_runs_vw.test_runner_id is 'Primary (Surrogate) Key for each Test Runner';
comment on column wt_testcase_runs_vw.test_runner_owner is 'Owner of the Test Runner package. Natural Key 1 part 1';
comment on column wt_testcase_runs_vw.test_runner_name is 'Name of the Test Runner package. Natural Key 1 part 2';
comment on column wt_testcase_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_testcase_runs_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_testcase_runs_vw.asrt_yield_pct is 'Percentage of successful assertions to total assertions.';
comment on column wt_testcase_runs_vw.asrt_cnt is 'Total number of assetions for the Test Case.';
comment on column wt_testcase_runs_vw.asrt_fail is 'Number of failed assertions for the Test Case.';
comment on column wt_testcase_runs_vw.asrt_pass is 'Number of passed assertions for the Test Case.';
comment on column wt_testcase_runs_vw.asrt_min_msecs is 'Minimum interval time between assertions in milliseconds for the Test Case';
comment on column wt_testcase_runs_vw.asrt_avg_msecs is 'Average interval time between assertions in milliseconds for the Test Case';
comment on column wt_testcase_runs_vw.asrt_max_msecs is 'Maximum interval time between assertions in milliseconds for the Test Case';
comment on column wt_testcase_runs_vw.asrt_tot_msecs is 'Total (sum) of interval times between assertions in milliseconds for the Test Case';

grant select on wt_testcase_runs_vw to public;
