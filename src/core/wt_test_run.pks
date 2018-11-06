create or replace package wt_test_run
   authid definer
as

   procedure insert_test_run
      (in_test_runs_rec  in wt_test_runs_vw%ROWTYPE);

   --   Use the SET_LAST_RUN procedure to set the IS_LAST_RUN flag
   --   after running this procedure.
   procedure clear_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2);

   --   Use the CLEAR_LAST_RUN procedure to clear the IS_LAST_RUN
   --   flag before running this procedure.
   procedure set_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2);

end wt_testcase;
