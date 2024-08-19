
----------------------------------------
-- Generate Dynamic Test Data

set termout on
prompt Generate Dynamic Test Data...
set termout off
@new_connection_reset.sql &PDB_SYS.

@"&INSTALL_PATH./tdat_gen/install.sql" "&INSTALL_PATH./tdat_gen" "&PDB_SYSTEM."

----------------------------------------
set termout on
prompt Run all wtPLSQL Unit Tests...
set termout off
@new_connection.sql WTP/WTP@&PDB_CONN.

@run_all_wtplsql_tests.sql

@timing_report.sql 'Testing of Unit'

----------------------------------------
-- Show the Services for this PDB
select name from v$services;

----------------------------------------
-- Setup for Reports
connect &PDB_SYSTEM.
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
select 'db: ' || name ||
       ', con: ' || sys_context('USERENV', 'CON_NAME') ||
       ', tstmp: ' || systimestamp
 from  v$database;
set linesize 2499
set trimspool on
set echo off
set verify off
set feedback off

spool off

----------------------------------------
set termout on
prompt Reporting Unit Test Results...
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
set linesize 2499
set trimspool on
set echo off
set verify off
set feedback off
set termout off

spool JUnit_Report_All.xml

begin
   wtp.junit_report_all;
end;
/

spool off
set termout on

----------------------------------------
-- Done with Reports
set linesize 80
set verify on
set feedback on
