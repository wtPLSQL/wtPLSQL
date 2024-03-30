
--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--

spool install_system.log

set blockterminator off
set sqlblanklines on

----------------------------------------
-- USER Install

@db_install.sql "SYS/WTP.usr" "" ""

----------------------------------------
set sqlblanklines off
set blockterminator on

spool off

