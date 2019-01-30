create or replace package body wt_test_run
as

   g_test_runs_rec  wt_test_runs%ROWTYPE;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   C_OWNER    CONSTANT varchar2(50) := 'WT_TEST_RUNNER_OWNER_FOR_TESTING_1234ABCD';
   C_NAME     CONSTANT varchar2(50) := 'WT_TEST_RUNNER_NAME_FOR_TESTING_1234ABCD';
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- Use the CLEAR_LAST_RUN procedure to clear the LAST_RUN_FLAG
--   flag before running this procedure.
procedure clear_last_run
      (in_test_runner_id   in number)
as
begin
   update wt_test_runs
     set  is_last_run = NULL
    where test_runner_id = in_test_runner_id
     and  is_last_run  = C_LAST_RUN_FLAG;
end clear_last_run;


------------------------------------------------------------
procedure insert_test_run
is
begin
   if g_test_runs_rec.id is null
   then
      return;
   end if;
   clear_last_run
      (in_test_runner_id  => g_test_runs_rec.test_runner_id);
   g_test_runs_rec.is_last_run := C_LAST_RUN_FLAG;
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
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec := g_test_runs_rec;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      delete from wt_test_runs
       where id = l_test_runs_rec.id;
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
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
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => 0);
   end t_insert_test_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_runs
   (in_test_runner_id  in number)
is
begin
   for buff in (select rownum, id from wt_test_runs
                 where test_runner_id = in_test_runner_id
                 order by start_dtm, id)
   loop
      -- Keep the last test runs for this Test Runner
      if buff.rownum > g_keep_num_recs
      then
         -- Autonomous Transaction COMMIT
         wt_profile.delete_run_id(buff.id);
         wt_result.delete_run_id(buff.id);
         delete_run_id(buff.id);
      end if;
   end loop;
exception when others then
   core_data.run_error('Test Runner ID: ' || in_test_runner_id || CHR(10) ||
	                    dbms_utility.format_error_stack ||
                       dbms_utility.format_error_backtrace);
