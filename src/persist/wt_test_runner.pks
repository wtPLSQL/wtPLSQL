create or replace package wt_test_runner
   authid definer
as

   -- Return a Test Runner Surrogate Key.
   -- Return NULL is the Test Runner does not exist.
   function get_id
      (in_owner  in varchar2
      ,in_name   in varchar2)
   return number;

   -- Return a Test Runner Surrogate Key.
   -- Add the Test Runner if it does not exist.
   function dim_id
      (in_owner  in varchar2
      ,in_name   in varchar2)
   return number;

   -- Delete all records for this Test Runner
   procedure delete_records
      (in_test_runner_id  in number);
   
   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_test_runner;
