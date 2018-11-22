create or replace package wtplsql
   authid definer
as

   C_RUNNER_ENTRY_POINT constant varchar2(30) := 'WTPLSQL_RUN';

   function get_runner_entry_point
      return varchar2 deterministic;

   function show_version
      return varchar2;

   g_keep_num_recs  number := 10;

   -- Database Object Under Test.
   --   Modify as required
   g_DBOUT    varchar2(128);

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

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
