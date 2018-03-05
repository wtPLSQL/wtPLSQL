
  White Box PL/SQL Testing
  src/core/README.txt

FILE                   DESCRIPTION
---------------------  -----------------------
common_setup.sql       Common setup script.  Contains values for install/uninstall.
dba_install.sql        Database Administrator install script.  Run as SYS or SYSTEM.
dba_uninstall.sql      Database Administrator uninstall script.  Run as SYS or SYSTEM.
install.sql            Main installation script.  Run after dba_install.sql.
proftab.sql            DBMS_PROFILER tables.  Copied from ?/rdbms/admin/proftab.sql.
wt_assert.pkb          WT_ASSERT package body.
wt_assert.pks          WT_ASSERT package specification.
wt_dbout_profiles.tab  WT_DBOUT_PROFILES table, constraints, indexes, comments, and grants.
wt_not_executable.tab  WT_NOT_EXECUTABLE table, constraints, indexes, comments, and grants.
wt_profiler.pkb        WT_PROFILER package body.
wt_profiler.pks        WT_PROFILER package specification.
wt_result.pkb          WT_RESULT package body.
wt_result.pks          WT_RESULT package specification.
wt_results.tab         WT_RESULTS table, constraints, indexes, comments, and grants.
wt_test_runs.tab       WT_TEST_RUNS table, constraints, indexes, comments, and grants.
wt_text_report.pkb     WT_TEXT_REPORT package body.
wt_text_report.pks     WT_TEXT_REPORT package specification.
wtplsql.pkb            WTPLSQL package body.
wtplsql.pks            WTPLSQL package specification.


Install Procedure:
------------------
1) Review common_setup.sql for appropriate values.
2) Start SQL*Plus.
3) connect as SYS, SYSTEM, or equivalent user.
4) @dba_install
5) Review dba_install.LST.
6) connect as &schema_owner defined in common_setup.sql
7) @install
8) Review install.LST.


UnInstall Procedure:
--------------------
1) Review common_setup.sql for appropriate values.
2) Start SQL*Plus.
3) connect as SYS, SYSTEM, or equivalent user.
4) @dba_uninstall
5) Review dba_uninstall.LST.


Custom Error Codes:
-------------------
20001 - WTPLSQL Runner Name is NULL
20002 - WTPLSQL Runner Name is not valid
20003 - WT_ASSERT User Test Result is FAIL (g_raise_exception is TRUE)
20004 - WT_PROFILER Test Run ID is NULL
20005 - WT_PROFILER dbms_profiler.INTERNAL_VERSION_CHECK failed
20006 - WT_PROFILER dbms_profiler.START_PROFILER failed
20007 - WT_PROFILER g_rec.test_run_id is null
20008 - WT_PROFILER Regular Expression Failure from NOT_EXECUTABLE
