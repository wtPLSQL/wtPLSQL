[Website Home Page](README.md)

# Core Features

---
## PLSQL Driven Testing
User written test runner packages are collections of assertions.  The simplest way to get started with testing is to create a test runner package with a single assertion.  After the one assertion is successfully running, more assertions and supporting PL/SQL can be added until white-box testing is complete.  A test runner package can also call other packages.  Groups of assertions can be separated into test cases.  The test runner package can also be the same package as the package being tested (embedded test runner).

## Test Anything in the Oracle database
Because the test runner packages are user written, they can be used to test anything in the database.
- PL/SQL Packages, Procedures, Functions
- Table Constraints and Triggers
- Types and Type Bodies

## Built-in Code Coverage
The Database Object Under Test, or DBOUT, is a database object that is the target of the test runner package.  An annotation is used to identify the DBOUT in a test runner package.  If the DBOUT annotation is missing from a test runner package, no code coverage data is collected.  If more than one annotation occurs in a test runner package, the first occurrence in the source code is used.

**Regular Expression:**
```
    --% WTPLSQL SET DBOUT "[[:alnum:]._$#]+" %--
```
**Example:**
```
    --% WTPLSQL SET DBOUT "SCHEMA.TEST_ME" %--
```
"Ignore" annotations are used to indicate source code lines to ignore when calculating code coverage metrics.

**Regular Expression:**
```
    --%WTPLSQL_(begin|end)_ignore_lines%--
```
**Example:**
```
    --%WTPLSQL_begin_ignore_lines%--
```
Occasionally, DBMS_PROFILER does not capture the execution of some PL/SQL source.  Examples PL/SQL source that are reported incorrectly include "end if", "select", and "return".  wtPLSQL excludes some of these source lines when calculating code coverage metrics.  Use the "Ignore" annotations to ignore other lines of PL/SQL when calculating code coverage metrics.

## Built-in Schema-wide Testing
wtPLSQL will locate and execute all test runner packages in a schema.  This is done by finding all packages with a WTPLSQL_RUN procedure that has no parameters.  There is no requirement to pre-define the test runners in a schema.

## Test Result Capture
Test results from assertions executed in a test runner package are automatically captured in WTPLSQL database tables.  Results are stored by test runner execution.  If specified in the test runner, test results are stored by test case.  If a DBOUT is specified in the test runner, code coverage data is also stored.  All captured data is automatically deleted except for the last 20 runs of any test runner.

## Test Result Reporting
Reporting of the assertion test results is not a included with the execution of the test runner package(s).  Some other mechanism, like the reporting package, must be used to display the assertion test results.  This allows the following choices during test execution:
- **Run the WT_TEXT_REPORT.DBMS_OUT Report** - This is the default Reporting Package to report test results using DBMS_OUTPUT.  Several parameter options are available to change level of detail and report sequencing.
- **Run an Add-On Reporting Package** - Bespoke reporting packages can be created or downloaded to provide for the exact requirements of test result reporting.
- **Copy Test Results** - Create or download bespoke storage and reporting systems that copy the test result data from the WTPLSQL database tables for more complex test result reporting.
- **No Action** - Test results remain in the WTPLSQL database tables until they are automatically deleted.

## Stand Alone Assertion Execution
In utPLSQL V2, executing an assertion outside of the test execution procedure produced an error message.  wtPLSQL allows a single assertion can be executed outside of the WTPLSQL.test_run procedure.  The results of the assertion will be output to DBMS_OUTPUT.  The result is the same when executing a WTPLSQL_RUN procedure in a test runner package.

## Private Procedure Testing within a Package
One of the difficult parts of testing a package is testing the private "internals" within the package.  With wtPLSQL, the test runner procedure (WTPLSQL_RUN) can be included, or embedded, in the package that is being testing.  In this way, the test runner has full access to all internal procedures and variables.  It also keeps the package and the test together.  The test runner can be "hidden" in the production deployment by using the "PLSQL_CCFLAGS" conditional compilation select directives.  If the directive is missing, FALSE is assumed:

```
alter system set PLSQL_CCFLAGS = 'WTPLSQL_ENABLE:TRUE';
```

## Optional Setup and Teardown
In utPLSQL V2, setup and teardown procedures were required in each test suite.  V2 also has a "per method setup" parameter to control startup and teardown timing/sequencing.  In wtPSQL, setup and teardown are optional.  Setup and teardown are written into a test runner package.

## Simpler Installation Scripts
In utPLSQL V2, a very sophisticated set of installation scripts are available.  The source code for these scripts is very complex.  wtPLSQL will use simpler installation scripts for core and option installation.  This will require multiple installation steps on the part of the DBA. (Simplicity of coding has priority over convenience of installation)

## Minimal Database Footprint
In utPLSQL V2, an extensive amount of source code is dedicated to the detection and adaptation of previous releases of Oracle, as far back as Oracle database version 6.  In wtPLSQL, the minimum edition of the oldest available Oracle database version is supported. Currently, Oracle XE 11gR2 is the minimum edition of the oldest available Oracle database version. Any testing of features in Oracle database releases beyond Oracle 11g XE will be included in Oracle edition and database version specific "options".

## Operation Overview
When the WTPLSQL.test_run procedure is called, a test runner package name is passed in as a parameter.  The "WTPLSQL_RUN" procedure in the test runner package is called with an EXECUTE IMMEDIATE.  An exception handler is used in the WTPLSQL package to catch any exceptions raised from a test runner Package.  Results from assertions are immediately stored in a Nested Table in the WTPLSQL package.  After the test runner completes execution, the results are transferred into database tables.

The WTPLSQL.test_all procedure will locate all test runner packages (containing the WTPLSQL_RUN procedure) and execute them using the WTPLSQL.test_run procedure.

---
[Website Home Page](README.md)
