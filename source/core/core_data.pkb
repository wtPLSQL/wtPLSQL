create or replace package body core_data
is

   g_first_executed_dtm timestamp(6) with local time zone;

---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function get_testcase
   return long_name
is
begin
   return nvl(wt_assert.g_testcase
             ,substr(core_data.g_run_rec.test_runner_owner || '.' ||
                     core_data.g_run_rec.test_runner_name, 1, 128));
end get_testcase;

------------------------------------------------------------
procedure init1
      (in_package_name  in  varchar2)
is
   l_run_recNULL      run_rec_type;
   l_testcase         long_name;
begin
   -- Initialize Test Run Record
   g_run_rec  := l_run_recNULL;
   g_run_rec.start_dtm        := systimestamp;
   g_run_rec.test_runner_name := in_package_name;
   -- These don't always work:
   --   g_run_rec.test_runner_owner := USER;
   --   g_run_rec.test_runner_owner := sys_context('userenv', 'current_schema');
   select username into g_run_rec.test_runner_owner from user_users;
   -- Initialize Test Cases Array
   l_testcase := g_tcases_aa.LAST;
   while l_testcase is not null
   loop
                    g_tcases_aa.DELETE(l_testcase);
      l_testcase := g_tcases_aa.PRIOR(l_testcase);
   end loop;
   -- Initialize Test Results Array
   g_results_nt := null;
end init1;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_init1
   is
      l_run_recSAVE      run_rec_type;
      l_tcases_aaSAVE    tcases_aa_type;
      l_results_ntSAVE   results_nt_type;
      l_run_recTEST      run_rec_type;
      l_tcases_aaTEST    tcases_aa_type;
      l_results_ntTEST   results_nt_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INIT "One" Happy Path 1';
      l_run_recSAVE     := g_run_rec;
      l_tcases_aaSAVE   := g_tcases_aa;
      l_results_ntSAVE  := g_results_nt;
      g_tcases_aa('INIT Happy 1 Test 1') := NULL;
      g_tcases_aa('INIT Happy 1 Test 2') := NULL;
      init1 ('WTPLSQL');
      l_run_recTEST     := g_run_rec;
      l_tcases_aaTEST   := g_tcases_aa;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_tcases_aa       := l_tcases_aaSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.test_runner_owner'
         ,check_this_in   =>  l_run_recTEST.test_runner_owner
         ,against_this_in =>  USER);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.test_runner_name'
         ,check_this_in   =>  l_run_recTEST.test_runner_name
         ,against_this_in => 'WTPLSQL');
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.start_dtm'
         ,check_this_in   =>  l_run_recTEST.start_dtm);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.start_dtm > l_run_recSAVE.start_dtm'
         ,check_this_in   =>  l_run_recTEST.start_dtm > l_run_recSAVE.start_dtm);
      wt_assert.isnull
         (msg_in          => 'l_run_recTEST.end_dtm'
         ,check_this_in   =>  l_run_recTEST.end_dtm);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.runner_sec'
         ,check_this_in   =>  l_run_recTEST.runner_sec
         ,against_this_in =>  0);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.runner_sec'
         ,check_this_in   =>  l_run_recTEST.runner_sec
         ,against_this_in =>  0);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.tc_cnt'
         ,check_this_in   =>  l_run_recTEST.tc_cnt
         ,against_this_in =>  0);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.tc_fail'
         ,check_this_in   =>  l_run_recTEST.tc_fail
         ,against_this_in =>  0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_cnt'
         ,check_this_in   =>  l_run_recTEST.asrt_cnt
         ,against_this_in =>  0);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_fail'
         ,check_this_in   =>  l_run_recTEST.asrt_fail
         ,against_this_in =>  0);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_tot_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_tot_msec
         ,against_this_in =>  0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_tcases_aaTEST.FIRST'
         ,check_this_in   =>  l_tcases_aaTEST.FIRST);
      wt_assert.this
         (msg_in          => 'l_results_ntTEST is null'
         ,check_this_in   => (l_results_ntTEST is NULL) );
   end t_init1;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure init2
is
begin
   g_first_executed_dtm := systimestamp;
