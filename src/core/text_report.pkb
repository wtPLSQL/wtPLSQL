create or replace package body text_report
as

   g_test_runs_rec  test_runs%ROWTYPE;


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
            ,avg(elapsed_msecs)              AVG_MSEC
            ,max(elapsed_msecs)              MAX_MSEC
       from  results
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
            ,sum(decode(status,'EXCL',1,0))  NOEX_LINES
            ,sum(decode(status,'MISS',1,0))  MISS_LINES
            ,sum(decode(status,'HIT',1,0))   HIT_LINES
            ,min(min_time)                   MIN_MSEC
            ,sum(total_time)/count(*)        AVG_MSEC
            ,max(max_time)                   MAX_MSEC
       from  dbout_profiles
       where test_run_id = g_test_runs_rec.id )
   loop
      p('  Minimum Elapsed msec: ' || buff.min_msec);
      p('  Average Elapsed msec: ' || buff.avg_msec);
      p('  Maximum Elapsed msec: ' || buff.max_msec);
      p('    Total Source Lines: ' || buff.tot_lines);
      p('    Non-Executed Lines: ' || buff.noex_lines);
      p('          Missed Lines: ' || buff.miss_lines);
      if (buff.hit_lines + buff.miss_lines) = 0
      then
         p('         Code Coverage: (Divide by Zero)');
      else
         p('         Code Coverage: ' || round( 100 * buff.hit_lines /
                                               (buff.hit_lines + buff.miss_lines)
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
   last_testcase  results.testcase%TYPE;
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
            ,error_message
       from  results
       where test_run_id = g_test_runs_rec.id
       order by result_seq )
   loop
      if    buff.testcase = last_testcase
         OR (    buff.testcase is null
             AND last_testcase is null )
      then
         text_report.ad_hoc_result(buff.assertion
                                  ,buff.status
                                  ,buff.details
                                  ,NULL
                                  ,buff.message
                                  ,buff.error_message);
      else
         text_report.ad_hoc_result(buff.assertion
                                  ,buff.status
                                  ,buff.details
                                  ,buff.testcase
                                  ,buff.message
                                  ,buff.error_message);
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
       from  dbout_profiles
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
procedure dbms_out
      (in_test_run_id    in  number
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_first  in  boolean default FALSE)
is
begin

   --  Load Test Run Record
   select * into g_test_runs_rec
    from  test_runs where id = in_test_run_id;

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

procedure ad_hoc_result
      (in_assertion      in results.assertion%TYPE
      ,in_status         in results.status%TYPE
      ,in_details        in results.details%TYPE
      ,in_testcase       in results.testcase%TYPE
      ,in_message        in results.message%TYPE
      ,in_error_message  in results.error_message%TYPE)
is

   out_str        varchar2(32000);

begin

   if in_testcase is not null
   then
      p('-- TESTCASE: ' || in_testcase || ' --');
   end if;

   out_str := rpad(in_status,4) || ' ';

   if in_message is not null
   then
      out_str := out_str || in_message  || '. ';
   end if;

   out_str := out_str || in_assertion || ' - ';
   out_str := out_str || in_details;

   p(out_str);

   if in_error_message is not null
   then
      p('       ERROR: ' || in_error_message);
   end if;

end ad_hoc_result;

end text_report;
