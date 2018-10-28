create or replace procedure junit_report_all
is
   procedure p (in_line in varchar2) is
   begin
      DBMS_OUTPUT.PUT_LINE(in_line);
   end p;
begin
   p('<?xml version="1.0" encoding="UTF-8"?>');
   p('<!-- http://dmdiet.com - Adapted to SQLDeveloper Unit Test Utility -->');
   p('<!-- http://nelsonwells.net/2012/09/how-jenkins-ci-parses-and-displays-junit-output/ -->');
   p('<!-- Jenkins identifies the failed tests as {package}.{class}.{test}. -->');
   p('<testsuites>');
   for suites in (
      select tr.start_dtm
            ,tr.end_dtm
            ,tr.id
            ,tr.runner_owner || '.' || tr.runner_name
                                             SUITE_NAME
            ,nvl(tr.dbout_owner, tr.runner_owner)
                                             PACKAGE_NAME
            ,case when tr.dbout_name || tr.dbout_type is null
                  then 'TEST_RUNNER'
                  else tr.dbout_name || ':' || tr.dbout_type
             end                             CLASS_NAME
            ,ts.testcases
            ,ts.failures
            ,extract(day from (tr.end_dtm -
                               tr.start_dtm) * 86400000)
                                             TOT_INTERVAL_MSECS
            ,tr.error_message
       from  wt_test_runs  tr
        left join wt_test_run_stats  ts
                  on  ts.test_run_id = tr.id
       where tr.is_last_run = wtplsql.get_last_run_flag
       order by tr.start_dtm, tr.id )
   loop
      p('  <testsuite name="' || suites.suite_name ||
                  '" tests="' || suites.testcases ||
               '" failures="' || suites.failures ||
                   '" time="' || suites.tot_interval_msecs ||
              '" timestamp="' || to_char(suites.start_dtm,'YYYY-MM-DD"T"HH24:MI:SS.FF3') ||
                                 to_char(systimestamp,'TZH:TZM') ||
                         '">' );
      for cases in (
         select tr.id 
               ,tc.testcase
               ,tc.asserts
               ,tc.failures
               ,nvl(tc.tot_interval_msecs
                   ,suites.tot_interval_msecs) TOT_INTERVAL_MSECS
          from  wt_test_runs  tr
           left join wt_testcase_stats  tc
                     on  tc.test_run_id = tr.id
          where tr.id = suites.id
          order by testcase )
      loop
         if     nvl(cases.failures,1) = 0
            and suites.error_message is null
         then
            p('    <testcase name="' || nvl(cases.testcase,'NULL') ||
                      '" classname="' || suites.suite_name ||
                      '" time="' || cases.tot_interval_msecs || '"/>');
         else
            p('    <testcase name="' || nvl(cases.testcase,'NULL') ||
                      '" classname="' || suites.package_name || '.' || suites.class_name ||
                           '" time="' || cases.tot_interval_msecs || '">');
            p('      <error message="' || nvl(cases.failures,'No') || ' assertion failures. ' ||
                                          suites.error_message || '">');
            -- Print each of the non-passing results
            for asrts in (
               select result_seq
                     ,status
                     ,interval_msecs
                     ,message
                     ,assertion
                     ,details
                from  wt_results
                where test_run_id = suites.id
                 and  (   (cases.testcase is null
                           and   testcase is null)
                       or testcase = cases.testcase)
                 and  status != wt_assert.C_PASS
                order by result_seq )
            loop
               p(lpad(asrts.result_seq,4)     || ': '  ||
                 rpad(asrts.status,4)         || ' '   ||
                 lpad(asrts.interval_msecs,4) || 'ms ' ||
                 asrts.message                ||  '. ' ||
                 asrts.assertion              || ' - ' ||
                 replace(replace(asrts.details
                                ,CHR(13),'\r')
                        ,CHR(10),'\n')        || '.'   );
            end loop;
            p('      </error>');
            p('    </testcase>');
         end if;
      end loop;
   end loop;
   p('  </testsuite>');
   p('</testsuites>');
end junit_report_all;
/
