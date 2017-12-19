create or replace package wtplsql authid current_user
as

   procedure test_run
      (in_package_name  in  varchar2);

   procedure test_all;

end wtplsql;
