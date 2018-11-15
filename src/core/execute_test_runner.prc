create or replace procedure execute_test_runner
      (in_str  in  varchar2)
   authid current_user
   -- AUTHID CURRENT_USER is required for dynamic PL/SQL execution.
is
begin
   execute immediate in_str;
end execute_test_runner;
