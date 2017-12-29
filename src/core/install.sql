
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
@result.pks
--@assert.pks
@profiler.pks
@text_report.pks

-- Package Bodies
@wtplsql.pkb
@result.pkb
--@assert.pkb
@profiler.pkb
@text_report.pkb
