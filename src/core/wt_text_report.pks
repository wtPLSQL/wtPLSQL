create or replace package wt_text_report authid current_user
as

   function format_test_result
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE)
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
      ,in_summary_first  in  boolean default FALSE
      ,in_show_pass      in  boolean default FALSE
      ,in_show_aux       in  boolean default FALSE);

end wt_text_report;
