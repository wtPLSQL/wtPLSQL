
--
--  Core Installation
--
--   Run as System
--

-- Capture output
spool install
set showmode off
set serveroutput on size unlimited format truncated

-- Shared Setup Script
@common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

begin
   if USER not in ('SYS','SYSTEM')
   then
      raise_application_error (-20000,
        'Not logged in as SYS');
   end if;
end;
/

WHENEVER SQLERROR continue

-- Create the schema owner.

create user &schema_owner. identified by &schema_owner.
   default tablespace users
   quota unlimited on users
   temporary tablespace temp;

grant create session   to &schema_owner.;
grant create type      to &schema_owner.;
grant create sequence  to &schema_owner.;
grant create table     to &schema_owner.;
grant create trigger   to &schema_owner.;
grant create view      to &schema_owner.;
grant create procedure to &schema_owner.;
grant select on dba_source to &schema_owner.;

-- This MUST be run by SYS.
grant select on dba_objects to &schema_owner.;

begin
   for buff in (select p.value PLSQL_CCFLAGS
                 from  dual  d
                  left join v$parameter  p
                       on  p.name in 'plsql_ccflags')
   loop
      dbms_output.put_line('PLSQL_CCFLAGS Before: ' || buff.PLSQL_CCFLAGS);
   end loop;
end;
/

-- This block is IDEMPOTENT. It can run more than once and give
--   the same result.
declare
   C_FLAG  CONSTANT varchar2(100) := 'WTPLSQL_ENABLE:';
   parm_value   v$parameter.value%TYPE;
   procedure set_plsql_ccflags (in_value in varchar2) is begin
      execute immediate 'alter system set PLSQL_CCFLAGS = ''' ||
                         in_value || ''' scope=BOTH';
   end set_plsql_ccflags;
begin
   select value into parm_value
    from  v$parameter
    where name in 'plsql_ccflags';
   if nvl(length(parm_value),0) = 0
   then
      -- No Flags have been set
      set_plsql_ccflags(C_FLAG || 'TRUE');
   elsif instr(parm_value, C_FLAG) = 0
   then
      -- C_FLAG is not already present
      set_plsql_ccflags(C_FLAG || 'TRUE, ' || parm_value);
   end if;
end;
/

begin
   for buff in (select p.value PLSQL_CCFLAGS
                 from  dual  d
                  left join v$parameter  p
                       on  p.name in 'plsql_ccflags')
   loop
      dbms_output.put_line('PLSQL_CCFLAGS After: ' || buff.PLSQL_CCFLAGS);
   end loop;
end;
/

-- Public Synonyms

create or replace public synonym wt_version        for &schema_owner..wt_version;
create or replace public synonym wt_test_runs_seq  for &schema_owner..wt_test_runs_seq;
create or replace public synonym wt_test_runs      for &schema_owner..wt_test_runs;
create or replace public synonym wt_results        for &schema_owner..wt_results;
create or replace public synonym wt_dbout_profiles for &schema_owner..wt_dbout_profiles;
create or replace public synonym wt_test_run_stats for &schema_owner..wt_test_run_stats;
create or replace public synonym wt_testcase_stats for &schema_owner..wt_testcase_stats;
create or replace public synonym wt_self_test      for &schema_owner..wt_self_test;

create or replace public synonym utassert       for &schema_owner..wt_assert;
create or replace public synonym wt_assert      for &schema_owner..wt_assert;
create or replace public synonym wt_text_report for &schema_owner..wt_text_report;
create or replace public synonym wt_wtplsql     for &schema_owner..wtplsql;
create or replace public synonym wtplsql        for &schema_owner..wtplsql;


WHENEVER SQLERROR exit SQL.SQLCODE

-- Connect as SCHEMA_OWNER
connect &schema_owner./&schema_owner.
set serveroutput on size unlimited format truncated

begin
   if USER != upper('&schema_owner')
   then
      raise_application_error (-20000,
        'Not logged in as &schema_owner');
   end if;
end;
/

WHENEVER SQLERROR continue

--
-- Run Oracle's Profiler Table Installation
--  Note1: Tables converted to Global Temporary
--  Note2: Includes "Drop Table" and "Drop Sequence" statements
--
@proftab.sql
@proftab_comments.sql
--
create index plsql_profiler_runs_idx1
   on plsql_profiler_runs (run_date);

-- Core Tables
@wt_version.tab
@wt_test_runs.tab
@wt_results.tab
@wt_dbout_profiles.tab
@wt_test_run_stats.tab
@wt_testcase_stats.tab
@wt_self_test.tab

-- Package Specifications
@wtplsql.pks
/
@wt_result.pks
/
@wt_assert.pks
/
@wt_profiler.pks
/
@wt_test_run_stat.pks
/
@wt_text_report.pks
/

grant execute on wtplsql to public;
grant execute on wt_assert to public;
grant execute on wt_text_report to public;

-- Package Bodies
@wtplsql.pkb
/
@wt_result.pkb
/
@wt_assert.pkb
/
@wt_profiler.pkb
/
@wt_test_run_stat.pkb
/
@wt_text_report.pkb
/

set showmode on
spool off
