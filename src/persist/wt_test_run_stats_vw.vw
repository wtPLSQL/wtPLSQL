
--
--  Test Runs Statistics View Installation
--

create view wt_test_run_stats_vw as
select stat.test_run_id
      ,run.test_runner_id
      ,tr.runner_owner
      ,tr.runner_name
      ,run.start_dtm
      ,run.end_dtm
      ,run.is_last_run
      ,run.error_message
      ,stat.yield_pct
      ,stat.testcases
      ,stat.passes
      ,stat.failures
      ,stat.min_interval_msecs
      ,stat.avg_interval_msecs
      ,stat.max_interval_msecs
      ,stat.tot_interval_msecs
 from  wt_test_run_stats  stat
       join wt_test_runs  run
            on  run.id = stat.test_run_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

comment on table wt_test_run_stats_vw is 'Test Run data statistics for each execution of a Test Runner.';
comment on column wt_test_run_stats_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_test_run_stats_vw.test_runner_id is 'Primary (Surrogate) Key for each Test Runner';
comment on column wt_test_run_stats_vw.runner_owner is 'Owner of the Test Runner package. Natural Key 1 part 1';
comment on column wt_test_run_stats_vw.runner_name is 'Name of the Test Runner package. Natural Key 1 part 2';
comment on column wt_test_run_stats_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
comment on column wt_test_run_stats_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_test_run_stats_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_test_run_stats_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_test_run_stats_vw.yield_pct is 'Percentage of successful test cases to total Test Cases.';
comment on column wt_test_run_stats_vw.testcases is 'Total number of Test Cases.';
comment on column wt_test_run_stats_vw.passes is 'Number of passed Test Cases.';
comment on column wt_test_run_stats_vw.failures is 'Number of failed Test Cases.';
comment on column wt_test_run_stats_vw.min_interval_msecs is 'Minimum tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.avg_interval_msecs is 'Average tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.max_interval_msecs is 'Maximum tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.tot_interval_msecs is 'Total (sum) of tot_interval_msecs between assertions across all Test Cases';

grant select on wt_test_run_stats_vw to public;