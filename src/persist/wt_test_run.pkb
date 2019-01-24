create or replace package body wt_test_run
as


------------------------------------------------------------
-- Use the CLEAR_LAST_RUN procedure to clear the IS_LAST_RUN
--   flag before running this procedure.
procedure clear_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2)
as
begin
   update wt_test_runs
     set  is_last_run = NULL
    where runner_owner = in_runner_owner
     and  runner_name  = in_runner_name
     and  is_last_run  = in_last_run_flag;
end clear_last_run;


------------------------------------------------------------
-- Use the SET_LAST_RUN procedure to set the IS_LAST_RUN flag
--   after running this procedure.
procedure set_last_run
      (in_runner_owner   in varchar2
      ,in_runner_name    in varchar2
      ,in_last_run_flag  in varchar2)
as
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
procedure insert_test_run
      (in_test_runs_rec  in core_data.run_rec_type)
is
begin
   if core_data.g_run_rec.runner_name is null
   then
      return;
   end if;
   core_data.g_run_rec.id      := wt_test_runs_seq.nextval;
   clear_last_run
      (in_runner_owner  => g_test_runs_rec.runner_owner
      ,in_runner_name   => g_test_runs_rec.runner_name
      ,in_last_run_flag => IS_LAST_RUN_FLAG);
   insert into wt_test_runs values g_test_runs_rec;
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

------------------------------------------------------------
procedure delete_run
      (in_test_run_id  in number)
is
   r_owner   varchar2(200);
   r_name    varchar2(200);
begin
   hook.before_delete_runs;
   wt_test_run_stat.delete_records(in_test_run_id);
   wt_profiler.delete_records(in_test_run_id);
   wt_result.delete_records(in_test_run_id);
   wt_test_run.delete_records(in_test_run_id);
   hook.after_delete_runs;
end delete_run;

procedure delete_runner
      (in_test_runner_id  in number
      ,in_keep_records    in number  default null)
is
begin
   for buff in (select id from wt_test_runs
                 where test_runner_id = in_test_runner_id
                 order by start_dtm desc, id desc)
   loop
      -- Keep the last test runs for this Test Runner
      if num_recs > nvl(in_keep_records, g_keep_num_recs)
      then
       -- Autonomous Transaction COMMIT
       delete_runs(buff.id);
      end if;
   end loop;
   if in_keep_records = 0
   then
      surrogate_key.delete_records(in_test_runner_id);
   end if;
end delete_runner;

procedure delete_runner
      (in_runner_owner  in varchar2
      ,in_runner_name   in varchar2
      ,in_keep_records  in number  default null)
is
   l_id  number;
begin
   select id into l_id
    from  wt_test_runners
    where owner = in_runner_owner
     and  name  = in_runner_name;
   delete_runner(l_id, in_keep_records);
exception
   when no_data_found then
      null;   -- Nothing to delete. Return silently.
end delete_runner;

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
       where runner_owner = core_data.g_run_rec.runner_owner
        and  runner_name  = core_data.g_run_rec.runner_name;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in        => 'Number of Records Before Insert',
         check_this_in => l_num_recs);
      wt_assert.this (
         msg_in        => 'Number of Records Before Insert <= ' || g_keep_num_recs,
         check_this_in => l_num_recs <= g_keep_num_recs);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_test_runs values core_data.g_run_rec;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Insert',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || core_data.g_run_rec.id,
         against_value_in => 1);
      delete_runs(core_data.g_run_rec.id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || core_data.g_run_rec.id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Happy Path 2';
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || core_data.g_run_rec.runner_owner ||
                           ''' and runner_name = ''' || core_data.g_run_rec.runner_name ||
                           '''',
         against_value_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      for i in 1 .. g_keep_num_recs
      loop
         insert into wt_test_runs
               (id, start_dtm, runner_owner, runner_name)
            values
               (0-i, sysdate-7000-i, core_data.g_run_rec.runner_owner, core_data.g_run_rec.runner_name);
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check Added ' || g_keep_num_recs || ' records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || core_data.g_run_rec.runner_owner ||
                           ''' and runner_name = ''' || core_data.g_run_rec.runner_name ||
                           '''',
         against_value_in => l_num_recs + g_keep_num_recs);
      delete_runs(core_data.g_run_rec.runner_owner, core_data.g_run_rec.runner_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check number of records reduced',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || core_data.g_run_rec.runner_owner ||
                           ''' and runner_name = ''' || core_data.g_run_rec.runner_name ||
                           '''',
         against_value_in => g_keep_num_recs);
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm original number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where runner_owner = ''' || core_data.g_run_rec.runner_owner ||
                           ''' and runner_name = ''' || core_data.g_run_rec.runner_name ||
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

   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_insert_test_run;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_run;
