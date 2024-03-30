
--
--  wtptst Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

spool install_wtptst.log

define INSTALL_SYSTEM_CONNECT="&1."

-- Must Set SQLPREFIX away from "#" Oracle Change Data Capture packages
set sqlprefix "~"

-- Using "^P", CHR(16), DLE as an escape character
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install
@db_install.sql "./installation_prepare.sql" "" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE Install

@db_install.sql "WTP/WT_SELF_TEST.tab" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- DATA_LOAD Install

@db_install.sql "WTP/WT_SELF_TEST.cdl" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TRIGGER Install

@db_install.sql "WTP/WT_SELF_TEST.tabtrg" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- Finalize Installation
@db_install.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."

spool off

