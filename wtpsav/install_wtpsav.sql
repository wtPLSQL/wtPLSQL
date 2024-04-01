
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

-- Must Set SQLPREFIX away from "#" Oracle Change Data Capture packages
set sqlprefix "~"

-- Using "^P", CHR(16), DLE as an escape character
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install
@db_install.sql "./installation_prepare.sql" "" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- SEQUENCE Install

@db_install.sql "WTP/PLSQL_PROFILER_RUNNUMBER.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_DBOUTS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASES_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNNERS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNS_SEQ.seq" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE Install

@db_install.sql "WTP/WT_DBOUT.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_JOB.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PERSIST_REPORT.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PROFILE.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULT.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUN.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNNER.pspec" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE Install

@db_install.sql "WTP/PLSQL_PROFILER_DATA.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/PLSQL_PROFILER_RUNS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/PLSQL_PROFILER_UNITS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_DBOUTS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_DBOUT_RUNS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PROFILES.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULTS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASES.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE_RUNS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNNERS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNS.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- INDEX Install

@db_install.sql "WTP/PLSQL_PROFILER_RUNS.tabind" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_DBOUTS.tabind" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULTS.tabind" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE_RUNS.tabind" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNS.tabind" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- VIEW Install

@db_install.sql "WTP/WT_DBOUT_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PROFILES_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULTS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_SCHEDULER_JOBS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE BODY Install

@db_install.sql "WTP/WT_DBOUT.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_JOB.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PERSIST_REPORT.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PROFILE.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULT.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUN.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNNER.pbody" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE_FOREIGN_KEY Install

@db_install.sql "WTP/PLSQL_PROFILER_DATA.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/PLSQL_PROFILER_UNITS.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_DBOUT_RUNS.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_PROFILES.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_RESULTS.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TESTCASE_RUNS.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."
@db_install.sql "WTP/WT_TEST_RUNS.tabfk" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- Finalize Installation
@db_install.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."

spool off

