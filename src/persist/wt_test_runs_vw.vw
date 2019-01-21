
--
--  Test Runs Table View Installation
--

create or replace force view wt_test_runs_vw as
select run.id                 TEST_RUN_ID
      ,run.test_runner_id
      ,tr.owner               TEST_RUNNER_OWNER
      ,tr.name                TEST_RUNNER_NAME
      ,run.start_dtm
      ,run.end_dtm
      ,run.runner_sec
      ,run.is_last_run
      ,run.error_message
      ,run.tc_cnt
      ,run.tc_fail
      ,run.tc_yield_pct
      ,run.asrt_fst_dtm
      ,run.asrt_lst_dtm
      ,run.asrt_cnt
      ,run.asrt_fail
      ,run.asrt_yield_pct
      ,run.asrt_min_msec
      ,run.asrt_max_msec
      ,run.asrt_tot_msec
      ,run.asrt_sos_msec
 from  wt_test_runs  run
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

comment on table wt_test_runs_vw is 'Test Run data for each execution of a Test Runner.';
comment on column wt_test_runs_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_test_runs_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_test_runs_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_test_runs_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_test_runs_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started.';
comment on column wt_test_runs_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_test_runs_vw.runner_sec is 'Total Runtime for Test Runner in Seconds'
comment on column wt_test_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_test_runs_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_test_runs_vw.tc_cnt is 'Number of Test Cases'
comment on column wt_test_runs_vw.tc_fail is 'Number of Failed Test Cases'
comment on column wt_test_runs_vw.tc_yield_pct is 'Percentage of successful test cases to total Test Cases.';
comment on column wt_test_runs_vw.asrt_fst_dtm is 'Date/Time of First Assertion';
comment on column wt_test_runs_vw.asrt_lst_dtm is 'Date/Time of Last Assertion';
comment on column wt_test_runs_vw.asrt_cnt is 'Number of Assertions across all Test Cases'
comment on column wt_test_runs_vw.asrt_fail is 'Number of Assertion Failures across all Test Cases'
comment on column wt_test_runs_vw.asrt_yield_pct is 'Percentage of successful assertions to total assertions.';
comment on column wt_test_runs_vw.asrt_min_msec is 'Minumum Assertion Interval in Milliseconds across all Test Cases'
comment on column wt_test_runs_vw.asrt_max_msec is 'Maximum Assertion Interval in Milliseconds across all Test Cases'
comment on column wt_test_runs_vw.asrt_tot_msec is 'Total Assertion Intervals in Milliseconds across all Test Cases'
comment on column wt_test_runs_vw.asrt_sos_msec is 'Sum of Squares of Assertion Interval in Milliseconds across all Test Cases'

grant select on wt_test_runs_vw to public;
