
--
--  Core Table Installation
--

drop table not_executable;
drop table excluded_lines;
drop sequence excluded_lines_seq;
drop table dbout_profiles;
drop sequence dbout_profiles_seq;
drop table results;
drop sequence results_seq;
drop table test_runs;
drop sequence test_runs_seq;

create sequence test_runs_seq;

create global temporary table test_runs
   (id             number(38)    constraint test_runs_nn1 not null
   ,start_dtm      timestamp     constraint test_runs_nn2 not null
   ,runner_name    varchar2(30)  constraint test_runs_nn3 not null
   ,runner_owner   varchar2(30)  constraint test_runs_nn4 not null
   ,end_dtm        timestamp     constraint test_runs_nn5 not null
   ,dbout_owner    varchar2(30)
   ,dbout_name     varchar2(30)
   ,dbout_type     varchar2(30)
   ,error_message  varchar2(4000)
   ,constraint test_runs_pk primary key (id)
   ,constraint test_runs_nk1 unique (start_dtm, runner_name, runner_owner)
   );

comment on table test_runs is 'Test Run data for each execution of the WTPLSQL_RUN procedure.';
comment on column test_runs.id  is 'Primary (Surrogate) Key for each Test Run';
comment on column test_runs.start_dtm is 'Date/time (and fractional seconds) this Test Run started. Natural Key 1 of 3';
comment on column test_runs.runner_name is 'Name of the package with the WTPLSQL_RUN procedure. Natural Key 2 of 3';
comment on column test_runs.runner_owner is 'Owner of the package with the WTPLSQL_RUN procedure. Natural Key 3 of 3';
comment on column test_runs.end_dtm is 'Date/time (and fractional seconds) this Test Run ended.';
comment on column test_runs.dbout_owner is 'Optional Owner of the Database Object Under Test (DBOUT).';
comment on column test_runs.dbout_name is 'Optional Name of the Database Object Under Test (DBOUT).';
comment on column test_runs.dbout_type is 'Optional Type of the Database Object Under Test (DBOUT).';
comment on column test_runs.error_message is 'Last error messages from this Test Run.';

create sequence results_seq;

create global temporary table results
   (id             number(38)     constraint results_nn1 not null
   ,test_run_id    number(38)     constraint results_nn2 not null
   ,result_seq     number(8)      constraint results_nn3 not null
   ,executed_dtm   timestamp      constraint results_nn4 not null
   ,elapsed_msecs  number(6)      constraint results_nn5 not null
   ,assertion      varchar2(30)   constraint results_nn6 not null
   ,status         varchar2(30)   constraint results_nn7 not null
   ,expected_value varchar2(4000) constraint results_nn8 not null
   ,actual_value   varchar2(4000) constraint results_nn9 not null
   ,testcase       varchar2(30)
   ,message        varchar2(4000)
   ,error_message  varchar2(4000)
   ,constraint results_pk primary key (id)
   ,constraint results_nk1 unique (test_run_id, result_seq)
   --,constraint results_fk1 foreign key (test_run_id)
   --    references test_runs (id)
   ,constraint results_ck1 check (status in ('P','F','E'))
   );

comment on table results is 'Results data from Test Runs.';
comment on column results.id is 'Primary (Surrogate) Key for each Test Run Result.';
comment on column results.test_run_id is 'Foriegn Key for the Test Run, Natural Key 1 of 2.';
comment on column results.result_seq is 'Sequence number for this Result, Natural Key 2 of 2.';
comment on column results.executed_dtm is 'Date/Time (with Fractional Seconds) this Result was captured';
comment on column results.elapsed_msecs is 'Elapsed time in milliseonds since the previous Result or start ot the Test Run.';
comment on column results.assertion is 'Name of the Assertion Test performed';
comment on column results.status is 'P(ass)/F(ail)/E(rror) Result from the Assertion';
comment on column results.expected_value is 'Expected Value from the Assertion';
comment on column results.actual_value is 'Actual Value from the Assertion';
comment on column results.testcase is 'Optional Test Case name.';
comment on column results.message is 'Optional Assetion message.';
comment on column results.error_message is 'Error Message from the Assertion.';

