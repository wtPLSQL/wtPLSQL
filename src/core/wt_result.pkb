create or replace package body wt_result
as

   TYPE results_nt_type is table of wt_results%ROWTYPE;
   g_results_nt      results_nt_type;
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
   l_results_recNULL   wt_results%ROWTYPE;
begin
   if g_results_rec.test_run_id IS NULL
   then
      return;
   end if;
   -- There is always an extra NULL element in the g_results_nt array.
   forall i in 1 .. g_results_nt.COUNT - 1
      insert into wt_results values g_results_nt(i);
   COMMIT;
   g_results_nt := results_nt_type(null);
   g_results_rec := l_results_recNULL;
   g_results_nt := results_nt_type(null);
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_finalize
   is
      type num_recs_aa_type is table of number index by varchar2(50);
      num_recs_aa   num_recs_aa_type;
      l_test_runs_rec      wt_test_runs%ROWTYPE;
      l_results_recNULL    wt_results%ROWTYPE;
      l_results_recSAVE    wt_results%ROWTYPE;
      l_results_recTEST    wt_results%ROWTYPE;
      l_results_ntSAVE     results_nt_type;
      l_results_ntTEST     results_nt_type;
      l_num_recs           number;
   begin
      wt_assert.g_testcase := 'Finalize';
      l_results_ntSAVE  := g_results_nt;    -- Capture Original Values
      l_results_recSAVE := g_results_rec;   -- Capture Original Values
      --------------------------------------  WTPLSQL Testing --
      -- Can't Test in this block because g_results_rec has test data
      g_results_rec  := l_results_recNULL;
      g_results_rec.test_run_id   := -99;
      g_results_rec.result_seq    := 1;
      g_results_rec.executed_dtm  := systimestamp;
      g_results_rec.elapsed_msecs := 99;
      g_results_rec.assertion     := 'FINALTEST';
      g_results_rec.status        := wt_assert.C_PASS;
      g_results_rec.details       := 'This is a WT_RESULT.FINALIZE Test';
      g_results_nt := results_nt_type(null);
      g_results_nt(1) := g_results_rec;
      g_results_nt.extend;  -- Finalize expects that last element to be NULL
      --------------------------------------  WTPLSQL Testing --
      -- Can't Test in this block because g_results_rec has test data
      g_results_rec.test_run_id   := NULL;
      select count(*)
       into  num_recs_aa('Finalize Before NULL Test Record Count')
       from  wt_results
       where test_run_id = -99;
      finalize;
      select count(*)
       into  num_recs_aa('Finalize After NULL Test Record Count')
       from  wt_results
       where test_run_id = -99;
      rollback;    -- UNDO all database changes
      g_results_rec.test_run_id   := -99;
      --------------------------------------  WTPLSQL Testing --
      -- Can't Test in this block because g_results_rec has test data
      l_test_runs_rec.id           := -99;
      l_test_runs_rec.start_dtm    := systimestamp;
      l_test_runs_rec.runner_name  := 'Finalize Test';
      l_test_runs_rec.runner_owner := 'BOGUS';
      insert into wt_test_runs values l_test_runs_rec;
      commit;      -- Must commit because finalize is AUTONOMOUS TRANSACTION
      finalize;    -- g_results_nt is still loaded with one element
      l_results_ntTEST  := g_results_nt;
      l_results_recTEST := g_results_rec;
      select count(*)
       into  num_recs_aa('Finalize Record Count Test')
       from  wt_results
       where test_run_id = -99;
      delete from wt_results where test_run_id = -99;
      delete from wt_test_runs where id = -99;
      commit;      -- UNDO all database changes
      --------------------------------------  WTPLSQL Testing --
      -- Restore values so we can test
      g_results_rec := l_results_recSAVE;
      g_results_nt  := l_results_ntSAVE;
      wt_assert.eq (
         msg_in          => 'Finalize Before NULL Test Record Count',
         check_this_in   => num_recs_aa('Finalize Before NULL Test Record Count'),
         against_this_in => 0);
      wt_assert.eq (
         msg_in          => 'Finalize After NULL Test Record Count',
         check_this_in   => num_recs_aa('Finalize After NULL Test Record Count'),
         against_this_in => 0);
      wt_assert.isnull (
         msg_in        => 'Finalize g_results_rec.test_run_id',
         check_this_in => l_results_recTEST.test_run_id);
      wt_assert.eq (
         msg_in          => 'Finalize g_results_nt.COUNT',
         check_this_in   => l_results_ntTEST.COUNT,
         against_this_in => 1);
      wt_assert.eq (
         msg_in          => 'Finalize Record Count Test',
         check_this_in   => num_recs_aa('Finalize Record Count Test'),
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
   procedure tc_null_save_testing
   is
      l_test_run_id    number;
      l_dbmsout_line   varchar2(32767);
      l_dbmsout_stat   number;
   begin
      wt_assert.g_testcase := 'Null Save Testing';
      l_test_run_id  := g_results_rec.test_run_id;
      g_results_rec.test_run_id := NULL;
      wt_result.save (
         in_assertion  => 'SELFTEST1',
         in_status     => wt_assert.C_PASS,
         in_details    => 'tc_null_save_testing Testing Details',
         in_testcase   => wt_assert.g_testcase,
         in_message    => 'tc_null_save_testing Testing Message');
      g_results_rec.test_run_id := l_test_run_id;
      --------------------------------------  WTPLSQL Testing --
      DBMS_OUTPUT.GET_LINE (
         line   => l_dbmsout_line,
         status => l_dbmsout_stat);
      wt_assert.eq (
         msg_in          => 'Save Testing NULL Test DBMS_OUTPUT 1 Status',
         check_this_in   => l_dbmsout_stat,
         against_this_in => 0);
      if not wt_assert.last_pass
      then
         return;  -- Nothing in DBMS_OUPUT buffer. End this now.
      end if;
      wt_assert.isnotnull (
         msg_in        => 'Save Testing NULL Test DBMS_OUTPUT 2 Line',
         check_this_in => l_dbmsout_line);
      wt_assert.this (
         msg_in        => 'Save Testing NULL Test DBMS_OUTPUT 3 Message',
         check_this_in => (l_dbmsout_line like '%' || wt_assert.g_testcase ||
                          '%tc_null_save_testing Testing%'));
      if not wt_assert.last_pass
      then
         -- No match, put the line back into DBMS_OUTPUT buffer and end this.
         DBMS_OUTPUT.PUT_LINE(l_dbmsout_line);
         return;
      end if;
   end tc_null_save_testing;
      --------------------------------------  WTPLSQL Testing --
   procedure tc_save_testing
   is
      l_nt_count       number;
   begin
      wt_assert.g_testcase := 'Save Testing';
      l_nt_count     := g_results_nt.COUNT;
      wt_result.save (
         in_assertion  => 'SELFTEST2',
         in_status     => wt_assert.C_PASS,
         in_details    => 'tc_save_testing Testing Details',
         in_testcase   => wt_assert.g_testcase,
         in_message    => 'tc_save_testing Testing Message');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 1 COUNT',
         check_this_in   => g_results_nt.COUNT,
         against_this_in => l_nt_count + 1);
      if not wt_assert.last_pass
      then
         return;   -- Something went wrong, end this now.
      end if;
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 2 assetion',
         check_this_in   => g_results_nt(l_nt_count).assertion,
         against_this_in => 'SELFTEST2');
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 3 status',
         check_this_in   => g_results_nt(l_nt_count).status,
         against_this_in => wt_assert.C_PASS);
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 4 details',
         check_this_in   => g_results_nt(l_nt_count).details,
         against_this_in => 'tc_save_testing Testing Details');
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 5 status',
         check_this_in   => g_results_nt(l_nt_count).testcase,
         against_this_in => wt_assert.g_testcase);
      wt_assert.eq (
         msg_in          => 'Save Testing Test g_results_nt 6 message',
         check_this_in   => g_results_nt(l_nt_count).message,
         against_this_in => 'tc_save_testing Testing Message');
      wt_assert.isnotnull (
         msg_in          => 'Save Testing Test g_results_nt 7 elapsed_msecs',
         check_this_in   => g_results_nt(l_nt_count).elapsed_msecs);
      wt_assert.isnotnull (
         msg_in          => 'Save Testing Test g_results_nt 8 executed_dtm',
         check_this_in   => g_results_nt(l_nt_count).executed_dtm);
      wt_assert.isnotnull (
         msg_in          => 'Save Testing Test g_results_nt 9 result_seq',
         check_this_in   => g_results_nt(l_nt_count).result_seq);
      --  Can't Delete Test Element.  g_results_nt.COUNT is not reduced
      --    because nested tables are not dense.
      --g_results_nt.delete(l_nt_count + 1);
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
   procedure WTPLSQL_RUN  --% WTPLSQL SET DBOUT "WT_RESULT" %--
   is
   begin
      tc_initialize;
      tc_finalize;
      tc_null_save_testing;
      tc_save_testing;
      tc_delete_records;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_result;
