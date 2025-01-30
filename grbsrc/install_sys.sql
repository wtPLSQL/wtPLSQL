
--
--  SYS Installation Script
--
--  Must be run as SYS
--

spool install_sys.log

set blockterminator off
set sqlblanklines on

----------------------------------------
-- USER Install

@dbi.sql "SYS/ODBCAPTURE.user" "" ""

----------------------------------------
set sqlblanklines off
set blockterminator on

spool off

