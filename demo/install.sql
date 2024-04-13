
--
--  Demo Installation
--

-- Capture output
spool install
set serveroutput on size unlimited format truncated

WHENEVER SQLERROR exit SQL.SQLCODE

begin
   if USER != upper('WT_DEMO')
   then
      raise_application_error (-20000,
        'Not logged in as WT_DEMO');
   end if;
end;
/

WHENEVER SQLERROR continue

execute dbms_output.put_line(wtp.core_data.g_run_rec.test_runner_name);
execute wtp.core_data.g_run_rec.test_runner_name := null;
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
