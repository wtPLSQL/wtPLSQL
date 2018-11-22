create or replace package hook
   authid definer
as

   TYPE run_nt_type is table
      of varchar2(4000);
   run_nt  run_nt_type;
   TYPE run_aa_type is table
      of run_nt_type
      index by varchar2(20);
   run_aa  run_aa_type;

   before_test_all_active      boolean := FALSE;
   before_test_run_active      boolean := FALSE;
   execute_test_runner_active  boolean := FALSE;
   after_assertion_active      boolean := FALSE;
   after_test_run_active       boolean := FALSE;
   after_test_all_active       boolean := FALSE;
   ad_hoc_report_active        boolean := FALSE;

   procedure before_test_all;
   procedure before_test_run;
   procedure execute_test_runner;
   procedure after_assertion;
   procedure after_test_run;
   procedure after_test_all;
   procedure ad_hoc_report;
   procedure init;

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      TYPE  save_nt_type is table of hooks%ROWTYPE;
      t_hooks_rec   hooks%ROWTYPE;
      t_save_nt     save_nt_type;
      --
      TYPE hooks_nt_type is table of hooks.hook_name%TYPE;
      t_hooks_nt    hooks_nt_type;
      --
      t_run_assert_hook  boolean := TRUE;
      t_test_hook_msg    varchar2(4000);
      --
      procedure test_hook
         (in_msg  in  varchar2);
      procedure WTPLSQL_RUN;
   $END

end hook;
