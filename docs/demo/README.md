[Website Home Page](../README.md)

# Demonstrations and Examples

---

Demonstrations and examples assume successful connection to an [Oracle database](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html) with wtPLSQL installed. wtPLSQL Installation instructions are available on the [wtPLSQL Releases page](https://github.com/DDieterich/wtPLSQL/releases).

Test results from assertions can be queried from a set of wtPLSQL tables. The examples here will use the default reporting package called WT_TEXT_REPORT.  This package displays test results using DBMS_OUTPUT.

## The Basics

A login, or database session, is required to interact with the Oracle database.  The SQL below will create a user that can run these examples.  If you already have a database login, this is not necessary.

```
create user wtp_demo identified by wtp_demo
   default tablespace users
   quota unlimited on users
   temporary tablespace temp;

grant create session   to wtp_demo;
grant create type      to wtp_demo;
grant create sequence  to wtp_demo;
grant create table     to wtp_demo;
grant create trigger   to wtp_demo;
grant create view      to wtp_demo;
grant create procedure to wtp_demo;
```

The simplest check for a wtPLSQL installation is to select the "version from dual".

Run this:

```
select wtplsql.show_version from dual;
```

And get this:

```
SHOW_VERSION
-----------------------------------------------------------
1.1.0
```

This shows the wtPLSQL version as 1.1.0.

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

This indicates:
 * the assertion passed
 * the assertion had the message "Ad-Hoc Test"
 * the assertion name is "EQ"
 * the assertion details which may include the values tested

Note: This ad-hoc test also demonstrates implicit data type conversion.

## Create a Test Runner Package

A test runner package is central to running tests in wtPLSQL.  The [Test Runner](Test-Runner.md) page covers all the basics of creating a test runner package.

## Database Object Tests
More interesting examples actually test database objects. Here are some examples.
* [Package Test](Package-Test.md)
* [Table Constraints Test](Table-Test.md)
* [Trigger Test](Trigger-Test.md)
* [Type Test](Type-Test.md)

## utPLSQL 2.3 Examples
wtPLSQL was built with the utPLSQL "ut_assert" API.  These examples were created from the original utPLSQL 2.3 examples without modifying the "ut_assert" calls

* [ut_betwnstr](ut_betwnstr.md) - Choose a program to test
* [ut_calc_secs_between](ut_calc_secs_between.md) - Test a Simple Procedure
* [ut_truncit](ut_truncit.md) - Test a Table Modification Procedure
* [ut_str](ut_str.md) - Test a Simple Function

## Demo Installer
To save some typing, there is an installer for the demonstrations and examples.  This installer will:
* Prompt for a schema name (WT_DEMO is the default).
* Confirm the database user is SYS or SYSTEM.
* Create the schema.
* Load database objects in the schema.

To run this installer:
1. cd to "src/demo"
1. login as SYS or SYSTEM using SQL*Plus
1. Run the "install.sql" script

To confirm a successful installation, review the newly created "install.LST" log file against the "installO.LST" example log file.

## Demo Un-Install

The "uninstall.sql" script provided in the "src/demo" directory drops the demo schema from the database, with cascade.

To un-install:
1. cd to "src/demo"
1. login as SYS or SYSTEM using SQL*Plus
1. Run the "uninstall.sql" script


To confirm a successful un-install, review the "uninstall.LST" log file against the "uninstallO.LST" example log file.

---
[Website Home Page](../README.md)