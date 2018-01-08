create or replace package wt_result authid current_user
as

   C_PASS  CONSTANT varchar2(10) := 'PASS';
   C_FAIL  CONSTANT varchar2(10) := 'FAIL';

   procedure initialize
      (in_test_run_id   in wt_test_runs.id%TYPE);

   procedure finalize;

   procedure save
      (in_assertion      in wt_results.assertion%TYPE
      ,in_status         in wt_results.status%TYPE
      ,in_details        in wt_results.details%TYPE
      ,in_testcase       in wt_results.testcase%TYPE
      ,in_message        in wt_results.message%TYPE);

   procedure delete_records
      (in_test_run_id  in number);

end wt_result;
