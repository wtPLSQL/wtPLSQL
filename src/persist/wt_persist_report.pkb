create or replace package body wt_persist_report
as

   g_test_runs_rec       wt_test_runs_vw%ROWTYPE;
   g_dbout_runs_rec      wt_dbout_runs_vw%ROWTYPE;


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
begin
   p('');
   p('    wtPLSQL ' || wtplsql.show_version);
   p('    Run ID ' || g_test_runs_rec.test_run_id ||
              ': ' || to_char(g_test_runs_rec.start_dtm
                             ,wt_core_report.g_date_format));
   p('----------------------------------------');
   p('  Test Results for ' || g_test_runs_rec.test_runner_owner ||
                       '.' || g_test_runs_rec.test_runner_name  );
   p('  Minimum Elapsed msec: ' || to_char(g_test_runs_rec.asrt_min_msec, '9999999') ||
     '      Total Assertions: ' || to_char(g_test_runs_rec.asrt_cnt,      '9999999') );
   p('  Average Elapsed msec: ' || to_char(g_test_runs_rec.asrt_avg_msec, '9999999') ||
     '       Total Testcases: ' || to_char(g_test_runs_rec.tc_cnt,        '9999999') );
   p('  Maximum Elapsed msec: ' || to_char(g_test_runs_rec.asrt_max_msec, '9999999') ||
     '      Failed Testcases: ' || to_char(g_test_runs_rec.tc_fail,       '9999999') );
   p('  Total Run Time (sec): ' || to_char(g_test_runs_rec.runner_sec,    '99990.9') ||
     '        Testcase Yield: ' || to_char(g_test_runs_rec.tc_yield_pct,  '99990.9') || '%');
   if     g_dbout_runs_rec.dbout_name is not null
      AND g_dbout_runs_rec.profiler_runid is null
   then
      p('');
      p('  Note: ' || g_dbout_runs_rec.dbout_type  || ' ' ||
                      g_dbout_runs_rec.dbout_owner || '.' ||
                      g_dbout_runs_rec.dbout_name  || ' was not profiled.');
   end if;
   if g_test_runs_rec.error_message is not null
   then
      p('');
      p('  *** Test Runner Error ***');
      p(g_test_runs_rec.error_message);
   end if;
   ----------------------------------------
   if g_dbout_runs_rec.profiler_runid is null
   then
      return;
   end if;
   p('');
   p('  Code Coverage for ' || g_dbout_runs_rec.dbout_type  ||
                        ' ' || g_dbout_runs_rec.dbout_owner ||
                        '.' || g_dbout_runs_rec.dbout_name  );
   p('          Ignored Lines: ' || to_char(g_dbout_runs_rec.ignored_lines,  '9999999') ||
     '   Total Profiled Lines: ' || to_char(g_dbout_runs_rec.profiled_lines, '9999999') );
   p('         Excluded Lines: ' || to_char(g_dbout_runs_rec.excluded_lines, '9999999') ||
     '   Total Executed Lines: ' || to_char(g_dbout_runs_rec.executed_lines, '9999999') );
   p('  Minimum LineExec usec: ' || to_char(g_dbout_runs_rec.exec_min_usec,  '9999999') ||
     '     Not Executed Lines: ' || to_char(g_dbout_runs_rec.notexec_lines,  '9999999') );
   p('  Average LineExec usec: ' || to_char(g_dbout_runs_rec.exec_avg_usec,  '9999999') ||
     '          Unknown Lines: ' || to_char(g_dbout_runs_rec.unknown_lines,  '9999999') );
   p('  Maximum LineExec usec: ' || to_char(g_dbout_runs_rec.exec_max_usec,  '9999999') ||
     '          Code Coverage: ' || to_char(g_dbout_runs_rec.coverage_pct,   '99990.9') || '%');
   p('  Trigger Source Offset: ' || to_char(g_dbout_runs_rec.trigger_offset, '9999999') );
end summary_out;

------------------------------------------------------------
procedure results_out
      (in_show_pass  in boolean)