end init2;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_init2
   is
      l_run_recSAVE      run_rec_type;
      l_tcases_aaSAVE    tcases_aa_type;
      l_results_ntSAVE   results_nt_type;
      l_run_recTEST      run_rec_type;
      l_tcases_aaTEST    tcases_aa_type;
      l_results_ntTEST   results_nt_type;
      lt   PLS_INTEGER;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INIT "Two" Happy Path 1';
      l_run_recSAVE     := g_run_rec;
      l_tcases_aaSAVE   := g_tcases_aa;
      l_results_ntSAVE  := g_results_nt;
      -- lt points to the NULL record in g_results_nt
      lt := g_results_nt.COUNT;
      g_results_nt(lt).executed_dtm := null;
      init2;
      l_run_recTEST     := g_run_rec;
      l_tcases_aaTEST   := g_tcases_aa;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_tcases_aa       := l_tcases_aaSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_ntTEST(1).executed_dtm'
         ,check_this_in   =>  l_results_ntTEST(1).executed_dtm);
      wt_assert.this
         (msg_in          => 'l_results_ntTEST(1).executed_dtm >= l_run_recTEST.start_dtm'
         ,check_this_in   =>  l_results_ntTEST(1).executed_dtm >= l_run_recTEST.start_dtm);
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
   l_results_rec      results_rec_type;
   l_results_recNULL  results_rec_type;
   l_tcases_rec       tcases_rec_type;
   l_current_tstamp   timestamp(6) := systimestamp;
   l_interval_buff    interval day(9) to second(6);
begin
   ------------------------------------------------------------
   --  Set and Update "l_results_rec"
   if g_results_nt is null
   then
      l_results_rec := l_results_recNULL;
   else
      l_results_rec := g_results_nt(g_results_nt.COUNT);
   end if;
   l_results_rec.testcase   := nvl(in_testcase
                                  ,substr(g_run_rec.test_runner_owner || '.' ||
                                          g_run_rec.test_runner_name, 1, 128));
   l_results_rec.assertion  := in_assertion;
   l_results_rec.pass       := nvl(in_pass,FALSE);
   l_results_rec.details    := in_details;
   l_results_rec.message    := in_message;
   l_interval_buff             := l_current_tstamp -
                                     nvl(l_results_rec.executed_dtm
                                        ,g_first_executed_dtm);
   l_results_rec.interval_msec := (extract(second from l_interval_buff) +
                                   60 * ( extract(minute from l_interval_buff) +
                                         60 * ( extract(hour from l_interval_buff) +
                                               24 * ( extract(day from l_interval_buff)
                                  )     )     )     ) * 1000;
   l_results_rec.executed_dtm  := l_current_tstamp;
   ------------------------------------------------------------
   --  Add New Element
   if g_results_nt is null
   then
      -- Initialize the "g_results_nt" Array
      g_results_nt := results_nt_type(l_results_rec);
   else
      --  Add New Element to "g_results_nt" Array
      g_results_nt.extend;
      g_results_nt(g_results_nt.COUNT) := l_results_rec;
   end if;
   -----------------------------------------------
   --  Update "g_run_rec" based on "l_results_rec"
   g_run_rec.asrt_cnt      := g_run_rec.asrt_cnt +  1;
   if NOT l_results_rec.pass
   then
      g_run_rec.asrt_fail := g_run_rec.asrt_fail + 1;
   end if;
   g_run_rec.asrt_tot_msec := g_run_rec.asrt_tot_msec +
                              l_results_rec.interval_msec;
   if l_results_rec.interval_msec < nvl(g_run_rec.asrt_min_msec,9999999)
   then
      g_run_rec.asrt_min_msec := l_results_rec.interval_msec;
   end if;
   if l_results_rec.interval_msec > nvl(g_run_rec.asrt_max_msec,-1)
   then
      g_run_rec.asrt_max_msec := l_results_rec.interval_msec;
   end if;
   -----------------------------------------------------------------------
   --  Set "l_tcases_rec" and update the appropriate "g_tcases_aa" element
   --
   if g_tcases_aa.EXISTS(l_results_rec.testcase)
   then
      l_tcases_rec := g_tcases_aa(l_results_rec.testcase);
   end if;
   l_tcases_rec.asrt_cnt      := l_tcases_rec.asrt_cnt + 1;
   if NOT l_results_rec.pass
   then
      l_tcases_rec.asrt_fail  := l_tcases_rec.asrt_fail + 1;
   end if;
   l_tcases_rec.asrt_tot_msec := l_tcases_rec.asrt_tot_msec +
                                 l_results_rec.interval_msec;
   if l_results_rec.interval_msec < nvl(l_tcases_rec.asrt_min_msec,9999999)
   then
      l_tcases_rec.asrt_min_msec := l_results_rec.interval_msec;
   end if;
   if l_results_rec.interval_msec > nvl(l_tcases_rec.asrt_max_msec,-1)
   then
      l_tcases_rec.asrt_max_msec := l_results_rec.interval_msec;
   end if;
   g_tcases_aa(l_results_rec.testcase) := l_tcases_rec;
   --
