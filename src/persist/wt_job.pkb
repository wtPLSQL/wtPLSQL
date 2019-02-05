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
procedure test_run_schema
      (in_schema_name   in  varchar2
      ,in_package_name  in  varchar2)
is
begin
   dbms_scheduler.create_job
      (job_name        => 'WT_RUN_SCHEMA_' ||
                          substr(in_schema_name,1,100)
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin wtplsql.test_run(' || in_package_name || '); end;'
      ,credential_name => in_schema_name);
end test_run_schema;


------------------------------------------------------------
-- Run all test runners in a different schema
-- Returns before all test runners are complete
procedure test_all_schema
      (in_schema_name   in  varchar2)
is
begin
   dbms_scheduler.create_job
      (job_name        => 'WT_RUN_SCHEMA_' ||
                          substr(in_schema_name,1,100)
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin wtplsql.test_all; end;'
      ,credential_name => in_schema_name);
end test_all_schema;


------------------------------------------------------------
-- Run all test runners in all schema in parallel
-- Returns before all test runners are complete
procedure test_all_schema_parallel
is
begin
   for buff in (
      select owner
       from  wt_qual_test_runners_vw
       group by owner)
   loop
      test_all_schema(buff.owner);
   end loop;
end test_all_schema_parallel;


------------------------------------------------------------
-- Waits for all test runners to complete
procedure wait_for_all_schema
      (in_timeout_seconds         in number  default 3600
      ,in_check_interval_seconds  in number  default 60)
is
   cursor main is
      select job_name from wt_scheduler_jobs_vw
       where status = 'RUNNING';
   buff     main%ROWTYPE;
   running  boolean;
begin
   for i in 1 .. trunc(in_timeout_seconds/in_check_interval_seconds)
   loop
      open main;
      fetch main into buff;
      running := main%FOUND;
      close main;
      exit when not running;
      dbms_lock.sleep(in_check_interval_seconds);
   end loop;
end wait_for_all_schema;


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
