
--
--  Test Run Profiles View Installation
--

create view wt_profiles_vw as
select run.id               TEST_RUN_ID
      ,run.test_runner_id
      ,tr.owner             RUNNER_OWNER
      ,tr.name              RUNNER_NAME
      ,run.dbout_id
      ,dbo.owner            DBOUT_OWNER
      ,dbo.name             DBOUT_NAME
      ,dbo.type             DBOUT_TYPE
      ,run.start_dtm
      ,run.end_dtm
      ,run.trigger_offset 
      ,run.profiler_runid 
      ,run.is_last_run
      ,run.error_message
      ,dbo.line         
      ,dbo.status       
      ,dbo.total_occur  
      ,dbo.total_usecs  
      ,dbo.min_usecs    
      ,dbo.max_usecs    
      ,dbo.text         
 from  wt_profiles  dbo
       join wt_test_runs  run
            on  run.dbout_id = dbo.id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id;

comment on table wt_profiles_vw is 'Test Run profile statistics for each execution of a Test Runner.';
comment on column wt_profiles_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_profiles_vw.test_runner_id is 'Primary (Surrogate) Key for each Test Runner';
comment on column wt_profiles_vw.runner_owner is 'Owner of the Test Runner package. Natural Key 1 part 1';
comment on column wt_profiles_vw.runner_name is 'Name of the Test Runner package. Natural Key 1 part 2';
comment on column wt_profiles_vw.id is 'Primary (Surrogate) Key for each Database Objects Under Test (DBOUT)';
comment on column wt_profiles_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
comment on column wt_profiles_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_profiles_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_profiles_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_profiles.line is 'Source code line number, Primary Key part 2.';
comment on column wt_profiles.status is 'Executed/NotExecuted/Excluded/Ignored/Unknown Status from the Profiler';
comment on column wt_profiles.total_occur is 'Number of times this line was executed.';
comment on column wt_profiles.total_usecs is 'Total time in microseconds spent executing this line.';
comment on column wt_profiles.min_usecs is 'Minimum execution time in microseconds for this line.';
comment on column wt_profiles.max_usecs is 'Maximum execution time in microseconds for this line.';
comment on column wt_profiles.text is 'Source code text for this line number.';

grant select on wt_profiles_vw to public;