is
   l_rec            core_data.results_rec_type;
   l_show_pass_txt  varchar2(1);
   old_testcase     core_data.long_name;
   show_header      boolean := TRUE;
begin
   if in_show_pass
   then
      l_show_pass_txt := 'Y';
   else
      l_show_pass_txt := 'N';
   end if;
   for buff in (
      select * from wt_results_vw
       where test_run_id = g_test_runs_rec.test_run_id
       and  (   l_show_pass_txt = 'Y'
             or status         != 'PASS')
       order by result_seq )
   loop
      -- Load l_rec
      l_rec.assertion      := buff.assertion;
      l_rec.pass           := (buff.status = 'PASS');
      l_rec.details        := buff.details;
      l_rec.testcase       := buff.testcase;
      l_rec.message        := buff.message;
      l_rec.interval_msec  := buff.interval_msec;
      -- Remove Consecutive Testcases
      if l_rec.testcase = old_testcase
      then
         l_rec.testcase := '';
      else
         old_testcase := l_rec.testcase;
      end if;
      -- Display header if needed
      if show_header
      then
         p('');
         p(' - ' || g_test_runs_rec.test_runner_owner  ||
             '.' || g_test_runs_rec.test_runner_name   || 
             ' Test Result Details (Test Run ID '      ||
                    g_test_runs_rec.test_run_id        ||
             ')' );
         p('-----------------------------------------------------------');
         show_header := FALSE;
      end if;
      -- Display the result
      p(wt_core_report.format_test_result(l_rec));
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
     p(' - ' || g_dbout_runs_rec.dbout_owner     ||
         '.' || g_dbout_runs_rec.dbout_name      ||
         ' ' || g_dbout_runs_rec.dbout_type      ||
         ' Code Coverage Details (Test Run ID '  ||
                g_dbout_runs_rec.test_run_id     ||
         ')' );
   end l_show_header;
begin
   if g_dbout_runs_rec.profiler_runid is null
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
            ,exec_cnt
            ,exec_tot_usec
            ,exec_min_usec
            ,exec_max_usec
            ,text
            ,rownum
       from  wt_profiles
       where test_run_id = g_dbout_runs_rec.test_run_id
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
      p(to_char(buff.line,'99999')             ||
        case buff.status when 'NOTX' then '#NOTX#'
        else ' ' || rpad(buff.status,4) || ' '
        end                                    ||
        to_char(buff.exec_cnt,'99999')         || ' ' ||
        to_char(buff.exec_tot_usec,'99999999') || ' ' ||
        to_char(buff.exec_min_usec,'999999')   || ' ' ||
        to_char(buff.exec_max_usec,'99999999') || ' ' ||
        replace(buff.text,CHR(10),'')          );
   end loop;
end profile_out;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure dbms_out
      (in_runner_owner   in  varchar2   default USER
      ,in_runner_name    in  varchar2   default null
      ,in_detail_level   in  number     default 0
      ,in_summary_last   in  boolean    default FALSE)
is

   g_dbout_runs_recNULL   wt_dbout_runs_vw%ROWTYPE;

begin

   for buff in (
      -- MAX(t2.start_dtm) is a fail-safe if IS_LAST_RUN is not set.
      select * from wt_test_runs_vw
       where (          test_runner_name,        start_dtm) in
             (select t2.test_runner_name, max(t2.start_dtm)
               from  wt_test_runs_vw  t2
               where (   (    in_runner_name is not null
                          and in_runner_name = t2.test_runner_name)
                      OR in_runner_name is null  )
                and  t2.test_runner_owner = in_runner_owner
               group by t2.test_runner_name )
       order by start_dtm, test_runner_name )
   loop

      --  Load Test Run Record
      g_test_runs_rec := buff;

      --  Load the DBOUT Record
      begin
         select * into g_dbout_runs_rec
          from  wt_dbout_runs_vw
          where test_run_id = buff.test_run_id;
      exception when NO_DATA_FOUND
      then
         g_dbout_runs_rec := g_dbout_runs_recNULL;
      end;

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


end wt_persist_report;
