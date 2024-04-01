
--
--  Create WTP.WT_DBOUT_RUNS_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_DBOUT_RUNS_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_DBOUT_RUNS_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_DBOUT_RUNS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_DBOUT_RUNS_VW" ("TEST_RUN_ID", "DBOUT_ID", "DBOUT_OWNER", "DBOUT_NAME", "DBOUT_TYPE", "TEST_RUNNER_ID", "TEST_RUNNER_OWNER", "TEST_RUNNER_NAME", "START_DTM", "END_DTM", "IS_LAST_RUN", "ERROR_MESSAGE", "PROFILER_RUNID", "TRIGGER_OFFSET", "COVERAGE_PCT", "PROFILED_LINES", "EXECUTED_LINES", "IGNORED_LINES", "EXCLUDED_LINES", "NOTEXEC_LINES", "UNKNOWN_LINES", "EXEC_MIN_USEC", "EXEC_AVG_USEC", "EXEC_MAX_USEC", "EXEC_TOT_USEC") AS 
  select run.id                TEST_RUN_ID
      ,run.dbout_id
      ,db.owner              DBOUT_OWNER
      ,db.name               DBOUT_NAME
      ,db.type               DBOUT_TYPE
      ,run.test_runner_id
      ,tr.owner              TEST_RUNNER_OWNER
      ,tr.name               TEST_RUNNER_NAME
      ,run.start_dtm
      ,run.end_dtm
      ,run.is_last_run
      ,run.error_message
      ,dbr.profiler_runid
      ,dbr.trigger_offset 
      ,dbr.coverage_pct
      ,dbr.profiled_lines
      ,dbr.executed_lines
      ,dbr.ignored_lines
      ,dbr.excluded_lines
      ,dbr.notexec_lines
      ,dbr.unknown_lines
      ,dbr.exec_min_usec
      ,dbr.exec_avg_usec
      ,dbr.exec_max_usec
      ,dbr.exec_tot_usec
 from  wt_test_runs  run
       join wt_dbouts  db
            on  db.id = run.dbout_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
  left join wt_dbout_runs  dbr
            on  run.id = dbr.test_run_id
 where run.dbout_id is not null;

--  Comments

--DBMS_METADATA:WTP.WT_DBOUT_RUNS_VW

   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."TEST_RUN_ID" IS 'Primary (Surrogate) Key for each Test Run';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."DBOUT_ID" IS 'Surrogate Key to the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."DBOUT_OWNER" IS 'Owner of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."DBOUT_NAME" IS 'Name of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."DBOUT_TYPE" IS 'Type of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."TEST_RUNNER_ID" IS 'Surrogate Key the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."TEST_RUNNER_OWNER" IS 'Owner of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."TEST_RUNNER_NAME" IS 'Name of the Test Runner package.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."START_DTM" IS 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."END_DTM" IS 'Date/time (and fractional seconds) this Test Run ended.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."IS_LAST_RUN" IS 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."ERROR_MESSAGE" IS 'Optional Error messages from this Test Run.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."PROFILER_RUNID" IS 'DBMS_PROFILER unique run identifier from plsql_profiler_runnumber sequence';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."TRIGGER_OFFSET" IS 'Calculated offset from start of Trigger Source to start of Trigger PL/SQL Block.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."COVERAGE_PCT" IS 'Percentage of executed source lines to valid executable source lines.';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."PROFILED_LINES" IS 'Total number of source lines as counted by DBMS_PROFILER';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXECUTED_LINES" IS 'Number of source lines executed';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."IGNORED_LINES" IS 'Number of source lines ignored as uncountable';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXCLUDED_LINES" IS 'Number of source lines excluded due to unexplained DBMS_PROFILER metrics';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."NOTEXEC_LINES" IS 'Number of source lines not executed';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."UNKNOWN_LINES" IS 'Number of source lines that have unexplained DBMS_PROFILER metrics';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXEC_MIN_USEC" IS 'Minumum execution time for a line of source in microseconds';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXEC_AVG_USEC" IS 'Average execution time for a line of source in microseconds';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXEC_MAX_USEC" IS 'Maximum execution time for a line of source in microseconds';
   COMMENT ON COLUMN "WTP"."WT_DBOUT_RUNS_VW"."EXEC_TOT_USEC" IS 'Total (Sum) of execution times for a line of source in microseconds';
   COMMENT ON TABLE "WTP"."WT_DBOUT_RUNS_VW"  IS 'Test Run data for each execution of a Test Runner.';


--  Grants
grant SELECT on "WTP"."WT_DBOUT_RUNS_VW" to "PUBLIC";


--  Synonyms


set define on