end delete_runs;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_runs
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
       where test_runner_id = g_test_runs_rec.test_runner_id;
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
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => 1);
      delete_runs(g_test_runs_rec.test_runner_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Happy Path 2';
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      for i in 1 .. g_keep_num_recs
      loop
         insert into wt_test_runs
               (id, start_dtm, test_runner_id)
            values
               (0-i, sysdate-7000-i, g_test_runs_rec.test_runner_id);
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check Added ' || g_keep_num_recs || ' records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => l_num_recs + g_keep_num_recs);
      delete_runs(g_test_runs_rec.test_runner_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check number of records reduced',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => g_keep_num_recs);
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm original number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
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
   end t_delete_runs;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure initialize
is
   l_test_runs_recNULL  wt_test_runs%ROWTYPE;
begin
   g_test_runs_rec := l_test_runs_recNULL;
   wt_result.initialize;
   wt_profile.initialize;  -- Clear, Check, and Set Profiler Runid
end initialize;


------------------------------------------------------------
procedure finalize
is 
begin
   --
   g_test_runs_rec.id                := wt_test_runs_seq.nextval;
   g_test_runs_rec.test_runner_id    := wt_test_runner.dim_id
                                           (core_data.g_run_rec.test_runner_owner
                                           ,core_data.g_run_rec.test_runner_name);
   g_test_runs_rec.start_dtm         := core_data.g_run_rec.start_dtm;
   g_test_runs_rec.end_dtm           := core_data.g_run_rec.end_dtm;
   g_test_runs_rec.runner_sec        := core_data.g_run_rec.runner_sec;
   g_test_runs_rec.error_message     := core_data.g_run_rec.error_message;
   g_test_runs_rec.tc_cnt            := core_data.g_run_rec.tc_cnt;
   g_test_runs_rec.tc_fail           := core_data.g_run_rec.tc_fail;
   if g_test_runs_rec.tc_cnt != 0
   then
      g_test_runs_rec.tc_yield_pct := (g_test_runs_rec.tc_cnt - g_test_runs_rec.tc_fail) /
                                       g_test_runs_rec.tc_cnt;
   end if;
   g_test_runs_rec.asrt_fst_dtm      := core_data.g_run_rec.asrt_fst_dtm;
   g_test_runs_rec.asrt_lst_dtm      := core_data.g_run_rec.asrt_lst_dtm;
   g_test_runs_rec.asrt_cnt          := core_data.g_run_rec.asrt_cnt;
   g_test_runs_rec.asrt_fail         := core_data.g_run_rec.asrt_fail;
   g_test_runs_rec.asrt_min_msec     := core_data.g_run_rec.asrt_min_msec;
   g_test_runs_rec.asrt_max_msec     := core_data.g_run_rec.asrt_max_msec;
   g_test_runs_rec.asrt_tot_msec     := core_data.g_run_rec.asrt_tot_msec;
   g_test_runs_rec.asrt_sos_msec     := core_data.g_run_rec.asrt_sos_msec;
   g_test_runs_rec.dbout_id          := wt_dbout.dim_id
                                           (core_data.g_run_rec.dbout_owner
                                           ,core_data.g_run_rec.dbout_name
                                           ,core_data.g_run_rec.dbout_type);
   if g_test_runs_rec.asrt_cnt != 0
   then
      g_test_runs_rec.asrt_yield_pct := (g_test_runs_rec.asrt_cnt - g_test_runs_rec.asrt_fail) /
                                                      g_test_runs_rec.asrt_cnt;
      g_test_runs_rec.asrt_avg_msec  := g_test_runs_rec.asrt_tot_msec /
                                            g_test_runs_rec.asrt_cnt;
      g_test_runs_rec.asrt_std_msec  := sqrt( ( power(g_test_runs_rec.asrt_tot_msec,2) -
                                                      g_test_runs_rec.asrt_sos_msec      ) /
                                             g_test_runs_rec.asrt_cnt                        );
   end if;
   insert_test_run;
   --
   wt_result.finalize(g_test_runs_rec.id);
   wt_profile.finalize(g_test_runs_rec.id);
   --
   commit;
end finalize;


------------------------------------------------------------
function get_last_run_flag
      return varchar2
is
begin
   return C_LAST_RUN_FLAG;
end get_last_run_flag;


------------------------------------------------------------
-- Use the SET_LAST_RUN procedure to set the LAST_RUN flag
--   after running this procedure.
procedure set_last_run
      (in_test_runner_id   in number)
as
   num_rows  number;
begin
   if in_test_runner_id is null
   then
      return;
   end if;
   select count(is_last_run)
    into  num_rows
    from  wt_test_runs
    where test_runner_id = in_test_runner_id
     and  is_last_run  = C_LAST_RUN_FLAG;
   if num_rows > 0
   then
      -- Abort if a LAST_RUN_FLAG is already set
      return;
   end if;
   --update the latest as the LAST_RUN
   update wt_test_runs
     set  is_last_run = C_LAST_RUN_FLAG
    where test_runner_id = in_test_runner_id
     and  start_dtm = (
          select max(tr.start_dtm)
           from  wt_test_runs  tr
           where tr.test_runner_id = in_test_runner_id);
end set_last_run;

------------------------------------------------------------
procedure delete_run_id
      (in_test_run_id  in number)
is
   l_test_runner_id  number;
begin
   begin
      select test_runner_id
       into  l_test_runner_id
       from  wt_test_runs
       where id = in_test_run_id;
   exception when NO_DATA_FOUND then
      l_test_runner_id := NULL;
   end;
   delete from wt_test_runs
    where id = in_test_run_id;
   set_last_run(l_test_runner_id);
exception when NO_DATA_FOUND then
   null;  -- Ignore Error
end delete_run_id;

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
       where id = g_test_runs_rec.id;
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
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      for i in 1 .. g_keep_num_recs
      loop
         insert into wt_test_runs
               (id, start_dtm)
            values
               (0-i, sysdate-7000-i);
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check Added ' || g_keep_num_recs || ' records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || g_test_runs_rec.test_runner_id,
         against_value_in => l_num_recs + g_keep_num_recs);
      delete_runs(g_test_runs_rec.test_runner_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check number of records reduced',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
         against_value_in => g_keep_num_recs);
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Confirm original number of records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || g_test_runs_rec.id,
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
               ,check_this_in =>  g_test_runs_rec.id);
      wt_assert.isnotnull
               (msg_in        => 'g_test_runs_rec.start_dtm'
               ,check_this_in =>  g_test_runs_rec.start_dtm);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
               (msg_in        => 'g_test_runs_rec.test_runner_id'
               ,check_this_in =>  g_test_runs_rec.test_runner_id);
      wt_assert.eq
               (msg_in          => 'g_test_runs_rec.test_runner_id'
               ,check_this_in   =>  g_test_runs_rec.test_runner_id
               ,against_this_in => 'WTPLSQL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
               (msg_in        => 'g_test_runs_rec.dbout_id'
               ,check_this_in =>  g_test_runs_rec.dbout_id);
      wt_assert.isnull
               (msg_in        => 'g_test_runs_rec.end_dtm'
               ,check_this_in => g_test_runs_rec.end_dtm);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
               (msg_in        => 'g_test_runs_rec.error_message'
               ,check_this_in => g_test_runs_rec.error_message);
      wt_assert.eqqueryvalue
               (msg_in             => 'TEST_RUNS Record for this TEST_RUN'
               ,check_query_in     => 'select count(*) from WT_TEST_RUNS' ||
                                      ' where id = ''' || g_test_runs_rec.id || ''''
               ,against_value_in   => 0);
   end t_test_runs_rec_and_table;

$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wtplsql.g_DBOUT := 'WT_TEST_RUN:PACKAGE BODY';
      t_clear_last_run;
      t_insert_test_run;
      t_delete_runs;
      t_initialize;
      t_finalize;
      t_set_last_run;
      t_delete_run_id;
      t_test_runs_rec_and_table;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_run;
