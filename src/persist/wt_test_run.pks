create or replace package wt_test_run
   authid definer
as

   C_LAST_RUN_FLAG  constant varchar2(1) := 'Y';

   g_keep_num_recs    number := 20;

   function get_last_run_flag
      return varchar2 deterministic;

   g_test_runs_rec  wt_test_runs%ROWTYPE;

   procedure initialize;

   procedure finalize;

   procedure clear_last_run
      (in_test_runner_id   in number);

   procedure set_last_run
      (in_test_runner_id   in number);

   procedure delete_runs
      (in_test_runner_id   in number);

   procedure delete_run_id
      (in_test_run_id   in number);

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

end wt_test_run;
