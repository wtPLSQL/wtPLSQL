create or replace package body wt_text_report
as

   g_test_runs_rec  wt_test_runs%ROWTYPE;


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
   yield_txt  varchar2(50);
begin
   for buff in (
      select count(*)                        TOT_CNT
            ,sum(decode(status,'FAIL',1,0))  FAIL_CNT
            ,sum(decode(status,'ERR',1,0))   ERR_CNT
            ,count(distinct testcase)        TCASE_CNT
            ,min(elapsed_msecs)              MIN_MSEC
            ,round(avg(elapsed_msecs),3)     AVG_MSEC
            ,max(elapsed_msecs)              MAX_MSEC
       from  wt_results
       where test_run_id = g_test_runs_rec.id )
   loop
      if buff.tot_cnt = 0
      then
         yield_txt := '(Divide by Zero)';
      else
         yield_txt := to_char(round( ( 1 - (buff.fail_cnt+buff.err_cnt)
                                               / buff.tot_cnt
                                     ) * 100
                                   ,2)
                             ,'9990.99') || '%';
      end if;
      p('       Total Testcases: ' || to_char(buff.tcase_cnt,'9999999') ||
        '      Total Assertions: ' || to_char(buff.tot_cnt  ,'9999999') );
      p('  Minimum Elapsed msec: ' || to_char(buff.min_msec ,'9999999') ||
        '     Failed Assertions: ' || to_char(buff.fail_cnt ,'9999999') );
      p('  Average Elapsed msec: ' || to_char(buff.avg_msec ,'9999999') ||
        '      Error Assertions: ' || to_char(buff.err_cnt  ,'9999999') );
      p('  Maximum Elapsed msec: ' || to_char(buff.max_msec ,'9999999') ||
        '            Test Yield: ' || yield_txt                      );
   end loop;
end result_summary;

------------------------------------------------------------
procedure profile_summary
is
   code_coverage  varchar2(100);
begin
   for buff in (
      select count(*)                        TOT_LINES
            ,sum(decode(status,'EXEC',1,0))  EXEC_LINES
            ,sum(decode(status,'ANNO',1,0))  ANNO_LINES
            ,sum(decode(status,'EXCL',1,0))  EXCL_LINES
            ,sum(decode(status,'NOTX',1,0))  NOTX_LINES
            ,sum(decode(status,'UNKN',1,0))  UNKN_LINES
            ,min(min_time)/1000              MIN_USEC
            ,sum(total_time)/1000/count(*)   AVG_USEC
            ,max(max_time)/1000              MAX_USEC
       from  wt_dbout_profiles
       where test_run_id = g_test_runs_rec.id )
   loop
      p('    Total Source Lines: ' || to_char(buff.tot_lines ,'9999999') ||
        '          Missed Lines: ' || to_char(buff.notx_lines,'9999999') );
      p('  Minimum Elapsed usec: ' || to_char(buff.min_usec  ,'9999999') ||
        '       Annotated Lines: ' || to_char(buff.anno_lines,'9999999') );
      p('  Average Elapsed usec: ' || to_char(buff.avg_usec  ,'9999999') ||
        '        Excluded Lines: ' || to_char(buff.excl_lines,'9999999') );
      p('  Maximum Elapsed usec: ' || to_char(buff.max_usec  ,'9999999') ||
        '         Unknown Lines: ' || to_char(buff.unkn_lines,'9999999') );
      if (buff.exec_lines + buff.notx_lines) = 0
      then
         code_coverage := '(Divide by Zero)';
      else
         code_coverage := to_char(      100 * buff.exec_lines /
                                  (buff.exec_lines + buff.notx_lines)
                                 ,'9990.99') || '%';
      end if;
      p(' Trigger Source Offset: ' || to_char(g_test_runs_rec.trigger_offset,'9999999') ||
        '         Code Coverage: ' || code_coverage);
   end loop;
end profile_summary;

------------------------------------------------------------
procedure summary_out
is
begin
   p('');
   p('Summary Results for Test Runner ' || g_test_runs_rec.runner_owner ||
                                    '.' || g_test_runs_rec.runner_name  ||
                       ' (Test Run ID ' || g_test_runs_rec.id           ||
                                    ')' );
   result_summary;
   p('  Total Run Time (sec): ' ||
      to_char(extract(day from (g_test_runs_rec.end_dtm -
                                g_test_runs_rec.start_dtm) * 86400 * 100) / 100
             ,'99990.9') );
   if g_test_runs_rec.error_message is not null
   then
      p('');
      p('  *** Test Runner Error ***');
      p(g_test_runs_rec.error_message);
   end if;
   ----------------------------------------
   if g_test_runs_rec.dbout_name is null
   then
      return;
   end if;
   p('');
   p('Summary Results for DBOUT: ' || g_test_runs_rec.dbout_owner ||
                               '.' || g_test_runs_rec.dbout_name  ||
                               '(' || g_test_runs_rec.dbout_type  || ')' );
   profile_summary;
