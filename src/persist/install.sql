
--
--  Core Installation
--
--   Run as SYS
--

-- Capture output
spool install
set showmode off
set serveroutput on size unlimited format truncated

-- Shared Setup Script
@common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

-- Connect as SCHEMA_OWNER
connect &schema_owner./&schema_owner.&connect_string.
set serveroutput on size unlimited format truncated

begin
   if USER != upper('&schema_owner')
   then
      raise_application_error (-20000,
        'Not logged in as &schema_owner');
   end if;
end;
/

WHENEVER SQLERROR continue

--
-- Run Oracle's Profiler Table Installation
--  Note1: Tables converted to Global Temporary
--  Note2: Includes "Drop Table" and "Drop Sequence" statements
--
@proftab.sql
@proftab_comments.sql
--
create index plsql_profiler_runs_idx1
   on plsql_profiler_runs (run_date);

-- Package Specifications
@wtdbout.pks
/
@wtjob.pks
/
@wt_profile.pks
/
@wt_result.pks
/
@wt_test_run.pks
/
@wt_test_run_stat.pks
/
@wt_test_runner.pks
/
@wt_testcase.pks
/
@wt_text_report.pks
/

-- Core Tables
--   Must be ordered for foreign keys
@wt_test_runners.tab
@wt_testcases.tab
@wt_dbouts.tab
@wt_test_runs.tab
@wt_results.tab
@wt_profiles.tab
@wt_testcase_stats.tab

-- Install Views
@wt_dbout_runs_vw.vw
@wt_profiles_vw.vw
@wt_results_vw.vw
@wt_scheduler_jobs.vw
@wt_test_runs_vw.vw
@wt_testcase_runs_vw.vw

-- Package Bodies
@wtdbout.pkb
/
@wtjob.pkb
/
@wt_profile.pkb
/
@wt_result.pkb
/
@wt_test_run.pkb
/
@wt_test_run_stat.pkb
/
@wt_test_runner.pkb
/
@wt_testcase.pkb
/
@wt_text_report.pkb
/

set showmode on
spool off
