
--
--  Data Build Script
--
-- Command Line Parameters:
--   1 - PDB_SYSTEM: Connect String for SYSTEM in the Pluggable Database
--   2 - PDB_PASSKEY: Part of the User/Schema Password Authentication
--

WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

define PDB_SYSTEM="&1."
define PDB_PASSKEY="&2."

set linesize 2499
set trimspool on
set termout on
set verify off
set echo off
set timing off

@"install.sql" "&PDB_SYSTEM."

set linesize 123
set trimspool on
set termout on
set verify off
set echo off
set timing on

connect &PDB_SYSTEM.
set serveroutput on size unlimited format wrapped
select 'user: ' || u.username ||
       ', db: ' || d.name ||
       ', con: ' || sys_context('USERENV', 'CON_NAME') ||
       ', tstmp: ' || systimestamp   CONNECTION
 from  v$database d
 cross join user_users u;

set timing off

@"set_user_authentication.sql" "&PDB_PASSKEY."

exit
