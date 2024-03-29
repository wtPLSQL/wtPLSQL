
--
-- Comments taken from
--   Oracle Database Online Documentation 11g Release 2 (11.2)
--   Database PL/SQL Packages and Types Reference
-- https://docs.oracle.com/cd/E11882_01/appdev.112/e40758/d_profil.htm#ARPLS67461
--

comment on table PLSQL_PROFILER_RUNS is 'Table of profiler runs for DBMS_PROFILER';
comment on column PLSQL_PROFILER_RUNS.runid is '(PRIMARY KEY) Unique run identifier from plsql_profiler_runnumber';
comment on column PLSQL_PROFILER_RUNS.related_run is 'Runid of related run (for client/server correlation)';
comment on column PLSQL_PROFILER_RUNS.run_owner is 'User who started run';
comment on column PLSQL_PROFILER_RUNS.run_date is 'Start time of run';
comment on column PLSQL_PROFILER_RUNS.run_comment is 'User provided comment for this run';
comment on column PLSQL_PROFILER_RUNS.run_total_time is 'Elapsed time for this run in nanoseconds';
comment on column PLSQL_PROFILER_RUNS.run_system_info is 'Currently unused';
comment on column PLSQL_PROFILER_RUNS.run_comment1 is 'Additional comment';
comment on column PLSQL_PROFILER_RUNS.spare1 is 'Unused';

comment on table PLSQL_PROFILER_UNITS is 'Table of program units for DBMS_PROFILER';
comment on column PLSQL_PROFILER_UNITS.runid is '(Primary key) References plsql_profiler_runs';
comment on column PLSQL_PROFILER_UNITS.unit_number is '(Primary key) Internally generated library unit #';
comment on column PLSQL_PROFILER_UNITS.unit_type is 'Library unit type';
comment on column PLSQL_PROFILER_UNITS.unit_owner is 'Library unit owner name';
comment on column PLSQL_PROFILER_UNITS.unit_name is 'Library unit name timestamp on library unit';
comment on column PLSQL_PROFILER_UNITS.unit_timestamp is 'In the future will be used to detect changes to unit between runs';
comment on column PLSQL_PROFILER_UNITS.total_time is 'Total time spent in this unit in nanoseconds. The profiler does not set this field, but it is provided for the convenience of analysis tools';
comment on column PLSQL_PROFILER_UNITS.spare1 is 'Unused';
comment on column PLSQL_PROFILER_UNITS.spare2 is 'Unused';

comment on table PLSQL_PROFILER_DATA is 'Table of program units for DBMS_PROFILER';
comment on column PLSQL_PROFILER_DATA.runid is 'Primary key, unique (generated) run identifier';
comment on column PLSQL_PROFILER_DATA.unit_number is 'Primary key, internally generated library unit number';
comment on column PLSQL_PROFILER_DATA.line# is 'Primary key, not null, line number in unit';
comment on column PLSQL_PROFILER_DATA.total_occur is 'Number of times line was executed';
comment on column PLSQL_PROFILER_DATA.total_time is 'Total time spent executing line in nanoseconds';
comment on column PLSQL_PROFILER_DATA.min_time is 'Minimum execution time for this line in nanoseconds';
comment on column PLSQL_PROFILER_DATA.max_time is 'Maximum execution time for this line in nanoseconds';
comment on column PLSQL_PROFILER_DATA.spare1 is 'Unused';
comment on column PLSQL_PROFILER_DATA.spare2 is 'Unused';
comment on column PLSQL_PROFILER_DATA.spare3 is 'Unused';
comment on column PLSQL_PROFILER_DATA.spare4 is 'Unused';
