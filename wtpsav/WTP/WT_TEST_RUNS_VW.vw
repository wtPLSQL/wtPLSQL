
--
--  Create WTP.WT_TEST_RUNS_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_TEST_RUNS_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_TEST_RUNS_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_TEST_RUNS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_TEST_RUNS_VW" ("TEST_RUN_ID", "TEST_RUNNER_ID", "TEST_RUNNER_OWNER", "TEST_RUNNER_NAME", "START_DTM", "END_DTM", "RUNNER_SEC", "IS_LAST_RUN", "ERROR_MESSAGE", "TC_CNT", "TC_FAIL", "TC_YIELD_PCT", "ASRT_FST_DTM", "ASRT_LST_DTM", "ASRT_CNT", "ASRT_FAIL", "ASRT_YIELD_PCT", "ASRT_MIN_MSEC", "ASRT_AVG_MSEC", "ASRT_MAX_MSEC", "ASRT_TOT_MSEC") AS 
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
      ,run.asrt_avg_msec
      ,run.asrt_max_msec
      ,run.asrt_tot_msec
 from  wt_test_runs  run
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

--  Comments

--DBMS_METADATA:WTP.WT_TEST_RUNS_VW

   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TEST_RUN_ID" IS 'Primary (Surrogate) Key for each Test Run';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TEST_RUNNER_ID" IS 'Surrogate Key the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TEST_RUNNER_OWNER" IS 'Owner of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TEST_RUNNER_NAME" IS 'Name of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."START_DTM" IS 'Date/time (and fractional seconds) this Test Run started.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."END_DTM" IS 'Date/time (and fractional seconds) this Test Run ended.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."RUNNER_SEC" IS 'Total Runtime for Test Runner in Seconds';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."IS_LAST_RUN" IS 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ERROR_MESSAGE" IS 'Optional Error messages from this Test Run.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TC_CNT" IS 'Number of Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TC_FAIL" IS 'Number of Failed Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."TC_YIELD_PCT" IS 'Percentage of successful test cases to total Test Cases.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_FST_DTM" IS 'Date/Time of First Assertion';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_LST_DTM" IS 'Date/Time of Last Assertion';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_CNT" IS 'Number of Assertions across all Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_FAIL" IS 'Number of Assertion Failures across all Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_YIELD_PCT" IS 'Percentage of successful assertions to total assertions.';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_MIN_MSEC" IS 'Minumum Assertion Interval in Milliseconds across all Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_AVG_MSEC" IS 'Sum of Squares of Assertion Interval in Milliseconds across all Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_MAX_MSEC" IS 'Maximum Assertion Interval in Milliseconds across all Test Cases';
   COMMENT ON COLUMN "WTP"."WT_TEST_RUNS_VW"."ASRT_TOT_MSEC" IS 'Total Assertion Intervals in Milliseconds across all Test Cases';
   COMMENT ON TABLE "WTP"."WT_TEST_RUNS_VW"  IS 'Test Run data for each execution of a Test Runner.';


--  Grants
grant SELECT on "WTP"."WT_TEST_RUNS_VW" to "PUBLIC";


--  Synonyms


set define on