end add;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_add
   is
      l_run_recSAVE      run_rec_type;
      l_tcases_aaSAVE    tcases_aa_type;
      l_results_ntSAVE   results_nt_type;
      l_run_recTEST      run_rec_type;
      l_tcases_aaTEST    tcases_aa_type;
      l_results_ntTEST   results_nt_type;
      lt   PLS_INTEGER;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Add Procedure Happy Path 1';
      l_run_recSAVE     := g_run_rec;
      l_tcases_aaSAVE   := g_tcases_aa;
      l_results_ntSAVE  := g_results_nt;
      add(in_testcase  => 'The Testcase'
         ,in_assertion => 'The Assert'
         ,in_pass      => TRUE
         ,in_details   => 'The Details'
         ,in_message   => 'The Message');
      --------------------------------------  WTPLSQL Testing --
      l_run_recTEST     := g_run_rec;
      l_tcases_aaTEST   := g_tcases_aa;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_tcases_aa       := l_tcases_aaSAVE;
      g_results_nt      := l_results_ntSAVE;
      lt := l_results_ntTEST.COUNT;
      wt_assert.isnotnull
         (msg_in          => 'The last element in l_resultsTEST_nt'
         ,check_this_in   =>  lt);
      --------------------------------------  WTPLSQL Testing --
      -- l_results_nt Testing
      -----------------------
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST.COUNT = ' ||
                             'l_results_ntSAVE.COUNT + 1'
         ,check_this_in   =>  l_results_ntTEST.COUNT
         ,against_this_in =>  l_results_ntSAVE.COUNT + 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_ntTEST(lt).interval_msec'
         ,check_this_in   =>  l_results_ntTEST(lt).interval_msec);
      wt_assert.this
         (msg_in          => 'l_results_ntTEST(lt).interval_msec >= 0'
         ,check_this_in   =>  l_results_ntTEST(lt).interval_msec >= 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_results_ntTEST(lt).executed_dtm'
         ,check_this_in   =>  l_results_ntTEST(lt).executed_dtm);
      wt_assert.this
         (msg_in          => 'l_results_ntTEST(lt).executed_dtm >= ' ||
                             'l_results_ntTEST(lt-1).executed_dtm'
         ,check_this_in   =>  l_results_ntTEST(lt).executed_dtm >=
                              l_results_ntTEST(lt-1).executed_dtm);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST(lt).testcase'
         ,check_this_in   =>  l_results_ntTEST(lt).testcase
         ,against_this_in => 'The Testcase');
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST(lt).assertion'
         ,check_this_in   =>  l_results_ntTEST(lt).assertion
         ,against_this_in => 'The Assert');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST(lt).pass'
         ,check_this_in   =>  l_results_ntTEST(lt).pass
         ,against_this_in => TRUE);
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST(lt).details'
         ,check_this_in   =>  l_results_ntTEST(lt).details
         ,against_this_in => 'The Details');
      wt_assert.eq
         (msg_in          => 'l_results_ntTEST(lt).message'
         ,check_this_in   =>  l_results_ntTEST(lt).message
         ,against_this_in => 'The Message');
      --------------------------------------  WTPLSQL Testing --
      -- l_run_rec Testing
      --------------------
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_cnt = ' ||
                             'l_run_recSAVE.asrt_cnt + 1'
         ,check_this_in   =>  l_run_recTEST.asrt_cnt
         ,against_this_in =>  l_run_recSAVE.asrt_cnt + 1);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_fail = ' ||
                             'l_run_recSAVE.asrt_fail'
         ,check_this_in   =>  l_run_recTEST.asrt_fail
         ,against_this_in =>  l_run_recSAVE.asrt_fail);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_tot_msec = ' ||
                             'l_run_recSAVE.asrt_tot_msec + ' ||
                             'l_results_ntTEST(lt).interval_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_tot_msec
         ,against_this_in =>  l_run_recSAVE.asrt_tot_msec + 
                              l_results_ntTEST(lt).interval_msec);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.asrt_min_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_min_msec);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.asrt_min_msec <= ' ||
                             'l_run_recSAVE.asrt_min_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_min_msec <=
                              l_run_recSAVE.asrt_min_msec);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.asrt_max_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_max_msec);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.asrt_max_msec <= ' ||
                             'l_run_recSAVE.asrt_max_msec'
         ,check_this_in   =>  l_run_recTEST.asrt_max_msec <=
                              l_run_recSAVE.asrt_max_msec);
      --------------------------------------  WTPLSQL Testing --
      -- l_tcases_aa Testing
      ----------------------
      wt_assert.eq
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_cnt'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_cnt
         ,against_this_in =>  1);
      wt_assert.eq
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_fail'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_fail
         ,against_this_in =>  0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_fail'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_fail);
      wt_assert.isnotnull
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_tot_msec'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_tot_msec);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_min_msec'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_min_msec);
      wt_assert.isnotnull
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_max_msec'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_max_msec);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Add Procedure Happy Path 2';
      l_run_recSAVE     := g_run_rec;
      l_tcases_aaSAVE   := g_tcases_aa;
      l_results_ntSAVE  := g_results_nt;
      add(in_testcase  => 'The Testcase'
         ,in_assertion => 'The Assert'
         ,in_pass      => FALSE
         ,in_details   => 'The Details'
         ,in_message   => 'The Message');
      --------------------------------------  WTPLSQL Testing --
      l_run_recTEST     := g_run_rec;
      l_tcases_aaTEST   := g_tcases_aa;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_tcases_aa       := l_tcases_aaSAVE;
      g_results_nt      := l_results_ntSAVE;
      lt := l_results_ntTEST.COUNT;
      wt_assert.isnotnull
         (msg_in          => 'The last element in l_resultsTEST_nt'
         ,check_this_in   =>  lt);
      --------------------------------------  WTPLSQL Testing --
      -- l_results_nt Testing
      --------------------
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_cnt = ' ||
                             'l_run_recSAVE.asrt_cnt + 1'
         ,check_this_in   =>  l_run_recTEST.asrt_cnt
         ,against_this_in =>  l_run_recSAVE.asrt_cnt + 1);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_fail = ' ||
                             'l_run_recSAVE.asrt_fail + 1'
         ,check_this_in   =>  l_run_recTEST.asrt_fail
         ,against_this_in =>  l_run_recSAVE.asrt_fail + 1);
      --------------------------------------  WTPLSQL Testing --
      -- l_run_rec Testing
      --------------------
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_cnt = ' ||
                             'l_run_recSAVE.asrt_cnt + 1'
         ,check_this_in   =>  l_run_recTEST.asrt_cnt
         ,against_this_in =>  l_run_recSAVE.asrt_cnt + 1);
      wt_assert.eq
         (msg_in          => 'l_run_recTEST.asrt_fail = ' ||
                             'l_run_recSAVE.asrt_fail + 1'
         ,check_this_in   =>  l_run_recTEST.asrt_fail
         ,against_this_in =>  l_run_recSAVE.asrt_fail + 1);
      --------------------------------------  WTPLSQL Testing --
      -- l_tcases_aa Testing
      ----------------------
      wt_assert.eq
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_cnt'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_cnt
         ,against_this_in =>  1);
      wt_assert.eq
         (msg_in          => 'l_tcases_aaTEST(''The Testcase'').asrt_fail'
         ,check_this_in   =>  l_tcases_aaTEST('The Testcase').asrt_fail
         ,against_this_in =>  1);
   end t_add;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure final1
