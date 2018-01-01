create or replace package result authid current_user
as

   C_PASS  CONSTANT varchar2(10) := 'PASS';
   C_FAIL  CONSTANT varchar2(10) := 'FAIL';

   procedure initialize
      (in_test_run_id   in test_runs.id%TYPE);

   procedure finalize;

   procedure save
      (in_assertion      in results.assertion%TYPE
      ,in_status         in results.status%TYPE
      ,in_details        in results.details%TYPE
      ,in_testcase       in results.testcase%TYPE
      ,in_message        in results.message%TYPE);

end result;
