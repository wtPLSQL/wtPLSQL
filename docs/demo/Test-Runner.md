[Demos and Examples](README.md)

# Create a Simple Test Runner

---
Most all wtPLSQL tests are executed with a Test Runner. A Test Runner is a PL/SQL package written by the tester. Below are examples of very simple Test Runners.

Minimal Test Runner Package Spec:
```
create or replace package simple_test_runner authid current_user
as
   procedure wtplsql_run;
end simple_test_runner;
/
```
Minimal Test Runner Package Body:
```
create or replace package body simple_test_runner
as
   procedure wtplsql_run is begin
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
```
This is a minimal test runner.  It is a package that contains the (public) WTPLSQL_RUN procedure and 1 assertion. It does the same assertion as the ad-hoc assertion in the "Simple Test" page. However, the test results are not sent to DBMS_OUTPUT. The test results are saved in the wtPLSQL tables.

## Execute and Display

To execute the Test Runner, run this:
```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
end;
/
```

The results for this assertion have been saved in the wtPLSQL tables. Use the default reporting package to display the results.

```
set serveroutput on size unlimited format word_wrapped

begin
   wt_text_report.dbms_out;
end;
/

    wtPLSQL 1.1.0 - Run ID 12: 15-Jun-2018 01:45:16 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
        Total Testcases:        0       Total Assertions:        1
  Minimum Interval msec:       56      Failed Assertions:        0
  Average Interval msec:       56       Error Assertions:        0
  Maximum Interval msec:       56             Test Yield:   100.00%
   Total Run Time (sec):      0.2
```

While the results might vary, this is latest test result summary from all Test Runners for the login user.  The report confirms that one assertion was executed for SIMPLE_TEST_RUNNER and it passed.

## WT_TEXT_REPORT Display Levels

This example shows all result details for the SIMPLE_TEST_RUNNER only.

```
set serveroutput on size unlimited format word_wrapped

begin
   wt_text_report.dbms_out(in_runner_name  => 'SIMPLE_TEST_RUNNER'
                          ,in_detail_level => 30);
end;
/

    wtPLSQL 1.1.0 - Run ID 12: 15-Jun-2018 01:45:16 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
        Total Testcases:        0       Total Assertions:        1
  Minimum Interval msec:       56      Failed Assertions:        0
  Average Interval msec:       56       Error Assertions:        0
  Maximum Interval msec:       56             Test Yield:   100.00%
   Total Run Time (sec):      0.2

 - WTP_DEMO.SIMPLE_TEST_RUNNER Test Result Details (Test Run ID 12)
-----------------------------------------------------------
 PASS   56ms Ad-Hoc Test. EQ - Expected "1" and got "1"
```

A detail level of 30 shows all summary and detail results for a Test Runner.  In this case, the summary is the same and the detailed results of the EQ assertion are shown.  These detail levels are explained in the [Reference Page](../Reference.md).

## Test Cases

For wtPLSQL, a test case is a collection of assertions.  Test results can be grouped by test case name. There can be zero or more test cases in a Test Runner.

```
create or replace package body simple_test_runner
as
   procedure wtplsql_run is begin
      wt_assert.g_testcase := 'My Test Case';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
```

This modification of the SIMPLE_TEST_RUNNER sets a test case for the assertion.  It is done by modifying a WT_ASSERT package variable.  More on this below.


## DBOUT Annotation

The Database Object Under Test (DBOUT) annotation is used to determine which database object to profile.  If this annotation identifies accessible source code for a DBOUT, the DBMS_PROFILER package is activated to check code coverage.

```
create or replace package body simple_test_runner
as
   --% WTPLSQL SET DBOUT "SIMPLE_TEST_RUNNER:PACKAGE BODY" %--
   procedure wtplsql_run is begin
      wt_assert.g_testcase := 'My Test Case';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
```

With the addition of the DBOUT annotation, the profiling information is available for the SIMPLE_TEST_RUNNER package.

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wt_text_report.dbms_out(USER,'SIMPLE_TEST_RUNNER');
end;
/

    wtPLSQL 1.1.0 - Run ID 38: 15-Jun-2018 11:03:52 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
        Total Testcases:        1       Total Assertions:        1
  Minimum Interval msec:      186      Failed Assertions:        0
  Average Interval msec:      186       Error Assertions:        0
  Maximum Interval msec:      186             Test Yield:   100.00%
   Total Run Time (sec):      0.2

  Code Coverage for PACKAGE BODY WTP_DEMO.SIMPLE_TEST_RUNNER
          Ignored Lines:        0   Total Profiled Lines:        4
         Excluded Lines:        0   Total Executed Lines:        3
  Minimum LineExec usec:        1     Not Executed Lines:        0
  Average LineExec usec:        7          Unknown Lines:        1
  Maximum LineExec usec:       25          Code Coverage:   100.00%
  Trigger Source Offset:        0
