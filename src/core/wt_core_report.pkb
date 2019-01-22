create or replace package body wt_core_report
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
procedure summary_out
is
   asrt_cnt     number;
   run_sec      number;
   tc_cnt       number;
   tc_fail      number;
   min_msec     number;
   max_msec     number;
   tot_msec     number;
   avg_msec     number;
   l_yield_txt  varchar2(50);
begin
   p('');
   --
   p('   wtPLSQL ' || wtplsql.show_version);
   p('   Start Date/Time: ' ||
         to_char(core_data.g_run_rec.start_dtm, g_date_format));
   p('');
   p('Test Results for ' || core_data.g_run_rec.test_runner_owner ||
                     '.' || core_data.g_run_rec.test_runner_name  );
   ----------------------------------------
   if core_data.g_run_rec.dbout_name is not null
   then
      p('Database Object Under Test is ' || core_data.g_run_rec.dbout_type  ||
                                     ' ' || core_data.g_run_rec.dbout_owner ||
                                     '.' || core_data.g_run_rec.dbout_name  );
   end if;
   p('----------------------------------------');
   --
   asrt_cnt := core_data.g_run_rec.asrt_cnt;
   run_sec  := core_data.g_run_rec.runner_sec;
   tc_cnt   := core_data.g_run_rec.tc_cnt;
   tc_fail  := core_data.g_run_rec.tc_fail;
   min_msec := core_data.g_run_rec.asrt_min_msec;
   max_msec := core_data.g_run_rec.asrt_max_msec;
   tot_msec := core_data.g_run_rec.asrt_tot_msec;
   case nvl(asrt_cnt,0)
        when 0 then avg_msec := 0;
               else avg_msec := tot_msec/asrt_cnt;
   end case;
   case nvl(tc_cnt,0)
        when 0 then l_yield_txt := '(Divide by Zero)';
               else l_yield_txt := to_char(100 * ( 1 - (tc_fail/tc_cnt) )
                                          ,'9999999') || '%';
   end case;
   --
   p('  Minimum Elapsed msec: ' || to_char(min_msec ,'9999999') ||
     '      Total Assertions: ' || to_char(asrt_cnt ,'9999999') );
   p('  Average Elapsed msec: ' || to_char(avg_msec ,'9999999') ||
     '       Total Testcases: ' || to_char(tc_cnt   ,'9999999') );
   p('  Maximum Elapsed msec: ' || to_char(max_msec ,'9999999') ||
     '      Failed Testcases: ' || to_char(tc_fail  ,'9999999') );
   p('  Total Run Time (sec): ' || to_char(run_sec  ,'99990.9') ||
     '        Testcase Yield: ' || l_yield_txt                  );
   --
   if core_data.g_run_rec.error_message is not null
   then
      p('');
      p('  *** Test Runner Error ***');
      p(core_data.g_run_rec.error_message);
   end if;
   --
end summary_out;

------------------------------------------------------------
procedure results_out
      (in_show_pass  in boolean)
is
   l_rec         core_data.results_rec_type;
   old_testcase  core_data.long_name;
   show_header   boolean := TRUE;
begin
   -- Loop through all results
   for i in 1 .. core_data.g_results_nt.COUNT
   loop
      -- Determine if this should be displayed
      if    in_show_pass
         OR NOT core_data.g_results_nt(i).pass
      then
         l_rec := core_data.g_results_nt(i);
         -- Remove Consecutive Testcases
         if core_data.g_results_nt(i).testcase = old_testcase
         then
            l_rec.testcase := '';
         else
            old_testcase := l_rec.testcase;
         end if;
         -- Display header if needed
         if show_header
         then
            p('');
            p(               core_data.g_run_rec.test_runner_owner ||
                      '.' || core_data.g_run_rec.test_runner_name  ||
              ' Test Runner Details:' );
            p('----------------------------------------');
            show_header := FALSE;
         end if;
         -- Display the result
         p(format_test_result(l_rec));
      end if;
   end loop;
   --
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
   p(wt_assert.g_rec.last_msg);
   p(' Assertion ' || wt_assert.g_rec.last_assert ||
                     case wt_assert.last_pass
                     when TRUE then ' PASSED.'
                               else ' FAILED.'
                     end);
   if wt_assert.g_testcase is not null
   then
      p(' Testcase: ' || wt_assert.g_testcase);
   end if;
   p(          ' ' || wt_assert.g_rec.last_details);
end ad_hoc_result;


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


end wt_core_report;