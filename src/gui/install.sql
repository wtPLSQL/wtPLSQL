
-- Can be run as SYSTEM
grant create job to &schema_owner.;
grant create database link to &schema_owner.;
grant create job to &schema_owner.;

-- Must be run as SYS
grant select on dba_arguments to &schema_owner.;
grant select on gv_$parameter to &schema_owner.;

-- Install Views
@wt_test_runs_gui_tree.vw
@wt_scheduler_jobs.vw

-- Install APEX Application
@f700.sql
