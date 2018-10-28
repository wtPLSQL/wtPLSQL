create or replace package body wtplsql
as

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
    from  user_procedures
    where procedure_name = C_RUNNER_ENTRY_POINT
     and  object_name    = g_test_runs_rec.runner_name
     and  object_type    = 'PACKAGE';
   if l_package_check != 1
   then
      raise_application_error (-20002, 'RUNNER_NAME Procedure "' ||
                                     g_test_runs_rec.runner_name ||
                                     '.' || C_RUNNER_ENTRY_POINT ||
                                                '" is not valid' );
   end if;
end check_runner;


$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_check_runner
   is
      l_save_test_runs_rec   wt_test_runs%ROWTYPE := g_test_runs_rec;
      l_msg_in   varchar2(4000);
      l_err_in   varchar2(4000);
      --------------------------------------  WTPLSQL Testing --
      procedure l_test_sqlerrm is begin
         -- Restore the G_TEST_RUNS_REC
         g_test_runs_rec := l_save_test_runs_rec;
         wt_assert.eq
                  (msg_in          => l_msg_in
                  ,check_this_in   => SQLERRM
                  ,against_this_in => l_err_in);
      end l_test_sqlerrm;
   begin
      --------------------------------------  WTPLSQL Testing --
      -- This Test Case runs in the EXECUTE IMMEDIATE in the TEST_RUN
      --   procedure in this package.
      wt_assert.g_testcase := 'CHECK_RUNNER Sad Path 1';
      begin
         g_test_runs_rec.runner_name := '';
         l_msg_in := 'Null RUNNER_NAME';
         l_err_in := 'ORA-20001: RUNNER_NAME is null';
         check_runner;
         l_test_sqlerrm;
      exception when others then
         l_test_sqlerrm;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'CHECK_RUNNER Sad Path 2';
      begin
         g_test_runs_rec.runner_name := 'BOGUS';
         l_msg_in := 'Invalid RUNNER_NAME';
         l_err_in := 'ORA-20002: RUNNER_NAME "BOGUS.' ||
                     C_RUNNER_ENTRY_POINT || '" is not valid';
         check_runner;
         l_test_sqlerrm;
      exception when others then
         l_test_sqlerrm;
      end;
   end t_check_runner;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure insert_test_run
is
   l_wt_test_runs_recNULL  wt_test_runs%ROWTYPE;
begin
   if g_test_runs_rec.id is null
   then
      return;
   end if;
   g_test_runs_rec.end_dtm := systimestamp;
   clear_last_run
      (in_runner_owner  => g_test_runs_rec.runner_owner
      ,in_runner_name   => g_test_runs_rec.runner_name
      ,in_last_run_flag => IS_LAST_RUN_FLAG);
   insert into wt_test_runs values g_test_runs_rec;
   g_test_runs_rec := l_wt_test_runs_recNULL;
end insert_test_run;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_insert_test_run
   is
      --------------------------------------  WTPLSQL Testing --
      TYPE l_dbmsout_buff_type is table of varchar2(32767);
      l_dbmsout_buff   l_dbmsout_buff_type;
      l_test_runs_rec  wt_test_runs%ROWTYPE;
      l_dbmsout_line   varchar2(32767);
      l_dbmsout_stat   number;
      l_num_recs       number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INSERT_TEST_RUN Happy Path 1';
      wt_assert.eqqueryvalue (
         msg_in           => 'Records Before Insert',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec := g_test_runs_rec;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      delete from wt_test_runs
       where id = l_test_runs_rec.id;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --	
      wt_assert.g_testcase := 'INSERT_TEST_RUN Happy Path 2';
      l_test_runs_rec := g_test_runs_rec;
      g_test_runs_rec.id := null;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 0);
   end t_insert_test_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_last_run_flag
      return varchar2
is
begin
   return IS_LAST_RUN_FLAG;
end get_last_run_flag;

------------------------------------------------------------
function get_runner_entry_point
   return varchar2
is
begin
   return C_RUNNER_ENTRY_POINT;
end get_runner_entry_point;

------------------------------------------------------------
function show_version
   return varchar2
is
   ret_str  wt_version.text%TYPE;
begin
   select max(t1.text) into ret_str
    from  wt_version  t1
    where t1.install_dtm = (select max(t2.install_dtm)
                             from  wt_version  t2);
   return ret_str;
exception when NO_DATA_FOUND
then
   return '';
