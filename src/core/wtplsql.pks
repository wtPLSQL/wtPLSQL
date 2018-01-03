create or replace package wtplsql authid current_user
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   test_runs%ROWTYPE;

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

--  WtPLSQL Procedures
$IF $$WTPLSQL_ENABLE
$THEN
   procedure WTPLSQL_RUN;
$END

end wtplsql;
