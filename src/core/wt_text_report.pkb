create or replace package body wt_text_report
as

   g_test_runs_rec       wt_test_runs%ROWTYPE;
   g_test_run_stats_rec  wt_test_run_stats%ROWTYPE;


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
   p('       Total Test Cases: ' || to_char(nvl(g_test_run_stats_rec.testcases         ,0),'9999999') ||
     '       Total Assertions: ' || to_char(nvl(g_test_run_stats_rec.asserts           ,0),'9999999') );
   p('  Minimum Interval msec: ' || to_char(nvl(g_test_run_stats_rec.min_interval_msecs,0),'9999999') ||
     '      Failed Assertions: ' || to_char(nvl(g_test_run_stats_rec.failures          ,0),'9999999') );
   p('  Average Interval msec: ' || to_char(nvl(g_test_run_stats_rec.avg_interval_msecs,0),'9999999') ||
     '       Error Assertions: ' || to_char(nvl(g_test_run_stats_rec.errors            ,0),'9999999') );
   p('  Maximum Interval msec: ' || to_char(nvl(g_test_run_stats_rec.max_interval_msecs,0),'9999999') ||
     '             Test Yield: ' || to_char(    g_test_run_stats_rec.test_yield * 100     ,'9990.99') ||
                                                                                                  '%' );
   p('   Total Run Time (sec): ' || to_char(extract(day from (g_test_runs_rec.end_dtm -
                                                g_test_runs_rec.start_dtm)*86400*100)/100 ,'99990.9') );
end result_summary;

------------------------------------------------------------
procedure profile_summary
is
begin
   p('          Ignored Lines: ' || to_char(nvl(g_test_run_stats_rec.ignored_lines     ,0),'9999999') ||
     '   Total Profiled Lines: ' || to_char(nvl(g_test_run_stats_rec.profiled_lines    ,0),'9999999') );
   p('         Excluded Lines: ' || to_char(nvl(g_test_run_stats_rec.excluded_lines    ,0),'9999999') ||
     '   Total Executed Lines: ' || to_char(nvl(g_test_run_stats_rec.executed_lines    ,0),'9999999') );
   p('  Minimum LineExec usec: ' || to_char(nvl(g_test_run_stats_rec.min_executed_usecs,0),'9999999') ||
     '     Not Executed Lines: ' || to_char(nvl(g_test_run_stats_rec.notexec_lines     ,0),'9999999') );
   p('  Average LineExec usec: ' || to_char(nvl(g_test_run_stats_rec.avg_executed_usecs,0),'9999999') ||
     '          Unknown Lines: ' || to_char(nvl(g_test_run_stats_rec.unknown_lines     ,0),'9999999') );
   p('  Maximum LineExec usec: ' || to_char(nvl(g_test_run_stats_rec.max_executed_usecs,0),'9999999') ||
     '          Code Coverage: ' || to_char(    g_test_run_stats_rec.code_coverage * 100  ,'9990.99') ||
                                                                                                  '%' );
   p('  Trigger Source Offset: ' || to_char(    g_test_runs_rec.trigger_offset            ,'9999999') );
end profile_summary;

------------------------------------------------------------
procedure summary_out
is
begin
   p('');
   p('    wtPLSQL ' || wtplsql.show_version ||
       ' - Run ID ' || g_test_runs_rec.id   ||
               ': ' || to_char(g_test_runs_rec.start_dtm, g_date_format) ||
            CHR(10) );
   p('  Test Results for ' || g_test_runs_rec.runner_owner ||
                       '.' || g_test_runs_rec.runner_name  );
   result_summary;
   if     g_test_runs_rec.dbout_name is not null
      AND g_test_runs_rec.profiler_runid is null
   then
      p('');
      p('  Note: ' || g_test_runs_rec.dbout_type  || ' ' ||
                      g_test_runs_rec.dbout_owner || '.' ||
                      g_test_runs_rec.dbout_name  || ' was not profiled.');
   end if;
   if g_test_runs_rec.error_message is not null
   then
      p('');
      p('  *** Test Runner Error ***');
      p(g_test_runs_rec.error_message);
   end if;
   ----------------------------------------
   if g_test_runs_rec.profiler_runid is null
   then
      return;
   end if;
   p('');
   p('  Code Coverage for ' || g_test_runs_rec.dbout_type  ||
                        ' ' || g_test_runs_rec.dbout_owner ||
                        '.' || g_test_runs_rec.dbout_name  );
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
      p(' - ' || g_test_runs_rec.runner_owner  ||
          '.' || g_test_runs_rec.runner_name   || 
          ' Test Result Details (Test Run ID ' ||
                 g_test_runs_rec.id            ||
          ')' );
      p('-----------------------------------------------------------');
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
            ,interval_msecs
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
                        (in_assertion       => buff.assertion
                        ,in_status          => buff.status
                        ,in_details         => buff.details
                        ,in_testcase        => NULL
                        ,in_message         => buff.message
                        ,in_interval_msecs  => buff.interval_msecs) );
      else
         p(format_test_result
                        (in_assertion       => buff.assertion
                        ,in_status          => buff.status
                        ,in_details         => buff.details
                        ,in_testcase        => buff.testcase
                        ,in_message         => buff.message
                        ,in_interval_msecs  => buff.interval_msecs) );
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
     p(' - ' || g_test_runs_rec.dbout_owner     ||
         '.' || g_test_runs_rec.dbout_name      ||
         ' ' || g_test_runs_rec.dbout_type      ||
         ' Code Coverage Details (Test Run ID ' ||
                g_test_runs_rec.id              ||
         ')' );
   end l_show_header;
