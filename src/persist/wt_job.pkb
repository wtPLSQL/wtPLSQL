create or replace package body wt_job
as


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure test_run_schema
      (in_schema_name   in  varchar2
      ,in_package_name  in  varchar2)
is
begin
   dbms_scheduler.create_job
      (job_name        => 'WT_RUN_SCHEMA_' ||
                          substr(in_schema_name,1,100)
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin wtplsql.test_run(' ||
                           in_package_name || '); end;'
      ,credential_name => in_schema_name);
end test_run_schema;


------------------------------------------------------------
procedure test_all_schema
      (in_schema_name   in  varchar2)
is
begin
   null;
end test_all_schema;


------------------------------------------------------------
procedure test_all_schema_parallel
is
begin
   null;
end test_all_schema_parallel;


------------------------------------------------------------
procedure test_all_schema_sequential
is
begin
   null;
end test_all_schema_sequential;


------------------------------------------------------------
procedure wait_for_all_schema
      (in_timeout_seconds         in number  default null
      ,in_check_interval_seconds  in number  default 60)
is
begin
   null;
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


end wtplsql;
