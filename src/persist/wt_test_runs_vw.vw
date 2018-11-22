
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

grant select on wt_test_runs_vw to public;
