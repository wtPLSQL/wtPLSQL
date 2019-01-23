create or replace package wt_test_run_stat authid definer
as

   procedure initialize;

   procedure add_result
      (in_results_rec  in wt_results%ROWTYPE);

   procedure add_profile
      (in_dbout_profiles_rec  in wt_dbout_profiles%ROWTYPE);

   procedure finalize;

   procedure delete_records
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

end wt_test_run_stat;
