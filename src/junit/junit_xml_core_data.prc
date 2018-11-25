create or replace procedure junit_xml_core_data
is
   l_rec             core_data.results_rec_type;
   l_testcase        core_data.long_name;
   single_line_save  boolean;
   -- Print to DBMS_OUTPUT
   procedure p (in_line in varchar2) is begin
      DBMS_OUTPUT.PUT_LINE(in_line);
   end p;
   -- XML Escape
   function xe (in_txt in varchar2) return varchar2 is begin
      return replace
                (replace
                   (replace
                      (replace
                         (replace
                            (in_txt
                            ,'<','&lt;')  -- Less Than
                         ,'>','&gt;')  -- Greater Than
                      ,'&','&amp;')  -- Ampersand
                   ,'''','&apos;')  -- Apostrophe
                ,'"','&quot;');  -- Quotation Mark
   end xe;
begin
   single_line_save := wt_text_report.g_single_line_output;
   wt_text_report.g_single_line_output := TRUE;
   p('<?xml version="1.0" encoding="UTF-8"?>');
   p('<!-- https://stackoverflow.com/questions/4922867/what-is-the-junit-xml-format-specification-that-hudson-supports -->');
   p('<!-- http://nelsonwells.net/2012/09/how-jenkins-ci-parses-and-displays-junit-output -->');
   p('<!-- Jenkins identifies the failed tests as {package}.{class}.{testcase}. -->');
   p('<testsuites>');
   if core_data.g_tcases_aa.COUNT > 0
   then
      ---------------------
      --  Test Suite Header
      p('  <testsuite name="' ||      xe(core_data.g_run_rec.runner_owner)     ||
                          '.' ||      xe(core_data.g_run_rec.runner_name)      ||
                  '" tests="' ||         core_data.g_run_rec.tc_cnt            ||
               '" failures="' ||         core_data.g_run_rec.tc_fail           ||
                   '" time="' ||         core_data.g_run_rec.runner_sec        ||
              '" timestamp="' || to_char(core_data.g_run_rec.start_dtm
                                        ,'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM') ||
                         '">' );
      l_testcase := core_data.g_tcases_aa.FIRST;
      loop
         --------------------
         --  Test Case Header
         p('    <testcase name="' || xe(l_testcase)                                     ||
                  '" classname="' || xe(core_data.g_run_rec.dbout_owner)                ||
                              '.' || xe(core_data.g_run_rec.dbout_name)                 ||
                              ':' || xe(replace(core_data.g_run_rec.dbout_type,' ','_'))||
                       '" time="' ||    core_data.g_tcases_aa(l_testcase).asrt_tot_msec ||
                             '">' );
         if    core_data.g_tcases_aa(l_testcase).asrt_fail > 0
            or (    core_data.g_run_rec.error_message is not null
                and l_testcase = core_data.g_results_nt(core_data.g_results_nt.COUNT).testcase)
         then
            -----------------------
            --  Short Error Message
            if     core_data.g_run_rec.error_message is not null
               and l_testcase = core_data.g_results_nt(core_data.g_results_nt.COUNT).testcase
            then
               p('      <error message="' || xe(replace
                                                  (replace
                                                     (substr(core_data.g_run_rec.error_message
                                                            ,1,60)
                                                     ,CHR(10),' ')
                                               ,CHR(13),'')) ||
                                     '">' );
            else
               p('      <error message="' || core_data.g_tcases_aa(l_testcase).asrt_fail ||
                 ' assertion failures.">' );
            end if;
            p('         <![CDATA[');
            ---------------------
            --  Print all results
            for i in 1 .. core_data.g_results_nt.COUNT
            loop
               if core_data.g_results_nt(i).testcase = l_testcase
               then
                  l_rec := core_data.g_results_nt(i);
                  l_rec.testcase := '';
                  p(wt_text_report.format_test_result(l_rec));
               end if;
            end loop;
            ----------------------
            --  Long Error Message
            if     core_data.g_run_rec.error_message is not null
               and l_testcase = core_data.g_results_nt(core_data.g_results_nt.COUNT).testcase
            then
               p(' ----');
               p(core_data.g_run_rec.error_message);
            end if;
            ----------------------
            p('         ]]>');
            p('      </error>');
            -----------------------
         end if;
         p('    </testcase>');
         --------------------
         exit when l_testcase = core_data.g_tcases_aa.LAST;
         l_testcase := core_data.g_tcases_aa.NEXT(l_testcase);
      end loop;
      p('  </testsuite>');
      ---------------------
   end if;
   p('</testsuites>');
   wt_text_report.g_single_line_output := single_line_save;
end junit_xml_core_data;
/
