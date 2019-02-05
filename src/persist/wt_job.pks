create or replace package wt_job
   authid definer
as

   --BEGIN
   --    dbms_scheduler.create_credential(
   --        username => 'WTP_DEMO',
   --        password => 'WTP_DEMO',
   --        comments => 'WTP_DEMO',
   --        credential_name => '"WTP"."WTP_DEMO"'
   --    );
   --END;

   -- Run a test runner in a different schema
   -- Returns before the test runner is complete
   procedure test_run_schema
      (in_schema_name   in  varchar2
      ,in_package_name  in  varchar2);

   -- Run all test runners in a different schema
   -- Returns before all test runners are complete
   procedure test_all_schema
      (in_schema_name   in  varchar2);

   -- Run all test runners in all schema in parallel
   -- Returns before all test runners are complete
   procedure test_all_schema_parallel;

   -- Waits for all test runners to complete
   procedure wait_for_all_schema
      (in_timeout_seconds         in number  default 3600
      ,in_check_interval_seconds  in number  default 60);

   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_job;
