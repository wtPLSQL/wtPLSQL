
--
--  Results View Installation
--

create or replace force view wt_results_vw as
select tr.test_runner_id 
      ,tr.test_runner_owner
      ,tr.test_runner_name
      ,res.test_run_id   
      ,tr.is_last_run    
      ,tr.start_dtm      
      ,tr.end_dtm        
      ,tr.error_message
      ,res.result_seq    
      ,res.testcase_id   
      ,tc.name               TESTCASE_NAME
      ,res.executed_dtm  
      ,res.interval_msecs
      ,res.assertion     
      ,res.status        
      ,res.message       
      ,res.details       
 from  wt_results  res
       join wt_test_runs_vw  tr
            on  tr.test_run_id = res.test_run_id
       join wt_testcases  tc
            on  tc.id = res.testcase_id;

comment on table wt_results_vw is 'Results data from Test Runs.';
comment on column wt_results_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_results_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_results_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_results_vw.test_run_id is 'Foreign Key for the Test Run';
comment on column wt_results_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_results_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started.';
comment on column wt_results_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_results_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_results_vw.result_seq is 'Sequence number for this Result';
comment on column wt_results_vw.testcase_id is 'Foreign Key for the Test Case.';
comment on column wt_results_vw.testcase_name is 'The Test Case name';
comment on column wt_results_vw.executed_dtm is 'Date/Time (with Fractional Seconds) this Result was captured';
comment on column wt_results_vw.interval_msecs is 'Interval time in milliseonds since the previous Result or start ot the Test Run.';
comment on column wt_results_vw.assertion is 'Name of the Assertion Test performed';
comment on column wt_results_vw.status is 'PASS/FAIL Status from the Assertion';
comment on column wt_results_vw.details is 'Assertion Details, i.e. Expected Value and Actual Value';
comment on column wt_results_vw.message is 'Optional test identifier that helps connect an Assertion to the Test Runner.';

grant select on wt_results_vw to public;
