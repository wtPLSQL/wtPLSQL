
--
--  Demo Installation
--

-- Capture output
spool install
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

prompt
prompt Shared Setup Script
@../common_setup.sql

WHENEVER SQLERROR continue


prompt
prompt Create Demo owner

create user &demo_owner. identified by &demo_owner.
   default tablespace users
   quota 1M on users
   temporary tablespace temp;

grant create session   to &demo_owner.;
grant create type      to &demo_owner.;
grant create sequence  to &demo_owner.;
grant create table     to &demo_owner.;
grant create trigger   to &demo_owner.;
grant create view      to &demo_owner.;
grant create procedure to &demo_owner.;

begin
   $IF $$WTPLSQL_ENABLE
   $THEN
      dbms_output.put_line('WTPLSQL_ENABLE is TRUE');
   $END
   dbms_output.put_line('Check WTPLSQL_ENABLE is Done.');
end;
/

WHENEVER SQLERROR exit SQL.SQLCODE


prompt
prompt Connect as DEMO_OWNER

connect &demo_owner./&demo_owner.&connect_string.
set serveroutput on size unlimited format truncated

begin
   if USER != upper('&demo_owner')
   then
      raise_application_error (-20000,
        'Not logged in as &demo_owner');
   end if;
end;
/

WHENEVER SQLERROR continue

set serveroutput on size unlimited format truncated

select wtplsql.show_version from dual;

begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end;
/


prompt
prompt Test Installation

prompt Install Package Test
@Package-Test.sql

prompt Install Table Test
@Table-Test.sql

prompt Install Test Runner
@Test-Runner.sql

prompt Install Trigger Test
@Trigger-Test.sql

prompt Install Type Test
@Type-Test.sql

prompt utPLSQL 2.3 ut_betwnstr Example
@ut_betwnstr.sql

prompt utPLSQL 2.3 ut_calc_secs_between Example
@ut_calc_secs_between.sql

prompt utPLSQL 2.3 ut_str Example
@ut_str.sql

prompt utPLSQL 2.3 ut_truncit Example
@ut_truncit.sql

spool off
