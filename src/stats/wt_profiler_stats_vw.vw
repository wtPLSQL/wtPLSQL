
--
--  Test Run Profile Statistics View Installation
--

create view wt_profiler_stats_vw as
select stat.test_run_id
      ,run.test_runner_id
      ,tr.runner_owner
      ,tr.runner_name
      ,run.dbout_id       
      ,dbo.dbout_owner  
      ,dbo.dbout_name   
      ,dbo.dbout_type   
      ,run.start_dtm
      ,run.end_dtm
      ,run.trigger_offset 
      ,run.profiler_runid 
      ,run.is_last_run
      ,run.error_message
      ,stat.line         
      ,stat.status       
      ,stat.total_occur  
      ,stat.total_usecs  
      ,stat.min_usecs    
      ,stat.max_usecs    
      ,stat.text         
 from  wt_profiler_stats  stat
       join wt_test_runs  run
            on  run.id = stat.test_run_id
       join wt_test_runners  tr
            on  tr.id = run.test_runner_id
       join wt_profilers  dbo
            on  dbo.id = run.dbout_id;

comment on table wt_profiler_stats_vw is 'Test Run profile statistics for each execution of a Test Runner.';
comment on column wt_profiler_stats_vw.test_run_id is 'Primary (Surrogate) Key for each Test Run';
comment on column wt_profiler_stats_vw.test_runner_id is 'Primary (Surrogate) Key for each Test Runner';
comment on column wt_profiler_stats_vw.runner_owner is 'Owner of the Test Runner package. Natural Key 1 part 1';
comment on column wt_profiler_stats_vw.runner_name is 'Name of the Test Runner package. Natural Key 1 part 2';
comment on column wt_profiler_stats_vw.id is 'Primary (Surrogate) Key for each Database Objects Under Test (DBOUT)';
comment on column wt_profiler_stats_vw.dbout_owner is 'Owner of the Database Object Under Test (DBOUT).';
comment on column wt_profiler_stats_vw.dbout_name is 'Name of the Database Object Under Test (DBOUT).';
comment on column wt_profiler_stats_vw.dbout_type is 'Type of the Database Object Under Test (DBOUT).';
comment on column wt_profiler_stats_vw.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 part 2';
comment on column wt_profiler_stats_vw.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column wt_profiler_stats_vw.is_last_run is 'Optional Flag "Y" to indicate this is the most recent run for this package owner/name';
comment on column wt_profiler_stats_vw.error_message is 'Optional Error messages from this Test Run.';
comment on column wt_profiler_stats_vw.coverage_pct is 'Percentage of executed source lines to valid executable source lines.';
comment on column wt_profiler_stats_vw.profiled_lines is 'Total number of source lines as counted by DBMS_PROFILER';
comment on column wt_profiler_stats_vw.executed_lines is 'Number of source lines executed';
comment on column wt_profiler_stats_vw.ignored_lines is 'Number of source lines ignored as uncountable';
comment on column wt_profiler_stats_vw.excluded_lines is 'Number of source lines excluded due to unexplained DBMS_PROFILER metrics';
comment on column wt_profiler_stats_vw.notexec_lines is 'Number of source lines not executed';
comment on column wt_profiler_stats_vw.unknown_lines is 'Number of source lines that have unexplained DBMS_PROFILER metrics';
comment on column wt_profiler_stats_vw.min_executed_usecs is 'Minumum execution time for a line of source in microseconds';
comment on column wt_profiler_stats_vw.avg_executed_usecs is 'Average execution time for a line of source in microseconds';
comment on column wt_profiler_stats_vw.max_executed_usecs is 'Maximum execution time for a line of source in microseconds';
comment on column wt_profiler_stats_vw.tot_executed_usecs is 'Total (Sum) of execution times for a line of source in microseconds';

grant select on wt_profiler_stats_vw to public;
