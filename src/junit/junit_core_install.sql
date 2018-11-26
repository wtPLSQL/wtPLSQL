
--
--  JUnit Core Report Installation
--

-- Capture output
spool junit_core_install

-- Connect as SCHEMA_OWNER
connect &schema_owner./&schema_owner.&connect_string.
set serveroutput on size unlimited format truncated

-- Shared Setup Script
@../common_setup.sql

-- Install Packages
@junit_core_report.pks
@junit_core_report.pkb

-- Install Hooks
insert into hooks (hook_name, seq, run_string)
   values ('before_test_all', 1, 'begin junit_core_report.before_test_all; end;');
update hooks set run_string = 'begin junit_core_report.show_current; end;'
 where hook_name = 'after_test_run' and seq = 1;
insert into hooks (hook_name, seq, run_string)
   values ('after_test_all', 1, 'begin junit_core_report.after_test_all; end;');
commit;
begin
   hook.init;
end;
/

spool off
