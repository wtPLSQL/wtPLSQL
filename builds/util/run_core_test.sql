
--
--  Run Core Unit Test
--
--  Should be run as WTP Schema/User after installation
--

----------------------------------------
--  Should be default Installation Settings
--prompt
--prompt Initialize Hooks.
--execute wt_test_run.delete_hooks;
--execute junit_core_report.delete_hooks;
--execute wt_core_report.insert_hooks;

----------------------------------------
prompt
prompt Run Unit Test and Report.
set feedback off
set termout off
spool wt_core_report_dbms_out.log
execute wtplsql.test_all;
spool off
set termout on
set feedback on

EXIT
