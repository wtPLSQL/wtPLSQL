
  White Box PL/SQL Testing
  src/core/README.txt

FILE                   DESCRIPTION
---------------------  -----------------------
common_setup.sql       Common setup script.  Contains values for install/uninstall.
install.sql            Install script.  Run as SYS or SYSTEM.
installO.LST           Example of a successfull install.
proftab.sql            DBMS_PROFILER tables.  Copied from ?/rdbms/admin/proftab.sql.
test_all.sql           SQL script to execute all Test Runners.
test_allO.LST          Example of successful results from all Test Runners.
uninstall.sql          Uninstall script.  Run as SYS or SYSTEM.
uninstallO.LST         Example of a successfull uninstall.
wt_assert.pkb          WT_ASSERT package body.
wt_assert.pks          WT_ASSERT package specification.
wt_dbout_profiles.tab  WT_DBOUT_PROFILES table.
wt_profiler.pkb        WT_PROFILER package body.
wt_profiler.pks        WT_PROFILER package specification.
wt_result.pkb          WT_RESULT package body.
wt_result.pks          WT_RESULT package specification.
wt_results.tab         WT_RESULTS table.
wt_test_data.tab       WT_TEST_DATA table
wt_test_runs.tab       WT_TEST_RUNS table.
wt_text_report.pkb     WT_TEXT_REPORT package body.
wt_text_report.pks     WT_TEXT_REPORT package specification.
wtplsql.pkb            WTPLSQL package body.
wtplsql.pks            WTPLSQL package specification.


Install Procedure:
------------------
1) sqlplus SYS/password as SYSDBA @install
2) exit
3) Compare install.LST to installO.LST


UnInstall Procedure:
--------------------
1) sqlplus SYS/password as SYSDBA @uninstall
2) exit
3) Compare uninstall.LST to uninstallO.LST


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
20009 - WT_RESULT "in_test_run_id" cannot be NULL
