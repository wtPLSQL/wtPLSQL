
--
--  Run Unit Tests with JUnit Report
--
--  Should be run as WTP Schema/User after run_core_test.sql
--

----------------------------------------
prompt
prompt Setup for Unit Tests.
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
execute wt_test_run.delete_hooks;
execute junit_core_report.insert_hooks;

----------------------------------------
prompt
prompt Run and Report Unit Tests.
set verify off
set feedback off
set termout off
spool junit_core_report_show_current.xml
execute wtplsql.test_all;
spool off
set termout on
set feedback on
set verify on

----------------------------------------
prompt
prompt Done with Reports
set linesize 80

EXIT