is
   l_testcase         long_name;
   l_interval_buff    interval day(9) to second(6);
begin
   -- Update Test Case Data
   g_run_rec.tc_cnt  := g_tcases_aa.COUNT;
   g_run_rec.tc_fail := 0;
   if g_tcases_aa.COUNT > 0
   then
      l_testcase := g_tcases_aa.FIRST;
      loop
         if g_tcases_aa(l_testcase).asrt_fail > 0
         then
            g_run_rec.tc_fail := g_run_rec.tc_fail + 1;
         end if;
         exit when l_testcase = g_tcases_aa.LAST;
         l_testcase := g_tcases_aa.NEXT(l_testcase);
      end loop;
   end if;
   --
   if g_results_nt.COUNT > 0
   then
      g_run_rec.asrt_fst_dtm := g_results_nt(1).executed_dtm;
      g_run_rec.asrt_lst_dtm := g_results_nt(g_results_nt.COUNT).executed_dtm;
   end if;
   -- Update Test Run Data
   g_run_rec.end_dtm       := systimestamp;
   l_interval_buff         := g_run_rec.end_dtm - g_run_rec.start_dtm;
   g_run_rec.runner_sec    := (extract(second from l_interval_buff) +
                               60 * ( extract(minute from l_interval_buff) +
                                     60 * ( extract(hour from l_interval_buff) +
                                           24 * ( extract(day from l_interval_buff)
                              )     )     )     );
