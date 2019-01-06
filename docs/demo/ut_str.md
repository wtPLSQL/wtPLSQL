[Demos and Examples](README.md)

# utPLSQL 2.3 ut_str Example

---

## Original Example

The [original "ut_str" example](https://utplsql.org/utPLSQL/v2.3.1/testfunc.html) is in the utPLSQL documentation.  The PL/SQL source for the package to be tested is somewhat elusive.  It is not on the website, but in the "examples" source in a files called "str.pks" and "str.pkb".  This example is the unique case of a self-testing package in utPLSQL, which is also discussed in the [Put Test Code in Same Package](https://utplsql.org/utPLSQL/v2.3.1/samepack.html) web page.  Since it is a self-testing package, all the source is included in this web page.

## Test Package Conversion

Conversion of this test package into a test runner package requires the addition of the "wtPLSQL_run" procedure in the package specification.

Run this:

```
/* Formatted on 2001/11/19 15:11 (Formatter Plus v4.5.2) */
CREATE OR REPLACE PACKAGE str
IS
   FUNCTION betwn (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2;

   FUNCTION betwn2 (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2;

   PROCEDURE ut_setup;

   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_betwn;
   PROCEDURE wtplsql_run;
END str;
/
```

Likewise, the package body needs the wtPLSQL_run procedure.

Run this:

```
/* Formatted on 2001/11/19 15:15 (Formatter Plus v4.5.2) */
CREATE OR REPLACE PACKAGE BODY str
IS
   FUNCTION betwn (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
      l_start   PLS_INTEGER := start_in;
   BEGIN
      IF l_start = 0
      THEN
         l_start := 1;
      END IF;

      RETURN (SUBSTR (
                 string_in,
                 l_start,
                   end_in
                 - l_start
                 + 1
              )
             );
   END;

   FUNCTION betwn2 (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      -- Handle negative values
      IF end_in < 0
      THEN
         RETURN betwn (string_in, start_in, end_in);
      ELSE
         RETURN (SUBSTR (
                    string_in,
                      LENGTH (string_in)
                    + end_in
                    + 1,
                      start_in
                    - end_in
                    + 1
                 )
                );
      END IF;
   END;

   --%WTPLSQL_begin_ignore_lines%--

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
   PROCEDURE ut_betwn
   IS
   BEGIN
      utassert.eq (
         'Typical Valid Usage',
         str.betwn ('this is a string', 3, 7),
         'is is'
      );
      utassert.eq (
         'Test Negative Start',
         str.betwn ('this is a string', -3, 7),
         'ing'
      );
      utassert.isnull (
         'Start bigger than end',
         str.betwn ('this is a string', 3, 1)
      );
   END;

   --% WTPLSQL SET DBOUT "STR:PACKAGE BODY" %--
   PROCEDURE wtplsql_run IS
   BEGIN
      ut_setup;
      ut_betwn;
      ut_teardown;
   END wtplsql_run;

END str;
/
```

Mid-way down the package body is the annotation "WTPLSQL_begin_ignore_lines".  This annotation defines the source lines that will not be included in the code coverage metrics.  The SET DBOUT annotation was also added to gather code coverage data.


## Check the Results

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('STR');
   wt_text_report.dbms_out(in_runner_name  => 'STR'
                          ,in_detail_level => 30);
end;
/
```

And Get This:

```
    wtPLSQL 1.1.0 - Run ID 82: 25-Jun-2018 10:08:46 PM

  Test Results for WTP_DEMO.STR
       Total Test Cases:        0       Total Assertions:        3
  Minimum Interval msec:        0      Failed Assertions:        0
  Average Interval msec:       30       Error Assertions:        0
  Maximum Interval msec:       89             Test Yield:   100.00%
   Total Run Time (sec):      0.1

  Code Coverage for PACKAGE BODY WTP_DEMO.STR
          Ignored Lines:       14   Total Profiled Lines:       25
         Excluded Lines:        1   Total Executed Lines:        4
  Minimum LineExec usec:        0     Not Executed Lines:        5
  Average LineExec usec:        0          Unknown Lines:        1
  Maximum LineExec usec:        5          Code Coverage:    44.40%
  Trigger Source Offset:        0

 - WTP_DEMO.STR Test Result Details (Test Run ID 82)
-----------------------------------------------------------
 PASS   89ms Typical Valid Usage. EQ - Expected "is is" and got "is is"
 PASS    0ms Test Negative Start. EQ - Expected "ing" and got "ing"
 PASS    0ms Start bigger than end. ISNULL - Expected NULL and got ""

 - WTP_DEMO.STR PACKAGE BODY Code Coverage Details (Test Run ID 82)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     3 UNKN      0         2       1         1    FUNCTION betwn (
    10 EXEC      3         1       0         1       l_start   PLS_INTEGER := start_in;
    12 EXEC      3         1       0         1       IF l_start = 0
    14#NOTX#     0         0       0         0          l_start := 1;
    17 EXEC      3         7       0         5       RETURN (SUBSTR (
    25 EXEC      3         1       1         1    END;
    27 EXCL      0         0       0         0    FUNCTION betwn2 (
    36#NOTX#     0         0       0         0       IF end_in < 0
    38#NOTX#     0         0       0         0          RETURN betwn (string_in, start_in, end_in);
    40#NOTX#     0         0       0         0          RETURN (SUBSTR (
    51#NOTX#     0         0       0         0    END;
    55 IGNR      0         0       0         0    PROCEDURE ut_setup
    58 IGNR      1         1       1         1       NULL;
    61 IGNR      0         0       0         0    PROCEDURE ut_teardown
    64 IGNR      1         0       0         0       NULL;
    68 IGNR      0         3       3         3    PROCEDURE ut_betwn
    71 IGNR      1        18      18        18       utassert.eq (
    76 IGNR      1         1       1         1       utassert.eq (
    81 IGNR      1         1       1         1       utassert.isnull (
    85 IGNR      1         0       0         0    END;
    88 IGNR      0         1       1         1    PROCEDURE wtplsql_run IS
    90 IGNR      1         0       0         0       ut_setup;
    91 IGNR      1         0       0         0       ut_betwn;
    92 IGNR      1         0       0         0       ut_teardown;
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
    93 IGNR      1         0       0         0    END wtplsql_run;
```

---
[Demos and Examples](README.md)
