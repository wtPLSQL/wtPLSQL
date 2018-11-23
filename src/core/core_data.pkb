create or replace package body core_data
is

   g_results_rec   results_rec_type;

---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure init1
      (in_package_name  in  varchar2)
is
   l_run_recNULL      run_rec_type;
   l_results_recNULL  results_rec_type;
begin
   -- Initialize Test Run Record
   g_run_rec    := l_run_recNULL;
   g_run_rec.start_dtm     := systimestamp;
   g_run_rec.runner_name   := in_package_name;
   --  These don't work:
   --  g_run_rec.runner_owner := USER;
   --  g_run_rec.runner_owner := sys_context('userenv', 'current_schema');
   select username into g_run_rec.runner_owner from user_users;
   -- Initialize Test Results Array
   g_results_nt := results_nt_type(null);
   -- Initialize Test Results Record
   g_results_rec := l_results_recNULL;
end init1;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_init1
   is
      l_run_recSAVE      run_rec_type;
      l_results_ntSAVE   results_nt_type;
      l_results_recSAVE  results_rec_type;
      l_run_recTEST      run_rec_type;
      l_results_ntTEST   results_nt_type;
      l_results_recTEST  results_rec_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INIT "One" Happy Path 1';
      l_run_recSAVE     := g_run_rec;
      l_results_recSAVE := g_results_rec;
      l_results_ntSAVE  := g_results_nt;
      init1 ('WTPLSQL');
      l_run_recTEST     := g_run_rec;
      l_results_recTEST := g_results_rec;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_results_rec     := l_results_recSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_ntSAVE.COUNT'
         ,check_this_in   =>  l_results_ntSAVE.COUNT);
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST.COUNT'
         ,check_this_in   =>  l_results_ntTEST.COUNT
         ,against_this_in =>  1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.runner_owner'
         ,check_this_in   =>  l_run_recTEST.runner_owner
         ,against_this_in =>  USER);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.runner_name'
         ,check_this_in   =>  l_run_recTEST.runner_name
         ,against_this_in => 'WTPLSQL');
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.start_dtm'
         ,check_this_in   =>  l_run_recTEST.start_dtm);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.start_dtm > l_run_recSAVE.start_dtm'
         ,check_this_in   =>  l_run_recTEST.start_dtm > l_run_recSAVE.start_dtm);
      wt_assert.isnull
         (msg_in          => 'l_results_recTEST.pass'
         ,check_this_in   =>  l_results_recTEST.pass);
   end t_init1;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure init2
is
   l_run_recNULL      run_rec_type;
   l_results_recNULL  results_rec_type;
begin
   g_results_rec.result_seq   := 0;
   g_results_rec.executed_dtm := systimestamp;
end init2;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_init2
   is
      l_run_recSAVE      run_rec_type;
      l_results_ntSAVE   results_nt_type;
      l_results_recSAVE  results_rec_type;
      l_results_recTEST  results_rec_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INIT "Two" Happy Path 1';
      l_run_recSAVE     := g_run_rec;
      l_results_recSAVE := g_results_rec;
      l_results_ntSAVE  := g_results_nt;
      g_results_rec.executed_dtm := null;
      --------------------------------------  WTPLSQL Testing --
      init2;
      l_results_recTEST := g_results_rec;
      g_run_rec         := l_run_recSAVE;
      g_results_rec     := l_results_recSAVE;
      g_results_nt      := l_results_ntSAVE;
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.result_seq'
         ,check_this_in   =>  l_results_recTEST.result_seq
         ,against_this_in =>  0);
      wt_assert.isnotnull
         (msg_in          => 'l_results_recTEST.executed_dtm'
         ,check_this_in   =>  l_results_recTEST.executed_dtm);
   end t_init2;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure add
      (in_testcase   in varchar2
      ,in_assertion  in varchar2
      ,in_pass       in boolean
      ,in_details    in varchar2
      ,in_message    in varchar2)
is
   l_current_tstamp   timestamp(6);
