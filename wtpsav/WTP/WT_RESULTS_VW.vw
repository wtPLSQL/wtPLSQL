
--
--  Create WTP.WT_RESULTS_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_RESULTS_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_RESULTS_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_RESULTS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_RESULTS_VW" ("TEST_RUN_ID", "TEST_RUNNER_ID", "TEST_RUNNER_OWNER", "TEST_RUNNER_NAME", "START_DTM", "END_DTM", "IS_LAST_RUN", "ERROR_MESSAGE", "RESULT_SEQ", "TESTCASE_ID", "TESTCASE", "EXECUTED_DTM", "INTERVAL_MSEC", "ASSERTION", "STATUS", "MESSAGE", "DETAILS") AS 
  select run.id                TEST_RUN_ID 
      ,run.test_runner_id 
      ,tr.owner              TEST_RUNNER_OWNER
      ,tr.name               TEST_RUNNER_NAME
      ,run.start_dtm      
      ,run.end_dtm        
      ,run.is_last_run    
      ,run.error_message
      ,res.result_seq    
      ,res.testcase_id   
      ,tc.testcase
      ,res.executed_dtm  
      ,res.interval_msec
      ,res.assertion     
      ,res.status        
      ,res.message       
      ,res.details       
 from  wt_test_runs  run
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
       join wt_results  res
            on  res.test_run_id = run.id
       join wt_testcases  tc
            on  tc.id = res.testcase_id;

--  Comments

--DBMS_METADATA:WTP.WT_RESULTS_VW

   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TEST_RUN_ID" IS 'Foreign Key for the Test Run';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TEST_RUNNER_ID" IS 'Surrogate Key the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TEST_RUNNER_OWNER" IS 'Owner of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TEST_RUNNER_NAME" IS 'Name of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."START_DTM" IS 'Date/time (and fractional seconds) this Test Run started.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."END_DTM" IS 'Date/time (and fractional seconds) this Test Run ended.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."IS_LAST_RUN" IS 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."ERROR_MESSAGE" IS 'Optional Error messages from this Test Run.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."RESULT_SEQ" IS 'Sequence number for this Result';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TESTCASE_ID" IS 'Foreign Key for the Test Case.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."TESTCASE" IS 'The Test Case name';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."EXECUTED_DTM" IS 'Date/Time (with Fractional Seconds) this Result was captured';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."INTERVAL_MSEC" IS 'Interval time in milliseconds since the previous Result or start ot the Test Run.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."ASSERTION" IS 'Name of the Assertion Test performed';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."STATUS" IS 'PASS/FAIL Status from the Assertion';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."MESSAGE" IS 'Optional test identifier that helps connect an Assertion to the Test Runner.';
   COMMENT ON COLUMN "WTP"."WT_RESULTS_VW"."DETAILS" IS 'Assertion Details, i.e. Expected Value and Actual Value';
   COMMENT ON TABLE "WTP"."WT_RESULTS_VW"  IS 'Results data from Test Runs.';


--  Grants
grant SELECT on "WTP"."WT_RESULTS_VW" to "PUBLIC";


--  Synonyms


set define on
