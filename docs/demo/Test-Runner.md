[Demos and Examples](README.md)

# Create a Simple Test Runner Package

---
Most all wtPLSQL tests are executed by a test runner package. Test runner packages are written by the tester. Below are examples of very simple test runner packages.

Run this:

```
create or replace package simple_test_runner authid definer
as
   procedure wtplsql_run;
end simple_test_runner;
/

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

SIMPLE_TEST_RUNNER is a minimal test runner.  It is a package that contains the (public) WTPLSQL_RUN procedure and 1 assertion. It does the same assertion as the ad-hoc assertion in the [Simple Test](Simple-Test.md) page. 

## Execute and Display

To execute the test runner package, run this:

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
end;
/
```

There are no test results because the test results were not sent to DBMS_OUTPUT. The test results were saved in the wtPLSQL tables.

To view the results, run this:

```
set serveroutput on size unlimited format word_wrapped

begin
   wt_text_report.dbms_out;
end;
/
```

And get this:

```
    wtPLSQL 1.1.0 - Run ID 12: 15-Jun-2018 01:45:16 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
       Total Test Cases:        0       Total Assertions:        1
  Minimum Interval msec:       56      Failed Assertions:        0
  Average Interval msec:       56       Error Assertions:        0
  Maximum Interval msec:       56             Test Yield:   100.00%
   Total Run Time (sec):      0.2
```

This is latest test result summary from all test runner packages for the login user.  The interval time shown here is the elapsed time from starting the test runner package until the first assertion was executed.  The total run time is the elapsed time from start to finish for the test runner package.  The report confirms that one assertion was executed for SIMPLE_TEST_RUNNER and it passed.  All tests passed, so the test yield is 100%.

## WT_TEXT_REPORT Display Levels

This example shows all result details for the SIMPLE_TEST_RUNNER only.

Run this:

```
set serveroutput on size unlimited format word_wrapped

begin
   wt_text_report.dbms_out(in_runner_name  => 'SIMPLE_TEST_RUNNER'
                          ,in_detail_level => 30);
end;
/
```

And get this:

```
    wtPLSQL 1.1.0 - Run ID 12: 15-Jun-2018 01:45:16 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
       Total Test Cases:        0       Total Assertions:        1
  Minimum Interval msec:       56      Failed Assertions:        0
  Average Interval msec:       56       Error Assertions:        0
  Maximum Interval msec:       56             Test Yield:   100.00%
   Total Run Time (sec):      0.2

 - WTP_DEMO.SIMPLE_TEST_RUNNER Test Result Details (Test Run ID 12)
-----------------------------------------------------------
 PASS   56ms Ad-Hoc Test. EQ - Expected "1" and got "1"
```

This shows the latest test result summary with test results details.  A detail level of 30 shows summary and detailed test results for a test runner package.  In this case, the summary is the same and the detailed results of the EQ assertion are shown.  These detail levels are explained in the [Reference Page](../Reference.md).

The detailed results shown are the same as the ad-hoc result, with a "56ms" added.  The detailed results from the test runner package includes the elapsed time between assertions, or elapsed time from test runner package startup to the first assertion.

## Test Cases

For wtPLSQL, a test case is a collection of assertions.  Assertion results can be grouped by test case. There can be zero or more test cases in a test runner package.

Run this:

```
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
```

Setting a value for WT_ASSERT.G_TESTCASE in the SIMPLE_TEST_RUNNER package sets a test case for all following assertions.  This value can be set multiple times within a test runner package.  The results summary will show the number of test cases.  The test results details will group assertions by test case.

Run this:

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wt_text_report.dbms_out(in_runner_name  => 'SIMPLE_TEST_RUNNER'
                          ,in_detail_level => 30);
