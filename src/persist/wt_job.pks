create or replace package wt_job
   authid definer
as

   -- Run all test runners in a different schema
   -- Returns before all test runners are complete
   procedure test_all_schema
      (in_schema_name   in  varchar2);

   -- Run all test runners in all schema in sequence
   -- Returns before all test runners are complete
   procedure test_all_schema_sequential;

   -- Run all test runners in all schema in parallel
   -- Returns before all test runners are complete
   procedure test_all_schema_parallel;

   -- Waits for all test runners to complete
   procedure wait_for_all_schema
      (in_timeout_seconds         in number  default null
      ,in_check_interval_seconds  in number  default 60);

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

end wt_job;