end show_version;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_show_version
   is
      existing_version   wt_version.text%TYPE;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Show Version Happy Path';
      existing_version := show_version;
      wt_assert.isnotnull (
         msg_in        => 'Test Existing Version',
         check_this_in => existing_version);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_version (install_dtm, action, text)
         values (to_date('31-DEC-4000','DD-MON-YYYY'), 'TESTING', 'TESTING');
      wt_assert.eq (
         msg_in          => 'Test New Version',
         check_this_in   => show_version,
         against_this_in => 'TESTING');
      --------------------------------------  WTPLSQL Testing --
      rollback;
      wt_assert.eq (
         msg_in          => 'Return to Existing Version',
         check_this_in   => show_version,
         against_this_in => existing_version);
   end t_show_version;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
   pragma AUTONOMOUS_TRANSACTION;  -- Required if called as Remote Procedure Call (RPC)
   l_test_runs_rec_NULL   wt_test_runs%ROWTYPE;
   l_error_stack          varchar2(32000);
   procedure concat_err_message
         (in_err_msg  in varchar2)
   is
   begin
      if g_test_runs_rec.error_message is not null
      then
         g_test_runs_rec.error_message := substr(in_err_msg || CHR(10)||
                                                 g_test_runs_rec.error_message
                                                ,1,4000);
      else
         g_test_runs_rec.error_message := in_err_msg;
      end if;
   end concat_err_message;
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
   g_test_runs_rec               := l_test_runs_rec_NULL;
   g_test_runs_rec.id            := wt_test_runs_seq.nextval;
   g_test_runs_rec.start_dtm     := systimestamp;
   --g_test_runs_rec.runner_owner  := USER;
   --g_test_runs_rec.runner_owner  := sys_context('userenv', 'current_schema');
   select username into g_test_runs_rec.runner_owner from user_users;
   g_test_runs_rec.runner_name   := in_package_name;
   g_test_runs_rec.is_last_run   := IS_LAST_RUN_FLAG;
   g_test_runs_rec.error_message := '';
   check_runner;
   -- Initialize
   delete_runs(in_runner_owner => g_test_runs_rec.runner_owner
              ,in_runner_name  => g_test_runs_rec.runner_name);
   COMMIT;   -- Start a new Transaction
   wt_hook.before_run_init;
   wt_assert.reset_globals;
   wt_test_run_stat.initialize;
   wt_result.initialize(g_test_runs_rec.id);
   wt_profiler.initialize(in_test_run_id      => g_test_runs_rec.id,
                          in_runner_owner     => g_test_runs_rec.runner_owner,
                          in_runner_name      => g_test_runs_rec.runner_name,
                          out_dbout_owner     => g_test_runs_rec.dbout_owner,
                          out_dbout_name      => g_test_runs_rec.dbout_name,
                          out_dbout_type      => g_test_runs_rec.dbout_type,
                          out_trigger_offset  => g_test_runs_rec.trigger_offset,
                          out_profiler_runid  => g_test_runs_rec.profiler_runid,
                          out_error_message   => l_error_stack);
   concat_err_message(l_error_stack);
   wt_hook.after_run_init
   -- Call the Test Runner
   begin
      execute immediate 'BEGIN ' || in_package_name || '.' ||
                      C_RUNNER_ENTRY_POINT || '; END;';
   exception
      when OTHERS
      then
         l_error_stack := dbms_utility.format_error_stack     ||
                          dbms_utility.format_error_backtrace ;
         concat_err_message(l_error_stack);
   end;

   -- Finalize
   insert_test_run;
   wt_hook.before_run_final;
   wt_profiler.finalize;
   wt_result.finalize;
   wt_test_run_stat.finalize;
   wt_hook.after_run_final;
   commit;  -- Required if called as Remote Procedure Call (RPC)

exception
   when OTHERS
   then
      l_error_stack := dbms_utility.format_error_stack     ||
                       dbms_utility.format_error_backtrace ;
      concat_err_message(l_error_stack);
      begin
         -- This is the only exception we can catch
         --   with a full call stack
         insert_test_run;
      exception
         when OTHERS
         then
            l_error_stack := dbms_utility.format_error_stack     ||
                             dbms_utility.format_error_backtrace ;
            concat_err_message(l_error_stack);
            raise_application_error(-20000, substr(g_test_runs_rec.error_message
                                                  ,1,2000         ));
      end;
      commit;  -- Required if called as Remote Procedure Call (RPC)

end test_run;

--==============================================================--
-- No Unit Test for TEST_RUN.
--   Too complicated because testing occurs while the TEST_RUN
--   procedure is executing.  This also prevents 100% profiling.
--==============================================================--


------------------------------------------------------------
procedure test_all
is
   TYPE runners_nt_type is table of varchar2(128);
   l_runners_nt      runners_nt_type;
begin
   wt_hook.before_test_all;
   select object_name
     bulk collect into l_runners_nt
    from  user_procedures  t1
    where procedure_name = C_RUNNER_ENTRY_POINT
     and  object_type    = 'PACKAGE'
    group by object_name
    order by object_name;
   for i in 1 .. l_runners_nt.COUNT
   loop
      test_run(l_runners_nt(i));
   end loop;
   wt_hook.after_test_all;
end test_all;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_test_all
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'TEST_ALL Happy Path';
      test_all_aa.DELETE;
      wtplsql_skip_test := TRUE;
      -- TEST_ALL will populate the test_all_aa array
      wtplsql.test_all;
      wtplsql_skip_test := FALSE;
      -- This package should be in the test_all_aa array
      --------------------------------------  WTPLSQL Testing --
      wt_assert.this (
         msg_in        => 'test_all_aa.EXISTS(''WTPLSQL'')',
         check_this_in => test_all_aa.EXISTS('WTPLSQL'));
   end t_test_all;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_runs
      (in_test_run_id  in number)
