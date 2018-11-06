create or replace package body wt_testcase
as

---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure insert_test_run
      (in_test_runs_rec  in wt_test_runs_vw%ROWTYPE)
is
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

end wt_testcase;