end;
/
```

And get this:

```
    wtPLSQL 1.1.0 - Run ID 43: 16-Jun-2018 07:43:50 AM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
       Total Test Cases:        2       Total Assertions:        4
  Minimum Interval msec:        0      Failed Assertions:        1
  Average Interval msec:        0       Error Assertions:        0
  Maximum Interval msec:        1             Test Yield:    75.00%
   Total Run Time (sec):      0.0

 - WTP_DEMO.SIMPLE_TEST_RUNNER Test Result Details (Test Run ID 43)
-----------------------------------------------------------
 ---- Test Case: My Test Case A
 PASS    1ms Ad-Hoc Test1. EQ - Expected "1" and got "1"
 PASS    0ms Ad-Hoc Test2. EQ - Expected "2" and got "2"
 ---- Test Case: My Test Case B
#FAIL#   0ms Ad-Hoc Test1. EQ - Expected " 4" and got "4"
 PASS    0ms Ad-Hoc Test2. EQ - Expected "5" and got "5"
```

The Test Results summary shows 2 test cases were found.  The Test Results Details show the assertion results grouped by test case.  The details also show a failed assertion.  It also shows "Ad-Hoc Test2" in "My Test Case B" passed because the TO_NUMBER was used to remove the space character from " 5".

## DBOUT Annotation

The Database Object Under Test (DBOUT) annotation is used to determine which database object to profile.  If this annotation identifies accessible source code for a DBOUT, the DBMS_PROFILER package is activated to check code coverage.

Run this:

```
create or replace package body simple_test_runner
as
   --% WTPLSQL SET DBOUT "SIMPLE_TEST_RUNNER:PACKAGE BODY" %--
   procedure wtplsql_run is begin
      wt_assert.eq(msg_in          => 'Ad-Hoc Test'
                  ,check_this_in   =>  1
                  ,against_this_in => '1');
   end wtplsql_run;
end simple_test_runner;
/
```

With the addition of the DBOUT annotation, the profiling information is available for the SIMPLE_TEST_RUNNER package.

Run this:

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wt_text_report.dbms_out(USER,'SIMPLE_TEST_RUNNER');
end;
/
```

And get this:

```
    wtPLSQL 1.1.0 - Run ID 38: 15-Jun-2018 11:03:52 PM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
       Total Test Cases:        0       Total Assertions:        1
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

This shows the latest test result summary and code coverage summary for the SIMPLE_TEST_RUNNER test runner.  DBMS_PROFILER found 4 lines of significance in the source code.  3 of those lines were executed.  1 line is unknown or undefined by DBMS_PROFILER.  Unknown lines consume execution time, but were not executed.  

## Ignore Annotation

In the previous example, the SIMPLE_TEST_RUNNER package is both the test runner and the Database Object Under Test (DBOUT).  In practice, this is a self testing package.  Because DBMS_OUTPUT includes all the source lines, there is a need to segregate "testing" source lines from "tested" source lines.  The ignore annotation is used to segregate these lines.

The function "add2" represents some code that needs to be tested.  It is also a private function.  Self testing packages can test the private functions in the package.

Run this:

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

Run this:

```
begin
   wtplsql.test_run('SIMPLE_TEST_RUNNER');
   wt_text_report.dbms_out(USER,'SIMPLE_TEST_RUNNER',30);
end;
/
```

And get this:

```
    wtPLSQL 1.1.0 - Run ID 40: 16-Jun-2018 12:38:49 AM

  Test Results for WTP_DEMO.SIMPLE_TEST_RUNNER
       Total Test Cases:        1       Total Assertions:        1
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

This is a very large report from the WT_TEXT_REPORT package.  The detail level of 30 displays the full detail of the test runner execution with code coverage.

Close to the middle of the output, is the "Code Coverage Details" title for the final section.  This section contains results from DBMS_PROFILER.  Each line of source code is matched with that output.  Some interesting points.

* Line 4, is excluded by wtPLSQL because it is not executable
* Lines 7, 8, and 9 were executed, according to DBMS_OUTPUT.
* Lines 10, 11, 12, and 15 were ignored as per the annotation.
* Several other lines are not included because DBMS_OUPUT did not collect any data on them.

---
[Demos and Examples](README.md)
