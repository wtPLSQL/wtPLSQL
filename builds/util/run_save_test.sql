
--
--  Run Unit Test with Peristence
--

----------------------------------------
prompt
prompt Reporting Unit Test Results...
set termout on
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
set linesize 2499
set trimspool on
set echo off

----------------------------------------
prompt
prompt Initialize Hooks.
execute wt_core_report.delete_hooks;
execute junit_core_report.delete_hooks;
execute wt_test_run.insert_hooks;

----------------------------------------
prompt
prompt Run Unit Tests and Report.
set verify off
set feedback off
set termout off
spool wt_persist_report_dbms_out.log
execute wtplsql.test_all;
execute wt_persist_report.dbms_out(in_detail_level => 10);
spool off
set termout on
set feedback on
set verify on

----------------------------------------
prompt
prompt JUnit Report Unit Tests.
set verify off
set feedback off
set termout off
spool junit_xml_persiste_all.xml
execute junit_xml_persist_all;
spool off
set termout on
set feedback on
set verify on

----------------------------------------
prompt
prompt Done with Reports
set linesize 80
