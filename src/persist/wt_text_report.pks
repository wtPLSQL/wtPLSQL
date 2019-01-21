create or replace package wt_text_report authid definer
as

   --   To report the latest result details for test runner:
   -- begin
   --    wt_text_report.dbms_out('RUNNER_OWNER', 'RUNNER', 30);
   -- end;
   -- /

   -- Turn this off to allow output across multiple lines of text
   g_single_line_output  boolean := TRUE;

   -- DATE data type format for Report Header
   g_date_format  varchar2(100) := 'DD-Mon-YYYY HH:MI:SS PM';

   function format_test_result
      (in_assertion      in varchar2
      ,in_status         in varchar2
      ,in_details        in varchar2
      ,in_testcase_name  in varchar2
      ,in_message        in varchar2
      ,in_interval_msecs in number)
   return varchar2;

--  "in_detail_level" settings for DBMS_OUT procedure:
--  * Less than 10 (including null) - No Detail
--     * Assertion results summary.
--     * Profiled lines summary.
--  * 10 to 19 - Minimal Detail
--     * Assertion results summary.
--     * Profiled lines summary.
--     * Failed assertion result details.
--     * Profiled source lines that were "not executed".
--  * 20 to 29 - Partial Full Detail
--     * Assertion results summary.
--     * Profiled lines summary.
--     * All assertion result details.
--     * Profiled source lines that were "not executed".
--  * 30 or more - Full Detail
--     * Assertion results summary.
--     * Profiled lines summary.
--     * All assertion result details.
--     * All profiled source lines.

   procedure dbms_out
      (in_runner_owner   in  varchar2  default USER
      ,in_runner_name    in  varchar2  default null
      ,in_detail_level   in  number    default 0
      ,in_summary_last   in  boolean   default FALSE);

end wt_text_report;
