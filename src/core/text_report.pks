create or replace package text_report authid current_user
as

   function format_test_result
      (in_assertion      in results.assertion%TYPE
      ,in_status         in results.status%TYPE
      ,in_details        in results.details%TYPE
      ,in_testcase       in results.testcase%TYPE
      ,in_message        in results.message%TYPE)
   return varchar2;

   procedure ad_hoc_result
      (in_assertion      in results.assertion%TYPE
      ,in_status         in results.status%TYPE
      ,in_details        in results.details%TYPE
      ,in_testcase       in results.testcase%TYPE
      ,in_message        in results.message%TYPE);

   procedure dbms_out
      (in_test_run_id    in  number
      ,in_hide_details   in  boolean default FALSE
      ,in_summary_first  in  boolean default FALSE);

end text_report;
