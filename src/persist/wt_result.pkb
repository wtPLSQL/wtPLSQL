create or replace package body wt_result
as

----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure initialize
is
begin
   return;
end initialize;

------------------------------------------------------------
-- Because this procedure is called to cleanup after errors,
--  it must be able to run multiple times without causing damage.
procedure finalize
      (in_test_run_id   in number)
is
   l_results_rec        wt_results%ROWTYPE;
   l_testcase_runs_rec  wt_testcase_runs%ROWTYPE;
   testcase             core_data.long_name;
begin
   if in_test_run_id IS NULL
   then
      return;
   end if;
   -- Test Results
   l_results_rec.TEST_RUN_ID := in_test_run_id;
   -- There is always an extra NULL element in the g_results_nt array.
   for i in 1 .. core_data.g_results_nt.COUNT - 1
   loop
      l_results_rec.RESULT_SEQ     := core_data.g_results_nt(i).RESULT_SEQ;
      l_results_rec.TESTCASE_ID    := wt_testcase.dim_id
                                         (core_data.g_results_nt(i).TESTCASE);
      l_results_rec.EXECUTED_DTM   := core_data.g_results_nt(i).EXECUTED_DTM;
      l_results_rec.INTERVAL_MSECS := core_data.g_results_nt(i).INTERVAL_MSECS;
      l_results_rec.ASSERTION      := core_data.g_results_nt(i).ASSERTION;
      if core_data.g_results_nt(i).PASS
      then
         l_results_rec.STATUS         := 'PASS';
      else
         l_results_rec.STATUS         := 'FAIL';
      end if;
      l_results_rec.MESSAGE        := core_data.g_results_nt(i).MESSAGE;
      l_results_rec.DETAILS        := core_data.g_results_nt(i).DETAILS;
      insert into wt_results values l_results_rec;
   end loop;
   -- Testcases
   if core_data.g_tcases_aa.COUNT > 0
   then
      l_testcase_runs_rec.test_run_id := in_test_run_id;
      testcase := core_data.g_tcases_aa.FIRST;
      loop
         l_results_rec.testcase_id          := wt_testcase.dim_id(testcase);
         l_testcase_runs_rec.asrt_cnt       := core_data.g_tcases_aa(testcase).asrt_cnt;
         l_testcase_runs_rec.asrt_fail      := core_data.g_tcases_aa(testcase).asrt_fail;
         l_testcase_runs_rec.asrt_min_msec  := core_data.g_tcases_aa(testcase).asrt_min_msec;
         l_testcase_runs_rec.asrt_max_msec  := core_data.g_tcases_aa(testcase).asrt_max_msec;
         l_testcase_runs_rec.asrt_tot_msec  := core_data.g_tcases_aa(testcase).asrt_tot_msec;
         --
         l_testcase_runs_rec.asrt_pass      := l_testcase_runs_rec.asrt_cnt -
                                               l_testcase_runs_rec.asrt_fail;
         if l_testcase_runs_rec.asrt_cnt > 0 then
            l_testcase_runs_rec.asrt_yield_pct := l_testcase_runs_rec.asrt_pass /
                                                  l_testcase_runs_rec.asrt_cnt;
            l_testcase_runs_rec.asrt_avg_msecs := l_testcase_runs_rec.asrt_tot_msec /
                                                  l_testcase_runs_rec.asrt_cnt;
         else
            l_testcase_runs_rec.asrt_yield_pct := NULL;
            l_testcase_runs_rec.asrt_avg_msecs := NULL;
         end if;
         --
         insert into wt_testcase_runs values l_testcase_runs_rec;
         exit when testcase = core_data.g_tcases_aa.LAST;
         testcase := core_data.g_tcases_aa.NEXT(testcase);
      end loop;
   end if;
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_finalize
   is
      --------------------------------------  WTPLSQL Testing --
      type num_recs_aa_type is table of number index by varchar2(50);
      num_recs_aa   num_recs_aa_type;
      l_results_ntSAVE     core_data.results_nt_type;
      l_results_ntTEST     core_data.results_nt_type;
      l_results_rec        core_data.results_rec_type;
      l_test_runs_rec      wt_test_runs%ROWTYPE;
      l_num_recs           number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Happy Path';
      l_results_rec.result_seq     := 1;
      l_results_rec.testcase       := 'TESTCASE TEST';
      l_results_rec.executed_dtm   := systimestamp;
      l_results_rec.interval_msecs := 99;
      l_results_rec.assertion      := 'FINALTEST';
      l_results_rec.pass           := TRUE;
      l_results_rec.details        := 'This is a WT_RESULT.FINALIZE Test';
      --------------------------------------  WTPLSQL Testing --
      -- Setup the FK Record
      l_test_runs_rec.id              := -99;
      l_test_runs_rec.start_dtm       := sysdate;
      l_test_runs_rec.test_runner_id  := wt_test_runner.dim_id('WT_RESULT_TEST','WT_RESULT_TEST');
      insert into wt_test_runs values l_test_runs_rec;
      --------------------------------------  WTPLSQL Testing --
      -- Capture Original Values
      l_results_ntSAVE := core_data.g_results_nt;
      select count(*)
       into  num_recs_aa('Initial Record Count')
       from  wt_results
       where test_run_id = -99;
      --------------------------------------  WTPLSQL Testing --
      core_data.g_results_nt := core_data.results_nt_type(l_results_rec, NULL);
      finalize(-99);
      select count(*)
       into  num_recs_aa('Record Count Test')
       from  wt_results
       where test_run_id = -99;
      rollback;    -- UNDO all database changes
      --------------------------------------  WTPLSQL Testing --
      core_data.g_results_nt := core_data.results_nt_type(NULL);
      finalize(-99);
      select count(*)
       into  num_recs_aa('NULL Record Count')
       from  wt_results
       where test_run_id = -99;
      rollback;    -- UNDO all database changes
      --------------------------------------  WTPLSQL Testing --
      -- Restore values so we can test
      core_data.g_results_nt := l_results_ntSAVE;
      wt_assert.eq (
         msg_in          => 'Initial Record Count',
         check_this_in   => num_recs_aa('Initial Record Count'),
         against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'Record Count Test',
         check_this_in   => num_recs_aa('Record Count Test'),
         against_this_in => 1);
      wt_assert.eq (
         msg_in          => 'NULL Record Count',
         check_this_in   => num_recs_aa('NULL Record Count'),
         against_this_in => 0);
   end t_finalize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_run_id
      (in_test_run_id  in number)