is
   r_owner   varchar2(200);
   r_name    varchar2(200);
begin
   wt_hook.before_delete_runs;
   wt_test_run_stat.delete_records(in_test_run_id);
   wt_profiler.delete_records(in_test_run_id);
   wt_result.delete_records(in_test_run_id);
   begin
      --
      select runner_owner, runner_name
        into r_owner,      r_name
       from  wt_test_runs
       where id = in_test_run_id;
      --
      delete from wt_test_runs
       where id = in_test_run_id;
      --
      set_last_run(in_runner_owner  => r_owner
                  ,in_runner_name   => r_name
                  ,in_last_run_flag => IS_LAST_RUN_FLAG);
      --
   exception when NO_DATA_FOUND
   then
      null;  -- Ignore Error
   end;
   wt_hook.after_delete_runs;
end delete_runs;

procedure delete_runs
      (in_runner_owner  in varchar2
      ,in_runner_name   in varchar2)
is
   num_recs    number;
begin
   num_recs := 1;
   for buf2 in (select id from wt_test_runs
                 where runner_owner = in_runner_owner
                  and  runner_name  = in_runner_name
                 order by start_dtm desc, id desc)
   loop
      -- Keep the last 20 rest runs for this USER
      if num_recs > g_keep_num_recs
      then
       -- Autonomous Transaction COMMIT
       delete_runs(buf2.id);
      end if;
      num_recs := num_recs + 1;
   end loop;
end delete_runs;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_run_id
   is
      l_num_recs   number;
      l_err_stack  varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
      --  DELETE_RECORDS has already run when we arrive here.
      -- Cleanup from previous test
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Happy Path 1';
      select count(*)
       into  l_num_recs
       from  wt_test_runs
       where runner_owner = g_test_runs_rec.runner_owner
        and  runner_name  = g_test_runs_rec.runner_name;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in        => 'Number of Records Before Insert',
         check_this_in => l_num_recs);
      wt_assert.this (
         msg_in        => 'Number of Records Before Insert <= ' || g_keep_num_recs,
         check_this_in => l_num_recs <= g_keep_num_recs);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_test_runs values g_test_runs_rec;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Insert',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 1);
      delete_runs(g_test_runs_rec.id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Happy Path 2';
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || g_test_runs_rec.runner_owner ||
                           ''' and runner_name = ''' || g_test_runs_rec.runner_name ||
                           '''',
         against_value_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      for i in 1 .. g_keep_num_recs
      loop
         insert into wt_test_runs
               (id, start_dtm, runner_owner, runner_name)
            values
               (0-i, sysdate-7000-i, g_test_runs_rec.runner_owner, g_test_runs_rec.runner_name);
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check Added ' || g_keep_num_recs || ' records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || g_test_runs_rec.runner_owner ||
                           ''' and runner_name = ''' || g_test_runs_rec.runner_name ||
                           '''',
         against_value_in => l_num_recs + g_keep_num_recs);
      delete_runs(g_test_runs_rec.runner_owner, g_test_runs_rec.runner_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check number of records reduced',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || g_test_runs_rec.runner_owner ||
                           ''' and runner_name = ''' || g_test_runs_rec.runner_name ||
                           '''',
         against_value_in => g_keep_num_recs);
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm original number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || g_test_runs_rec.runner_owner ||
                           ''' and runner_name = ''' || g_test_runs_rec.runner_name ||
                           '''',
         against_value_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Sad Path 1';
      begin
         delete_runs(-9995);  -- Should run without error
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'Delete Runs(-9995)',
         check_this_in   => l_err_stack);
   end t_delete_run_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_test_runs_rec_and_table
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'TEST_RUNS_REC_AND_TABLE Happy Path';
      -- This Test Case runs in the EXECUTE IMMEDAITE in the TEST_RUN
      --   procedure in this package.
      wt_assert.isnotnull
               (msg_in        => 'g_test_runs_rec.id'
               ,check_this_in => g_test_runs_rec.id);
      wt_assert.isnotnull
               (msg_in        => 'g_test_runs_rec.start_dtm'
               ,check_this_in => g_test_runs_rec.start_dtm);
      --------------------------------------  WTPLSQL Testing --
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
      --------------------------------------  WTPLSQL Testing --
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
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
               (msg_in             => 'TEST_RUNS Record for this TEST_RUN'
               ,check_query_in     => 'select count(*) from WT_TEST_RUNS' ||
                                      ' where id = ''' || g_test_runs_rec.id || ''''
               ,against_value_in   => 0);
   end t_test_runs_rec_and_table;
   ----------------------------------------
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_show_version;
      t_check_runner;
      t_insert_test_run;
      t_test_all;
      t_delete_run_id;
      t_test_runs_rec_and_table;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wtplsql;
