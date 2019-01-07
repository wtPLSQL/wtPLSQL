[Demos and Examples](README.md)

# utPLSQL 2.3 ut_truncit Example

---

## Original Example

The [original "ut_truncit" example](https://utplsql.org/utPLSQL/v2.3.1/testproc.html) is in the utPLSQL documentation.  The PL/SQL source for the function that will be tested is in the "Test Success by Analyzing Impact" section.  There is an additional function "tabcount" that is also needed.  The PL/SQL source for the package specification and body of the utPLSQL test package are in the same section.

## Test Package Conversion

Conversion of this test package into a test runner package requires the addition of the "wtPLSQL_run" procedure in the package specification.

Run this:

```
CREATE OR REPLACE PACKAGE ut_truncit
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_TRUNCIT;
   PROCEDURE wtplsql_run;
END ut_truncit;
/
```

Likewise, the package body needs the wtPLSQL_run procedure.

Run this:

```
/*file ut_truncit.pkb */
CREATE OR REPLACE PACKAGE BODY ut_truncit
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      EXECUTE IMMEDIATE 
         'CREATE TABLE temp_emp AS SELECT * FROM DUAL';
   END;
   
   PROCEDURE ut_teardown
   IS
   BEGIN
      EXECUTE IMMEDIATE 
         'DROP TABLE temp_emp';
   END;

   -- For each program to test...
   PROCEDURE ut_TRUNCIT IS
   BEGIN
      TRUNCIT (
            TAB => 'temp_emp'
            ,
            SCH => USER
       );

      utAssert.eq (
         'Test of TRUNCIT',
         tabcount (USER, 'temp_emp'),
         0
         );
   END ut_TRUNCIT;

   --% WTPLSQL SET DBOUT "TRUNCIT:PROCEDURE" %--

   PROCEDURE wtplsql_run IS
   BEGIN
      ut_setup;
      ut_TRUNCIT;
      ut_teardown;
   END wtplsql_run;
END ut_truncit;
/
```

The SET DBOUT annotation was also added to gather code coverage data.


## Check the Results

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('UT_TRUNCIT');
   wt_text_report.dbms_out(in_runner_name  => 'UT_TRUNCIT'
                          ,in_detail_level => 30);
end;
/
```

And Get This:

```
    wtPLSQL 1.1.0 - Run ID 81: 25-Jun-2018 09:48:39 PM

  Test Results for WTP_DEMO.UT_TRUNCIT
       Total Test Cases:        0       Total Assertions:        1
  Minimum Interval msec:      331      Failed Assertions:        0
  Average Interval msec:      331       Error Assertions:        0
  Maximum Interval msec:      331             Test Yield:   100.00%
   Total Run Time (sec):      0.4

  Code Coverage for PROCEDURE WTP_DEMO.TRUNCIT
          Ignored Lines:        0   Total Profiled Lines:        3
         Excluded Lines:        0   Total Executed Lines:        2
  Minimum LineExec usec:        2     Not Executed Lines:        0
  Average LineExec usec:    15714          Unknown Lines:        1
  Maximum LineExec usec:    31423          Code Coverage:   100.00%
  Trigger Source Offset:        0

 - WTP_DEMO.UT_TRUNCIT Test Result Details (Test Run ID 81)
-----------------------------------------------------------
 PASS  331ms Test of TRUNCIT. EQ - Expected "0" and got "0"

 - WTP_DEMO.TRUNCIT PROCEDURE Code Coverage Details (Test Run ID 81)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     1 UNKN      0         3       3         3 PROCEDURE truncit (
     7 EXEC      1     31426       3     31423    EXECUTE IMMEDIATE 'truncate table ' || NVL (sch, USER) || '.' || tab;
     8 EXEC      1         2       2         2 END;
```

If the Persist add-on is not installed, the code coverage results will not be displayed.


---
[Demos and Examples](README.md)
