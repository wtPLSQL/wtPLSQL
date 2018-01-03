create or replace package wtplsql authid current_user
as

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

--  WtPLSQL Procedures
$IF $$WTPLSQL_ENABLE
$THEN
   procedure WTPLSQL_RUN;
$END

end wtplsql;
