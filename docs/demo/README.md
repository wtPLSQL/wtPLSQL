# Demonstrations and Examples
---
Demonstrations and examples assume successful connection to an [Oracle database](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html) with wtPLSQL installed. [wtPLSQL Installation instructions](https://github.com/DDieterich/wtPLSQL/releases) are available on the [wtPLSQL Releases page](https://github.com/DDieterich/wtPLSQL/releases).

## Simple Stuff

The simplest check for a wtPLSQL installation is to select the "version from dual".

Run this:
```
select wtplsql.show_version from dual;
```
and get this:
```
SHOW_VERSION
------------
1.1.0
```

Another simple test is an ad-hoc assertion. This test requires DBMS_OUTPUT. The results of this test are not recorded.

Run this:
```
set serveroutput on size unlimited format word_wrapped

begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end;
/
```
And get this:
```
PASS Ad-Hoc Test. EQ - Expected "1" and got "1"
```

Note: This ad-hoc test also demonstrates implicit data type conversion.

The majority of wtPLSQL testing uses a Test Runner. A Test Runner is a PL/SQL package written by the tester. [This page](Test-Runner.md) has an example of a very simple [Test Runner](Test-Runner.md). All the examples below will use Test Runners.

## Database Object Tests
More interesting examples actually test database objects. Here is an example test of each database object supported by wtPLSQL.
* [Package Test](Package-Test.md) (Not Ready)
* [Procedure Test](Procedure-Test.md) (Not Ready)
* [Function Test](Function-Test.md) (Not Ready)
* [Table Constraints Test](Table-Constraints-Test.md) (Not Ready)
* [Table Trigger Test](Table-Trigger-Test.md) (Not Ready)
* [Type Test](Type-Test.md) (Not Ready)

## utPLSQL 2.3 Examples
* [ut_calc_secs_between](ut_calc_secs_between.md) - Test a Simple Procedure (Not Ready)
* [ut_truncit](ut_truncit.md) - Test a Table Modification Procedure (Not Ready)
* [ut_str](ut_str.md) - Test a Simple Function (Not Ready)
* [ut_del1](ut_del1.md) - Test an Entire Package (Not Ready)
* [Create and Run a Test Suite](Test-Suite.md) - Build a Test Suite package. (Not Ready)
* [ut_betwnstr](ut_betwnstr.md) (Not Ready)
* [Version](Version.md) (Not Ready)