end final1;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_final1
   is
      l_run_recSAVE      run_rec_type;
      l_tcases_aaSAVE    tcases_aa_type;
      l_results_ntSAVE   results_nt_type;
      l_run_recTEST      run_rec_type;
      l_tcases_aaTEST    tcases_aa_type;
      l_results_ntTEST   results_nt_type;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'FINAL "One" Happy Path';
      l_run_recSAVE     := g_run_rec;
      l_tcases_aaSAVE   := g_tcases_aa;
      l_results_ntSAVE  := g_results_nt;
      g_tcases_aa('TC1').asrt_fail := 2;
      final1;
      l_run_recTEST     := g_run_rec;
      l_tcases_aaTEST   := g_tcases_aa;
      l_results_ntTEST  := g_results_nt;
      g_run_rec         := l_run_recSAVE;
      g_tcases_aa       := l_tcases_aaSAVE;
      g_results_nt      := l_results_ntSAVE;
      --------------------------------------  WTPLSQL Testing --
      -- Update Test Case Data
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.tc_cnt'
         ,check_this_in   =>  l_run_recTEST.tc_cnt);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.tc_cnt > 0'
         ,check_this_in   =>  l_run_recTEST.tc_cnt > 0);
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.tc_fail'
         ,check_this_in   =>  l_run_recTEST.tc_fail);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.tc_fail >= 0'
         ,check_this_in   =>  l_run_recTEST.tc_fail >= 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_run_recSAVE.asrt_fst_dtm'
         ,check_this_in   =>  l_run_recSAVE.asrt_fst_dtm);
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.asrt_fst_dtm'
         ,check_this_in   =>  l_run_recTEST.asrt_fst_dtm);
      wt_assert.isnull
         (msg_in          => 'l_run_recSAVE.asrt_lst_dtm'
         ,check_this_in   =>  l_run_recSAVE.asrt_lst_dtm);
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.asrt_lst_dtm'
         ,check_this_in   =>  l_run_recTEST.asrt_lst_dtm);
      --------------------------------------  WTPLSQL Testing --
      -- Update Test Run Data
      wt_assert.isnull
         (msg_in          => 'l_run_recSAVE.end_dtm'
         ,check_this_in   =>  l_run_recSAVE.end_dtm);
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.end_dtm'
         ,check_this_in   =>  l_run_recTEST.end_dtm);
      wt_assert.isnotnull
         (msg_in          => 'l_run_recTEST.runner_sec'
         ,check_this_in   =>  l_run_recTEST.runner_sec);
      wt_assert.this
         (msg_in          => 'l_run_recTEST.runner_sec >= l_run_recSAVE.runner_sec'
         ,check_this_in   =>  l_run_recTEST.runner_sec >= l_run_recSAVE.runner_sec);
   end t_final1;
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
      t_final1;
      --t_final2;
      t_run_error;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end core_data;
