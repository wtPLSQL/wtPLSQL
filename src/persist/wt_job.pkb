create or replace package body wt_job
as

   $IF $$WTPLSQL_SELFTEST $THEN  ------%WTPLSQL_begin_ignore_lines%------
      g_current_user     varchar2(30);
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------

----------------------
--  Private Procedures
----------------------

--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN

   procedure tl_compile_db_object
         (in_ptype   in varchar2
         ,in_pname   in varchar2
         ,in_source  in varchar2)
   is
      l_sql_txt  varchar2(4000);
      l_errtxt   varchar2(32000) := '';
   begin
      --------------------------------------  WTPLSQL Testing --
      -- Wrap in_source to complete the DDL statement
      l_sql_txt := 'create ' || in_ptype  ||
                         ' ' || in_pname  ||
                      ' as ' || in_source ;
      wt_assert.raises
         (msg_in         => 'Compile ' || in_ptype || ' ' || in_pname
         ,check_call_in  => l_sql_txt
         ,against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      for buff in (select * from user_errors
                    where attribute = 'ERROR'
                     and  name      = in_pname
                     and  type      = in_ptype
                    order by sequence)
      loop
         l_errtxt := l_errtxt || buff.line || ', ' ||
            buff.position || ': ' || buff.text || CHR(10);
      end loop;
      wt_assert.isnull
         (msg_in        => 'Compile ' || in_ptype || ' ' || in_pname ||
                            ' Error'
         ,check_this_in => l_errtxt);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.objexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => g_current_user,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end tl_compile_db_object;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_drop_db_object
      (in_ptype  in  varchar2,
       in_pname  in  varchar2)
   is
      l_sql_txt  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'drop ' || in_ptype || ' ' || in_pname;
      wt_assert.raises
         (msg_in         => 'drop ' || in_ptype || ' ' || in_pname
         ,check_call_in  => l_sql_txt
         ,against_exc_in => '');
      wt_assert.objnotexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => g_current_user,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end tl_drop_db_object;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


---------------------
--  Public Procedures
---------------------


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


------------------------------------------------------------
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_create_drop_db_link
   is
      num_rows  number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Create and Drop DB Link';
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links before testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 0);
      wt_assert.raises (
         msg_in          => 'Create the Database Link',
         check_call_in   => 'begin wt_job.create_db_link(''' ||
                                   g_current_user || ''',''' ||
                                   lower(g_current_user) || '''); end;',
         against_exc_in  => '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links during testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 1);
      select count(*)
       into  num_rows
       from  wt_self_test;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Rows from WT_SELF_TEST@' || g_current_user,
         check_query_in   => 'select count(*) from WT_SELF_TEST@' || g_current_user,
         against_value_in => num_rows);
      --------------------------------------  WTPLSQL Testing --
      rollback;
      wt_assert.raises (
         msg_in          => 'Close the Database Link',
         check_call_in   => 'alter session close database link ' ||
                                   g_current_user,
         against_exc_in  => '');
      wt_assert.raises (
         msg_in          => 'Drop the Database Link',
         check_call_in   => 'begin wt_job.drop_db_link(''' ||
                                   g_current_user || '''); end;',
         against_exc_in  => '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.objnotexists (
         msg_in        =>  g_current_user || ' Database Link',
         obj_owner_in  =>  g_current_user,
         obj_name_in   =>  g_current_user,
         obj_type_in   =>  'DATABASE LINK');
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of DB Links after testing',
         check_query_in   => 'select count(*) from user_db_links',
         against_value_in => 0);
   end t_create_drop_db_link;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
                           ,1,30)
      ,job_type   => 'PLSQL_BLOCK'
      ,job_action => plsql_block
      ,enabled    => TRUE);
end test_run;


------------------------------------------------------------
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_run_and_wait_for_job
   is
      num_rows  number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Run and Wait for Job';
      tl_compile_db_object ('PACKAGE', 'WT_RUN_AND_WAIT_TEST','
            procedure wtplsql_run;
         end WT_RUN_AND_WAIT_TEST;');
      tl_compile_db_object ('PACKAGE BODY', 'WT_RUN_AND_WAIT_TEST','
         procedure wtplsql_run is
         begin
            wt_assert.isnotnull (
               msg_in        => ''Test1'',
               check_this_in => ''Test1'');
         end wtplsql_run;
         end WT_RUN_AND_WAIT_TEST;');
      select count(*) into num_rows
       from  wt_test_runs_vw
       where test_runner_owner = g_current_user
        and  test_runner_name  = 'WT_RUN_AND_WAIT_TEST';
      wt_assert.isnotnull (
         msg_in        => 'Number of Test Runs Before',
         check_this_in => num_rows);
      wt_assert.raises
         (msg_in         => 'wt_job.test_run'
         ,check_call_in  => 'begin wt_job.test_run(''' || g_current_user ||
                            ''', ''WT_RUN_AND_WAIT_TEST''); end;'
         ,against_exc_in => '');
      
      wt_assert.raises
         (msg_in         => 'wait_for_all_tests'
         ,check_call_in  => 'begin wt_job.wait_for_all_tests(2,0.5); end;'
         ,against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Test Runs After',
         check_query_in   => 'select count(*) from wt_test_runs_vw
                               where test_runner_id = wt_test_runner.get_id(''' ||
                                                      g_current_user ||
                                               ''', ''WT_RUN_AND_WAIT_TEST'')',
         against_value_in => num_rows);
      tl_drop_db_object('PACKAGE', 'WT_RUN_AND_WAIT_TEST');
   end t_run_and_wait_for_job;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      wtplsql.g_DBOUT := 'WT_JOB:PACKAGE BODY';
      select username into g_current_user from user_users;
      --------------------------------------  WTPLSQL Testing --
      t_create_drop_db_link;
      t_run_and_wait_for_job;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_job;
