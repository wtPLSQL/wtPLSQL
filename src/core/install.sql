
--
--  Core Installation
--


--
-- Run Oracle's Profiler Table Installation
--  Note1: Tables converted to Global Temporary
--  Note2: Includes "Drop Table" and "Drop Sequence" statements
--
@proftab.sql


-- Core Tables
@test_runs.tab
@results.tab
@dbout_profiles.tab
@not_executable.tab

-- Package Specifications
@wtplsql.pks
grant execute on wtplsql to public;
@result.pks
grant execute on result to public;
@assert.pks
grant execute on assert to public;
@profiler.pks
grant execute on profiler to public;
@text_report.pks
grant execute on text_report to public;

-- Package Bodies
@wtplsql.pkb
@result.pkb
@assert.pkb
@profiler.pkb
@text_report.pkb
