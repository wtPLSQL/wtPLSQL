
--
--  Data Build Script
--
-- Command Line Parameters:
--   1 - BUTIL_PATH: Path to Build Utility Scripts
--   2 - PDB_SYS: Connect String for SYS in the Pluggable Database
--   3 - PDB_SYSTEM: Connect String for SYSTEM in the Pluggable Database
--

WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

define BUTIL_PATH="&1."
define PDB_SYS="&2."
define PDB_SYSTEM="&3."

set linesize 2499
set trimspool on
set termout on
set verify off
set echo off
set timing on

@"&BUTIL_PATH./new_session.sql" "&PDB_SYS." "" ""
set timing off
@"install.sql" "&PDB_SYSTEM." "" ""
--@"&BUTIL_PATH./fix_invalid_public_synonyms.sql"

exit
