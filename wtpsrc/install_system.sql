
--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--

spool install_system.log

set blockterminator off
set sqlblanklines on

----------------------------------------
-- GRANT Install

@db_install.sql "SYSTEM/WTP_usr.grnt" "" ""

----------------------------------------
set sqlblanklines off
set blockterminator on

spool off

