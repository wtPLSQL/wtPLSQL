
--
--  JUnit Core Report Installation
--

--
-- NOTE: Must be run using "wtPLSQL.test_all".
--       "wtPLSQL.test_run" will not provide
--       a complete JUnit XML document.
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
   values ('before_test_all', 20, 'begin junit_core_report.before_test_all; end;');
update hooks set run_string = 'begin junit_core_report.show_current; end;'
 where hook_name = 'after_test_run'
  and  run_string = 'begin wt_text_report.dbms_out(10); end;';
insert into hooks (hook_name, seq, run_string)
   values ('after_test_all', 20, 'begin junit_core_report.after_test_all; end;');
commit;
begin
   hook.init;
end;
/

spool off
