[Demos and Examples](README.md)

# Test a PL/SQL Package

---

A majority of wtPLSQL testing is done with a Test Runner package.  In this example, we will create a Test Runner package that will test the DBMS_OUTPUT package.  The DBMS_OUTPUT package is a part of every Oracle database.  For brevity, only PUT_LINE and GET_LINE will be tested in the DBMS_OUTPUT package.

## Test Runner Package Specification

The specification for a Test Runner package is brutally simple.  It only needs one procedure.  Here, we create a package specification for the Test Runner.

Run this:

```
create or replace package test_dbms_output authid definer
as
   procedure wtplsql_run;
end test_dbms_output;
/
```

## Test Runner Package Body

Create a package body with the needed procedure.  Add a call to enable DBMS_OUTPUT for testing.  Setup and teardown will be handled later.

Run this:

```
create or replace package body test_dbms_output
as
   procedure wtplsql_run
   as
   begin
      dbms_output.enable(128000);
   end wtplsql_run;
end test_dbms_output;
/
```

## Testing Put Line and Get Line

The new TEST_PUT_GET_LINE procedure will test the PUT_LINE and GET_LINE procedures together.  Also, the TEST_PUT_GET_LINE procedure call is added to the WTPLSQL_RUN procedure.

Run this:

```
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
```

Run this to setup HOOKS:

```
begin
   wtp.junit_core_report.delete_hooks;
   wtp.wt_test_run.delete_hooks;
   wtp.wt_core_report.insert_hooks;
end;
/
```

Then, run this:

```
begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
end;
/
```

And get this:

```
  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Start Date/Time: 13-Apr-2024 01:21:28 AM
  Test Results for WT_DEMO.TEST_DBMS_OUTPUT
  ------------------------------------------------------------------
  Minimum Elapsed msec:          0      Total Assertions:          1
  Average Elapsed msec:          0     Failed Assertions:          0
  Maximum Elapsed msec:          0       Total Testcases:          1
  Total Run Time (sec):        0.0      Failed Testcases:          0
                                          Testcase Yield:        100%
```

A successful test.

## Catching an Exception

In the previous example, everything worked correctly.  Here is an example of GET_LINE not working.  For testing purposes, an exception will be thrown between the PUT_LINE and GET_LINE call.

Run this:

```
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
```

Then, run this:

```
begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
end;
/
```

And get this:

```
Test 1

  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Start Date/Time: 12-Apr-2024 09:49:26 PM
  Test Results for WT_DEMO.TEST_DBMS_OUTPUT
  ------------------------------------------------------------------
  Minimum Elapsed msec:          0      Total Assertions:          0
  Average Elapsed msec:          0     Failed Assertions:          0
  Maximum Elapsed msec:          0       Total Testcases:          0
  Total Run Time (sec):        0.0      Failed Testcases:          0
                                          Testcase Yield:          0%

  *** Test Runner Error ***
Hook Error in "execute_test_runner", SEQ 20.
ORA-06512: at "WT_DEMO.TEST_DBMS_OUTPUT", line 10
ORA-06512: at "WT_DEMO.TEST_DBMS_OUTPUT", line 18
ORA-06512: at line 1
ORA-06512: at "WTP.WT_EXECUTE_TEST_RUNNER", line 11
ORA-06512: at line 1
ORA-06512: at "WTP.HOOK", line 41
----- PL/SQL Call Stack -----
  object      line  object
  handle    number  name
0xa28c8178        43  package body WTP.HOOK.RUN
0x6f239218       503  package body WTP.WTPLSQL.TEST_RUN
0x9fa74a88         2  anonymous block

 * NOTE: No Data in Test Results Array "core_data.g_results_nt"
```

Your results should include the above results, if DBMS_OUTPUT is enabled.  There may be addition results due to a different wtPSQL configuration.

Notice there was no exception raised.  wtPLSQL captured the exception and logged it.  Also, the value of C_TEST1 shows in the output.  It was left behind in the DBMS_OUTPUT buffer.

No assertions were run because of the exception.  The exception that was captured appears below the test results summary.

## Setup and Teardown

Setup and Teardown procedures are used to prepare for and cleanup from tests.  For DBMS_OUTPUT testing, the buffer needs to be preserved before testing starts.  After testing is complete, the original buffer contents need to be returned to the buffer.

Run this:

```
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
      l_error_message := substr(SQLERRM || CHR(10) ||
                                dbms_utility.format_error_backtrace ||
                                dbms_utility.format_call_stack,1,4000);
      teardown;
      raise_application_error(-20000, l_error_message);
   end wtplsql_run;
   --
end test_dbms_output;
/
```

The Test Runner package is quite large now.  To review, the Test Runner will
* Capture the current DBMS_OUPUT buffer.
* Run a procedure that adds to the DBMS_OUPUT buffer.
* Catch an exception raised by the procedure.
* Capture the error stack.
* Clear the current DBMS_OUPUT buffer.
* Restore the original DBMS_OUPUT buffer.

In order to ensure it is restoring the original DBMS_OUPUT buffer, the message "This should be preserved." is added to the buffer.  That message should be available after the Test Runner completes.

Run this:

```
begin
   wtplsql.test_run('TEST_DBMS_OUTPUT');
end;
/
```

And get this:

```
This should be preserved.

  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Start Date/Time: 13-Apr-2024 12:49:43 AM
  Test Results for WT_DEMO.TEST_DBMS_OUTPUT
  ------------------------------------------------------------------
  Minimum Elapsed msec:          0      Total Assertions:          0
  Average Elapsed msec:          0     Failed Assertions:          0
  Maximum Elapsed msec:          0       Total Testcases:          0
  Total Run Time (sec):        0.0      Failed Testcases:          0
                                          Testcase Yield:          0%

  *** Test Runner Error ***
Hook Error in "execute_test_runner", SEQ 20.
ORA-20000: ORA-20000: Fault insertion exception
ORA-06512: at "WTP_DEMO.TEST_DBMS_OUTPUT", line 21
ORA-06512: at "WTP_DEMO.TEST_DBMS_OUTPUT", line 47
ORA-06512: at "WTP_DEMO.TEST_DBMS_OUTPUT", line 54
ORA-06512: at line 1
ORA-06512: at "WTP.WT_EXECUTE_TEST_RUNNER", line 11
ORA-06512: at line 1
ORA-06512: at "WTP.HOOK", line 41
----- PL/SQL Call Stack -----
  object      line  object
  handle    number  name
0x9deb4af8        43  package body WTP.HOOK.RUN
0x99b16938       503  package body WTP.WTPLSQL.TEST_RUN
0x7d7d6190         2  anonymous block

 * NOTE: No Data in Test Results Array "core_data.g_results_nt"

```

The exception handler preserved the error stack before calling teardown.  Also, there is an extra "ORA-20000:" at the front of the error stack displayed, but all the error information is preserved.

These are all the basic tools needed to successfully create and run Test Runner packages in wtPLSQL.

---
[Demos and Examples](README.md)
