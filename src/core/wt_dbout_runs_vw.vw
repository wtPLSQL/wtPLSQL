
--
--  Database Object Under Test Runs Table View Installation
--

create view wt_dbout_runs_vw as
select tr.dbout_id       
      ,db.owner              DBOUT_OWNER
      ,db.name               DBOUT_NAME
      ,db.type               DBOUT_TYPE
      ,tr.test_runner_id 
      ,tnr.owner             TEST_RUNNER_OWNER
      ,tnr.name              TEST_RUNNER_NAME
      ,tr.id                 TEST_RUN_ID
      ,tr.is_last_run    
      ,tr.trigger_offset 
      ,tr.profiler_runid 
      ,tr.error_message
 from  wt_test_runs  tr
       join wt_dbouts  db
            on  db.id = tr.dbout_id
       join wt_test_runners  tnr
            on  tnr.id = tr.test_runner_id;

comment on table wt_dbout_runs_vw is 'Test Run data for each execution of a Test Runner.';
comment on column wt_dbout_runs_vw.dbout_id is 'Surrogate Key to the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_dbout_runs_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_dbout_runs_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_dbout_runs_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_dbout_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_dbout_runs_vw.trigger_offset is 'Calculated offset from start of Trigger Source to start of Trigger PL/SQL Block.';
comment on column wt_dbout_runs_vw.profiler_runid is 'DBMS_PROFILER unique run identifier from plsql_profiler_runnumber sequence';
comment on column wt_dbout_runs_vw.error_message is 'Optional Error messages from this Test Run.';

grant select on wt_dbout_runs_vw to public;
