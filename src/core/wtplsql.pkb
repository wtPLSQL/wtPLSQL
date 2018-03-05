create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   wt_test_runs%ROWTYPE;

----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
-- This procedure is separated for internal WTPLSQL testing
procedure check_runner
is
   l_package_check        number;
begin
   -- These RAISEs can be captured because the Test Runs Record is set.
   --  Check for NULL Runner Name
   if g_test_runs_rec.runner_name is null
   then
      raise_application_error (-20001, 'RUNNER_NAME is null');
   end if;
   --  Check for Valid Runner Name
   select count(*) into l_package_check
    from  all_arguments
    where owner         = USER
     and  object_name   = 'WTPLSQL_RUN'
     and  package_name  = g_test_runs_rec.runner_name
     and  argument_name is null
     and  position      = 1
     and  sequence      = 0;
   if l_package_check != 1
   then
      raise_application_error (-20002, 'RUNNER_NAME "' ||
                        g_test_runs_rec.runner_name || '" is not valid');
   end if;
end check_runner;

------------------------------------------------------------
procedure insert_test_run
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_wt_test_runs_recNULL  wt_test_runs%ROWTYPE;
begin
   if g_test_runs_rec.id is null
   then
      return;
   end if;
   g_test_runs_rec.end_dtm := systimestamp;
   insert into wt_test_runs values g_test_runs_rec;
   g_test_runs_rec := l_wt_test_runs_recNULL;
   COMMIT;
end insert_test_run;


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
   l_test_runs_rec_NULL   wt_test_runs%ROWTYPE;
begin
   -- Reset the Test Runs Record before checking anything
   g_test_runs_rec              := l_test_runs_rec_NULL;
   g_test_runs_rec.id           := wt_test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_owner := USER;
   g_test_runs_rec.runner_name  := in_package_name;
   check_runner;
   -- Initialize
   delete_records;       -- Autonomous Transaction COMMIT
   wt_result.initialize(g_test_runs_rec.id);
   wt_profiler.initialize(in_test_run_id      => g_test_runs_rec.id,
                          in_runner_name      => g_test_runs_rec.runner_name,
                          out_dbout_owner     => g_test_runs_rec.dbout_owner,
                          out_dbout_name      => g_test_runs_rec.dbout_name,
                          out_dbout_type      => g_test_runs_rec.dbout_type,
                          out_trigger_offset  => g_test_runs_rec.trigger_offset,
                          out_profiler_runid  => g_test_runs_rec.profiler_runid);

   -- Call the Test Runner
   begin
      execute immediate 'BEGIN ' || in_package_name || '.WTPLSQL_RUN; END;';
   exception
      when OTHERS
      then
         g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                                 dbms_utility.format_error_backtrace
                                                ,1,4000);
   end;

   -- Finalize
   wt_profiler.pause;
   insert_test_run;       -- Autonomous Transaction COMMIT
   wt_profiler.finalize;  -- Autonomous Transaction COMMIT
   wt_result.finalize;    -- Autonomous Transaction COMMIT

exception
   when OTHERS
   then
      g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace ||
                                              CHR(10) || g_test_runs_rec.error_message
                                             ,1,4000);
      wt_profiler.pause;
      insert_test_run;       -- Autonomous Transaction COMMIT
      wt_profiler.finalize;  -- Autonomous Transaction COMMIT
      wt_result.finalize;    -- Autonomous Transaction COMMIT

end test_run;

------------------------------------------------------------
procedure test_all
is
begin
   select package_name
     bulk collect into g_runners_nt
    from  all_arguments  t1
    where owner       = USER
     and  object_name = 'WTPLSQL_RUN'
     and  position    = 1
     and  sequence    = 0
     and  data_type   is null
     and  not exists (
          select 'x' from all_arguments  t2
           where t2.owner       = USER
            and  t2.object_name = t1.object_name
            and  t2.position    > t1.position
            and  t2.sequence    > t1.sequence
            and  (   t2.overload is null
                  OR t2.overload = t1.overload)
          );
   for i in 1 .. g_runners_nt.COUNT
   loop
      test_run(g_runners_nt(i));
   end loop;
end test_all;

------------------------------------------------------------
procedure delete_records
      (in_test_run_id  in number default NULL)
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   num_recs    number;
   procedure del_rec (in_id in number) is begin
      -- Profiler delete must be first because it contains a
      --    PRAGMA AUTONOMOUS_TRANSACTION
      wt_profiler.delete_records(in_id);
      wt_result.delete_records(in_id);
      delete from wt_test_runs
       where id = in_id;
      COMMIT;
   end del_rec;
