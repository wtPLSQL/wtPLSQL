
--
--  Create WTP.WT_PROFILES_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_PROFILES_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_PROFILES_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_PROFILES_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_PROFILES_VW" ("TEST_RUN_ID", "DBOUT_ID", "DBOUT_OWNER", "DBOUT_NAME", "DBOUT_TYPE", "TEST_RUNNER_ID", "TEST_RUNNER_OWNER", "TEST_RUNNER_NAME", "START_DTM", "END_DTM", "IS_LAST_RUN", "ERROR_MESSAGE", "LINE", "STATUS", "EXEC_CNT", "EXEC_TOT_USEC", "EXEC_MIN_USEC", "EXEC_MAX_USEC", "TEXT") AS 
  select run.id               TEST_RUN_ID
      ,run.dbout_id
      ,db.owner             DBOUT_OWNER
      ,db.name              DBOUT_NAME
      ,db.type              DBOUT_TYPE
      ,run.test_runner_id
      ,tr.owner             TEST_RUNNER_OWNER
      ,tr.name              TEST_RUNNER_NAME
      ,run.start_dtm
      ,run.end_dtm
      ,run.is_last_run
      ,run.error_message
      ,pf.line
      ,pf.status
      ,pf.exec_cnt
      ,pf.exec_tot_usec
      ,pf.exec_min_usec
      ,pf.exec_max_usec
      ,pf.text
 from  wt_test_runs  run
       join wt_dbouts  db
            on  db.id = run.dbout_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
       join wt_profiles  pf
           on  pf.test_run_id = run.id;

--  Comments

--DBMS_METADATA:WTP.WT_PROFILES_VW

   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."TEST_RUN_ID" IS 'Primary (Surrogate) Key for each Test Run';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."DBOUT_ID" IS 'Primary (Surrogate) Key for each Database Objects Under Test (DBOUT)';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."DBOUT_OWNER" IS 'Owner of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."DBOUT_NAME" IS 'Name of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."DBOUT_TYPE" IS 'Type of the Database Object Under Test (DBOUT).';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."TEST_RUNNER_ID" IS 'Primary (Surrogate) Key for each Test Runner';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."TEST_RUNNER_OWNER" IS 'Owner of the Test Runner package. Natural Key 1 part 1';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."TEST_RUNNER_NAME" IS 'Name of the Test Runner package. Natural Key 1 part 2';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."LINE" IS 'Source code line number, Primary Key part 2.';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."STATUS" IS 'EXEC/NOTX/EXCL/IGNR/UNKN Status from the Profiler';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."EXEC_CNT" IS 'Number of times this line was executed.';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."EXEC_TOT_USEC" IS 'Total time in microseconds spent executing this line.';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."EXEC_MIN_USEC" IS 'Minimum execution time in microseconds for this line.';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."EXEC_MAX_USEC" IS 'Maximum execution time in microseconds for this line.';
   COMMENT ON COLUMN "WTP"."WT_PROFILES_VW"."TEXT" IS 'Source code text for this line number.';
   COMMENT ON TABLE "WTP"."WT_PROFILES_VW"  IS 'Test Run profile statistics for each execution of a Test Runner.';


--  Grants
grant SELECT on "WTP"."WT_PROFILES_VW" to "PUBLIC";


--  Synonyms


set define on
