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

   PROCEDURE wtplsql_run IS
   BEGIN
      wtplsql.g_DBOUT := 'TRUNCIT:PROCEDURE';
      ut_setup;
      ut_TRUNCIT;
      ut_teardown;
   END wtplsql_run;
END ut_truncit;
/
```

The SET DBOUT annotation was also added to gather code coverage data.


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
   wtplsql.test_run('UT_TRUNCIT');
   wtp.wt_persist_report.dbms_out(in_runner_owner => USER
                                 ,in_runner_name  => 'UT_TRUNCIT'
                                 ,in_detail_level => 30);
end;
/
```

And Get This:

```
  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Test Results for WT_DEMO.UT_TRUNCIT
  Run ID 49: 13-Apr-2024 06:48:15 PM
  --------------------------------------------------------------
  Minimum Elapsed msec:      559      Total Assertions:        1
  Average Elapsed msec:      559     Failed Assertions:        0
  Maximum Elapsed msec:      559       Total Testcases:        1
  Total Run Time (sec):      1.0      Failed Testcases:        0
                                        Testcase Yield:      100%

  Code Coverage for PROCEDURE WT_DEMO.TRUNCIT
  ----------------------------------------------------------------
          Ignored Lines:        0   Total Profiled Lines:        3
         Excluded Lines:        0   Total Executed Lines:        2
  Minimum LineExec usec:        2     Not Executed Lines:        0
  Average LineExec usec:    16393          Unknown Lines:        1
  Maximum LineExec usec:    32778          Code Coverage:    100.0%
  Trigger Source Offset:        0                                 

  WT_DEMO.UT_TRUNCIT Test Result Details
  Test Run ID: 49
  --------------------------------------------------------------
---***  WT_DEMO.UT_TRUNCIT  ***-------------------------------------------------
 PASS 559.ms Test of TRUNCIT. EQ - Expected "0" and got "0"

  WT_DEMO.TRUNCIT PROCEDURE Code Coverage Details
  Test Run ID: 49
  ----------------------------------------------------------------
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     1 UNKN      0         1       1         1 PROCEDURE truncit (
     7 EXEC      1     32784       6     32778    EXECUTE IMMEDIATE 'truncate table ' || NVL (sch, USER) || '.' || tab;
     8 EXEC      1         2       2         2 END;
```

---
[Demos and Examples](README.md)
