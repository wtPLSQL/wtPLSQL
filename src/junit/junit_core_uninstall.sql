
--
--  JUnit Core Report Un-Install
--

-- Capture output
spool junit_core_uninstall

-- Shared Setup Script
@../common_setup.sql

-- Connect as SCHEMA_OWNER
connect &schema_owner./&schema_owner.&connect_string.
set serveroutput on size unlimited format truncated

-- Un-Install Hooks
delete from hooks
 where hook_name  = 'before_test_all'
  and  seq        = 1
  and  run_string = 'begin junit_core_report.before_test_all; end;';
update hooks set run_string = 'begin wt_text_report.dbms_out(10); end;'
 where hook_name = 'after_test_run' and seq = 1;
delete from hooks
 where hook_name  = 'after_test_all'
  and  seq        = 1
  and  run_string = 'begin junit_core_report.after_test_all; end;';
commit;
begin
   hook.init;
end;
/

-- Un-Install Package
drop package junit_core_report;

spool off
