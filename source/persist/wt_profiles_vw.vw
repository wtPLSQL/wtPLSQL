
--
--  Test Run Profiles View Installation
--

create or replace force view wt_profiles_vw as
select run.id               TEST_RUN_ID
      ,run.dbout_id
      ,db.owner             DBOUT_OWNER
      ,db.name              DBOUT_NAME
      ,db.type              DBOUT_TYPE
      ,run.test_runner_id
      ,tr.owner             TEST_RUNNER_OWNER
      ,tr.name              TEST_RUNNER_NAME
      ,run.start_dtm
      ,run.end_dtm
      ,run.is_last_run
      ,run.error_message
      ,pf.line         
      ,pf.status       
      ,pf.exec_cnt
      ,pf.exec_tot_usec
      ,pf.exec_min_usec
      ,pf.exec_max_usec
      ,pf.text         
 from  wt_test_runs  run
       join wt_dbouts  db
            on  db.id = run.dbout_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
       join wt_profiles  pf
           on  pf.test_run_id = run.id;

comment on table wt_profiles_vw is 'Test Run profile statistics for each execution of a Test Runner.';
comment on column wt_profiles_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_profiles_vw.dbout_id is 'Primary (Surrogate) Key for each Database Objects Under Test (DBOUT)';
comment on column wt_profiles_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_profiles_vw.test_runner_id is 'Primary (Surrogate) Key for each Test Runner';
comment on column wt_profiles_vw.test_runner_owner is 'Owner of the Test Runner package. Natural Key 1 part 1';
comment on column wt_profiles_vw.test_runner_name is 'Name of the Test Runner package. Natural Key 1 part 2';
comment on column wt_dbout_runs_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
comment on column wt_dbout_runs_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_dbout_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_dbout_runs_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_profiles_vw.line is 'Source code line number, Primary Key part 2.';
comment on column wt_profiles_vw.status is 'EXEC/NOTX/EXCL/IGNR/UNKN Status from the Profiler';
comment on column wt_profiles_vw.exec_cnt is 'Number of times this line was executed.';
comment on column wt_profiles_vw.exec_tot_usec is 'Total time in microseconds spent executing this line.';
comment on column wt_profiles_vw.exec_min_usec is 'Minimum execution time in microseconds for this line.';
comment on column wt_profiles_vw.exec_max_usec is 'Maximum execution time in microseconds for this line.';
comment on column wt_profiles_vw.text is 'Source code text for this line number.';

grant select on wt_profiles_vw to public;
