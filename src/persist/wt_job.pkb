create or replace package body wt_job
as


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
-- Run a test runner in a different schema
-- Returns before the test runner is complete
procedure test_run
      (in_schema_name  in  varchar2
      ,in_runner_name  in  varchar2)
is
   plsql_block    varchar2(32000);
begin
   plsql_block := 
      'begin'                                          || CHR(10) ||
      '   wtplsql.test_run@' || in_schema_name ||
                         '(' || in_runner_name || ');' || CHR(10) ||
      'end;';
   dbms_scheduler.create_job
      (job_name   => substr('WT_TEST_RUN$' || in_schema_name ||
                                       '$' || in_runner_name
                           ,1,128)
      ,job_type   => 'PLSQL_BLOCK'
      ,job_action => plsql_block);
end test_run;


------------------------------------------------------------
-- Run all test runners in a different schema
-- Returns before all test runners are complete
procedure test_all
      (in_schema_name   in  varchar2)
is
   plsql_block    varchar2(32000);
begin
   plsql_block := 
      'begin'                                          || CHR(10) ||
      '   wtplsql.test_all@' || in_schema_name  || ';' || CHR(10) ||
      'end;';
   dbms_scheduler.create_job
      (job_name   => substr('WT_TEST_ALL$' || in_schema_name
                           ,1,128)
      ,job_type   => 'PLSQL_BLOCK'
      ,job_action => plsql_block);
end test_all;


------------------------------------------------------------
-- Run all test runners in all schema in sequence
-- Returns before all test runners are complete
procedure test_all_sequential
is
   plsql_block    varchar2(32000);
begin
   plsql_block := 'begin' || CHR(10);
   for buff in (
      select owner
       from  wt_qual_test_runners_vw
       group by owner)
   loop
      plsql_block := plsql_block ||
         '   wtplsql.test_all@' || buff.owner || ';' || CHR(10);
   end loop;
   plsql_block := plsql_block ||
      'end;';
   dbms_scheduler.create_job
      (job_name   => 'WT_TEST_ALL_SEQUENTIAL'
      ,job_type   => 'PLSQL_BLOCK'
      ,job_action => plsql_block);
end test_all_sequential;


------------------------------------------------------------
-- Run all test runners in all schema in parallel
-- Returns before all test runners are complete
procedure test_all_parallel
is
begin
   for buff in (
      select owner
       from  wt_qual_test_runners_vw
       group by owner)
   loop
      test_all(buff.owner);
   end loop;
end test_all_parallel;


------------------------------------------------------------
-- Waits for all test runners to complete
procedure wait_for_all_tests
      (in_timeout_seconds         in number  default 3600
      ,in_check_interval_seconds  in number  default 60)
is
   num_jobs       number := 0;
   max_intervals  pls_integer;
begin
   max_intervals := nvl(in_timeout_seconds,3600) /
                    nvl(in_check_interval_seconds,60);
   for i in 1 .. max_intervals
   loop
      select count(*) into num_jobs
       from  wt_scheduler_jobs_vw
       where status = 'RUNNING';
      exit when num_jobs = 0;
      dbms_lock.sleep(in_check_interval_seconds);
   end loop;
   if num_jobs > 0
   then
      raise_application_error(-20000, 'WAIT_FOR_ALL_TESTS timeout, ' ||
                                       num_jobs || ' jobs still running');
   end if;
end wait_for_all_tests;


------------------------------------------------------------
procedure create_db_link
      (in_schema_name  in varchar2
      ,in_password     in varchar2)
is
   connect_string  varchar2(2000);
begin
    select '//' || 'localhost' ||
            ':' || 1521        ||
            '/' || global_name
    into  connect_string
    from  global_name;
   execute immediate
      'create database link ' || in_schema_name ||
               ' connect to ' || in_schema_name ||
            ' identified by ' || in_password    ||
                  ' using ''' || connect_string || '''';
end create_db_link;


------------------------------------------------------------
procedure drop_db_link
      (in_schema_name  in varchar2)
is
begin
   execute immediate
      'drop database link ' || in_schema_name;
exception when OTHERS then
   if SQLERRM != 'ORA-02024: database link not found'
   then
      raise;
   end if;
end drop_db_link;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_create_drop_db_link
   is
      num_rows  number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Create Drop DB Link';
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links before testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 0);
      wt_assert.raises (
         msg_in          => 'Create the Database Link',
         check_call_in   => 'begin wt_job.create_db_link(''' ||
                                   USER || ''',''' ||
                                   lower(USER) || '''); end;',
         against_exc_in  => '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.objexists (
         msg_in        =>  USER || ' Database Link',
         obj_owner_in  =>  USER,
         obj_name_in   =>  USER,
         obj_type_in   =>  'DATABASE LINK');
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links during testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      select count(*)
       into  num_rows
       from  wt_results;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Rows from WT_RESULTS@' || USER,
         check_query_in   => 'select count(*) from user_db_links@' || USER,
         against_value_in => num_rows);
      --------------------------------------  WTPLSQL Testing --
      rollback;
      wt_assert.raises (
         msg_in          => 'Close the Database Link',
         check_call_in   => 'alter session close database link ' ||
                                   USER,
         against_exc_in  => '');
      wt_assert.raises (
         msg_in          => 'Drop the Database Link',
         check_call_in   => 'begin wt_job.drop_db_link(''' ||
                                   USER || '''); end;',
         against_exc_in  => '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.objnotexists (
         msg_in        =>  USER || ' Database Link',
         obj_owner_in  =>  USER,
         obj_name_in   =>  USER,
         obj_type_in   =>  'DATABASE LINK');
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links after testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 0);
   end t_create_drop_db_link;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_create_drop_db_link;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_job;
