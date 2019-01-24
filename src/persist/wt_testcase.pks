create or replace package wt_testcase
   authid definer
as

   -- Return a Testcase Surrogate Key.
   -- Return NULL is the Testcase does not exist.
   function get_id
      (in_testcase   in varchar2)
   return number;

   -- Return a Testcase Surrogate Key.
   -- Add the Testcase if it does not exist.
   function dim_id
      (in_testcase   in varchar2)
   return number;

   -- Delete all records with no child records
   procedure delete_records;
   
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

end wt_testcase;
