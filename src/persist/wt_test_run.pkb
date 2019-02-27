create or replace package body wt_test_run
as

   g_test_runs_rec  wt_test_runs%ROWTYPE;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   C_OWNER    CONSTANT varchar2(50) := 'WT_TEST_RUNNER_OWNER_FOR_TESTING_1234ABCD';
   C_NAME     CONSTANT varchar2(50) := 'WT_TEST_RUNNER_NAME_FOR_TESTING_1234ABCD';
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_insert_test_runs
         (in_test_run_id  in NUMBER
         ,in_runner_name  in varchar2)
   is
      l_sql_txt    varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'insert into wt_test_runs' ||
                   ' (id, start_dtm, test_runner_id)' ||
                   ' values (' || in_test_run_id || ', sysdate, ' ||
                                  wt_test_runner.dim_id(C_OWNER
                                                       ,C_NAME) || ')';
      wt_assert.raises (
         msg_in         => 'Insert wt_test_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs (' || in_test_run_id || ') Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 1);
      commit;
   end tl_insert_test_runs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_delete_test_runs
         (in_test_run_id  in NUMBER)
   is
      l_sql_txt  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from wt_test_runs where id = ' || in_test_run_id;
      wt_assert.raises (
         msg_in         => 'Delete wt_test_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in         => 'wt_test_runs rows deleted',
         check_this_in  => SQL%ROWCOUNT);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs (' || in_test_run_id || ') Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 0);
      commit;
   end tl_delete_test_runs;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure set_g_test_runs_rec
is
   g_test_runs_recNULL  wt_test_runs%ROWTYPE;
begin
   g_test_runs_rec  := g_test_runs_recNULL;
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
      g_test_runs_rec.tc_yield_pct := round( 100 *
                                             ( g_test_runs_rec.tc_cnt -
                                               g_test_runs_rec.tc_fail  ) /
                                             g_test_runs_rec.tc_cnt        , 2);
   end if;
   g_test_runs_rec.asrt_fst_dtm      := core_data.g_run_rec.asrt_fst_dtm;
   g_test_runs_rec.asrt_lst_dtm      := core_data.g_run_rec.asrt_lst_dtm;
   g_test_runs_rec.asrt_cnt          := core_data.g_run_rec.asrt_cnt;
   g_test_runs_rec.asrt_fail         := core_data.g_run_rec.asrt_fail;
   g_test_runs_rec.asrt_min_msec     := core_data.g_run_rec.asrt_min_msec;
   g_test_runs_rec.asrt_max_msec     := core_data.g_run_rec.asrt_max_msec;
   g_test_runs_rec.asrt_tot_msec     := core_data.g_run_rec.asrt_tot_msec;
   g_test_runs_rec.dbout_id          := wt_dbout.dim_id
                                           (core_data.g_run_rec.dbout_owner
                                           ,core_data.g_run_rec.dbout_name
                                           ,core_data.g_run_rec.dbout_type);
   if nvl(g_test_runs_rec.asrt_cnt,0) != 0
   then
      g_test_runs_rec.asrt_yield_pct := round(100 * ( g_test_runs_rec.asrt_cnt -
                                                      g_test_runs_rec.asrt_fail ) /
                                                    g_test_runs_rec.asrt_cnt       , 2);
      g_test_runs_rec.asrt_avg_msec  := round(g_test_runs_rec.asrt_tot_msec /
                                              g_test_runs_rec.asrt_cnt       , 2);
   end if;
