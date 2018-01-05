
-- Create the schema owner.

create user &schema_owner. identified by &schema_owner.
   default tablespace users
   temporary tablespace temp;

grant connect, resource to &schema_owner.;
--grant create view to wtp;

select p.value PLSQL_CCFLAGS
 from  dual  d
  left join v$parameter  p
            on  p.name in 'plsql_ccflags';

-- This block is IDEMPOTENT. It can run more than once and give
--   the same result.
declare
   C_FLAG  CONSTANT varchar2(100) := 'WTPLSQL_ENABLE:';
   parm_value   v_$parameter.value%TYPE;
   procedure set_plsql_ccflags (in_value in varchar2) is begin
      execute immediate 'alter system set PLSQL_CCFLAGS = ''' ||
                         in_value || ''' scope=BOTH';
   end set_plsql_ccflags;
begin
   select value into parm_value
    from  v_$parameter
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

select p.value PLSQL_CCFLAGS
 from  dual  d
  left join v$parameter  p
            on  p.name in 'plsql_ccflags';

-- Public Synonyms

create or replace public synonym wt_test_runs_seq  for &schema_owner..wt_test_runs_seq;

create or replace public synonym wt_test_runs      for &schema_owner..wt_test_runs;
create or replace public synonym wt_results        for &schema_owner..wt_results;
create or replace public synonym wt_dbout_profiles for &schema_owner..wt_dbout_profiles;
create or replace public synonym wt_not_executable for &schema_owner..wt_not_executable;

create or replace public synonym ut_assert         for &schema_owner..wt_assert;
create or replace public synonym wt_assert         for &schema_owner..wt_assert;
create or replace public synonym wt_profiler       for &schema_owner..wt_profiler;
create or replace public synonym wt_result         for &schema_owner..wt_result;
create or replace public synonym wt_text_report    for &schema_owner..wt_text_report;
create or replace public synonym wt_wtplsql        for &schema_owner..wtplsql;
create or replace public synonym wtplsql           for &schema_owner..wtplsql;
