[Website Home Page](../README.md)

# Demonstrations and Examples

---

Demonstrations and examples assume successful connection to an [Oracle database](https://www.oracle.com/database/technologies/appdev/xe.html) with wtPLSQL installed. wtPLSQL Installation instructions are available on the [wtPLSQL Releases page](https://github.com/wtPLSQL/wtPLSQL/releases).

Demonstrations and examples requires the Persist add-on.  Test results from assertions can be queried from a set of wtPLSQL tables. The examples here will use the default reporting package called WT_PERSIST_REPORT.  This package displays test results using DBMS_OUTPUT.

## User Setup

A login, or database session, is required to interact with the Oracle database.  The SQL below will create a user that can run these examples.  If you already have a database login, this is not necessary.

To create a database login, run this installer:
1. cd to "src/demo"
1. login as SYS or SYSTEM using SQL*Plus
1. Run the "install_sys.sql" script

To confirm a successful install, review the "install_sys.LST" log file.


## Confirm the Installation

The simplest check for a wtPLSQL installation is to select the "version from dual".  If wtPSQL is installed, it will show which add-ons have been installed if any.

Run this:

```
select wtplsql.show_version from dual;
```

If the result is something like "wtpsrc 1.003, wtpsav 1.003", wtPSQL is installed with the Persist (wtpsav) add-on. If the result is ,missing "wtpsav", the Persist add-on has not been installed. For simplicity, the adjustments required to make the demonstrations and exercises work without the Persist add-on are not included.

### Another simple test

Another simple test is an ad-hoc assertion. The ad-hoc assertion requires DBMS_OUTPUT. The results of the ad-hoc assertions are not recorded by wtPLSQL.

Run this:

```
set serveroutput on size unlimited format truncated

begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end;
/
```

And get this:

```
Ad-Hoc Test
 Assertion EQ PASSED.
 Expected "1" and got "1"
```

This indicates:
 * the assertion had the message "Ad-Hoc Test"
 * the assertion name is "EQ"
 * the assertion passed
 * the assertion details which may include the values tested

Note: This ad-hoc test also demonstrates implicit data type conversion between number and varchar2.

## Create a Test Runner Package

Creating a Test Runner package is central to using the wtPLSQL server. The Test Runner package contains all the assertion API calls used for testing. The package can also update/change wtPSQL settings, like the name of the Database Object Under Test (DBOUT).

The web page link below includes an exercise that shows how create a Test Runner package. The web page covers all the basics of creating a Test Runner package.

[Create Test Runner Package](Test-Runner.md)

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
To save some typing, there are scripts in the "src/demo" folder for the demonstrations and examples:
* Package-Test.sql
* Table-Test.sql
* Trigger-Test.sql
* Type-Test.sql
* ut_betwnstr.sql
* ut_calc_secs_between.sql
* ut_truncit.sql
* ut_str.sql

## Demo Un-Install

The "uninstall.sql" script provided in the "src/demo" directory drops the demo schema from the database, with cascade.

To un-install:
1. cd to "src/demo"
1. login as SYS or SYSTEM using SQL*Plus
1. Run the "uninstall.sql" script


To confirm a successful un-install, review the "uninstall.LST" log file.

---

*The following applies to files and directories at this location in the documentation repository.*

File Name     | Description
--------------|------------
DBDocs        | SQL Developer DBDocs Files
*.md          | Markdown files for "github.io"
*.htm         | HTML files for local documentation
md-to-htm.bat | MS-Dos Batch File to convert MD to HTML
md-to-htm.lua | Lua script used by Pandoc for MD to HTML

To view documentation use the URL "file://README.htm" or Double-click on the README.htm file.

NOTE: All HTML files are sourced from Markdown files.
  Modify the Markdown files, then build HTML from the
  Markdown files using "md-to-htm.bat".

---
[Website Home Page](../README.md)