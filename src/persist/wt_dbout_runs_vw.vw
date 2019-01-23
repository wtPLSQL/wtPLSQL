
--
--  Database Object Under Test Runs Table View Installation
--

create or replace force view wt_dbout_runs_vw as
select run.id                TEST_RUN_ID
      ,run.dbout_id
      ,db.owner              DBOUT_OWNER
      ,db.name               DBOUT_NAME
      ,db.type               DBOUT_TYPE
      ,run.test_runner_id
      ,tr.owner              TEST_RUNNER_OWNER
      ,tr.name               TEST_RUNNER_NAME
      ,run.start_dtm
      ,run.end_dtm
      ,run.is_last_run
      ,run.error_message
      ,run.profiler_runid
      ,run.trigger_offset 
      ,run.coverage_pct
      ,run.profiled_lines
      ,run.executed_lines
      ,run.ignored_lines
      ,run.excluded_lines
      ,run.notexec_lines
      ,run.unknown_lines
      ,run.exec_min_usecs
      ,run.exec_avg_usecs
      ,run.exec_max_usecs
      ,run.exec_tot_usecs
 from  wt_test_runs  run
       join wt_dbouts  db
            on  db.id = run.dbout_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
 where run.dbout_id is not null;

comment on table wt_dbout_runs_vw is 'Test Run data for each execution of a Test Runner.';
comment on column wt_dbout_runs_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_dbout_runs_vw.dbout_id is 'Surrogate Key to the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_dbout_runs_vw.test_runner_id is 'Surrogate Key the Test Runner package.';
comment on column wt_dbout_runs_vw.test_runner_owner is 'Owner of the Test Runner package.';
comment on column wt_dbout_runs_vw.test_runner_name is 'Name of the Test Runner package.';
comment on column wt_dbout_runs_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
comment on column wt_dbout_runs_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_dbout_runs_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_dbout_runs_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_dbout_runs_vw.profiler_runid is 'DBMS_PROFILER unique run identifier from plsql_profiler_runnumber sequence';
comment on column wt_dbout_runs_vw.trigger_offset is 'Calculated offset from start of Trigger Source to start of Trigger PL/SQL Block.';
comment on column wt_dbout_runs_vw.coverage_pct is 'Percentage of executed source lines to valid executable source lines.';
comment on column wt_dbout_runs_vw.profiled_lines is 'Total number of source lines as counted by DBMS_PROFILER';
comment on column wt_dbout_runs_vw.executed_lines is 'Number of source lines executed';
comment on column wt_dbout_runs_vw.ignored_lines is 'Number of source lines ignored as uncountable';
comment on column wt_dbout_runs_vw.excluded_lines is 'Number of source lines excluded due to unexplained DBMS_PROFILER metrics';
comment on column wt_dbout_runs_vw.notexec_lines is 'Number of source lines not executed';
comment on column wt_dbout_runs_vw.unknown_lines is 'Number of source lines that have unexplained DBMS_PROFILER metrics';
comment on column wt_dbout_runs_vw.exec_tot_usecs is 'Total (Sum) of execution times for a line of source in microseconds';
comment on column wt_dbout_runs_vw.exec_min_usecs is 'Minumum execution time for a line of source in microseconds';
comment on column wt_dbout_runs_vw.exec_max_usecs is 'Maximum execution time for a line of source in microseconds';
comment on column wt_dbout_runs_vw.exec_avg_usecs is 'Average execution time for a line of source in microseconds';

grant select on wt_dbout_runs_vw to public;
