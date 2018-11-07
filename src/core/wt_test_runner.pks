create or replace package wt_test_runner
   authid definer
as

   function get_id
      (in_owner  in varchar2
      ,in_name   in varchar2)
   return number;

   procedure delete_id
      (in_id  in number);

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
