
--
--  Report Status Script
--
--  Must be run as SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--
-- Note: odbcapture_installation_logs table will be created
--   to load installation logs (if not already available).
--

----------------------------------------
prompt
prompt Load Installation Files
@"odbcapture_installation_logs.cldr" "&1."

----------------------------------------
-- Setup for Reports
set linesize 2499
set trimspool on
set echo off
set verify off
set termout on
set serveroutput on size unlimited format wrapped

----------------------------------------
prompt
prompt Reporting Summary of Build Type Log Errors
@"../grb_linked_install_scripts/summarize_install_log.sql" "wtp_gui"

----------------------------------------
prompt
prompt Reorting JUnit XML Installation Log
set feedback off
set termout off
spool log_files_junit_report.xml
@"../grb_linked_install_scripts/log_files_junit_report.sql" "wtp_gui"
spool off
set termout on
set feedback on

----------------------------------------
-- Done with Reports
set linesize 80
set verify on
