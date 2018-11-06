create or replace package wt_test_run
   authid definer
as

   procedure insert_test_run
      (in_test_runs_rec  in wt_test_runs_vw%ROWTYPE);

   procedure delete_runs
      (in_test_run_id  in number);

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
