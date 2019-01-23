create or replace package wt_core_report
   authid definer
as

   --   To report the latest Test Runner results:
   -- begin
   --    wt_core_report.dbms_out(30, TRUE);
   -- end;
   -- /

   -- Turn this off to allow output across multiple lines of text
   g_single_line_output  boolean := TRUE;

   -- DATE data type format for Report Header
   g_date_format  varchar2(100) := 'DD-Mon-YYYY HH:MI:SS PM';

   procedure dbms_out
      (in_detail_level   in  number   default 0
      ,in_summary_last   in  boolean  default FALSE);
      --  "in_detail_level" settings for DBMS_OUT procedure:
      --  * Less than 10 (including null) - No Detail
      --     * Assertion results summary.
      --  * 10 to 19 - Minimal Detail
      --     * Assertion results summary.
      --     * Failed assertion result details.
      --  * 20 or more - Full Detail
      --     * Assertion results summary.
      --     * All assertion result details.

   procedure ad_hoc_result;

   function format_test_result
      (in_rec  in core_data.results_rec_type)
   return varchar2;

end wt_core_report;