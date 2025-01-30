
--
--  Run Unit Test with Peristence
--

----------------------------------------
prompt
prompt Initialize Hooks.
execute wt_core_report.delete_hooks;
execute junit_core_report.delete_hooks;
execute wt_test_run.insert_hooks;

----------------------------------------
prompt
prompt Run Unit Tests and Report.
set feedback off
set termout off
spool wt_persist_report_dbms_out.log
execute wtplsql.test_all;
execute wt_persist_report.dbms_out(in_detail_level => 10);
spool off
set termout on
set feedback on

----------------------------------------
prompt
prompt JUnit Report Unit Tests.
set feedback off
set termout off
spool junit_xml_persist_all.xml
execute junit_xml_persist_all;
spool off
set termout on
set feedback on

EXIT
