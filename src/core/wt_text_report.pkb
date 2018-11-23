create or replace package body wt_text_report
as


----------------------
--  Private Procedures
----------------------


------------------------------------------------------------
procedure p
      (in_text  in  varchar2)
is
begin
   dbms_output.put_line(in_text);
end p;

------------------------------------------------------------
procedure result_summary
is
   TYPE tcase_aa_type is table of varchar2(1)
      index by varchar2(200);
   tcase_aa     tcase_aa_type;
   tot_cnt      number := 0;
   fail_cnt     number := 0;
   min_msec     number := 0;
   max_msec     number := 0;
   tot_msec     number := 0;
   avg_msec     number := 0;
   l_yield_txt  varchar2(50);
begin
   tot_cnt := core_data.g_results_nt.COUNT;
   for i in 1 .. tot_cnt
   loop
      tcase_aa(core_data.g_results_nt(i).testcase) := 'x';
      if not core_data.g_results_nt(i).pass
      then
         fail_cnt := fail_cnt + 1;
      end if;
      min_msec := LEAST(min_msec, core_data.g_results_nt(i).interval_msecs);
      max_msec := GREATEST(max_msec, core_data.g_results_nt(i).interval_msecs);
      tot_msec := tot_msec + core_data.g_results_nt(i).interval_msecs;
   end loop;
   if nvl(tot_cnt,0) = 0
   then
      avg_msec := 0;
      l_yield_txt := '(Divide by Zero)';
   else
      avg_msec := tot_msec / tot_cnt;
      l_yield_txt := to_char(round(100*(1-(fail_cnt/tot_cnt)), 2)
                            ,'9990.99') || '%';
   end if;
   p('  Minimum Elapsed msec: ' || to_char(min_msec,      '9999999') ||
     '       Total Testcases: ' || to_char(tcase_aa.COUNT,'9999999') );
   p('  Average Elapsed msec: ' || to_char(avg_msec,      '9999999') ||
     '      Total Assertions: ' || to_char(tot_cnt,       '9999999') );
   p('  Maximum Elapsed msec: ' || to_char(max_msec,      '9999999') ||
     '     Failed Assertions: ' || to_char(fail_cnt,      '9999999') );
   p('  Total Run Time (sec): ' ||
      to_char(extract(day from (core_data.g_run_rec.end_dtm -
                                core_data.g_run_rec.start_dtm) * 86400 * 100) / 100
                                                         ,'99990.9') ||
     '            Test Yield: ' || l_yield_txt                       );
end result_summary;

------------------------------------------------------------
procedure summary_out
is
begin
   p('');
   p('   wtPLSQL ' || wtplsql.show_version || ' - Start Date/Time: ' ||
         to_char(core_data.g_run_rec.start_dtm, g_date_format) ||
         CHR(10));
   p('Test Results for ' || core_data.g_run_rec.runner_owner ||
                     '.' || core_data.g_run_rec.runner_name  );
   ----------------------------------------
   if core_data.g_run_rec.dbout_name is not null
   then
      p('Database Object Under Test is ' || core_data.g_run_rec.dbout_type  ||
                                     ' ' || core_data.g_run_rec.dbout_owner ||
                                     '.' || core_data.g_run_rec.dbout_name  );
   end if;
   p('----------------------------------------');
   result_summary;
   if core_data.g_run_rec.error_message is not null
   then
      p('');
      p('  *** Test Runner Error ***');
      p(core_data.g_run_rec.error_message);
   end if;
end summary_out;

------------------------------------------------------------
procedure results_out
      (in_show_pass  in boolean)
is
   l_rec            core_data.results_rec_type;
   l_last_testcase  core_data.long_name;
begin
   show_result_header;
   for i in 1 .. core_data.g_results_nt.COUNT
   loop
      if    in_show_pass
         OR NOT core_data.g_results_nt(i).pass
      then
         if core_data.g_results_nt(i).testcase = l_last_testcase
         then
            l_rec := core_data.g_results_nt(i);
            l_rec.testcase := '';
            p(format_test_result(l_rec));
         else
            p(format_test_result(core_data.g_results_nt(i)));
            l_last_testcase := core_data.g_results_nt(i).testcase;
         end if;
      end if;
   end loop;
end results_out;


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure dbms_out
      (in_detail_level   in  number   default 0
      ,in_summary_last   in  boolean  default FALSE)
is
begin
   --  Setup Display Order
   if in_summary_last
   then
      if in_detail_level >= 10
      then
         results_out(in_detail_level >= 20);
      end if;
      summary_out;
   else
      summary_out;
      if in_detail_level >= 10
      then
         results_out(in_detail_level >= 20);
      end if;
   end if;
   p('');
end dbms_out;


------------------------------------------------------------
procedure ad_hoc_result
is
begin
   p(wt_assert.g_rec.last_msg                     || CHR(10) ||
     ' Assertion ' || wt_assert.g_rec.last_assert ||
                     case wt_assert.last_pass
                     when TRUE then ' PASSED.'
                               else ' FAILED.'
                     end                          || CHR(10) ||
     ' Testcase: ' || wt_assert.g_testcase        || CHR(10) ||
               ' ' || wt_assert.g_rec.last_details );
end ad_hoc_result;


------------------------------------------------------------
procedure show_result_header is begin
   p('');
   p(               core_data.g_run_rec.runner_owner ||
             '.' || core_data.g_run_rec.runner_name  ||
     ' Test Runner Details:' );
   p('----------------------------------------');
end show_result_header;


------------------------------------------------------------
function format_test_result
      (in_rec  in core_data.results_rec_type)
   return varchar2
is
   l_out_str  varchar2(32000) := '';
begin
   if in_rec.testcase is not null
   then
      l_out_str := rpad('---***  ' || in_rec.testcase ||
                        '  ***---'
                       ,80,'-') || CHR(10);
   end if;
   if in_rec.pass
   then
      l_out_str := l_out_str || ' PASS ';
   else
      l_out_str := l_out_str || '#FAIL#';
   end if;
   if in_rec.interval_msecs is not null
   then
      l_out_str := l_out_str || lpad(in_rec.interval_msecs,4) || 'ms ';
   end if;
   if in_rec.message is not null
   then
      l_out_str := l_out_str || in_rec.message  || '. ';
   end if;
   l_out_str := l_out_str || in_rec.assertion || ' - ';
   if g_single_line_output
   then
      l_out_str := l_out_str || replace(replace(in_rec.details
                                               ,CHR(13),'\r')
                                       ,CHR(10),'\n');
   else
      l_out_str := l_out_str || in_rec.details;
   end if;
   return l_out_str;
end format_test_result;


end wt_text_report;