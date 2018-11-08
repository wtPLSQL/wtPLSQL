create or replace package wt_result authid definer
as

   procedure initialize
      (in_test_run_id   in wt_test_runs.id%TYPE);

   procedure finalize;

   procedure save
      (in_assertion      in varchar2
      ,in_status         in varchar2
      ,in_details        in varchar2
      ,in_testcase_name  in varchar2
      ,in_message        in varchar2);

   procedure delete_records
      (in_test_run_id  in number);

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_result;
