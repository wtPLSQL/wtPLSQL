
--
--  Core Installation
--

-- Capture output
spool install

-- Shared Setup Script
@common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

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
--
create index plsql_profiler_runs_idx1
   on plsql_profiler_runs (run_date);
grant select, insert, delete on plsql_profiler_runs to public;
grant select, insert, delete on plsql_profiler_units to public;
grant select, insert, delete on plsql_profiler_data to public;

-- Core Tables
@wt_test_runs.tab
@wt_results.tab
@wt_dbout_profiles.tab
@wt_not_executable.tab
@wt_test_data.tab

-- Package Specifications

@wtplsql.pks
/
grant execute on wtplsql to public;

@wt_result.pks
/
grant execute on wt_result to public;

@wt_assert.pks
/
grant execute on wt_assert to public;

@wt_profiler.pks
/
grant execute on wt_profiler to public;

@wt_text_report.pks
/
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
@wt_text_report.pkb
/

spool off
