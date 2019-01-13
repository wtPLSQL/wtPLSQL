
wtPLSQL 1.1.0 Release Notes:

### New Features
* Added THROWS assertion.
* Fully implemented the utPLSQL V1 UT_ASSERT API for implemented assertions.
* Exceptions from "query" assertions are now handled.
* Streamlined WT_TEXT_REPORT output.
* Added WT_TEST_RUN_STATS and WT_TESTCASE_STATS summary tables.
* Added comments to DBMS_PROFILER tables.
* Changed ANNO annotation to IGNR in WT_DBOUT_PROFILES table.
* Added units to time columns in WT_DBOUT_PROFILES table.
* Improved robustness of WT_PROFILER package.
* Corrected problems with wtPLSQL non-owner testing.

### Detailed Changes
* Permission Changes
   * revoke connect, resource from &schema_owner.;
   * revoke select, insert, delete on plsql_profiler_runs from public;
   * revoke select, insert, delete on plsql_profiler_units from public;
   * revoke select, insert, delete on plsql_profiler_data from public;
   * revoke insert on wt_results from public;
   * revoke insert on wt_dbout_profiles from public;
   * revoke update on wt_dbout_profiles from public;
   * alter user &schema_owner. quota unlimited on USERS;
   * grant create session       to &schema_owner.;
   * grant create type          to &schema_owner.;
   * grant create sequence      to &schema_owner.;
   * grant create table         to &schema_owner.;
   * grant create trigger       to &schema_owner.;
   * grant create view          to &schema_owner.;
   * grant create procedure     to &schema_owner.;
   * grant select on dba_source to &schema_owner.;
   * grant select on dba_objects to &schema_owner.;
   * grant select on wt_test_runs_seq to public;
   * grant execute on wtplsql to public;
   * grant execute on wt_assert to public;
   * grant execute on wt_text_report to public;
* Public Synonym Changes
   * drop public synonym wt_not_executable;
   * drop public synonym plsql_profiler_runs;
   * drop public synonym plsql_profiler_units;
   * drop public synonym plsql_profiler_data;
   * drop public synonym wt_profiler;
   * drop public synonym wt_result;
   * create or replace public synonym utassert          for &schema_owner..wt_assert;
   * create or replace public synonym wt_version        for &schema_owner..wt_version;
   * create or replace public synonym wt_test_runs_seq  for &schema_owner..wt_test_runs_seq;
   * create or replace public synonym wt_test_run_stats for &schema_owner..wt_test_run_stats;
   * create or replace public synonym wt_testcase_stats for &schema_owner..wt_testcase_stats;
   * create or replace public synonym wt_self_test      for &schema_owner..wt_self_test;
   * grant select on plsql_profiler_runnumber to public;
* Add Profile Table Comments
   * @proftab_comments.sql
* Table Changes
   * drop table wt_test_data;
   * wt_version.tab
   * wt_testcase_stats.tab
   * wt_test_run_stats.tab
   * wt_self_test.tab
   * wt_test_runs.tab
   * @wt_results.tab
   * alter table wt_results rename column elapsed_msecs to interval_msecs;
   * comment on column wt_results.interval_msecs
   * alter table wt_dbout_profiles rename column total_time to total_usecs;
   * alter table wt_dbout_profiles rename column min_time to min_usecs;
   * alter table wt_dbout_profiles rename column max_time to max_usecs;
   * comment on column wt_dbout_profiles.status
   * comment on column wt_dbout_profiles.total_usecs
   * comment on column wt_dbout_profiles.min_usecs
   * comment on column wt_dbout_profiles.max_usecs
   * alter table wt_dbout_profiles drop constraint wt_dbout_profiles_ck1;
   * update wt_dbout_profiles set status = 'IGNR' where status = 'ANNO';
   * alter table wt_dbout_profiles add constraint wt_dbout_profiles_ck1 check (status in ('EXEC','NOTX','EXCL','IGNR','UNKN'));
   * update_all_stats.sql
* Packages
   * wtplsql.pks
   * wtplsql.pkb
   * wt_result.pks
   * wt_result.pkb
   * wt_assert.pks
   * wt_assert.pkb
   * wt_profiler.pks
   * wt_profiler.pkb
   * wt_test_run_stat.pks
   * wt_test_run_stat.pkb
   * wt_text_report.pks
   * wt_text_report.pkb
