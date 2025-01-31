
--
--  wtpsav Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

spool install_wtpsav.log

define INSTALL_SYSTEM_CONNECT="&1."

-- For Oracle Change Data Capture (CDC) packages
set sqlprefix "~"

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install
@dbi.sql "./installation_prepare.sql" "" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- SEQUENCE Install

@dbi.sql "WTP/PLSQL_PROFILER_RUNNUMBER.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_DBOUTS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASES_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNNERS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PROCEDURE Install

@dbi.sql "WTP/JUNIT_XML_PERSIST_ALL.proc" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE_SPEC Install

@dbi.sql "WTP/WT_DBOUT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_JOB.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PERSIST_REPORT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PROFILE.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUN.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNNER.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE Install

@dbi.sql "WTP/PLSQL_PROFILER_DATA.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/PLSQL_PROFILER_RUNS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/PLSQL_PROFILER_UNITS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_DBOUTS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_DBOUT_RUNS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PROFILES.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULTS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASES.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE_RUNS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNNERS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
prompt Compile All started
begin
   DBMS_UTILITY.compile_schema(schema      => 'WTP'
                              ,compile_all => FALSE);
end;
/
prompt Compile All is done.
----------------------------------------
-- VIEW Install

@dbi.sql "WTP/WT_DBOUT_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PROFILES_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULTS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_SCHEDULER_JOBS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE_INDEX Install

@dbi.sql "WTP/PLSQL_PROFILER_RUNS.tidx" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_DBOUTS.tidx" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULTS.tidx" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE_RUNS.tidx" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNS.tidx" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE_BODY Install

@dbi.sql "WTP/WT_DBOUT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_JOB.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PERSIST_REPORT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PROFILE.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUN.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNNER.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE_FOREIGN_KEY Install

@dbi.sql "WTP/PLSQL_PROFILER_DATA.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/PLSQL_PROFILER_UNITS.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_DBOUT_RUNS.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_PROFILES.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_RESULTS.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TESTCASE_RUNS.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_TEST_RUNS.tfk" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)
@dbi.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."

spool off

