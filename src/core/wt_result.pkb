create or replace package body wt_result
as

   TYPE results_nt_type is table of wt_results%ROWTYPE;
   g_results_nt      results_nt_type := results_nt_type(null);
   g_results_rec     wt_results%ROWTYPE;


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure initialize
      (in_test_run_id   in wt_test_runs.id%TYPE)
is
   l_results_recNULL  wt_results%ROWTYPE;
begin
   if in_test_run_id is NULL
   then
      raise_application_error(-20009, '"in_test_run_id" cannot be NULL');
   end if;
   g_results_rec := l_results_recNULL;
   g_results_rec.test_run_id  := in_test_run_id;
   g_results_rec.result_seq   := 0;
   g_results_rec.executed_dtm := systimestamp;
   g_results_nt := results_nt_type(null);
end initialize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_initialize
   is
      l_results_recNULL  wt_results%ROWTYPE;
      l_results_recSAVE  wt_results%ROWTYPE;
      l_results_recTEST  wt_results%ROWTYPE;
      l_results_ntSAVE   results_nt_type;
      l_results_ntTEST   results_nt_type;
   begin
      wt_assert.g_testcase := 'Initialize';
      l_results_ntSAVE  := g_results_nt;
      l_results_recSAVE := g_results_rec;
      g_results_rec     := l_results_recNULL;
      initialize(-99);
      l_results_recTEST := g_results_rec;
      g_results_rec     := l_results_recSAVE;
      l_results_ntTEST  := g_results_nt;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'Initialize g_results_rec.test_run_id',
         check_this_in   => l_results_recTEST.test_run_id,
         against_this_in => -99);
      wt_assert.eq (
         msg_in          => 'Initialize g_results_rec.result_seq',
         check_this_in   => l_results_recTEST.result_seq,
         against_this_in => 0);
      wt_assert.isnotnull (
         msg_in          => 'Initialize g_results_rec.executed_dtm',
         check_this_in   => l_results_recTEST.executed_dtm);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.elapsed_msecs',
         check_this_in   => l_results_recTEST.elapsed_msecs);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.assertion',
         check_this_in   => l_results_recTEST.assertion);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.status',
         check_this_in   => l_results_recTEST.status);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.details',
         check_this_in   => l_results_recTEST.details);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.testcase',
         check_this_in   => l_results_recTEST.testcase);
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_rec.message',
         check_this_in   => l_results_recTEST.message);
      wt_assert.eq (
         msg_in          => 'Initialize g_results_nt.COUNT',
         check_this_in   => l_results_ntTEST.COUNT,
         against_this_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'Initialize g_results_nt(1).test_run_id',
         check_this_in   => l_results_ntTEST(1).test_run_id);
      wt_assert.raises (
         msg_in         => 'Intialize Raises ORA-20009',
         check_call_in  => 'wt_result.initialize(NULL)',
         against_exc_in => 'ORA-20009: "in_test_run_id" cannot be NULL');
   end tc_initialize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- Because this procedure is called to cleanup after errors,
--  it must be able to run multiple times without causing damage.
procedure finalize
is
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
   if g_results_rec.test_run_id IS NULL
   then
      return;
   end if;
   -- There is always an extra NULL element in the g_results_nt array.
   forall i in 1 .. g_results_nt.COUNT - 1
      insert into wt_results values g_results_nt(i);
   g_results_nt := results_nt_type(null);
   g_results_rec.test_run_id := NULL;
   COMMIT;
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_finalize
   is
      l_test_runs_rec      wt_test_runs%ROWTYPE;
      l_results_recNULL    wt_results%ROWTYPE;
      l_results_recSAVE    wt_results%ROWTYPE;
      l_results_recTEST    wt_results%ROWTYPE;
      l_results_ntSAVE     results_nt_type;
      l_results_ntTEST     results_nt_type;
      l_num_recs           number;
   begin
      wt_assert.g_testcase := 'Finalize';
      l_results_ntSAVE  := g_results_nt;
      l_results_recSAVE := g_results_rec;
      g_results_rec     := l_results_recNULL;
      initialize(-99);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec.id           := -99;
      l_test_runs_rec.start_dtm    := sysdate;
      l_test_runs_rec.runner_name  := 'Finalize Test';
      l_test_runs_rec.runner_owner := 'BOGUS';
      insert into wt_test_runs values l_test_runs_rec;
      commit;
      --------------------------------------  WTPLSQL Testing --
      g_results_rec.test_run_id   := -99;
      g_results_rec.result_seq    := 1;
      g_results_rec.executed_dtm  := sysdate;
      g_results_rec.elapsed_msecs := 99;
      g_results_rec.assertion     := 'FINALTEST';
      g_results_rec.status        := wt_assert.C_PASS;
      g_results_rec.details       := 'This is a WT_RESULT.FINALIZE Test';
      g_results_nt(g_results_nt.COUNT) := g_results_rec;
      g_results_nt.extend;
      finalize;
      l_results_ntTEST  := g_results_nt;
      l_results_recTEST := g_results_rec;
      select count(*)
       into  l_num_recs
       from  wt_results
       where test_run_id = -99;
      --------------------------------------  WTPLSQL Testing --
      delete from wt_results where test_run_id = -99;
      delete from wt_test_runs where id = -99;
      commit;
      g_results_rec := l_results_recSAVE;
      g_results_nt  := l_results_ntSAVE;
      wt_assert.isnull (
         msg_in        => 'Finalize g_results_rec.test_run_id',
         check_this_in => l_results_recTEST.test_run_id);
      wt_assert.eq (
         msg_in          => 'Finalize g_results_nt.COUNT',
         check_this_in   => l_results_ntTEST.COUNT,
         against_this_in => 1);
      wt_assert.eq (
         msg_in          => 'Finalize Record Count Test',
         check_this_in   => l_num_recs,
         against_this_in => 1);
   end tc_finalize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure save
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE)
is
   l_current_tstamp  timestamp;
