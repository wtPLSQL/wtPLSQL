create or replace package wtplsql authid current_user
as

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

   procedure delete_records
      (in_test_run_id  in number default NULL);

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

end wtplsql;
