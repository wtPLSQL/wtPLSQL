create or replace package wt_persist_report authid definer
as

   --   To report a Test Runner result details:
   -- begin
   --    wt_persist_report.dbms_out('RUNNER_OWNER', 'RUNNER', 30);
   -- end;
   -- /

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

end wt_persist_report;
