create or replace package wtplsql authid current_user
as

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

   procedure clear_tables;

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
      procedure callback_1;
      procedure callback_2;
   $END

end wtplsql;
