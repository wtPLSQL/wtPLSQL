
--
--  Core Installation
--
--   Run as System
--

-- Capture output
spool upgrade
set serveroutput on size unlimited format truncated
set showmode off

-- Shared Setup Script
@../../common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

begin
   if USER not in ('SYS')
   then
      raise_application_error (-20000,
        'Not logged in as SYS');
   end if;
end;
/

WHENEVER SQLERROR continue

revoke connect, resource from &schema_owner.;

alter user &schema_owner. quota unlimited on USERS;
grant create session       to &schema_owner.;
grant create type          to &schema_owner.;
grant create sequence      to &schema_owner.;
grant create table         to &schema_owner.;
grant create trigger       to &schema_owner.;
grant create view          to &schema_owner.;
grant create procedure     to &schema_owner.;
grant select on dba_source to &schema_owner.;

-- This MUST be run by SYS.
grant select on dba_objects to &schema_owner.;

drop public synonym wt_not_executable;
drop public synonym plsql_profiler_runs;
drop public synonym plsql_profiler_units;
drop public synonym plsql_profiler_data;
drop public synonym wt_profiler;
drop public synonym wt_result;

create or replace public synonym utassert          for &schema_owner..wt_assert;
create or replace public synonym wt_version        for &schema_owner..wt_version;
create or replace public synonym wt_test_runs_seq  for &schema_owner..wt_test_runs_seq;
create or replace public synonym wt_test_run_stats for &schema_owner..wt_test_run_stats;
create or replace public synonym wt_testcase_stats for &schema_owner..wt_testcase_stats;
create or replace public synonym wt_self_test      for &schema_owner..wt_self_test;

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

@../../proftab_comments.sql
--
grant select on plsql_profiler_runnumber to public;
-- Core Tables
drop table wt_test_data;
revoke select, insert, delete on plsql_profiler_runs from public;
revoke select, insert, delete on plsql_profiler_units from public;
revoke select, insert, delete on plsql_profiler_data from public;
revoke insert on wt_results from public;
revoke insert on wt_dbout_profiles from public;
revoke update on wt_dbout_profiles from public;

-- Note: This table was included with the V1.0 source
--   but was omitted from the V1.0 installation script.
@../../wt_version.tab
delete from wt_version where action = 'INSTALL';
insert into wt_version (install_dtm, action, text)
   values (sysdate, 'INSTALL', '1.0');
insert into wt_version (install_dtm, action, text)
   values (sysdate, 'UPGRADE', '1.1.0');
select * from wt_version;

@../../wt_testcase_stats.tab
@../../wt_test_run_stats.tab
@../../wt_self_test.tab

-- @wt_test_runs.tab
grant select on wt_test_runs_seq to public;

-- @wt_results.tab
alter table wt_results rename column elapsed_msecs to interval_msecs;
comment on column wt_results.interval_msecs is 'Interval time in milliseonds since the previous Result or start ot the Test Run.';

-- @wt_dbout_profiles.tab
alter table wt_dbout_profiles rename column total_time to total_usecs;
alter table wt_dbout_profiles rename column min_time to min_usecs;
alter table wt_dbout_profiles rename column max_time to max_usecs;
comment on column wt_dbout_profiles.status is 'Executed/NotExecuted/Excluded/Ignored/Unknown Status from the Profiler';
comment on column wt_dbout_profiles.total_usecs is 'Total time in microseconds spent executing this line.';
comment on column wt_dbout_profiles.min_usecs is 'Minimum execution time in microseconds for this line.';
comment on column wt_dbout_profiles.max_usecs is 'Maximum execution time in microseconds for this line.';
alter table wt_dbout_profiles drop constraint wt_dbout_profiles_ck1;
update wt_dbout_profiles set status = 'IGNR' where status = 'ANNO';
alter table wt_dbout_profiles add constraint wt_dbout_profiles_ck1 check (status in ('EXEC','NOTX','EXCL','IGNR','UNKN'));

@update_all_stats

-- Package Specifications

@../../wtplsql.pks
/
@../../wt_result.pks
/
@../../wt_assert.pks
/
@../../wt_profiler.pks
/
@../../wt_test_run_stat.pks
/
@../../wt_text_report.pks
/

grant execute on wtplsql to public;
grant execute on wt_assert to public;
grant execute on wt_text_report to public;


-- Package Bodies
@../../wtplsql.pkb
/
@../../wt_result.pkb
/
@../../wt_assert.pkb
/
@../../wt_profiler.pkb
/
@../../wt_test_run_stat.pkb
/
@../../wt_text_report.pkb
/

set showmode on
spool off
