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
      p('       Total Testcases: ' || buff.tcase_cnt);
      p('  Minimum Elapsed msec: ' || buff.min_msec);
      p('  Average Elapsed msec: ' || buff.avg_msec);
      p('  Maximum Elapsed msec: ' || buff.max_msec);
      p('      Total Assertions: ' || buff.tot_cnt);
      p('     Failed Assertions: ' || buff.fail_cnt);
      p('      Error Assertions: ' || buff.err_cnt);
      if buff.tot_cnt = 0
      then
         p('            Test Yield: (Divide by Zero)');
      else
         p('            Test Yield: ' || round( ( 1 - (buff.fail_cnt+buff.err_cnt)
                                                            / buff.tot_cnt ) * 100
                                              ,2) ||
                                  '%' );
      end if;
   end loop;
end result_summary;

------------------------------------------------------------
procedure profile_summary
is
begin
   for buff in (
      select count(*)                        TOT_LINES
            ,sum(decode(status,'ANNO',1,0))  ANNO_LINES
            ,sum(decode(status,'EXCL',1,0))  EXCL_LINES
            ,sum(decode(status,'NOTX',1,0))  NOTX_LINES
            ,sum(decode(status,'EXEC',1,0))  EXEC_LINES
            ,min(min_time)                   MIN_MSEC
            ,sum(total_time)/count(*)        AVG_MSEC
            ,max(max_time)                   MAX_MSEC
       from  wt_dbout_profiles
       where test_run_id = g_test_runs_rec.id )
   loop
      p('  Minimum Elapsed msec: ' || buff.min_msec);
      p('  Average Elapsed msec: ' || buff.avg_msec);
      p('  Maximum Elapsed msec: ' || buff.max_msec);
      p('    Total Source Lines: ' || buff.tot_lines);
      p('        Executed Lines: ' || buff.exec_lines);
      p('          Missed Lines: ' || buff.notx_lines);
      p('       Annotated Lines: ' || buff.anno_lines);
      p('        Excluded Lines: ' || buff.excl_lines);
      if (buff.exec_lines + buff.notx_lines) = 0
      then
         p('         Code Coverage: (Divide by Zero)');
      else
         p('         Code Coverage: ' || round( 100 * buff.exec_lines /
                                               (buff.exec_lines + buff.notx_lines)
                                              ,2) ||
                                  '%' );
      end if;
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
   p('');
   result_summary;
   if g_test_runs_rec.error_message is not null
   then
      p('ERROR: ' || g_test_runs_rec.error_message);
   end if;
   p('    Run Time (seconds): ' || extract(day from (
                                   g_test_runs_rec.start_dtm - g_test_runs_rec.end_dtm
                                   ) * 86400         )      );
   p('');
   ----------------------------------------
   if g_test_runs_rec.dbout_name is null
   then
      return;
   end if;
   p('  Results for DBOUT: ' || g_test_runs_rec.dbout_owner ||
                         '.' || g_test_runs_rec.dbout_name  ||
                         '(' || g_test_runs_rec.dbout_type  ||
                         ')' );
   p('');
   profile_summary;
   p('');
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
   p('');
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
   p('');
end results_out;

------------------------------------------------------------
procedure profile_out
is
   header_txt  CONSTANT varchar2(2000) := chr(10) ||
     'Line   Stat Occurs TotTime MinTime MaxTime Text' || chr(10) ||
     '------ ---- ------ ------- ------- ------- ------------';
   last_line  pls_integer := 0;
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
      select line#
            ,status
            ,total_occur
            ,total_time
            ,min_time
            ,max_time
            ,text
            ,rownum
       from  wt_dbout_profiles
       where test_run_id = g_test_runs_rec.id
       order by line#  )
   loop
      p(to_char(buff.line#,'99999')        || ' ' ||
           rpad(buff.status,4)             || ' ' ||
        to_char(buff.total_occur,'99999')  || ' ' ||
        to_char(buff.total_time,'999999')  || ' ' ||
        to_char(buff.min_time,'999999')    || ' ' ||
        to_char(buff.max_time,'999999')    || ' ' ||
                buff.text                  );
      if mod(buff.rownum,25) = 0
      then
         p(header_txt);
      elsif buff.line# != last_line + 1
      then
         p('');
      end if;
   end loop;
   p('');
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
      (in_test_run_id    in  number
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_first  in  boolean default FALSE)
is
begin

   --  Load Test Run Record
   select * into g_test_runs_rec
    from  wt_test_runs where id = in_test_run_id;

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

exception
   when NO_DATA_FOUND
   then
      p('ERROR: Unable to find Test Run ID ' || in_test_run_id);
end dbms_out;

end wt_text_report;
