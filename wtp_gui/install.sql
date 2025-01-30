
--
--  APEX GUI Installation Script
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

----------------------------------------
prompt Identify this Module in V$SESSION
set appinfo "wtp_gui Installation"
set serveroutput on size unlimited format wrapped

----------------------------------------
prompt Setup Abort on Error
WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

-- Install APEX Workspace
spool WTP_workspace
@WTP_workspace.sql

-- Install APEX Application
spool f700
@f700.sql

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
prompt "wtp_gui" Installation is Done.
