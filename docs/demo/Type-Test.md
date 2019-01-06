[Demos and Examples](README.md)

# Test a PL/SQL Type

---

## Oracle Database Types

Following are the [4 Oracle database types](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_type.htm) that are defined and stored in the database.
* Abstract Data Type (ADT) (including a SQLJ object type)
* Standalone varying array (varray) type
* Standalone nested table type
* Incomplete object type

In contrast these Oracle database types are not stored in the database.
* Subtypes
* Record Types
* Associative Arrays

## Test a PL/SQL Object Type

Create a simple object type to test.  This object tracks the minimum value of one or more observations.  It also tracks the number of observations.  The constructor initializes the object as required.

Run this:

```
create or replace type simple_test_obj_type authid definer
   as object
   (minimum_value  number
   ,observations   number
   ,CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
       return self as result
   ,member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
   );
/
```

And run this:

```
create or replace type body simple_test_obj_type is
    CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
          return self as result
    is
    begin
       minimum_value  := null;
       observations   := 0;
       return;
    end simple_test_obj_type;
    member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
    is
    begin
       If minimum_value is null then minimum_value := in_observation;
       else minimum_value := least(minimum_value, in_observation);
       end if;
       observations := observations + 1;
    end add_observation;
end;
/
```

## Create a Simple Test Runner

All test runners are written as a PL/SQL package. A simple package is created first.  A DBOUT is also identified.

Run this:

```
create or replace package test_simple_object authid definer
as
   procedure wtplsql_run;
end test_simple_object;
/
```

The constructor has 2 basic functions:
* NULL the the minimum value
* Set number of observations to zero

Run this:

```
create or replace package body test_simple_object
as
   --% WTPLSQL SET DBOUT "SIMPLE_TEST_OBJ_TYPE:TYPE BODY" %--
   procedure t_constructor
   is
      simple_test_obj  simple_test_obj_type;
   begin
      wt_assert.g_testcase := 'Constructor Happy Path 1';
      simple_test_obj := simple_test_obj_type();
      wt_assert.isnull(msg_in        => 'Object MINIMUM_VALUE'
                      ,check_this_in => simple_test_obj.MINIMUM_VALUE);
      wt_assert.eq(msg_in          => 'Object OBSERVATIONS'
                  ,check_this_in   => simple_test_obj.OBSERVATIONS
                  ,against_this_in => 0);
   end t_constructor;
   procedure wtplsql_run
   as
   begin
      t_constructor;
   end wtplsql_run;
end test_simple_object;
/
```

## Check the Results

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('TEST_SIMPLE_OBJECT');
   wt_text_report.dbms_out(USER,'TEST_SIMPLE_OBJECT',30);
end;
/
```

And Get This:

```
    wtPLSQL 1.1.0 - Run ID 56: 18-Jun-2018 10:04:32 PM

  Test Results for WTP.TEST_SIMPLE_OBJECT
       Total Test Cases:        1       Total Assertions:        2
  Minimum Interval msec:        8      Failed Assertions:        0
  Average Interval msec:       74       Error Assertions:        0
  Maximum Interval msec:      139             Test Yield:   100.00%
   Total Run Time (sec):      0.1

  Code Coverage for TYPE BODY WTP.SIMPLE_TEST_OBJ_TYPE
          Ignored Lines:        0   Total Profiled Lines:       10
         Excluded Lines:        1   Total Executed Lines:        4
  Minimum LineExec usec:        0     Not Executed Lines:        4
  Average LineExec usec:        1          Unknown Lines:        1
  Maximum LineExec usec:        2          Code Coverage:    50.00%
  Trigger Source Offset:        0

 - WTP.TEST_SIMPLE_OBJECT Test Result Details (Test Run ID 56)
-----------------------------------------------------------
 ---- Test Case: Constructor Happy Path 1
 PASS  139ms Object MINIMUM_VALUE. ISNULL - Expected NULL and got ""
 PASS    8ms Object OBSERVATIONS. EQ - Expected "0" and got "0"

 - WTP.SIMPLE_TEST_OBJ_TYPE TYPE BODY Code Coverage Details (Test Run ID 56)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     2 UNKN      0         2       2         2     CONSTRUCTOR FUNCTION simple_test_obj_type
     7 EXEC      1         1       1         1        minimum_value  := null;
     8 EXEC      1         0       0         0        observations   := 0;
     9 EXEC      1         2       2         2        return;
    10 EXEC      1         2       2         2     end simple_test_obj_type;
    11#NOTX#     0         0       0         0     member procedure add_observation
    16#NOTX#     0         0       0         0        If minimum_value is null then minimum_value := in_observation;
    17#NOTX#     0         0       0         0        else minimum_value := least(minimum_value, in_observation);
    19#NOTX#     0         0       0         0        observations := observations + 1;
    20 EXCL      0         0       0         0     end add_observation;
```

This is report level 30, the most detailed level of reporting.  Starting from the top, we find the test runner executed 1 test case, 2 assertions, and no failed assertions, which resulted in 100% yield (all tests passed).  The next section shows the type body tested had 10 lines profiled, 4 were executed, and 4 were not executed, which resulted in a code coverage of 50%.  Additional testing is required to achieve 100% code coverage.  For brevity, this additional testing will not be included.


## Testing Private Object Methods and Self-Testing

An Oracle object type can have private methods.  These methods are not available outside the object.  They are inherited from a super-type.

[Private Object Methods on StackOverFlow](https://stackoverflow.com/questions/1580205/pl-sql-private-object-method)

Testing these private methods requires a mock object type of the super-type that exposes the private methods for testing.

Self-testing object types has the drawback of requires a CONSTRUCTOR FUNCTION with no parameters.  This limits testing of the object to that one constructor.

---
[Demos and Examples](README.md)
