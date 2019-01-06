[Website Home Page](README.md)

# About wtPLSQL

---
## From utPLSQL to wtPLSQL
Because of his reputation with Oracle's PL/SQL, Steven Feuerstein's utPLSQL has been widely adopted.  However, maintenance of the utPLSQL source code became a problem with the latest utPLSQL V2 releases.  Inspection of the utPLSQL V2 source code revealed some very complex code pathways.  Much of this resulted from the layering of the V1 API on top of the V2 implementation.  There is no documentation on how the V1 layering was intended to work.  There is no documentation on the overall design of the V2 implementation.  There is no documentation on how to use the V2 API.  (Kudos to [@PaulWalkerUK](https://github.com/PaulWalkerUK) for an amazing job of maintaining the V2 code set.)  As a result, most all unit tests written with utPLSQL V2 use the V1 APIs.

The utPLSQL V3 project was started with a "clean sheet" approach.  The project took a distinctly object oriented direction.  This is apropos, given that Steven Feuerstein subtitles utPLSQL as "JUnit for PLSQL".  The V3 project has also adopted other aspects of JUnit testing like annotations.  It is a clever and useful approach and will be familiar to Java developers. [@jgebal](https://github.com/jgebal) was part of the utPLSQL V3 development from the beginning and continues to provide excellent contributions and information for that project.

Before the "clean sheet" approach was adopted, the V3 team reviewed what has been published as the [utPLSQL_Lite project](https://github.com/DDieterich/utplsql_lite).  The utPSQL_Lite project was an effort to create a simplified utPLSQL core with the use of options/add-ons to achieve additional functionality.

The wtPLSQL project is a continuation of the utPLSQL_Lite project.

## What is wtPLSQL (Whitebox Testing PL/SQL)?

wtPLSQL helps with white-box testing of Oracle database objects.  It is particularly well suited for unit testing and simple integration testing.  It is written in PL/SQL.  It contains a self-test which makes it easier to support and customize.

wtPLSQL provides a set of assertion tests that can be used to determine how well an Oracle database object is performing. These assertions record the outcome (success or failure) of each test. These assertions also record the time between calls. A test runner (PL/SQL package) must be created with these assertion tests included.

wtPLSQL implements the basic/core functionality of utPLSQL V2 while preserving the programming investment in the assertion API (utAssert.eq, utAssert.isnotnull, etc.). The additional functionality of utPLSQL V2 that is not included in the wtPLSQL core component will be achieved through add-ons.

## Goals
This project focuses on providing a **simple**, yet **robust**, server for **dynamic**, **white box** testing of **Oracle Database Objects**.

### Simple Server
[Kent wants people to control their own environment, so he liked to have each team build the framework themselves](https://martinfowler.com/bliki/Xunit.html)

The wtPLSQL project is an attempt to allow PL/SQL developers to be PL/SQL developers.  The test runners are entirely user-written in PL/SQL.  The server supplies resources for collecting and reporting information from those test runners.  Through its simplified architecture, configurable hooks, and open source approach, extensions of the functionality are relatively easy.

### Robust Server
[Robustness is the ability of a computer system to cope with errors during execution](https://en.wikipedia.org/wiki/Robustness_(computer_science))

The wtPLSQL server includes provisions for the following errors during execution:
* Un-handled test runner exceptions.
* Isolation of different test runner results during concurrent test runs.
* Missing or non-existent test runners.
* Storage errors from too many old test result sets (persist add-on).
* Incorrect/incompatibly DBMS_PROFILER version (persist add-on).

### Dynamic Testing
[Testing that takes place when the program itself is run.](https://en.wikipedia.org/wiki/Software_testing#Static_vs._dynamic_testing)

The wtPLSQL server supports testing of source code during its execution.  That is, the source code is executed during testing.  It is not a static code analyzer or a guide for review meetings.

### White Box Testing
[Tests internal structures or workings of a program](https://en.wikipedia.org/wiki/Software_testing#White-box_testing)

The [essence of white box testing](https://en.wikipedia.org/wiki/White-box_testing#Overview) is the careful testing of the application at the source code level to prevent any hidden errors later on.  A key measure of completeness for this kind of testing is the [code coverage](https://en.wikipedia.org/wiki/Code_coverage) of the test.  A complete white box test will achieve 100% code coverage (*if the needed line feeds are in the PL/SQL source*).  This does not guarantee all aspects of the code have been tested but it does ensure that all code pathways have been tested (*if the needed line feeds are in the PL/SQL source*).

An important part of establishing code coverage is identifying what code is being tested. The Persist add-on uses a DBOUT (DataBase Object Under Test) to identify the code being tested. Upon identifying the DBOUT, code coverage information can be gathered and reported.

### Support for various Testing Levels

[Broadly speaking, there are at least three levels of testing: unit testing, integration testing, and system testing.](https://en.wikipedia.org/wiki/Software_testing#Testing_levels)

wtPLSQL is useful for all levels of testing.  White box testing is especially useful for testing at the unit level.  The flexibility of a Test Runner package is useful for testing at the integration and system levels.

### Oracle Database Objects
[Some of the (database) objects that schemas can contain are Packages, Procedures, Functions, Triggers, and Views.](https://docs.oracle.com/database/122/CNCPT/tables-and-table-clusters.htm#GUID-7567BE77-AFC0-446C-832A-FCC1337DEED8)

With the wtPLSQL server, Test Runner code coverage can be tracked on any of the following PL/SQL objects:
* Functions
* Packages
* Procedures
* Triggers
* Type Bodies

### Embedded Selftest

[Put Test Code in Same Package](https://utplsql.org/utPLSQL/v2.3.1/samepack.html)

With utPLSQL V1/V2, packages can include an embedded self-test. The required calls can be exposed within the package that is being tested. This is particularly useful for testing package internals like private variables and procedures. These embedded selftests also remove the need to expose private variables and procedures to public calls so they can be tested.

wtPLSQL continues this capability. However, with wtPLSQL, the addition of an embedded selftest requires only 1 additional procedure call in the package specification (WTPLSQL_RUN).

## History of utPLSQL
Following are some links regarding the history of utPLSQL.

[Steven Feuerstein Designed and Developed utPLSQL (V1)](http://archive.oreilly.com/pub/a/oreilly/oracle/utplsql/)

[Steven Feuerstein's Recommendations for Unit Testing PL/SQL Programs](http://stevenfeuersteinonplsql.blogspot.com/2015/03/recommendations-for-unit-testing-plsql.html)

[utPLSQL V2 Documentation](https://utplsql.org/utPLSQL/v2.3.1/)

[utPLSQL V3 Website](https://utplsql.org/)

---
[Website Home Page](README.md)
