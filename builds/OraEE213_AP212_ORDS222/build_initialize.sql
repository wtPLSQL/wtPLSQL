
--
--  Base Build Script
--
-- Command Line Parameters:
--   1 - PDB_NAME: Name of the Pluggable Database
--   2 - CDB_SYS: Connect String for SYS in the Container Database
--

WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

define PDB_NAME="&1."
define CDB_SYS="&2."

set linesize 2499
set trimspool on
set termout on
set verify off
set echo off
set timing on

@"../util/new_session.sql" "&CDB_SYS." "" ""
@"../util/create_pdb.sql" "&PDB_NAME."

exit