end set_g_test_runs_rec;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_set_g_test_runs_rec
   is
      l_cdr_recSAVE  core_data.run_rec_type;
      l_cdr_recTEST  core_data.run_rec_type;
      l_tr_recSAVE   wt_test_runs%ROWTYPE;
      l_tr_recTEST   wt_test_runs%ROWTYPE;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Set g_test_run_rec Happy Path 1';
      l_cdr_recSAVE := core_data.g_run_rec;
      l_tr_recSAVE  := g_test_runs_rec;
      --------------------------------------  WTPLSQL Testing --
      core_data.g_run_rec.test_runner_owner := C_OWNER;
      core_data.g_run_rec.test_runner_name  := C_NAME;
      core_data.g_run_rec.tc_cnt            := 2;
      core_data.g_run_rec.tc_fail           := 1;
      core_data.g_run_rec.dbout_owner       := C_OWNER;
      core_data.g_run_rec.dbout_name        := C_NAME;
      core_data.g_run_rec.dbout_type        := 'TYPE';
      core_data.g_run_rec.asrt_cnt          := 10;
      core_data.g_run_rec.asrt_fail         := 5;
      core_data.g_run_rec.asrt_tot_msec     := 100;
      --------------------------------------  WTPLSQL Testing --
      set_g_test_runs_rec;
      l_cdr_recTEST       := core_data.g_run_rec;
      core_data.g_run_rec := l_cdr_recSAVE;
      l_tr_recTEST    := g_test_runs_rec;
      g_test_runs_rec := l_tr_recSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'l_tr_recTEST.id',
         check_this_in   =>  l_tr_recTEST.id);
      wt_assert.isnotnull (
         msg_in          => 'l_tr_recTEST.test_runner_id',
         check_this_in   =>  l_tr_recTEST.test_runner_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'l_tr_recTEST.dbout_id',
         check_this_in   =>  l_tr_recTEST.dbout_id);
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.tc_cnt',
         check_this_in   =>  l_tr_recTEST.tc_cnt,
         against_this_in => 2);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.tc_fail',
         check_this_in   =>  l_tr_recTEST.tc_fail,
         against_this_in => 1);
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.asrt_cnt',
         check_this_in   =>  l_tr_recTEST.asrt_cnt,
         against_this_in => 10);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.asrt_fail',
         check_this_in   =>  l_tr_recTEST.asrt_fail,
         against_this_in => 5);
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.asrt_tot_msec',
         check_this_in   =>  l_tr_recTEST.asrt_tot_msec,
         against_this_in => 100);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.tc_yield_pct',
         check_this_in   =>  l_tr_recTEST.tc_yield_pct,
         against_this_in => 50);
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.tc_fail',
         check_this_in   =>  l_tr_recTEST.tc_fail,
         against_this_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.asrt_yield_pct',
         check_this_in   =>  l_tr_recTEST.asrt_yield_pct,
         against_this_in => 50);
      wt_assert.eq (
         msg_in          => 'l_tr_recTEST.asrt_avg_msec',
         check_this_in   =>  l_tr_recTEST.asrt_avg_msec,
         against_this_in => 10);
   end t_set_g_test_runs_rec;
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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_clear_last_run
   is
      l_sql_txt    varchar2(4000);
      l_sqlerrm    varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Clear Last Run Happy Path 1';
      tl_insert_test_runs(-1, 'Clear Last Run Testing');
      l_sql_txt := 'update wt_test_runs set is_last_run = ''Y'' where id = -1';
      wt_assert.raises (
         msg_in         => 'Update wt_test_runs (-1)',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs (-1) Count',
         check_query_in   => 'select count(*) from wt_test_runs where id = -1 and is_last_run = ''Y''',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      begin
         clear_last_run(wt_test_runner.get_id(C_OWNER,C_NAME));
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in        => 'clear_last_run(get_id(C_OWNER,C_NAME))',
         check_this_in => l_sqlerrm,
         against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.eqqueryvalue (
         msg_in           => 'clear_last_run(get_id(C_OWNER,C_NAME)) Count',
         check_query_in   => 'select count(*) from wt_test_runs where id = -1 and is_last_run = ''Y''',
         against_value_in => 0);
      tl_delete_test_runs(-1);
   end t_clear_last_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------

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
   commit;
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
                             ' where id = -2',
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec := g_test_runs_rec;
      g_test_runs_rec.id             := -2;
      g_test_runs_rec.test_runner_id := wt_test_runner.dim_id(C_OWNER, C_NAME);
      g_test_runs_rec.start_dtm      := systimestamp;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = -2',
         against_value_in => 1);
      tl_delete_test_runs(-2);
      --------------------------------------  WTPLSQL Testing --	
      wt_assert.g_testcase := 'INSERT_TEST_RUN Happy Path 2';
      select count(*) into l_num_recs from wt_test_runs;
      l_test_runs_rec := g_test_runs_rec;
      g_test_runs_rec.id := null;
      insert_test_run;
      g_test_runs_rec := l_test_runs_rec;
      wt_assert.eqqueryvalue (
         msg_in           => 'Before and After Record Count',
         check_query_in   => 'select count(*) from wt_test_runs',
         against_value_in => l_num_recs);
   end t_insert_test_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_runs
   (in_test_runner_id  in number)
