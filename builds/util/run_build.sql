
--
--  Data Build Script
--
-- Command Line Parameters:
--   1 - BUTIL_PATH: Path to Build Utility Scripts
--   2 - PDB_SYS: Connect String for SYS in the Pluggable Database
--   3 - PDB_SYSTEM: Connect String for SYSTEM in the Pluggable Database
--   4 - PDB_PASSKEY: Part of the User/Schema Password Authentication
--   5 - INSTALL_TYPE: Installation Type
--   6 - APP_VERSION: Version for this application installation
--

WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

define BUTIL_PATH="&1."
define PDB_SYS="&2."
define PDB_SYSTEM="&3."
define PDB_PASSKEY="&4."
define INSTALL_TYPE="&5."
define APP_VERSION="&6."

set linesize 2499
set trimspool on
set termout on
set verify off
set echo off
set timing on
@"&BUTIL_PATH./new_session.sql" "&PDB_SYS." "" ""
set timing off
@"install.sql" "&PDB_SYSTEM." "" ""

begin
   if '&INSTALL_TYPE.' like 'wtp%'
   then
      insert into WTP.wt_versions (component, version, action)
         values ('&INSTALL_TYPE.', '&APP_VERSION.', 'INSTALL');
      commit;
   end if;
end;
/

set linesize 123
set trimspool on
set termout on
set verify off
set echo off
set timing on
@"&BUTIL_PATH./new_session.sql" "&PDB_SYSTEM." "" ""
set timing off
@"set_user_authentication.sql" "&PDB_PASSKEY." "" ""

exit
