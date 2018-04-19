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
   l_yield_txt  varchar2(50);
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
         l_yield_txt := '(Divide by Zero)';
      else
         l_yield_txt := to_char(round( ( 1 - (buff.fail_cnt+buff.err_cnt)
                                                 / buff.tot_cnt
                                       ) * 100
                                     ,2)
                               ,'9990.99') || '%';
      end if;
      p('       Total Testcases: ' || to_char(nvl(buff.tcase_cnt,0),'9999999') ||
        '      Total Assertions: ' || to_char(nvl(buff.tot_cnt  ,0),'9999999') );
      p('  Minimum Elapsed msec: ' || to_char(nvl(buff.min_msec ,0),'9999999') ||
        '     Failed Assertions: ' || to_char(nvl(buff.fail_cnt ,0),'9999999') );
      p('  Average Elapsed msec: ' || to_char(nvl(buff.avg_msec ,0),'9999999') ||
        '      Error Assertions: ' || to_char(nvl(buff.err_cnt  ,0),'9999999') );
      p('  Maximum Elapsed msec: ' || to_char(nvl(buff.max_msec ,0),'9999999') ||
        '            Test Yield: ' || l_yield_txt                      );
   end loop;
end result_summary;

------------------------------------------------------------
procedure profile_summary
is
   l_code_coverage  varchar2(100);
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
      p('    Total Source Lines: ' || to_char(nvl(buff.tot_lines ,0),'9999999') ||
        '          Missed Lines: ' || to_char(nvl(buff.notx_lines,0),'9999999') );
      p('  Minimum Elapsed usec: ' || to_char(nvl(buff.min_usec  ,0),'9999999') ||
        '       Annotated Lines: ' || to_char(nvl(buff.anno_lines,0),'9999999') );
      p('  Average Elapsed usec: ' || to_char(nvl(buff.avg_usec  ,0),'9999999') ||
        '        Excluded Lines: ' || to_char(nvl(buff.excl_lines,0),'9999999') );
      p('  Maximum Elapsed usec: ' || to_char(nvl(buff.max_usec  ,0),'9999999') ||
        '         Unknown Lines: ' || to_char(nvl(buff.unkn_lines,0),'9999999') );
      if (buff.exec_lines + buff.notx_lines) = 0
      then
         l_code_coverage := '(Divide by Zero)';
      else
         l_code_coverage := to_char(      100 * buff.exec_lines /
                                    (buff.exec_lines + buff.notx_lines)
                                   ,'9990.99') || '%';
      end if;
      p(' Trigger Source Offset: ' || to_char(g_test_runs_rec.trigger_offset,'9999999') ||
        '         Code Coverage: ' || l_code_coverage);
   end loop;
end profile_summary;

------------------------------------------------------------
procedure summary_out
is
begin
   p('');
--   p(                    g_test_runs_rec.runner_owner ||
--                  '.' || g_test_runs_rec.runner_name  ||
--     --  ' Test Runner' ||
--     ' (Test Run ID ' || g_test_runs_rec.id           ||
--                  ')' );
   p('    Start Date/Time: ' || to_char(g_test_runs_rec.start_dtm
                                        ,'DD-Mon-YYYY HH24:MI:SS'));
   p('Test Results Run ID: ' || g_test_runs_rec.id           ||
                        ', ' || g_test_runs_rec.runner_owner ||
                         '.' || g_test_runs_rec.runner_name  );
   p('----------------------------------------');
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
--   p(                    g_test_runs_rec.dbout_owner ||
--                  '.' || g_test_runs_rec.dbout_name  ||
--                  ' ' || g_test_runs_rec.dbout_type  ||
--     ' Code Coverage' || 
--     ' (Test Run ID ' || g_test_runs_rec.id           ||
--                  ')' );
   p('Code Coverage Run ID: ' || g_test_runs_rec.id          ||
                         ', ' || g_test_runs_rec.dbout_type  ||
                          ' ' || g_test_runs_rec.dbout_owner ||
                          '.' || g_test_runs_rec.dbout_name  );
   p('----------------------------------------');
   profile_summary;
end summary_out;

------------------------------------------------------------
procedure results_out
      (in_show_pass  in boolean)
is
   l_last_testcase  wt_results.testcase%TYPE;
   l_show_pass_txt  varchar2(1);
   header_shown     boolean;
   procedure l_show_header is begin
      p('');
      p(                            g_test_runs_rec.runner_owner ||
                             '.' || g_test_runs_rec.runner_name  ||
      --            ' Test Runner' ||
        ' Details (Test Run ID ' || g_test_runs_rec.id           ||
                             ')' );
      p('----------------------------------------');
   end l_show_header;
begin
   if in_show_pass
   then
      l_show_pass_txt := 'Y';
   else
      l_show_pass_txt := 'N';
   end if;
   header_shown := FALSE;
   for buff in (
      select status
            ,elapsed_msecs
            ,testcase
            ,assertion
            ,details
            ,message
       from  wt_results
       where test_run_id = g_test_runs_rec.id
       and  (   l_show_pass_txt = 'Y'
             or status         != 'PASS')
       order by result_seq )
   loop
      if not header_shown
      then
         l_show_header;
         header_shown := TRUE;
      end if;
      if    buff.testcase = l_last_testcase
         OR (      buff.testcase is null
             AND l_last_testcase is null )
      then
         p(format_test_result
                        (in_assertion      => buff.assertion
                        ,in_status         => buff.status
                        ,in_details        => buff.details
                        ,in_testcase       => NULL
                        ,in_message        => buff.message
                        ,in_elapsed_msecs  => buff.elapsed_msecs) );
      else
         p(format_test_result
                        (in_assertion      => buff.assertion
                        ,in_status         => buff.status
                        ,in_details        => buff.details
                        ,in_testcase       => buff.testcase
                        ,in_message        => buff.message
                        ,in_elapsed_msecs  => buff.elapsed_msecs) );
         l_last_testcase := buff.testcase;
      end if;
   end loop;
