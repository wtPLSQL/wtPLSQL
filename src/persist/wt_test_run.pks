create or replace package wt_test_run
   authid definer
as

   IS_LAST_RUN_FLAG  constant varchar2(1) := 'Y';

   function get_last_run_flag
      return varchar2 deterministic;

   g_test_runs_rec  core_data.run_rec_type;

   procedure insert_test_run
      (in_test_runs_rec  in core_data.run_rec_type);

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

end wt_test_run;
