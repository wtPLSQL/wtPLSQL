create or replace package body wtplsql
as

   C_KEEP_NUM_RECS  number := 20;

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   wt_test_runs%ROWTYPE;

   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      TYPE test_all_aa_type is table of varchar2(400) index by varchar2(400);
      test_all_aa       test_all_aa_type;
      wtplsql_skip_test boolean := FALSE;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------

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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
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
      --------------------------------------  WTPLSQL Testing --
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
         l_err_in := 'ORA-20002: RUNNER_NAME "BOGUS" is not valid';
         check_runner;
         test_sqlerrm;
      exception when others then
         test_sqlerrm;
      end;
   end tc_check_runner;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_insert_test_run
   is
      l_test_runs_rec  wt_test_runs%ROWTYPE;
      l_num_recs       number;
   begin
      wt_assert.g_testcase := 'INSERT_TEST_RUN';
      l_test_runs_rec := g_test_runs_rec;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'INSERT_TEST_RUN Happy Path 1',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || l_test_runs_rec.id,
         against_value_in => 1);
      delete from wt_test_runs
       where id = l_test_runs_rec.id;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'INSERT_TEST_RUN Happy Path 2',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || l_test_runs_rec.id,
         against_value_in => 0);
   end tc_insert_test_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
   l_test_runs_rec_NULL   wt_test_runs%ROWTYPE;
begin
   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      -- This will avoid running the TEST_RUN procedure for some self-tests
      if wtplsql_skip_test
      then
         test_all_aa(in_package_name) := 'X';
         return;
      end if;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
   -- Reset the Test Runs Record before checking anything
   g_test_runs_rec              := l_test_runs_rec_NULL;
   g_test_runs_rec.id           := wt_test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_owner := USER;
   g_test_runs_rec.runner_name  := in_package_name;
   check_runner;
   -- Initialize
   delete_runs(in_runner_owner => g_test_runs_rec.runner_owner  -- Autonomous Transaction COMMIT
              ,in_runner_name  => g_test_runs_rec.runner_name);
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

--==============================================================--
-- No Unit Test for TEST_RUN.
--   Too complicated because testing occurs while the TEST_RUN
--   procedure is executing.  This also prevents 100% profiling.
--==============================================================--


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_test_all
   is
   begin
      wt_assert.g_testcase := 'TEST_ALL';
      test_all_aa.DELETE;
      wtplsql_skip_test := TRUE;
      -- TEST_ALL will populate the test_all_aa array
      wtplsql.test_all;
      wtplsql_skip_test := FALSE;
      -- This package should be in the test_all_aa array
      wt_assert.this (
         msg_in        => 'TEST_ALL Happy Path 1',
         check_this_in => test_all_aa.EXISTS('WTPLSQL'));
   end tc_test_all;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_runs
      (in_test_run_id  in number)
is
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
   -- Profiler delete must be first because it contains a
   --    PRAGMA AUTONOMOUS_TRANSACTION
   wt_profiler.delete_records(in_test_run_id);
   wt_result.delete_records(in_test_run_id);
   delete from wt_test_runs where id = in_test_run_id;
   COMMIT;
end delete_runs;

procedure delete_runs
      (in_runner_owner  in varchar2
      ,in_runner_name   in varchar2)
is
   num_recs    number;
begin
   num_recs := 1;
   for buf2 in (select id from wt_test_runs
                 where runner_owner = g_test_runs_rec.runner_owner
                  and  runner_name  = g_test_runs_rec.runner_name
                 order by start_dtm desc, id desc)
   loop
      -- Keep the last 20 rest runs for this USER
      if num_recs > C_KEEP_NUM_RECS
      then
       -- Autonomous Transaction COMMIT
       delete_runs(buf2.id);
      end if;
      num_recs := num_recs + 1;
   end loop;
end delete_runs;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_delete_run_id
   is
      l_num_recs  number;
   begin
      wt_assert.g_testcase := 'DELETE_RUNS TEST_RUN_ID';
      --------------------------------------  WTPLSQL Testing --
      -- Can't "load" records into WT_TEST_RUNS because
      --  DELETE_RECORDS has already run when we arrive here.
      select count(*)
       into  l_num_recs
       from  wt_test_runs
       where runner_owner = USER
        and  runner_name  = g_test_runs_rec.runner_name;
      wt_assert.isnotnull (
         msg_in        => 'Number of WT_TEST_RUNS Records',
         check_this_in => l_num_recs);
      wt_assert.this (
         msg_in        => 'Number of WT_TEST_RUNS Records <= ' || C_KEEP_NUM_RECS,
         check_this_in => l_num_recs <= C_KEEP_NUM_RECS);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_test_runs values g_test_runs_rec;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'DELETE_RECORDS Insert 1 record',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 1);
      delete_runs(g_test_runs_rec.id);  -- Autonomous Transaction
      wt_assert.eqqueryvalue (
         msg_in           => 'DELETE_RECORDS Delete 1 record',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 0);
      delete_runs(-99);  -- Should run without error
   end tc_delete_run_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
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
      --------------------------------------  WTPLSQL Testing --
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
      --------------------------------------  WTPLSQL Testing --
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
   procedure WTPLSQL_RUN
   is
   begin
      tc_test_runs_rec_and_table;
      tc_check_runner;
      tc_insert_test_run;
      tc_test_all;
      tc_delete_run_id;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wtplsql;
