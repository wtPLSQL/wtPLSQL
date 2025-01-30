
--
--  Initialize Database for Build
--
-- Command Line Parameters:
--   1 - PDB_NAME: Name of the Pluggable Database
--

WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT

define PDB_NAME="&1."

set linesize 2499
set trimspool on
set termout on
set verify off
set echo off
set timing on

set serveroutput on size unlimited format wrapped
select 'user: ' || u.username ||
       ', db: ' || d.name ||
       ', con: ' || sys_context('USERENV', 'CON_NAME') ||
       ', tstmp: ' || systimestamp   CONNECTION
 from  v$database d
 cross join user_users u;

@"../util/create_pdb.sql" "&PDB_NAME." "" ""

exit