begin
   g_results_rec.result_seq     := g_results_rec.result_seq + 1;
   -- g_results_rec.executed_dtm still has the last execution time
   --   core_data.init also sets this during test runner startup
   l_current_tstamp := systimestamp;
   g_results_rec.interval_msecs := extract(day from (
                                   l_current_tstamp - g_results_rec.executed_dtm
                                   ) * 86400 * 1000);
   g_results_rec.executed_dtm   := l_current_tstamp;
   g_results_rec.testcase       := in_testcase;
   g_results_rec.assertion      := in_assertion;
   g_results_rec.pass           := in_pass;
   g_results_rec.details        := in_details;
   g_results_rec.message        := in_message;
   g_results_nt(g_results_nt.COUNT) := g_results_rec;
   g_results_nt.extend;
end add;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_add
   is
      l_run_recSAVE      run_rec_type;
      l_results_ntSAVE   results_nt_type;
      l_results_recSAVE  results_rec_type;
      l_run_recTEST      run_rec_type;
      l_results_ntTEST   results_nt_type;
      l_results_recTEST  results_rec_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Add Procedure Happy Path';
      l_run_recSAVE     := g_run_rec;
      l_results_recSAVE := g_results_rec;
      l_results_ntSAVE  := g_results_nt;
      add(in_testcase  => 'The Testcase'
         ,in_assertion => 'The Assert'
         ,in_pass      => TRUE
         ,in_details   => 'The Details'
         ,in_message   => 'The Message');
      l_run_recTEST     := g_run_rec;
      l_results_recTEST := g_results_rec;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_results_rec     := l_results_recSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_ntSAVE.COUNT'
         ,check_this_in   =>  l_results_ntSAVE.COUNT);
      wt_assert.eq
         (msg_in          => 'Confirm l_results_ntTEST.COUNT'
         ,check_this_in   =>  l_results_ntTEST.COUNT
         ,against_this_in =>  l_results_ntSAVE.COUNT + 1);
      wt_assert.isnotnull
         (msg_in          => 'l_results_recTEST.result_seq'
         ,check_this_in   =>  l_results_recTEST.result_seq);
      wt_assert.this
         (msg_in          => 'l_results_recTEST.result_seq = ' ||
                             'l_results_recSAVE.result_seq + 1'
         ,check_this_in   =>  l_results_recTEST.result_seq =
                              l_results_recSAVE.result_seq + 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_recTEST.interval_msecs'
         ,check_this_in   =>  l_results_recTEST.interval_msecs);
      wt_assert.isnotnull
         (msg_in          => 'l_results_recTEST.executed_dtm'
         ,check_this_in   =>  l_results_recTEST.executed_dtm);
      wt_assert.this
         (msg_in          => 'l_results_recTEST.executed_dtm >= ' ||
                             'l_results_recSAVE.executed_dtm'
         ,check_this_in   =>  l_results_recTEST.executed_dtm >=
                              l_results_recSAVE.executed_dtm);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.testcase'
         ,check_this_in   =>  l_results_recTEST.testcase
         ,against_this_in => 'The Testcase');
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.assertion'
         ,check_this_in   =>  l_results_recTEST.assertion
         ,against_this_in => 'The Assert');
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.pass'
         ,check_this_in   =>  l_results_recTEST.pass
         ,against_this_in =>  TRUE);
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.details'
         ,check_this_in   =>  l_results_recTEST.details
         ,against_this_in => 'The Details');
      wt_assert.eq
         (msg_in          => 'l_results_recTEST.message'
         ,check_this_in   =>  l_results_recTEST.message
         ,against_this_in => 'The Message');
   end t_add;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure finalize
