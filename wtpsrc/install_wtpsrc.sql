
--
--  wtpsrc Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

spool install_wtpsrc.log

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
-- PROCEDURE Install

@dbi.sql "WTP/WT_AD_HOC_REPORT.proc" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_EXECUTE_TEST_RUNNER.proc" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE_SPEC Install

@dbi.sql "WTP/CORE_DATA.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/HOOK.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/JUNIT_CORE_REPORT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WTPLSQL.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_ASSERT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_CORE_REPORT.pkssql" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- TABLE Install

@dbi.sql "WTP/HOOKS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_VERSIONS.tbl" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
prompt Compile All started
begin
   DBMS_UTILITY.compile_schema(schema      => 'WTP'
                              ,compile_all => FALSE);
end;
/
prompt Compile All is done.
----------------------------------------
-- VIEW Install

@dbi.sql "WTP/WT_QUAL_TEST_RUNNERS_VW.vw" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- DATA_LOAD Install

@dbi.sql "WTP/HOOKS.cldr" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- PACKAGE_BODY Install

@dbi.sql "WTP/CORE_DATA.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/HOOK.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/JUNIT_CORE_REPORT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WTPLSQL.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_ASSERT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."
@dbi.sql "WTP/WT_CORE_REPORT.pkbsql" "WTP" "&INSTALL_SYSTEM_CONNECT."

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)
@dbi.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."

spool off

