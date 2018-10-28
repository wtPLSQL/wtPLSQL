create or replace package wtplsql authid current_user
as
   -- AUTHID CURRENT_USER is required for dynamic PL/SQL execution.

   IS_LAST_RUN_FLAG  constant varchar2(1) := 'Y';

   function get_last_run_flag
      return varchar2 deterministic;

   C_RUNNER_ENTRY_POINT constant varchar2(30) := 'WTPLSQL_RUN';

   function get_runner_entry_point
      return varchar2 deterministic;

   function show_version
      return varchar2;

   g_keep_num_recs  number := 20;

   g_test_runs_rec   wt_test_runs%ROWTYPE;

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
