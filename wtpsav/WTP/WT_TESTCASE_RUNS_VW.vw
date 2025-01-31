
--
--  Create WTP.WT_TESTCASE_RUNS_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_TESTCASE_RUNS_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_TESTCASE_RUNS_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_TESTCASE_RUNS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_TESTCASE_RUNS_VW" ("TEST_RUN_ID", "TESTCASE_ID", "TESTCASE", "TEST_RUNNER_ID", "TEST_RUNNER_OWNER", "TEST_RUNNER_NAME", "IS_LAST_RUN", "ERROR_MESSAGE", "ASRT_YIELD_PCT", "ASRT_CNT", "ASRT_FAIL", "ASRT_PASS", "ASRT_MIN_MSEC", "ASRT_AVG_MSEC", "ASRT_MAX_MSEC", "ASRT_TOT_MSEC") AS 
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
      ,tcr.asrt_min_msec
      ,tcr.asrt_avg_msec
      ,tcr.asrt_max_msec
      ,tcr.asrt_tot_msec
 from  wt_testcase_runs  tcr
       join wt_testcases  tc
            on  tc.id = tcr.testcase_id
       join wt_test_runs  run
            on  run.id = tcr.test_run_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

--  Comments

--DBMS_METADATA:WTP.WT_TESTCASE_RUNS_VW

   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TEST_RUN_ID" IS 'Primary (Surrogate) Key for each Test Run';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TESTCASE_ID" IS 'Primary (Surrogate) Key for each Test Case';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TESTCASE" IS 'The Test Case name';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TEST_RUNNER_ID" IS 'Primary (Surrogate) Key for each Test Runner';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TEST_RUNNER_OWNER" IS 'Owner of the Test Runner package. Natural Key 1 part 1';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."TEST_RUNNER_NAME" IS 'Name of the Test Runner package. Natural Key 1 part 2';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."IS_LAST_RUN" IS 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ERROR_MESSAGE" IS 'Optional Error messages from this Test Run.';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_YIELD_PCT" IS 'Percentage of successful assertions to total assertions.';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_CNT" IS 'Total number of assetions for the Test Case.';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_FAIL" IS 'Number of failed assertions for the Test Case.';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_PASS" IS 'Number of passed assertions for the Test Case.';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_MIN_MSEC" IS 'Minimum interval time between assertions in milliseconds for the Test Case';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_AVG_MSEC" IS 'Average interval time between assertions in milliseconds for the Test Case';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_MAX_MSEC" IS 'Maximum interval time between assertions in milliseconds for the Test Case';
   COMMENT ON COLUMN "WTP"."WT_TESTCASE_RUNS_VW"."ASRT_TOT_MSEC" IS 'Total (sum) of interval times between assertions in milliseconds for the Test Case';
   COMMENT ON TABLE "WTP"."WT_TESTCASE_RUNS_VW"  IS 'Test Run data statistics for each testcase in the execution of a Test Runner.';


--  Grants
grant SELECT on "WTP"."WT_TESTCASE_RUNS_VW" to "PUBLIC";


--  Synonyms


set define on