is
begin
   for buff in (
      with q1 as (select start_dtm, id from wt_test_runs
                   where test_runner_id = in_test_runner_id
                   order by start_dtm desc, id desc)
          ,q2 as (select rownum rnum, start_dtm, id from q1)
      select start_dtm, id from q2
       where rnum > g_keep_num_recs)
   loop
      wt_profile.delete_run_id(buff.id);
      wt_result.delete_run_id(buff.id);
      delete_run_id(buff.id);
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
      l_err_stack  varchar2(32000);
      l_tr_id      number := wt_test_runner.dim_id(C_OWNER, C_NAME);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Setup';
      --  DELETE_RECORDS has already run when we arrive here.
      -- Cleanup from previous test
      delete from wt_test_runs where test_runner_id = l_tr_id;
      wt_assert.isnotnull (
          msg_in        => 'Clear any previous records (ROWCOUNT)',
          check_this_in => SQL%ROWCOUNT);
      COMMIT;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUNS Happy Path 1';
      for i in 1 .. g_keep_num_recs + 1
      loop
         insert into wt_test_runs
               (id, start_dtm, test_runner_id)
            values
               (0-i, sysdate-100-i, l_tr_id);
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check Added ' || g_keep_num_recs || ' records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => g_keep_num_recs + 1);
      delete_runs(l_tr_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Check number of records reduced',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => g_keep_num_recs);
      delete from wt_test_runs
        where id between 0-g_keep_num_recs and 0-1;
      commit;
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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_initialize
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Initialization Testing';
      wt_assert.isnotnull (
         msg_in        => 'Not Testing Initialization',
         check_this_in => 'Setting "g_test_runs_rec" to NULL is trivial. Other initializers already tested');
   end t_initialize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure finalize1
is 
begin
   set_g_test_runs_rec;
   delete_runs(g_test_runs_rec.test_runner_id);
   insert_test_run;                          -- With COMMIT
   wt_result.finalize(g_test_runs_rec.id);   -- With COMMIT
   wt_profile.finalize(g_test_runs_rec.id);  -- With COMMIT
end finalize1;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_finalize
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalization Testing';
      wt_assert.isnotnull (
         msg_in        => 'Not Testing Finalization',
         check_this_in => 'All components already tested');
   end t_finalize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure finalize2
is 
begin
   -- Update any additional errors
   --   This will cause a chained row in WT_TEST_RUNS
   update wt_test_runs
     set  error_message = g_test_runs_rec.error_message
    where id = g_test_runs_rec.id
     and  (   (    error_message is null
               and g_test_runs_rec.error_message is not null )
           or (error_message != g_test_runs_rec.error_message) );
   commit;
end finalize2;


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
   if num_rows = 1
   then
      -- Abort if a LAST_RUN_FLAG is already set
      return;
   end if;
   if num_rows > 1
   then
      -- Clear out previous Flags
      clear_last_run(in_test_runner_id);
   end if;
   --Update the latest as the LAST_RUN
   update wt_test_runs
     set  is_last_run = C_LAST_RUN_FLAG
    where test_runner_id = in_test_runner_id
     and  start_dtm = (
          select max(tr.start_dtm)
           from  wt_test_runs  tr
           where tr.test_runner_id = in_test_runner_id);
end set_last_run;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_set_last_run
   is
      l_tr_id      number := wt_test_runner.dim_id(C_OWNER, C_NAME);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'SET_LAST_RUN Setup';
      delete from wt_test_runs where test_runner_id = l_tr_id;
      wt_assert.isnotnull (
          msg_in        => 'Clear any previous records (ROWCOUNT)',
          check_this_in => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'SET_LAST_RUN Happy Path 1';
      insert into wt_test_runs (id, test_runner_id, is_last_run, start_dtm)
         values (-11, l_tr_id, '', sysdate);
      insert into wt_test_runs (id, test_runner_id, is_last_run, start_dtm)
         values (-12, l_tr_id, '', sysdate-1);
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Test Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 2);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      set_last_run(l_tr_id);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 1);
      wt_assert.eqqueryvalue (
         msg_in           => 'Test Run ID of Last Run',
         check_query_in   => 'select id from wt_test_runs' ||
                             ' where is_last_run = ''Y''',
         against_value_in => -11);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'SET_LAST_RUN Happy Path 2';
      delete from wt_test_runs where id = -11;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Test Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 1);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      set_last_run(l_tr_id);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 1);
      wt_assert.eqqueryvalue (
         msg_in           => 'Test Run ID of Last Run',
         check_query_in   => 'select id from wt_test_runs' ||
                             ' where is_last_run = ''Y''',
         against_value_in => -12);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'SET_LAST_RUN Happy Path 3';
      delete from wt_test_runs where id = -12;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Test Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 0);
      set_last_run(l_tr_id);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
   end t_set_last_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
      l_tr_id      number := wt_test_runner.dim_id(C_OWNER, C_NAME);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUN_ID Setup';
      delete from wt_test_runs where test_runner_id = l_tr_id;
      wt_assert.isnotnull (
          msg_in        => 'Clear any previous records (ROWCOUNT)',
          check_this_in => SQL%ROWCOUNT);
      COMMIT;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUN_ID Happy Path 1';
      insert into wt_test_runs (id, test_runner_id, is_last_run, start_dtm)
         values (-9, l_tr_id, '', sysdate-3);
      insert into wt_test_runs (id, test_runner_id, is_last_run, start_dtm)
         values (-10, l_tr_id, '', sysdate-2);
      insert into wt_test_runs (id, test_runner_id, is_last_run, start_dtm)
         values (-11, l_tr_id, 'Y', sysdate-1);
      COMMIT;
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Insert',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 3);
      delete_run_id(-11);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 2);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      delete_run_id(-10);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After 2nd Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 1);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Last Run Records, 2nd Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id ||
                             ' and is_last_run = ''Y''',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      delete_run_id(-9);
      wt_assert.eqqueryvalue (
         msg_in           => 'Number of Records After 3rd Delete',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where test_runner_id = ' || l_tr_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'DELETE_RUN_ID Sad Path 1';
      -- Should run without error
      wt_assert.raises(
         msg_in         => 'Delete Run ID(-9995)',
         check_call_in  => 'begin wt_test_run.delete_run_id(-9995); end;',
         against_exc_in => '');
   end t_delete_run_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure insert_hooks
is
begin
   delete_hooks;
   insert into hooks (hook_name, seq, run_string)
      values ('before_test_run', 30, 'begin wt_test_run.initialize; end;');
   insert into hooks (hook_name, seq, run_string)
      values ('after_test_run', 30, 'begin wt_test_run.finalize1; end;');
   insert into hooks (hook_name, seq, run_string)
      values ('after_test_run', 70, 'begin wt_test_run.finalize2; end;');
   commit;
   hook.init;
end insert_hooks;


------------------------------------------------------------
procedure delete_hooks
is
begin
   delete from hooks
    where hook_name  = 'before_test_run'
     and  run_string = 'begin wt_test_run.initialize; end;';
   delete from hooks
    where hook_name  = 'after_test_run'
     and  run_string = 'begin wt_test_run.finalize2; end;';
   delete from hooks
    where hook_name  = 'after_test_run'
     and  run_string = 'begin wt_test_run.finalize2; end;';
   commit;
   hook.init;
end delete_hooks;


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wtplsql.g_DBOUT := 'WT_TEST_RUN:PACKAGE BODY';
      t_set_g_test_runs_rec;
      t_clear_last_run;
      t_insert_test_run;
      t_delete_runs;
      t_initialize;
      t_finalize;
      t_set_last_run;
      t_delete_run_id;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_run;