is
begin
   delete from wt_results
    where test_run_id = in_test_run_id;
end delete_run_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_run_id
   is
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec  wt_test_runs%ROWTYPE;
      l_results_rec    wt_results%ROWTYPE;
      l_num_recs       number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Happy Path';
      select count(*) into l_num_recs
       from  wt_results
       where test_run_id = -99;
      wt_assert.isnotnull (
         msg_in        => 'Before Insert Count',
         check_this_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec.id              := -99;
      l_test_runs_rec.start_dtm       := sysdate;
      l_test_runs_rec.test_runner_id  := wt_test_runner.dim_id('WT_RESULT_TEST','WT_RESULT_TEST');
      insert into wt_test_runs values l_test_runs_rec;
      l_results_rec.test_run_id       := -99;
      --------------------------------------  WTPLSQL Testing --
      l_results_rec.result_seq     := 1;
      l_results_rec.executed_dtm   := sysdate;
      l_results_rec.interval_msecs := 99;
      l_results_rec.assertion      := 'DELRECTEST';
      l_results_rec.status         := 'PASS';
      l_results_rec.details        := 'This is a WT_RESULT.DELETE_RECORDS Test';
      insert into wt_results values l_results_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in            => 'After Insert Count',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs + 1);
      delete_run_id(-99);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in            => 'After Test Count',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs);
      rollback;
      wt_assert.eqqueryvalue (
         msg_in            => 'After ROLLBACK Count',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs);
   end t_delete_run_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wtplsql.g_DBOUT := 'WT_RESULT:PACKAGE BODY';
      t_finalize;
      t_delete_run_id;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_result;
