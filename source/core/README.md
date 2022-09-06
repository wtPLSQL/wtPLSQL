# Core wtPLSQL Component Scripts


File Name              | Description
-----------------------|------------
downgrades             | Folder of downgrade scripts for this release
upgrades               | Folder of upgrade scripts for this release
common_setup.sql       | Common setup script.  Contains values for install/uninstall.
install.sql            | Install script.  Run as SYSTEM.
installO.LST           | Example of a successfull install.
proftab.sql            | DBMS_PROFILER tables.  Copied from ?/rdbms/admin/proftab.sql.
proftab_comments.sql   | Table/column comments on DBMS_PROFILER tables.
RELEASE_NOTES.txt      | Release Notes for this release
test_all.sql           | SQL script to execute all Test Runners.
test_allO.LST          | Example of successful results from all Test Runners.
uninstall.sql          | Uninstall script.  Run as SYSTEM.
uninstallO.LST         | Example of a successfull uninstall.
wt_assert.pkb          | WT_ASSERT package body.
wt_assert.pks          | WT_ASSERT package specification.
wt_core_report.pkb     | WT_CORE_REPORT package body.
wt_core_report.pks     | WT_CORE_REPORT package specification.
wt_dbout_profiles.tab  | WT_DBOUT_PROFILES table.
wt_profiler.pkb        | WT_PROFILER package body.
wt_profiler.pks        | WT_PROFILER package specification.
wt_result.pkb          | WT_RESULT package body.
wt_result.pks          | WT_RESULT package specification.
wt_results.tab         | WT_RESULTS table.
wt_self_test.tab       | WT_SELF_TEST Table and Data. Used for self-test
wt_test_run_stat.pkb   | WT_TEST_RUN_STAT package body.
wt_test_run_stat.pks   | WT_TEST_RUN_STAT package specification.
wt_test_run_stats.tab  | WT_TEST_RUN_STATS table.
wt_test_runs.tab       | WT_TEST_RUNS table.
wt_testcase_runs.tab   | WT_TESTCASE_RUNS table. 
wt_version.tab         | WT_VERSION table.
wtplsql.pkb            | WTPLSQL package body.
wtplsql.pks            | WTPLSQL package specification.


NOTE: "install.sql" creates PUBLIC SYNONYMS.


### Install Procedure

1) sqlplus SYS/password as SYSDBA @install
2) exit
3) Compare install.LST to installO.LST


### UnInstall Procedure

1) sqlplus SYS/password as SYSDBA @uninstall
2) exit
3) Compare uninstall.LST to uninstallO.LST
