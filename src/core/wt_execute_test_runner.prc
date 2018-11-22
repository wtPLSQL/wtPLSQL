create or replace procedure wt_execute_test_runner
   authid current_user
   -- AUTHID CURRENT_USER is required for assertions with
   --   dynamic PL/SQL execution.
is
   sql_txt  varchar2(4000);
begin
   sql_txt := 'begin "' || core_data.g_run_rec.runner_owner ||
                  '"."' || core_data.g_run_rec.runner_name  ||
                   '".' || wtplsql.C_RUNNER_ENTRY_POINT     || '; end;';
   --dbms_output.put_line(sql_txt);
   execute immediate sql_txt;
end wt_execute_test_runner;
/
