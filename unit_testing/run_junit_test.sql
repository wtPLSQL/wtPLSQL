
--
--  Run Unit Tests with JUnit Report
--
--  Should be run as WTP Schema/User after run_core_test.sql
--

----------------------------------------
prompt
prompt Initialize Hooks.
execute wt_core_report.delete_hooks;
execute wt_test_run.delete_hooks;
execute junit_core_report.insert_hooks;

----------------------------------------
prompt
prompt Run and Report Unit Tests.
set feedback off
set termout off
spool junit_core_report_show_current.xml
execute wtplsql.test_all;
spool off
set termout on
set feedback on

EXIT