```

Note the addition of the "Code Coverage" Summary.  DBMS_PROFILER found 4 lines of significance in the source code.  3 of those lines were executed.  1 line is unknown or undefined by DBMS_PROFILER.  Unknown lines consume execution time, but were not executed.  

## Ignore Annotation

In the previous example, the SIMPLE_TEST_RUNNER package is both the Test Runner and the Database Object Under Test (DBOUT).  In practice, this is a self testing package.  Because DBMS_OUTPUT includes all the source lines, there is a need to segregate "testing" source lines from "tested" source lines.  The ignore annotation is used to segregate these lines.

The function "add2" represents some code that needs to be tested.  It is also a private function.  Self testing packages can run private functions.

```
create or replace package body simple_test_runner
as
   --% WTPLSQL SET DBOUT "SIMPLE_TEST_RUNNER:PACKAGE BODY" %--
   function add2 (in_val1 number, in_val2 number) return number is
      l_result  number;
   begin
      l_result := in_val1 + in_val2;
      return l_result;
   end add2;
   procedure wtplsql_run is begin --%WTPLSQL_begin_ignore_lines%--
      wt_assert.g_testcase := 'My Test Case';
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   => add2(2, 3)
                  ,against_this_in => 5);
   end wtplsql_run;    --%WTPLSQL_end_ignore_lines%--
end simple_test_runner;
/
```

The DBOUT annotation has been moved for convenience.  It can be placed anywhere in the source.

The "begin_ignore" and "end_ignore" annotations have been added to the SIMPLE_TEST_RUNNER package.  The intent of these annotations is to ignore the source lines for the WTPLSQL_RUN procedure for code coverage calculations.

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wt_text_report.dbms_out(USER,'SIMPLE_TEST_RUNNER',50);
end;
/

    wtPLSQL 1.1.0 - Run ID 40: 16-Jun-2018 12:38:49 AM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
        Total Testcases:        1       Total Assertions:        1
  Minimum Interval msec:      111      Failed Assertions:        0
  Average Interval msec:      111       Error Assertions:        0
  Maximum Interval msec:      111             Test Yield:   100.00%
   Total Run Time (sec):      0.1

  Code Coverage for PACKAGE BODY WTP_DEMO.SIMPLE_TEST_RUNNER
          Ignored Lines:        4   Total Profiled Lines:        8
         Excluded Lines:        1   Total Executed Lines:        3
  Minimum LineExec usec:        0     Not Executed Lines:        0
  Average LineExec usec:        1          Unknown Lines:        0
  Maximum LineExec usec:        2          Code Coverage:   100.00%
  Trigger Source Offset:        0

 - WTP_DEMO.SIMPLE_TEST_RUNNER Test Result Details (Test Run ID 40)
-----------------------------------------------------------
 ---- Test Case: My Test Case
 PASS  111ms Ad-Hoc Test. EQ - Expected "5" and got "5"

 - WTP_DEMO.SIMPLE_TEST_RUNNER PACKAGE BODY Code Coverage Details (Test Run ID 40)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     4 EXCL      0         0       0         0    function add2 (in_val1 number, in_val2 number) return number is
     7 EXEC      1         2       2         2       l_result := in_val1 + in_val2;
     8 EXEC      1         0       0         0       return l_result;
     9 EXEC      1         1       1         1    end add2;
    10 IGNR      0         2       2         2    procedure wtplsql_run is begin --%WTPLSQL_begin_ignore_lines%--
    11 IGNR      2        30       1        29       wt_assert.g_testcase := 'My Test Case';
    12 IGNR      1        11      11        11       wt_assert.eq(msg_in          => 'Ad-Hoc Test'
    15 IGNR      1         0       0         0    end wtplsql_run;    --%WTPLSQL_end_ignore_lines%--
```

This is a very large report from the WT_TEXT_REPORT package.  The detail level of 50 displays the full detail of the Test Runner execution with code coverage.

Close to the middle of the output, is the "Code Coverage Details" title for the final section.  This section contains results from DBMS_PROFILER.  Each line of source code is matched with that output.  Some interesting points.

* Line 4, is excluded by wtPLSQL because it is not executable
* Lines 7, 8, and 9 were executed, according to DBMS_OUTPUT.
* Lines 10, 11, 12, and 15 were ignored as per the annotation.
* Several other lines are not included because DBMS_OUPUT did not collect any data on them.

---
[Demos and Examples](README.md)