end summary_out;

------------------------------------------------------------
procedure results_out
is
   last_testcase  wt_results.testcase%TYPE;
begin
   p('');
   p('Detailed Results for Test Runner ' || g_test_runs_rec.runner_owner ||
                                     '.' || g_test_runs_rec.runner_name  ||
                        ' (Test Run ID ' || g_test_runs_rec.id           ||
                                     ')' );
   for buff in (
      select status
            ,elapsed_msecs
            ,testcase
            ,assertion
            ,details
            ,message
       from  wt_results
       where test_run_id = g_test_runs_rec.id
       order by result_seq )
   loop
      if    buff.testcase = last_testcase
         OR (    buff.testcase is null
             AND last_testcase is null )
      then
         p(format_test_result
                        (in_assertion      => buff.assertion
                        ,in_status         => buff.status
                        ,in_details        => buff.details
                        ,in_testcase       => NULL
                        ,in_message        => buff.message) );
      else
         p(format_test_result
                        (in_assertion      => buff.assertion
                        ,in_status         => buff.status
                        ,in_details        => buff.details
                        ,in_testcase       => buff.testcase
                        ,in_message        => buff.message) );
         last_testcase := buff.testcase;
      end if;
   end loop;
end results_out;

------------------------------------------------------------
procedure profile_out
is
   header_txt  CONSTANT varchar2(2000) := chr(10) ||
     'Source               TotTime MinTime   MaxTime     ' || chr(10) ||
     '  Line Stat Occurs    (usec)  (usec)    (usec) Text' || chr(10) ||
     '------ ---- ------ --------- ------- --------- ------------';
begin
   if g_test_runs_rec.dbout_name is null
   then
      return;
   end if;
   p('');
   p('Detailed Profile for DBOUT ' || g_test_runs_rec.dbout_owner ||
                               '.' || g_test_runs_rec.dbout_name  ||
                              ' (' || g_test_runs_rec.dbout_type  ||
                               ')' );
   p('   from Test Runner ' || g_test_runs_rec.runner_owner ||
                        '.' || g_test_runs_rec.runner_name  ||
           ' (Test Run ID ' || g_test_runs_rec.id           ||
                        ')' );
   p(header_txt);
   for buff in (
      select line
            ,status
            ,total_occur
            ,total_time
            ,min_time
            ,max_time
            ,text
            ,rownum
       from  wt_dbout_profiles
       where test_run_id = g_test_runs_rec.id
       order by line  )
   loop
      p(to_char(buff.line,'99999')               || ' ' ||
           rpad(buff.status,4)                   || ' ' ||
        to_char(buff.total_occur,'99999')        || ' ' ||
        to_char(buff.total_time/1000,'99999999') || ' ' ||
        to_char(buff.min_time/1000,'999999')     || ' ' ||
        to_char(buff.max_time/1000,'99999999')   || ' ' ||
        replace(buff.text,CHR(10),'')            );
      if mod(buff.rownum,25) = 0
      then
         p(header_txt);
      end if;
   end loop;
end profile_out;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function format_test_result
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE)
   return varchar2
is

   out_str  varchar2(32000) := '';

begin

   if in_testcase is not null
   then
      out_str := ' --  ' || in_testcase || '  --' || CHR(10);
   end if;

   if in_status = wt_result.C_PASS
   then
      out_str := ' ' || rpad(in_status,4) || ' ';
   else
      out_str := '#' || rpad(in_status,4) || '#';
   end if;

   if in_message is not null
   then
      out_str := out_str || in_message  || '. ';
   end if;

   out_str := out_str || in_assertion || ' - ';
   out_str := out_str || in_details;

   return out_str;
   
end format_test_result;

------------------------------------------------------------
procedure ad_hoc_result
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE)
is
begin
   p(format_test_result
        (in_assertion  => in_assertion
        ,in_status     => in_status
        ,in_details    => in_details
        ,in_testcase   => in_testcase
        ,in_message    => in_message));
end ad_hoc_result;

------------------------------------------------------------
procedure dbms_out
      (in_test_run_id    in  number  default NULL
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_first  in  boolean default FALSE)
is
begin

   for buff in (select * from wt_test_runs
                 where in_test_run_id IS NULL
                   or  in_test_run_id = id)
   loop

      --  Load Test Run Record
      g_test_runs_rec := buff;
   
      --  Setup Display Order
      if in_summary_first
      then
         summary_out;
         if NOT in_hide_details
         then
            results_out;
            profile_out;
         end if;
      else
         if NOT in_hide_details
         then
            profile_out;
            results_out;
         end if;
         summary_out;
      end if;

   end loop;

end dbms_out;

end wt_text_report;
