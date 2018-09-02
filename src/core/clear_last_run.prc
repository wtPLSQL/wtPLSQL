create or replace procedure clear_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2)
   authid definer
as
   -- This procedure is required to prevent granting UPDATE on
   --   WT_TEST_RUNS to PUBLIC.  The WTPLSQL package must run
   --   with calling user permissions.  If this procedure is
   --   run by mistake, it is a simple matter to correct the
   --   IS_LAST_RUN flag.
begin
   update wt_test_runs
     set  is_last_run = NULL
    where runner_owner = in_runner_owner
     and  runner_name  = in_runner_name
     and  is_last_run  = in_last_run_flag;
end clear_last_run;