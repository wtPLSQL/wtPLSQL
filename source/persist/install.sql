
--
--  Core Installation
--
--   Run as SYS
--


prompt
prompt Capture output

spool install
set showmode off
set serveroutput on size unlimited format truncated

-- Shared Setup Script
@../common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

prompt
prompt Connect as SCHEMA_OWNER

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


@proftab.sql
@proftab_comments.sql

create index plsql_profiler_runs_idx1
   on plsql_profiler_runs (run_date);


prompt
prompt Install Package Specifications

@wt_dbout.pks
/
show errors

@wt_job.pks
/
show errors

@wt_profile.pks
/
show errors

@wt_result.pks
/
show errors

@wt_test_run.pks
/
show errors

@wt_test_runner.pks
/
show errors

@wt_testcase.pks
/
show errors

@wt_persist_report.pks
/
show errors


prompt
prompt Install Tables - Must be ordered for foreign keys

@wt_test_runners.tab
@wt_testcases.tab
@wt_dbouts.tab
@wt_dbout_runs.tab
@wt_test_runs.tab
@wt_results.tab
@wt_profiles.tab
@wt_testcase_runs.tab


prompt
prompt Install Views

@wt_dbout_runs_vw.vw
@wt_profiles_vw.vw
@wt_results_vw.vw
@wt_scheduler_jobs.vw
@wt_test_runs_vw.vw
@wt_testcase_runs_vw.vw


prompt
prompt Install Package Bodies

@wt_dbout.pkb
/
show errors

@wt_job.pkb
/
show errors

@wt_profile.pkb
/
show errors

@wt_result.pkb
/
show errors

@wt_test_run.pkb
/
show errors

@wt_test_runner.pkb
/
show errors

@wt_testcase.pkb
/
show errors

@wt_persist_report.pkb
/
show errors


prompt
prompt Configuration Data

-- Remove the core report hooks
begin
   wt_core_report.delete_hooks;
end;
/

-- Add the Persist Add-on hooks
begin
   wt_test_run.insert_hooks;
end;
/

insert into wt_versions (component, version, action)
   values ('Persist', 1.002, 'INSTALL');

commit;


set showmode on
spool off
