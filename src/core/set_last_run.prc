create or replace procedure set_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2)
   authid definer
as
   -- This procedure is required to prevent granting UPDATE on
   --   WT_TEST_RUNS to PUBLIC.  The WTPLSQL package must run
   --   with calling user permissions.  Use the CLEAR_LAST_RUN
   --   procedure to clear the IS_LAST_RUN flag before running
   --   this procedure.
begin
   for buff in (select * from wt_test_runs
                 where runner_owner = in_runner_owner
                  and  runner_name  = in_runner_name
                  and  is_last_run  = in_last_run_flag )
   loop
      -- Abort if a IS_LAST_RUN flag is already set
      return;
   end loop;
   update wt_test_runs
     set  is_last_run = in_last_run_flag
    where runner_owner = in_runner_owner
     and  runner_name  = in_runner_name
     and  start_dtm = (
          select max(trn.start_dtm)
           from  wt_test_runs  trn
           where trn.runner_owner = in_runner_owner
            and  trn.runner_name  = in_runner_name  );
end set_last_run;