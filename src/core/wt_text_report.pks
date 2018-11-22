create or replace package wt_text_report
   authid definer
as

   g_run_rec  core_data.run_rec_type;

   --   To report the latest result details for test runner:
   -- begin
   --    wt_text_report.dbms_out('TEST_RUNNER', FALSE, FALSE, TRUE, TRUE);
   -- end;
   -- /

   -- Turn this off to allow output across multiple lines of text
   g_single_line_output  boolean := TRUE;

   -- DATE data type format for Report Header
   g_date_format  varchar2(100) := 'DD-Mon-YYYY HH:MI:SS PM';

   procedure dbms_out
      (in_detail_level   in  number   default 0
      ,in_summary_last   in  boolean  default FALSE);

   procedure ad_hoc_result;

   procedure show_result_header;

   function format_test_result
      (in_rec  in core_data.results_rec_type)
   return varchar2;

end wt_text_report;