
create or replace package test_dbms_output authid definer
as
   procedure wtplsql_run;
end test_dbms_output;
/
show errors

create or replace package body test_dbms_output
as
   procedure wtplsql_run
   as
   begin
      dbms_output.enable(128000);
   end wtplsql_run;
end test_dbms_output;
/
show errors

create or replace package body test_dbms_output
as
   procedure test_put_get_line
   is
      c_test1   constant varchar2(100) := 'Test 1';
      l_buffer  varchar2(4000) := '';
      l_status  number := null;
   begin
      dbms_output.put_line(c_test1);
      dbms_output.get_line(l_buffer,l_status);
      wt_assert.eq('Test 1',l_buffer,c_test1);
   end test_put_get_line;
   procedure wtplsql_run
   as
   begin
      dbms_output.enable(128000);
      test_put_get_line;
   end wtplsql_run;
end test_dbms_output;
/
show errors

begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
   wt_persist_report.dbms_out(USER,'TEST_DBMS_OUTPUT',30);
end;
/
show errors

create or replace package body test_dbms_output
as
   procedure test_put_get_line
   is
      c_test1   constant varchar2(100) := 'Test 1';
      l_buffer  varchar2(4000) := '';
      l_status  number := null;
   begin
      dbms_output.put_line(c_test1);
      raise_application_error(-20000, 'Fault insertion exception');
      dbms_output.get_line(l_buffer,l_status);
      wt_assert.eq('Test 1',l_buffer,c_test1);
   end test_put_get_line;
   procedure wtplsql_run
   as
   begin
      dbms_output.enable(128000);
      test_put_get_line;
   end wtplsql_run;
end test_dbms_output;
/
show errors

begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
end;
/
show errors

begin
   wt_persist_report.dbms_out(USER,'TEST_DBMS_OUTPUT',30);
   end if;
end;
/
show errors

create or replace package body test_dbms_output
as
   -- Global variables to capture buffer contents
   g_buffer_contents_va  DBMSOUTPUT_LINESARRAY;
   g_num_lines           number;
   --
   procedure setup
   is
   begin
      -- Capture buffer contents
      dbms_output.get_lines(g_buffer_contents_va, g_num_lines);
   end setup;
   --
   procedure test_put_get_line
   is
      c_test1   constant varchar2(100) := 'Test 1';
      l_buffer  varchar2(4000) := '';
      l_status  number := null;
   begin
      dbms_output.put_line(c_test1);
      raise_application_error(-20000, 'Fault insertion exception');
      dbms_output.get_line(l_buffer,l_status);
      wt_assert.eq('Test 1',l_buffer,c_test1);
   end test_put_get_line;
   --
   procedure teardown
   is
      l_junk_va  DBMSOUTPUT_LINESARRAY;
      l_num      number;
   begin
      -- Clear buffer contents
      dbms_output.get_lines(l_junk_va, l_num);
      -- Restore the buffer
      for i in 1 .. g_num_lines
      loop
         dbms_output.put_line(g_buffer_contents_va(i));
      end loop;
   end teardown;
   --
   procedure wtplsql_run
   is
      l_error_message  varchar2(4000);
   begin
      dbms_output.enable(128000);
      dbms_output.put_line('This should be preserved.');
      setup;
      test_put_get_line;
      teardown;
   exception when others then
      l_error_message := substr(dbms_utility.format_error_stack ||
                                dbms_utility.format_error_backtrace,1,4000);
      teardown;
      raise_application_error(-20000, l_error_message);
   end wtplsql_run;
   --
end test_dbms_output;
/
show errors

begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
end;
/
show errors

begin
   wt_persist_report.dbms_out(USER,'TEST_DBMS_OUTPUT',30);
end;
/
show errors
