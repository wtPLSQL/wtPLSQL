create or replace package wtplsql authid current_user
as

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

--  WtPLSQL Procedures
$IF $$WTPLSQL_ENABLE
$THEN
   p_test_runs_rec   test_runs%ROWTYPE;
   procedure wtplsql_setup
      (in_package_name  in  varchar2);
   procedure wtplsql_teardown
      (in_package_name  in  varchar2);
   procedure testcase1;
   procedure testcase3;
   procedure WTPLSQL_RUN;
$END

end wtplsql;
