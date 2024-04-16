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

The Persist add-on must be installed.

Run this to setup HOOKS:

```
begin
   wtp.junit_core_report.delete_hooks;
   wtp.wt_core_report.delete_hooks;
   wtp.wt_test_run.insert_hooks;
end;
/
```

Run this:

```
begin
   wtplsql.test_run('UT_CALC_SECS_BETWEEN');
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'UT_CALC_SECS_BETWEEN'
                                 ,in_detail_level => 30);
end;
/
```

And Get This:

```
  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Test Results for WT_DEMO.UT_CALC_SECS_BETWEEN
  Run ID 48: 13-Apr-2024 06:44:27 PM
  --------------------------------------------------------------
  Minimum Elapsed msec:        0      Total Assertions:        2
  Average Elapsed msec:        1     Failed Assertions:        0
  Maximum Elapsed msec:        0       Total Testcases:        1
  Total Run Time (sec):      0.2      Failed Testcases:        0
                                        Testcase Yield:      100%

  Code Coverage for PROCEDURE WT_DEMO.CALC_SECS_BETWEEN
  ----------------------------------------------------------------
          Ignored Lines:        0   Total Profiled Lines:        3
         Excluded Lines:        0   Total Executed Lines:        2
  Minimum LineExec usec:        0     Not Executed Lines:        0
  Average LineExec usec:        2          Unknown Lines:        1
  Maximum LineExec usec:        6          Code Coverage:    100.0%
  Trigger Source Offset:        0                                 

  WT_DEMO.UT_CALC_SECS_BETWEEN Test Result Details
  Test Run ID: 48
  --------------------------------------------------------------
---***  WT_DEMO.UT_CALC_SECS_BETWEEN  ***---------------------------------------
 PASS .499ms Same dates. EQ - Expected "0" and got "0"
 PASS .095ms Exactly one day. EQ - Expected "86400" and got "86400"

  WT_DEMO.CALC_SECS_BETWEEN PROCEDURE Code Coverage Details
  Test Run ID: 48
  ----------------------------------------------------------------
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     1 UNKN      0         1       0         1 PROCEDURE calc_secs_between (
    10 EXEC      2         8       1         6    secs := (date2 - date1) * 24 * 60 * 60;
    11 EXEC      2         0       0         0 END;
```

---
[Demos and Examples](README.md)