create sequence dbout_profiles_seq;

create global temporary table dbout_profiles
   (id             number(38)     constraint dbout_profiles_nn1 not null
   ,test_run_id    number(38)     constraint dbout_profiles_nn2 not null
   ,line#          number(6)      constraint dbout_profiles_nn3 not null
   ,text           varchar2(4000) constraint dbout_profiles_nn4 not null
   ,total_occur    number(3)      constraint dbout_profiles_nn5 not null
   ,total_time     number(9)      constraint dbout_profiles_nn6 not null
   ,min_time       number(9)      constraint dbout_profiles_nn7 not null
   ,max_time       number(9)      constraint dbout_profiles_nn8 not null
   ,constraint dbout_profiles_pk primary key (id)
   ,constraint dbout_profiles_nk1 unique (test_run_id, line#)
   --,constraint dbout_profiles_fk1 foreign key (test_run_id)
   --    references test_runs (id)
   );

comment on table dbout_profiles is 'PL/SQL Profiler data for Database Object Under Test (DBOUT).';
comment on column dbout_profiles.id is 'Primary (Surrogate) Key for each Profiler Data Item.';
comment on column dbout_profiles.test_run_id is 'Foriegn Key for the Test Run, Natural Key 1 of 2.';
comment on column dbout_profiles.line# is 'Line number from the DBOUT, Natural Key 2 of 2.';
comment on column dbout_profiles.text is 'Source code text for this line.';
comment on column dbout_profiles.total_occur is 'Number of times this line was executed.';
comment on column dbout_profiles.total_time is 'Total time spent excuting this line.';
comment on column dbout_profiles.min_time is 'Minimum execution time for this line.';
comment on column dbout_profiles.max_time is 'Maximum execution time for this line.';

create sequence excluded_lines_seq;

create global temporary table excluded_lines
   (id             number(38)     constraint excluded_lines_nn1 not null
   ,test_run_id    number(38)     constraint excluded_lines_nn2 not null
   ,line#          number(6)      constraint excluded_lines_nn3 not null
   ,exclude_code   varchar2(4000) constraint excluded_lines_nn4 not null
   ,text           varchar2(4000) constraint excluded_lines_nn5 not null
   ,constraint excluded_lines_pk primary key (id)
   ,constraint excluded_lines_nk1 unique (test_run_id, line#)
   --,constraint excluded_lines_fk1 foreign key (test_run_id)
   --    references test_runs (id)
   ,constraint excluded_lines_ck1 check (exclude_code in ('A','N'))
   );

comment on table excluded_lines is 'Source code lines excluded from the PL/SQL Profiler data during a Test Run';
comment on column excluded_lines.id is 'Primary (Surrogate) Key for each Excluded Line.';
comment on column excluded_lines.test_run_id is 'Foriegn Key for the Test Run, Natural Key 1 of 2.';
comment on column excluded_lines.line# is 'Line number from the Excluded Line, Natural Key 2 of 2.';
comment on column excluded_lines.exclude_code is 'A(nnotation) or N(ot executable) reason for excluding this line';
comment on column excluded_lines.text is 'Source code text for this Excluded Line.';

create table not_executable
   (text  varchar2(4000)  constraint not_executable_nn1 not null
   ,note  varchar2(4000)
   ,constraint not_executable_pk primary key (text)
   );

comment on table not_executable is 'Table to exclude non-executable lines from code coverage';
comment on column not_executable.text is 'Primary key, source text to exclude from code coverage';
comment on column not_executable.note is 'Notes regarding this non-exectuable line of code';


--
-- Run Oracle's Profiler Table Installation
--  Note1: Tables converted to Global Temporary
--  Note2: Includes "Drop Table" and "Drop Sequence" statements
--
@proftab.sql
