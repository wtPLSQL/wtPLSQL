
--
--  Master Installation Script
--
--  Must be run as SYS
--
-- Command Line Parameters:
--   1 - TO_PDB_SYSTEM: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the pluggable database.
--       The Data Load installation requires this connection information.
--

--  NOTE: If running in a Linux based Docker Container from a Windows FileSystem Mount, run this first:
--    dos2unix -f -o ../install/*/*.csv ../install/*/*/*.csv

define TOP_PDB_SYSTEM="&1."
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped

----------------------------------------
prompt Identify this Module in V$SESSION
set appinfo "wtptst Installation"

----------------------------------------
prompt Setup Abort on Error
WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

----------------------------------------
prompt
prompt **************************
prompt *  Run SYS Installation  *
prompt **************************
prompt
@install_sys.sql "" "" ""

----------------------------------------
prompt Setup Continue on Error
WHENEVER SQLERROR CONTINUE
WHENEVER OSERROR CONTINUE

----------------------------------------
prompt
prompt *****************************
prompt *  Run SYSTEM Installation  *
prompt *****************************
prompt
connect &TOP_PDB_SYSTEM.
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped
@install_system.sql "" "" ""

----------------------------------------
prompt
prompt *************************
prompt *  Install Application  *
prompt *************************
prompt
@install_wtptst.sql "&TOP_PDB_SYSTEM." "" ""

----------------------------------------
prompt
prompt *****************
prompt *  Run Reports  *
prompt *****************
prompt
@report_status.sql "&TOP_PDB_SYSTEM." "" ""

----------------------------------------
set appinfo "Null"
set appinfo off
prompt
prompt "wtptst" Installation is Done.