begin
   if in_test_run_id is not null
   then
      del_rec(in_test_run_id);
   else
      num_recs := 1;
      for buff in (select id from wt_test_runs
                    where runner_owner = USER
                     and  runner_name  = g_test_runs_rec.runner_name
                    order by start_dtm desc, id desc)
      loop
         -- Keep the last 20 rest runs for this USER
         if num_recs > 20
         then
            del_rec(buff.id);
         end if;
         num_recs := num_recs + 1;
      end loop;
   end if;
end delete_records;


--==============================================================--
--===============--%WTPLSQL_begin_ignore_lines%--===============--
--==============================================================--
--  Embedded Test Procedures

$IF $$WTPLSQL_SELFTEST
$THEN

----------------------------------------
procedure tc_test_runs_rec_and_table
is
begin
   wt_assert.g_testcase := 'TEST_RUNS_REC_AND_TABLE';
   -- This Test Case runs in the EXECUTE IMMEDAITE in the TEST_RUN
   --   procedure in this package.
   wt_assert.isnotnull
            (msg_in        => 'g_test_runs_rec.id'
            ,check_this_in => g_test_runs_rec.id);
   wt_assert.isnotnull
            (msg_in        => 'g_test_runs_rec.start_dtm'
            ,check_this_in => g_test_runs_rec.start_dtm);
   wt_assert.isnotnull
            (msg_in        => 'g_test_runs_rec.runner_owner'
            ,check_this_in => g_test_runs_rec.runner_owner);
   wt_assert.eq
            (msg_in          => 'g_test_runs_rec.runner_name'
            ,check_this_in   => g_test_runs_rec.runner_name
            ,against_this_in => 'WTPLSQL');
   wt_assert.isnull
            (msg_in        => 'g_test_runs_rec.dbout_owner'
            ,check_this_in => g_test_runs_rec.dbout_owner);
   wt_assert.isnull
            (msg_in          => 'g_test_runs_rec.dbout_name'
            ,check_this_in   => g_test_runs_rec.dbout_name);
   wt_assert.isnull
            (msg_in          => 'g_test_runs_rec.dbout_type'
            ,check_this_in   => g_test_runs_rec.dbout_type);
   wt_assert.isnull
            (msg_in        => 'g_test_runs_rec.profiler_runid'
            ,check_this_in => g_test_runs_rec.profiler_runid);
   wt_assert.isnull
            (msg_in        => 'g_test_runs_rec.end_dtm'
            ,check_this_in => g_test_runs_rec.end_dtm);
   wt_assert.isnull
            (msg_in        => 'g_test_runs_rec.error_message'
            ,check_this_in => g_test_runs_rec.error_message);
   wt_assert.eqqueryvalue
            (msg_in             => 'TEST_RUNS Record for this TEST_RUN'
            ,check_query_in     => 'select count(*) from WT_TEST_RUNS' ||
                                   ' where id = ''' || g_test_runs_rec.id || ''''
            ,against_value_in   => 0);
end tc_test_runs_rec_and_table;

----------------------------------------
procedure tc_check_runner
is
   l_save_test_runs_rec   wt_test_runs%ROWTYPE := g_test_runs_rec;
   l_msg_in   varchar2(4000);
   l_err_in   varchar2(4000);
   procedure test_sqlerrm is begin
      -- Restore the G_TEST_RUNS_REC
      g_test_runs_rec := l_save_test_runs_rec;
      wt_assert.eq
               (msg_in          => l_msg_in
               ,check_this_in   => SQLERRM
               ,against_this_in => l_err_in);
   end test_sqlerrm;
begin
   wt_assert.g_testcase := 'CHECK_RUNNER';
   -- This Test Case runs in the EXECUTE IMMEDAITE in the TEST_RUN
   --   procedure in this package.
   begin
      g_test_runs_rec.runner_name := '';
      l_msg_in := 'Null RUNNER_NAME';
      l_err_in := 'ORA-20001: RUNNER_NAME is null';
      check_runner;
      test_sqlerrm;
   exception when others then
      test_sqlerrm;
   end;
   begin
      g_test_runs_rec.runner_name := 'BOGUS';
      l_msg_in := 'Invalid RUNNER_NAME';
      l_err_in := 'ORA-20002: RUNNER_NAME is not valid';
      check_runner;
      test_sqlerrm;
   exception when others then
      test_sqlerrm;
   end;
end tc_check_runner;

----------------------------------------
procedure WTPLSQL_RUN
is
begin
   -- This runs like a self-contained "in-circuit" test.
   tc_check_runner;
   tc_test_runs_rec_and_table;
end;

$END
--==============================================================--

end wtplsql;
