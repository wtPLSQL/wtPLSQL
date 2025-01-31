
--
--  wtpgrb Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

spool install_wtpgrb.log

define INSTALL_SYSTEM_CONNECT="&1."

-- For Oracle Change Data Capture (CDC) packages
set sqlprefix "~"

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install
@dbi.sql "./installation_prepare.sql" "" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- DATA_LOAD Install

@dbi.sql "ODBCAPTURE/BUILD_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/BUILD_PATH.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/DLOAD_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/OBJECT_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/ROLE_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/SCHEMA_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "ODBCAPTURE/TSPACE_CONF.cldr" "ODBCAPTURE" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)
@dbi.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."

spool off

