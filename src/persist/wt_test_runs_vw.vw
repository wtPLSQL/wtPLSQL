
--
--  Test Runs Table View Installation
--

create view wt_test_runs_vw as
select tr.id                 TEST_RUN_ID
      ,tr.test_runner_id 
      ,tnr.owner             TEST_RUNNER_OWNER
      ,tnr.name              TEST_RUNNER_NAME
      ,tr.is_last_run    
      ,tr.start_dtm      
      ,tr.end_dtm        
      ,tr.error_message
      ,stat.yield_pct
      ,stat.testcases
      ,stat.passes
      ,stat.failures
      ,stat.min_interval_msecs
      ,stat.avg_interval_msecs
      ,stat.max_interval_msecs
      ,stat.tot_interval_msecs
 from  wt_test_runs  tr
       join wt_test_runners  tnr
            on  tnr.id = tr.test_runner_id;

comment on table wt_test_runs_vw is 'Test Run data for each execution of a Test Runner.';
comment on column wt_test_runs_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_test_runs_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_test_runs_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_test_runs_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_test_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_test_runs_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started.';
comment on column wt_test_runs_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_test_runs_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_test_run_stats_vw.yield_pct is 'Percentage of successful test cases to total Test Cases.';
comment on column wt_test_run_stats_vw.testcases is 'Total number of Test Cases.';
comment on column wt_test_run_stats_vw.passes is 'Number of passed Test Cases.';
comment on column wt_test_run_stats_vw.failures is 'Number of failed Test Cases.';
comment on column wt_test_run_stats_vw.min_interval_msecs is 'Minimum tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.avg_interval_msecs is 'Average tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.max_interval_msecs is 'Maximum tot_interval_msecs between assertions across all Test Cases';
comment on column wt_test_run_stats_vw.tot_interval_msecs is 'Total (sum) of tot_interval_msecs between assertions across all Test Cases';

grant select on wt_test_runs_vw to public;