is
begin
   core_data.g_run_rec.end_dtm := systimestamp;
   g_results_nt.delete(g_results_nt.COUNT);
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_finalize
   is
      l_run_recSAVE      run_rec_type;
      l_results_ntSAVE   results_nt_type;
      l_results_recSAVE  results_rec_type;
      l_run_recTEST      run_rec_type;
      l_results_ntTEST   results_nt_type;
      l_results_recTEST  results_rec_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalize Happy Path';
      l_run_recSAVE     := g_run_rec;
      l_results_recSAVE := g_results_rec;
      l_results_ntSAVE  := g_results_nt;
      finalize;
      l_run_recTEST     := g_run_rec;
      l_results_recTEST := g_results_rec;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_results_rec     := l_results_recSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in        => 'l_run_recSAVE.end_dtm'
         ,check_this_in =>  l_run_recSAVE.end_dtm);
      wt_assert.isnotnull
         (msg_in        => 'l_run_recTEST.end_dtm'
         ,check_this_in =>  l_run_recTEST.end_dtm);
      wt_assert.isnotnull
         (msg_in        => 'l_results_ntSAVE.COUNT'
         ,check_this_in =>  l_results_ntSAVE.COUNT);
      wt_assert.this
         (msg_in        => 'l_results_ntTEST.COUNT = l_results_ntSAVE.COUNT - 1'
         ,check_this_in =>  l_results_ntTEST.COUNT = l_results_ntSAVE.COUNT - 1);
   end t_finalize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure run_error
      (in_error_message  in  varchar2)
is
begin
   if g_run_rec.error_message is null
   then
      g_run_rec.error_message := substr(in_error_message,1,4000);
   else
      g_run_rec.error_message := substr(g_run_rec.error_message || CHR(10) ||
                                        in_error_message,1,4000);
   end if;
end run_error;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_run_error
   is
      l_run_recSAVE   run_rec_type;
      l_run_recTEST   run_rec_type;
      test_message    varchar2(32767);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'RUN_ERROR Happy Path 1';
      l_run_recSAVE := g_run_rec;
      g_run_rec.error_message := '';
      run_error('Simlple Message');
      l_run_recTEST := g_run_rec;
      g_run_rec     := l_run_recSAVE;
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.error_message'
         ,check_this_in   =>  l_run_recTEST.error_message
         ,against_this_in => 'Simlple Message');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'RUN_ERROR Happy Path 2';
      l_run_recSAVE := g_run_rec;
      g_run_rec.error_message := '';
      run_error('Message 1');
      run_error('Message 2');
      l_run_recTEST := g_run_rec;
      g_run_rec     := l_run_recSAVE;
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.error_message'
         ,check_this_in   =>  l_run_recTEST.error_message
         ,against_this_in => 'Message 1' || CHR(10) || 'Message 2');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'RUN_ERROR Happy Path 3';
      for i in 1 .. 399
      loop
         test_message := test_message || '1234567890';
      end loop;
      l_run_recSAVE := g_run_rec;
      g_run_rec.error_message := '';
      run_error(test_message);
      run_error('Longer than 10 characters.');
      l_run_recTEST := g_run_rec;
      g_run_rec     := l_run_recSAVE;
      wt_assert.isnotnull
         (msg_in          => 'substr(l_run_recTEST.error_message,3000)'
         ,check_this_in   =>  substr(l_run_recTEST.error_message,3000));
      wt_assert.this
         (msg_in          => 'l_run_recTEST.error_message like ''%Longer th'''
         ,check_this_in   =>  l_run_recTEST.error_message like '%Longer th');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'RUN_ERROR Happy Path 4';
      l_run_recSAVE := g_run_rec;
      g_run_rec.error_message := '';
      run_error('');
      run_error('Message');
      run_error('');
      l_run_recTEST := g_run_rec;
      g_run_rec     := l_run_recSAVE;
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.error_message'
         ,check_this_in   =>  l_run_recTEST.error_message
         ,against_this_in => 'Message' || CHR(10));
   end t_run_error;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      wtplsql.g_DBOUT := 'CORE_DATA:PACKAGE BODY';
      --------------------------------------  WTPLSQL Testing --
      t_init1;
      t_init2;
      t_add;
      t_finalize;
      t_run_error;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end core_data;
