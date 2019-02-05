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
   procedure test_runner
      (in_schema_name  in  varchar2
      ,in_runner_name  in  varchar2);

   -- Run all test runners in a different schema
   -- Returns before all test runners are complete
   procedure test_all
      (in_schema_name   in  varchar2);

   -- Run all test runners in all schema in sequence
   -- Returns before all test runners are complete
   procedure test_all_sequential;

   -- Run all test runners in all schema in parallel
   -- Returns before all test runners are complete
   procedure test_all_parallel;

   -- Waits for all test runners to complete
   procedure wait_for_all_tests
      (in_timeout_seconds         in number  default 3600
      ,in_check_interval_seconds  in number  default 60);

   procedure create_db_link
      (in_schema_name  in varchar2
      ,in_password     in varchar2);

   procedure drop_db_link
      (in_schema_name  in varchar2);

   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_job;