begin
   if g_results_rec.test_run_id IS NULL
   then
      wt_text_report.ad_hoc_result
         (in_assertion
         ,in_status
         ,in_details
         ,in_testcase
         ,in_message);
      return;
   end if;
   -- Set the time and elapsed
   l_current_tstamp := systimestamp;
   g_results_rec.elapsed_msecs := extract(day from (
                                  l_current_tstamp - g_results_rec.executed_dtm
                                  ) * 86400 * 1000);
   g_results_rec.executed_dtm  := l_current_tstamp;
   -- Set the IN variables
   g_results_rec.assertion     := in_assertion;
   g_results_rec.status        := in_status;
   g_results_rec.details       := substr(in_details,1,4000);
   g_results_rec.testcase      := substr(in_testcase,1,30);
   g_results_rec.message       := substr(in_message,1,50);
   -- Increment, Extend, and Load
   g_results_rec.result_seq    := g_results_rec.result_seq + 1;
   g_results_nt(g_results_nt.COUNT) := g_results_rec;
   g_results_nt.extend;
end save;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_save_testing
   is
      l_results_recNULL  wt_results%ROWTYPE;
      l_results_recSAVE  wt_results%ROWTYPE;
      l_results_recTEST  wt_results%ROWTYPE;
      l_results_ntSAVE   results_nt_type;
      l_results_ntTEST   results_nt_type;
   begin
      wt_assert.g_testcase := 'Save Testing';
   end tc_save_testing;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_records
      (in_test_run_id  in number)
is
begin
   delete from wt_results
    where test_run_id = in_test_run_id;
end delete_records;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_delete_records
   is
      l_test_runs_rec  wt_test_runs%ROWTYPE;
      l_results_rec    wt_results%ROWTYPE;
      l_num_recs       number;
   begin
      wt_assert.g_testcase := 'Delete Records';
      select count(*) into l_num_recs
       from  wt_results
       where test_run_id = -99;
      wt_assert.isnotnull (
         msg_in        => 'Delete Records Count Test 1',
         check_this_in => l_num_recs);
      --------------------------------------  WTPLSQL Testing --
      l_test_runs_rec.id           := -99;
      l_test_runs_rec.start_dtm    := sysdate;
      l_test_runs_rec.runner_name  := 'Delete Records Test';
      l_test_runs_rec.runner_owner := 'BOGUS';
      insert into wt_test_runs values l_test_runs_rec;
      l_results_rec.test_run_id   := -99;
      l_results_rec.result_seq    := 1;
      l_results_rec.executed_dtm  := sysdate;
      l_results_rec.elapsed_msecs := 99;
      l_results_rec.assertion     := 'DELRECTEST';
      l_results_rec.status        := wt_assert.C_PASS;
      l_results_rec.details       := 'This is a WT_RESULT.DELETE_RECORDS Test';
      insert into wt_results values l_results_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue (
         msg_in            => 'Delete Records Count Test 2',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs + 1);
      delete_records(-99);
      wt_assert.eqqueryvalue (
         msg_in            => 'Delete Records Count Test 3',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs);
      rollback;
      wt_assert.eqqueryvalue (
         msg_in            => 'Delete Records Count Test 4',
         check_query_in    => 'select count(*) from wt_results' ||
                              ' where test_run_id = -99',
         against_value_in  => l_num_recs);
   end tc_delete_records;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      tc_initialize;
      tc_finalize;
      tc_save_testing;
      tc_delete_records;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_result;
