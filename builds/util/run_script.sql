
--
--  Run Generic Script
--
-- Command Line Parameters:
--   1 - SCRIPT_NAME: Name of SQL Script to Run
--

define SCRIPT_NAME="&1."
spool &SCRIPT_NAME..log

set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
set linesize 2499
set trimspool on
set termout on
set verify off
set echo off

show CON_NAME
show USER

----------------------------------------
prompt Setup Continue on Error
WHENEVER SQLERROR CONTINUE
WHENEVER OSERROR CONTINUE

----------------------------------------
prompt Running &SCRIPT_NAME.
set appinfo "Running &SCRIPT_NAME."

----------------------------------------
set blockterminator off
set sqlblanklines on
set timing on
@"&SCRIPT_NAME." "" "" ""
set timing off
set sqlblanklines off
set blockterminator on

----------------------------------------
set appinfo "Null"
set appinfo off
prompt
prompt "&SCRIPT_NAME." is Done.

exit
