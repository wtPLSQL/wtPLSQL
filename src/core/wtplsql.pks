create or replace package wtplsql authid current_user
as
   -- AUTHID CURRENT_USER is required for dynamic PL/SQL execution.

   function show_version
      return varchar2;

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

   procedure delete_runs
      (in_test_run_id  in number);

   procedure delete_runs
      (in_runner_owner  in varchar2
      ,in_runner_name   in varchar2);

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   -- begin
   --    dbms_utility.compile_schema('WTP',TRUE,FALSE);
   -- end;
   -- /
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wtplsql;
