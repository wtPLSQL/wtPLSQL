create or replace package wt_hook
   authid definer
as

   TYPE run_nt_type is table
      of varchar2(4000);
   run_nt  run_nt_type;
   TYPE run_aa_type is table
      of run_nt_type
      index by varchar2(20);
   run_aa  run_aa_type;

   before_test_all_active     boolean := FALSE;
   before_run_init_active     boolean := FALSE;
   after_run_init_active      boolean := FALSE;
   after_assertion_active     boolean := FALSE;
   before_run_final_active    boolean := FALSE;
   after_run_final_active     boolean := FALSE;
   after_test_all_active      boolean := FALSE;
   before_delete_runs_active  boolean := FALSE;
   after_delete_runs_active   boolean := FALSE;

   procedure before_test_all;
   procedure before_run_init;
   procedure after_run_init;
   procedure after_assertion;
   procedure before_run_final;
   procedure after_run_final;
   procedure after_test_all;
   procedure before_delete_runs;
   procedure after_delete_runs;

end wt_hook;
