
--
--  Demo Installation
--

-- Capture output
spool install

-- Shared Setup Script
@common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

begin
   if USER not in ('SYS','SYSTEM')
   then
      raise_application_error (-20000,
        'Not logged in as SYS or SYSTEM');
   end if;
end;
/

WHENEVER SQLERROR continue

-- Create the schema owner.

create user &schema_owner. identified by &schema_owner.
   default tablespace users
   temporary tablespace temp;

grant connect, resource to &schema_owner.;

WHENEVER SQLERROR exit SQL.SQLCODE

-- Connect as SCHEMA_OWNER
connect &schema_owner./&schema_owner.

begin
   if USER != upper('&schema_owner')
   then
      raise_application_error (-20000,
        'Not logged in as &schema_owner');
   end if;
end;
/

WHENEVER SQLERROR continue

/*
-- Demo Tables
@cluckers.tab
@clucks.tab

-- Package Specifications

@clucker_maint.pks
/

@clucking.pks
/

-- Package Bodies
@clucker_maint.pkb
/

@clucking.pkb
/

*/

spool off
