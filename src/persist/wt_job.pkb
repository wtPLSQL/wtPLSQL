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
procedure test_runner
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
end test_runner;


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
   cursor main is
      select job_name from wt_scheduler_jobs_vw
       where status = 'RUNNING';
   buff main%ROWTYPE;
   max_intervals  pls_integer;
   running        boolean;
begin
   max_intervals := nvl(in_timeout_seconds,3600) /
                    nvl(in_check_interval_seconds,60);
   for i in 1 .. max_intervals
   loop
      open main;
      fetch main into buff;
      running := main%FOUND;
      close main;
      exit when not running;
      dbms_lock.sleep(in_check_interval_seconds);
   end loop;
end wait_for_all_tests;


------------------------------------------------------------
procedure create_db_link
      (in_schema_name  in varchar2
      ,in_password     in varchar2)
is
   connect_string  varchar2(2000);
begin
   connect_string := '//' || 'localhost' ||
                      ':' || 1521        ||
                      '/' || SYS_CONTEXT('USERENV','SERVICE_NAME');
   execute immediate
      'create database link ' || in_schema_name ||
               ' connect to ' || in_schema_name ||
            ' identified by ' || in_password    ||
                  ' using ''' || connect_string || '''';
end create_db_link;

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


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      null;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_job;
