
--
--  DBOUT Profiles View Installation
--

create view wt_profiles_vw as
select db.dbout_id
      ,db.dbout_owner
      ,db.dbout_name
      ,db.dbout_type
      ,db.test_runner_id 
      ,db.test_runner_owner
      ,db.test_runner_name
      ,db.test_run_id  
      ,db.is_last_run
      ,db.trigger_offset 
      ,db.profiler_runid 
      ,db.error_message
      ,prof.line         
      ,prof.status       
      ,prof.total_occur  
      ,prof.total_usecs  
      ,prof.min_usecs    
      ,prof.max_usecs    
      ,prof.text         
 from  wt_profiles  prof
       join wt_dbout_runs_vw  db
            on  db.test_run_id = prof.test_run_id;

comment on table wt_profiles_vw is 'PL/SQL Profiler data for Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_id is 'Surrogate Key to the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_profiles_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_profiles_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_profiles_vw.test_run_id is 'Foreign Key for the Test Run.';
comment on column wt_profiles_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_profiles_vw.trigger_offset is 'Calculated offset from start of Trigger Source to start of Trigger PL/SQL Block.';
comment on column wt_profiles_vw.profiler_runid is 'DBMS_PROFILER unique run identifier from plsql_profiler_runnumber sequence';
comment on column wt_profiles_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_profiles_vw.line is 'Source code line number.';
comment on column wt_profiles_vw.status is 'Executed/NotExecuted/Excluded/Ignored/Unknown Status from the Profiler';
comment on column wt_profiles_vw.total_occur is 'Number of times this line was executed.';
comment on column wt_profiles_vw.total_usecs is 'Total time in microseconds spent executing this line.';
comment on column wt_profiles_vw.min_usecs is 'Minimum execution time in microseconds for this line.';
comment on column wt_profiles_vw.max_usecs is 'Maximum execution time in microseconds for this line.';
comment on column wt_profiles_vw.text is 'Source code text for this line number.';

grant select on wt_profiles_vw to public;
