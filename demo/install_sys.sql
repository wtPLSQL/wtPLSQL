
--
--  Demo Installation
--

-- Capture output
spool install_sys
set serveroutput on size unlimited format truncated

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

prompt
prompt Create Demo owner

create user WT_DEMO identified by WT_DEMO
   default tablespace users
   quota 1M on users
   temporary tablespace temp;

grant create session   to WT_DEMO;
grant create type      to WT_DEMO;
grant create sequence  to WT_DEMO;
grant create table     to WT_DEMO;
grant create trigger   to WT_DEMO;
grant create view      to WT_DEMO;
grant create procedure to WT_DEMO;

begin
   $IF $$WTPLSQL_ENABLE
   $THEN
      dbms_output.put_line('WTPLSQL_ENABLE is TRUE');
   $END
   dbms_output.put_line('Check WTPLSQL_ENABLE is Done.');
end;
/

WHENEVER SQLERROR exit SQL.SQLCODE
