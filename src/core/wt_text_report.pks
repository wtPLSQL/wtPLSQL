create or replace package wt_text_report
   authid definer
as

   g_test_runs_rec  wt_test_runs%ROWTYPE;

   --   To report the latest result details for test runner:
   -- begin
   --    wt_text_report.dbms_out('TEST_RUNNER', FALSE, FALSE, TRUE, TRUE);
   -- end;
   -- /

   -- Turn this off to allow output across multiple lines of text
   g_single_line_output  boolean := TRUE;

   -- DATE data type format for Report Header
   g_date_format  varchar2(100) := 'DD-Mon-YYYY HH:MI:SS PM';

   function format_test_result
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE
      ,in_elapsed_msecs  in wt_results.elapsed_msecs%TYPE DEFAULT NULL)
   return varchar2;

   procedure ad_hoc_result
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE);

   procedure dbms_out
      (in_runner_name    in  wt_test_runs.runner_name%TYPE
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_last   in  boolean default FALSE
      ,in_show_pass      in  boolean default FALSE
      ,in_show_aux       in  boolean default FALSE);

   procedure dbms_out_all;

end wt_text_report;