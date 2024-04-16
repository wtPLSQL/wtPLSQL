
create or replace package simple_test_runner authid definer
as
   procedure wtplsql_run;
end simple_test_runner;
/
show errors

create or replace package body simple_test_runner
as
   procedure wtplsql_run is begin
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
show errors

set serveroutput on size unlimited format truncated

begin
   wtp.junit_core_report.delete_hooks;
   wtp.wt_core_report.delete_hooks;
   wtp.wt_test_run.insert_hooks;
end;
/

begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wtp.wt_persist_report.dbms_out(in_runner_name  => 'SIMPLE_TEST_RUNNER');
end;
/

begin
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'SIMPLE_TEST_RUNNER'
                                 ,in_detail_level => 30);
end;
/

create or replace package body simple_test_runner
as
   procedure wtplsql_run is begin
      wt_assert.g_testcase := 'My Test Case A';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test1'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
      wt_assert.eq(msg_in          => 'Ad-Hoc Test2'
                  ,check_this_in   =>  2
                  ,against_this_in => '2');
      wt_assert.g_testcase := 'My Test Case B';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test1'
                  ,check_this_in   =>  4
                  ,against_this_in => ' 4');
      wt_assert.eq(msg_in          => 'Ad-Hoc Test2'
                  ,check_this_in   =>  5
                  ,against_this_in => to_number(' 5'));
   end wtplsql_run;
end simple_test_runner;
/
show errors

begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'SIMPLE_TEST_RUNNER'
                                 ,in_detail_level => 30);
end;
/

create or replace package body simple_test_runner
as
   procedure wtplsql_run is begin
      wtplsql.g_DBOUT := 'SIMPLE_TEST_RUNNER:PACKAGE BODY';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
show errors

begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'SIMPLE_TEST_RUNNER');
end;
/

create or replace package body simple_test_runner
as
   function add2 (in_val1 number, in_val2 number) return number is
      l_result  number;
   begin
      l_result := in_val1 + in_val2;
      return l_result;
   end add2;
   procedure wtplsql_run is begin --%WTPLSQL_begin_ignore_lines%--
      wtplsql.g_DBOUT := 'SIMPLE_TEST_RUNNER:PACKAGE BODY';
      wt_assert.g_testcase := 'My Test Case';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   => add2(2, 3)
                  ,against_this_in => 5);
   end wtplsql_run;    --%WTPLSQL_end_ignore_lines%--
end simple_test_runner;
/
show errors

begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'SIMPLE_TEST_RUNNER'
                                 ,in_detail_level => 30);
end;
/