begin
   if g_test_runs_rec.profiler_runid is null
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
            ,total_usecs
            ,min_usecs
            ,max_usecs
            ,text
            ,rownum
       from  wt_dbout_profiles
       where test_run_id = g_test_runs_rec.id
       and  (   l_show_aux_txt = 'Y'
             or status not in ('EXEC','IGNR','UNKN','EXCL'))
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
      p(to_char(buff.line,'99999') ||
        case buff.status when 'NOTX' then '#NOTX#'
        else ' ' || rpad(buff.status,4) || ' '
        end                                  ||
        to_char(buff.total_occur,'99999')    || ' ' ||
        to_char(buff.total_usecs,'99999999') || ' ' ||
        to_char(buff.min_usecs,'999999')     || ' ' ||
        to_char(buff.max_usecs,'99999999')   || ' ' ||
        replace(buff.text,CHR(10),'')            );
   end loop;
end profile_out;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function format_test_result
      (in_assertion       in wt_results.assertion%TYPE
      ,in_status          in wt_results.status%TYPE
      ,in_details         in wt_results.details%TYPE
      ,in_testcase        in wt_results.testcase%TYPE
      ,in_message         in wt_results.message%TYPE
      ,in_interval_msecs  in wt_results.interval_msecs%TYPE DEFAULT NULL)
   return varchar2
is
   l_out_str  varchar2(32000) := '';
begin
   if in_testcase is not null
   then
      l_out_str := ' ---- Test Case: ' || in_testcase || CHR(10);
   end if;
   if in_status = wt_assert.C_PASS
   then
      l_out_str := l_out_str || ' ' || rpad(in_status,4) || ' ';
   else
      l_out_str := l_out_str || '#' || rpad(in_status,4) || '#';
   end if;
   if in_interval_msecs is not null
   then
      l_out_str := l_out_str || lpad(in_interval_msecs,4) || 'ms ';
   end if;
   if in_message is not null
   then
      l_out_str := l_out_str || in_message  || '. ';
   end if;
   l_out_str := l_out_str || in_assertion || ' - ';
   if g_single_line_output
   then
      l_out_str := l_out_str || replace(replace(in_details,CHR(13),'\r'),CHR(10),'\n');
   else
      l_out_str := l_out_str || in_details;
   end if;
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
      (in_runner_owner   in  wt_test_runs.runner_owner%TYPE default USER
      ,in_runner_name    in  wt_test_runs.runner_name%TYPE  default null
      ,in_detail_level   in  number                         default 0
      ,in_summary_last   in  boolean                        default FALSE)
is

   cursor c_main(in_test_run_id  in number) is
      select * from wt_test_run_stats
       where test_run_id = in_test_run_id;
   g_test_run_statsNULL   wt_test_run_stats%ROWTYPE;

begin

   for buff in (
      select * from wt_test_runs
       where (          runner_name,        start_dtm) in
             (select t2.runner_name, max(t2.start_dtm)
               from  wt_test_runs  t2
               where (   (    in_runner_name is not null
                          and in_runner_name = t2.runner_name)
                      OR in_runner_name is null  )
                and  t2.runner_owner = in_runner_owner
               group by t2.runner_name )
       order by start_dtm, runner_name )
   loop

      --  Load Test Run Record
      g_test_runs_rec := buff;

      --  Load the Stats Record
      g_test_run_stats_rec := g_test_run_statsNULL;
      open c_main(buff.id);
      fetch c_main into g_test_run_stats_rec;
      close c_main;

      --  Setup Display Order
      if in_summary_last
      then
        if in_detail_level >= 10
         then
            profile_out(in_detail_level >= 30);
            results_out(in_detail_level >= 20);
         end if;
         summary_out;
      else
         summary_out;
         if in_detail_level >= 10
         then
            results_out(in_detail_level >= 20);
            profile_out(in_detail_level >= 30);
         end if;
      end if;

      p('');

   end loop;

end dbms_out;


end wt_text_report;
