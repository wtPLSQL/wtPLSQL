create or replace package body wt_test_run_stat
as

   TYPE tc_aa_type is
        table of wt_testcase_stats%ROWTYPE
        index by varchar2(50);
   g_tc_aa  tc_aa_type;
   g_rec    wt_test_run_stats%ROWTYPE;


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure initialize
is
   l_recNULL  wt_test_run_stats%ROWTYPE;
begin
   g_rec := l_recNULL;
   g_tc_aa.delete;
end initialize;


------------------------------------------------------------
procedure add_result
      (in_results_rec  in wt_results%ROWTYPE)
is
   tc  varchar2(50);
begin
   g_rec.test_run_id := in_results_rec.test_run_id;
   g_rec.asserts     := nvl(g_rec.asserts,0) + 1;
   case in_results_rec.status
      when 'PASS' then
         g_rec.passes := nvl(g_rec.passes,0) + 1;
      when 'FAIL' then
         g_rec.failures := nvl(g_rec.failures,0) + 1;
      when 'ERR' then
         g_rec.errors := nvl(g_rec.errors,0) + 1;
   end case;
   if in_results_rec.elapsed_msecs is not null
   then
      g_rec.tot_elapsed_msecs := nvl(g_rec.tot_elapsed_msecs,0) +
                                 in_results_rec.elapsed_msecs;
      g_rec.min_elapsed_msecs := least(nvl(g_rec.min_elapsed_msecs,999999999)
                                      ,in_results_rec.elapsed_msecs);
      g_rec.max_elapsed_msecs := greatest(nvl(g_rec.max_elapsed_msecs,0)
                                         ,in_results_rec.elapsed_msecs);
   end if;
   if in_results_rec.testcase is not null
   then
      tc := in_results_rec.testcase;
      g_tc_aa(tc).test_run_id := in_results_rec.test_run_id;
      g_tc_aa(tc).asserts     := nvl(g_tc_aa(tc).asserts,0) + 1;
      case in_results_rec.status
         when 'PASS' then
            g_tc_aa(tc).passes := nvl(g_tc_aa(tc).passes,0) + 1;
         when 'FAIL' then
            g_tc_aa(tc).failures := nvl(g_tc_aa(tc).failures,0) + 1;
         when 'ERR' then
            g_tc_aa(tc).errors := nvl(g_tc_aa(tc).errors,0) + 1;
      end case;
      if in_results_rec.elapsed_msecs is not null
      then
         g_tc_aa(tc).tot_elapsed_msecs := nvl(g_tc_aa(tc).tot_elapsed_msecs,0) +
                                          in_results_rec.elapsed_msecs;
         g_tc_aa(tc).min_elapsed_msecs := least(nvl(g_tc_aa(tc).min_elapsed_msecs,999999999)
                                               ,in_results_rec.elapsed_msecs);
         g_tc_aa(tc).max_elapsed_msecs := greatest(nvl(g_tc_aa(tc).max_elapsed_msecs,0)
                                                  ,in_results_rec.elapsed_msecs);
      end if;
   end if;
end add_result;


------------------------------------------------------------
procedure add_profile
      (in_dbout_profiles_rec  in wt_dbout_profiles%ROWTYPE)
is
begin
   g_rec.source_lines := nvl(g_rec.source_lines,0) + 1;
   case in_dbout_profiles_rec.status
      when 'EXEC' then
         g_rec.executed_lines := nvl(g_rec.executed_lines,0) + 1;
      when 'ANNO' then
         g_rec.annotated_lines := nvl(g_rec.annotated_lines,0) + 1;
      when 'EXCL' then
         g_rec.excluded_lines := nvl(g_rec.excluded_lines,0) + 1;
      when 'NOTX' then
         g_rec.notexec_lines := nvl(g_rec.notexec_lines,0) + 1;
      when 'UNKN' then
         g_rec.unknown_lines := nvl(g_rec.unknown_lines,0) + 1;
   end case;
   if in_dbout_profiles_rec.total_usecs is not null
   then
      g_rec.tot_executed_usecs := nvl(g_rec.tot_executed_usecs,0) +
                                  in_dbout_profiles_rec.total_usecs;
   end if;
   if in_dbout_profiles_rec.min_usecs is not null
   then
      g_rec.min_executed_usecs := least(nvl(g_rec.min_executed_usecs,999999999)
                                       ,in_dbout_profiles_rec.min_usecs);
   end if;
   if in_dbout_profiles_rec.max_usecs is not null
   then
      g_rec.max_executed_usecs := greatest(nvl(g_rec.max_executed_usecs,0)
                                          ,in_dbout_profiles_rec.max_usecs);
   end if;
end add_profile;


------------------------------------------------------------
procedure finalize
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   tc   varchar2(50);
begin
   g_rec.testcases := g_tc_aa.COUNT;
   insert into wt_test_run_stats values g_rec;
   if g_tc_aa.COUNT > 0
   then
      tc := g_tc_aa.FIRST;
      loop
         insert into wt_testcase_stats values g_tc_aa(tc);
         exit when tc = g_tc_aa.LAST;
         tc := g_tc_aa.NEXT(tc);
      end loop;
   end if;
   COMMIT;
   initialize;
end finalize;


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      null;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_run_stat;