end results_out;

------------------------------------------------------------
procedure profile_out
      (in_show_aux  in boolean)
is
   l_header_txt  CONSTANT varchar2(2000) := 
     'Source               TotTime MinTime   MaxTime     ' || chr(10) ||
     '  Line Stat Occurs    (usec)  (usec)    (usec) Text' || chr(10) ||
     '------ ---- ------ --------- ------- --------- ------------';
   l_show_aux_txt  varchar2(1);
   header_shown     boolean;
   procedure l_show_header is begin
     p('');
     p(                             g_test_runs_rec.dbout_owner ||
                              '.' || g_test_runs_rec.dbout_name  ||
                              ' ' || g_test_runs_rec.dbout_type  ||
         ' Code Coverage Details' ||
                 ' (Test Run ID ' || g_test_runs_rec.id           ||
                              ')' );
      --p('----------------------------------------');
   end l_show_header;
begin
   if g_test_runs_rec.dbout_name is null
   then
      return;
   end if;
   if in_show_aux
   then
      l_show_aux_txt := 'Y';
   else
      l_show_aux_txt := 'N';
   end if;
   header_shown := FALSE;
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
       and  (   l_show_aux_txt = 'Y'
             or status not in ('EXEC','ANNO','UNKN','EXCL'))
       order by line  )
   loop
      if not header_shown
      then
         l_show_header;
         p(l_header_txt);
         header_shown := TRUE;
      end if;
      if mod(buff.rownum,25) = 0
      then
         p(l_header_txt);
      end if;
      p(to_char(buff.line,'99999')               ||
        case buff.status when 'NOTX' then '#NOTX#'
        else ' ' || rpad(buff.status,4) || ' '
        end                                      ||
        to_char(buff.total_occur,'99999')        || ' ' ||
        to_char(buff.total_time/1000,'99999999') || ' ' ||
        to_char(buff.min_time/1000,'999999')     || ' ' ||
        to_char(buff.max_time/1000,'99999999')   || ' ' ||
        replace(buff.text,CHR(10),'')            );
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
      ,in_message        in wt_results.message%TYPE
      ,in_elapsed_msecs  in wt_results.elapsed_msecs%TYPE DEFAULT NULL)
   return varchar2
is
   l_out_str  varchar2(32000) := '';
begin
   if in_testcase is not null
   then
      l_out_str := rpad('---***  ' || in_testcase || '  ***---'
                       ,80,'-') || CHR(10);
   end if;
   if in_status = wt_assert.C_PASS
   then
      l_out_str := l_out_str || ' ' || rpad(in_status,4) || ' ';
   else
      l_out_str := l_out_str || '#' || rpad(in_status,4) || '#';
   end if;
   if in_elapsed_msecs is not null
   then
      if in_elapsed_msecs >= 0
      then
         l_out_str := l_out_str || lpad(in_elapsed_msecs,4) || 'ms ';
      else
         l_out_str := l_out_str || 'NEG ms ';
      end if;
   end if;
   if in_message is not null
   then
      l_out_str := l_out_str || in_message  || '. ';
   end if;
   l_out_str := l_out_str || in_assertion || ' - ';
   l_out_str := l_out_str || replace(replace(in_details,CHR(13),'\r'),CHR(10),'\n');
   return l_out_str;
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
      (in_runner_name    in  wt_test_runs.runner_name%TYPE
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_last   in  boolean default FALSE
      ,in_show_pass      in  boolean default FALSE
      ,in_show_aux       in  boolean default FALSE)
is
begin

   for buff in (
      select * from wt_test_runs
       where (runner_name, start_dtm) in (
             select runner_name
                    ,max(start_dtm)        MAX_START_DTM
              from  wt_test_runs
              where (   (    in_runner_name is not null
                        and in_runner_name = runner_name)
                     OR in_runner_name is null  )
               and  runner_owner = USER
              group by runner_name  )  )
   loop

      --  Load Test Run Record
      g_test_runs_rec := buff;

      --  Setup Display Order
      if in_summary_last
      then
        if NOT in_hide_details
         then
            profile_out(in_show_aux);
            results_out(in_show_pass);
         end if;
         summary_out;
      else
         summary_out;
         if NOT in_hide_details
         then
            results_out(in_show_pass);
            profile_out(in_show_aux);
         end if;
      end if;

      p('');

   end loop;

end dbms_out;

------------------------------------------------------------
procedure dbms_out_all
is
begin
   for buff in (select runner_name
                 from  wt_test_runs
                 where runner_owner = USER
                 group by runner_name
                 order by max(start_dtm)
                      ,runner_name)
   loop
      dbms_out(in_runner_name   => buff.runner_name
              ,in_hide_details  => TRUE);
   end loop;
end dbms_out_all;

end wt_text_report;
