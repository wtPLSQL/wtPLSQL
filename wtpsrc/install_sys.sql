
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

@db_install.sql "SYS/WTP.usr" "" ""

----------------------------------------
set sqlblanklines off
set blockterminator on

spool off

