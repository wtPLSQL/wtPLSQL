[Demos and Examples](README.md)

# utPLSQL 2.3 ut_ut_calc_secs_between Example

---

## Original Example

The [original "ut_ut_calc_secs_between" example](https://utplsql.org/utPLSQL/v2.3.1/testproc.html) is in the utPLSQL documentation.  The PL/SQL source for the procedure that will be tested is under the section "Test Success Through Parameters".  The PL/SQL source for the package specification and body of the utPLSQL test package are in the same section.

## Test Package Conversion

Conversion of this test package into a Test Runner package requires the addition of the "wtPLSQL_run" procedure in the package specification.

Run this:

```
CREATE OR REPLACE PACKAGE ut_calc_secs_between
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_CALC_SECS_BETWEEN;
   PROCEDURE wtplsql_run;
END ut_calc_secs_between;
/
```

Likewise, the package body needs the wtPLSQL_run procedure.

Run this:

```
CREATE OR REPLACE PACKAGE BODY ut_calc_secs_between
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   -- For each program to test...
   PROCEDURE ut_CALC_SECS_BETWEEN 
   IS
      secs PLS_INTEGER;
   BEGIN
      CALC_SECS_BETWEEN (
            DATE1 => SYSDATE
            ,
            DATE2 => SYSDATE
            ,
            SECS => secs
       );
   
      utAssert.eq (
         'Same dates',
         secs, 
         0
         );
         
      CALC_SECS_BETWEEN (
            DATE1 => SYSDATE
            ,
            DATE2 => SYSDATE+1
            ,
            SECS => secs
       );
   
      utAssert.eq (
         'Exactly one day',
         secs, 
         24 * 60 * 60
         );
         
   END ut_CALC_SECS_BETWEEN;

   --% WTPLSQL SET DBOUT "CALC_SECS_BETWEEN:PROCEDURE" %--
   PROCEDURE wtPLSQL_run IS
   BEGIN
      ut_setup;
      ut_CALC_SECS_BETWEEN;
      ut_teardown;
   END wtPLSQL_run;

END ut_calc_secs_between;
/
```

It is not necessary to keep the ut_setup and ut_teardown procedures.  These were kept to indicate how to incorporate those procedures into a Test Runner package.  The SET DBOUT annotation was also added to gather code coverage data.


## Check the Results

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('UT_CALC_SECS_BETWEEN');
   wt_persist_report.dbms_out(in_runner_name  => 'UT_CALC_SECS_BETWEEN'
                             ,in_detail_level => 30);
end;
/
```

And Get This:

```
  Code Coverage for PROCEDURE WTP_DEMO.CALC_SECS_BETWEEN
          Ignored Lines:        0   Total Profiled Lines:        3
         Excluded Lines:        0   Total Executed Lines:        2
  Minimum LineExec usec:        1     Not Executed Lines:        0
  Average LineExec usec:        2          Unknown Lines:        1
  Maximum LineExec usec:        8          Code Coverage:   100.00%
  Trigger Source Offset:        0

 - WTP_DEMO.UT_CALC_SECS_BETWEEN Test Result Details (Test Run ID 80)
-----------------------------------------------------------
 PASS  103ms Same dates. EQ - Expected "0" and got "0"
 PASS    0ms Exactly one day. EQ - Expected "86400" and got "86400"

 - WTP_DEMO.CALC_SECS_BETWEEN PROCEDURE Code Coverage Details (Test Run ID 80)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     1 UNKN      0         2       0         2 PROCEDURE calc_secs_between (
    10 EXEC      2         9       1         8    secs := (date2 - date1) * 24 * 60 * 60;
    11 EXEC      2         1       1         1 END;
```

If the Persist add-on is not installed, the code coverage results will not be displayed.

---
[Demos and Examples](README.md)
