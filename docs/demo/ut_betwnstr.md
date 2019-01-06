[Demos and Examples](README.md)

# utPLSQL 2.3 ut_betwnstr Example

---

## Original Example

The [original "ut_betwnstr" example](https://utplsql.org/utPLSQL/v2.3.1/fourstep.html) is in the utPLSQL documentation.  The PL/SQL source for the function that will be tested is in Step 2.  The PL/SQL source for the package specification and body of the utPLSQL test package are in Step 3.

## Test Package Conversion

Conversion of this test package into a test runner package requires the addition of the "wtPLSQL_run" procedure in the package specification.

Run this:

```
CREATE OR REPLACE PACKAGE ut_betwnstr
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;
   
   PROCEDURE ut_betwnstr;
   PROCEDURE wtplsql_run;
END ut_betwnstr;
/
```

Likewise, the package body needs the wtPLSQL_run procedure.

Run this:

```
CREATE OR REPLACE PACKAGE BODY ut_betwnstr
IS
   PROCEDURE ut_setup IS
   BEGIN
      NULL;
   END;
   
   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_betwnstr IS
   BEGIN
      utAssert.eq (
         'Typical valid usage',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 3,
            END_IN => 5
         ),
         'cde'
      );

      utAssert.isnull (
         'NULL start',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => NULL,
            END_IN => 5
         )
      );
      
      utAssert.isnull (
         'NULL end',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 2,
            END_IN => NULL
         )
      );
      
      utAssert.isnull (
         'End smaller than start',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 5,
            END_IN => 2
         )
      );
      
      utAssert.eq (
         'End larger than string length',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 3,
            END_IN => 200
         ),
         'cdefg'
      );

   END ut_BETWNSTR;

   --% WTPLSQL SET DBOUT "BETWNSTR:FUNCTION" %--
   PROCEDURE wtPLSQL_run IS
   BEGIN
      ut_setup;
      ut_betwnstr;
      ut_teardown;
   END wtPLSQL_run;
   
END ut_betwnstr;
/
```

It is not necessary to keep the ut_setup and ut_teardown procedures.  These were kept to indicate how to incorporate those procedures into a test runner package.  The SET DBOUT annotation was also added to gather code coverage data.


## Check the Results

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('UT_BETWNSTR');
   wt_text_report.dbms_out(USER,'UT_BETWNSTR',30);
end;
/
```

And Get This:

```
  Code Coverage for FUNCTION WTP_DEMO.BETWNSTR
          Ignored Lines:        0   Total Profiled Lines:        3
         Excluded Lines:        0   Total Executed Lines:        2
  Minimum LineExec usec:        0     Not Executed Lines:        0
  Average LineExec usec:        2          Unknown Lines:        1
  Maximum LineExec usec:       12          Code Coverage:   100.00%
  Trigger Source Offset:        0

 - WTP_DEMO.UT_BETWNSTR Test Result Details (Test Run ID 78)
-----------------------------------------------------------
 PASS  155ms Typical valid usage. EQ - Expected "cde" and got "cde"
 PASS    0ms NULL start. ISNULL - Expected NULL and got ""
 PASS    0ms NULL end. ISNULL - Expected NULL and got ""
 PASS    0ms End smaller than start. ISNULL - Expected NULL and got ""
 PASS    0ms End larger than string length. EQ - Expected "cdefg" and got "cdefg"

 - WTP_DEMO.BETWNSTR FUNCTION Code Coverage Details (Test Run ID 78)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     1 UNKN      0         5       1         2 function betwnstr
     8 EXEC      5        19       1        12    return (
    15 EXEC      5         1       0         1 end;
```

---
[Demos and Examples](README.md)
