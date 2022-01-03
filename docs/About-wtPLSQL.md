[Website Home Page](README.md)

# About wtPLSQL

---
## History
Following are some links regarding the history of utPLSQL.

[Steven Feuerstein Designed and Developed utPLSQL (V1)](http://archive.oreilly.com/pub/a/oreilly/oracle/utplsql/)

[Steven Feuerstein's Recommendations for Unit Testing PL/SQL Programs](http://stevenfeuersteinonplsql.blogspot.com/2015/03/recommendations-for-unit-testing-plsql.html)

[utPLSQL V2 Documentation](https://utplsql.org/utPLSQL/v2.3.1/)

[utPLSQL V3 Website](https://utplsql.org/)

## Background
Because of his reputation with Oracle's PL/SQL, Steven Feuerstein's utPLSQL has been widely adopted.  However, maintenance of the utPLSQL source code became a problem with the latest utPLSQL V2 releases.  Inspection of the utPLSQL V2 source code revealed some very complex code pathways.  Much of this resulted from the layering of the V1 API on top of the V2 implementation.  There is no documentation on how the V1 layering was intended to work.  There is no documentation on the overall design of the V2 implementation.  There is no documentation on how to use the V2 API.  (Kudos to [@PaulWalkerUK](https://github.com/PaulWalkerUK) for an amazing job of maintaining the V2 code set.)  As a result, most all unit tests written with utPLSQL V2 use the V1 APIs.

The utPLSQL V3 project was started with a "clean sheet" approach.  The project took a distinctly object oriented direction.  This is apropos, given that Steven Feuerstein subtitles utPLSQL as "JUnit for PLSQL".  The V3 project has also adopted other aspects of JUnit testing like annotations.  It is a clever and useful approach and will be familiar to Java developers. [@jgebal](https://github.com/jgebal) was part of the utPLSQL V3 development from the beginning and continues to provide excellent contributions and information for that project.

Before the "clean sheet" approach was adopted, the V3 team reviewed what has been published as the [utPLSQL_Lite project](https://github.com/DDieterich/utplsql_lite).  The utPSQL_Lite project was an effort to create a simplified utPLSQL core with the use of options/add-ons to achieve additional functionality.

The wtPLSQL project is a continuation of the utPLSQL_Lite project.

## What is wtPLSQL (Whitebox Testing PL/SQL)?

wtPLSQL helps with white-box testing of Oracle database objects.  It is particularly well suited for unit testing and simple integration testing.  It is written in PL/SQL.  It contains a self-test which makes it easier to support and customize.

wtPLSQL provides a set of assertion tests that can be used to determine how well an Oracle database object is performing. These assertions record the outcome (success or failure) of each test. These assertions also record the time between calls. A test runner (PL/SQL package) must be created with these assertion tests included.

wtPLSQL implements the basic/core functionality of utPLSQL V2 while preserving the programming investment in the assertion API (utAssert.eq, utAssert.isnotnull, etc.). The additional functionality of utPLSQL V2 that is not included in the wtPLSQL core component will be achieved through add-ons.

## Goals
This project focuses on providing a **simple**, yet **robust**, framework for **dynamic**, **white box** testing of **Oracle Database Objects**.

### Simple Framework
[Kent wants people to control their own environment, so he liked to have each team build the framework themselves](https://martinfowler.com/bliki/Xunit.html)

The wtPLSQL project is an attempt to allow PL/SQL developers to be PL/SQL developers.  The test runners are entirely user-written in PL/SQL.  The framework supplies resources for collecting and reporting information from those test runners.  Through its simplified architecture, configurable hooks, and open source approach, extensions of the functionality are relatively easy.

### Robust Framework
[Robustness is the ability of a computer system to cope with errors during execution](https://en.wikipedia.org/wiki/Robustness_(computer_science))

The wtPLSQL framework includes provisions for the following errors during execution:
* Un-handled test runner exceptions
* Storage errors from too many old test result sets.
* Isolation of different test runner results during concurrent test runs.
* Missing or non-existent test runners.
* Incorrect/incompatable DBMS_PROFILER version

### Dynamic Testing
[Testing that takes place when the program itself is run.](https://en.wikipedia.org/wiki/Software_testing#Static_vs._dynamic_testing)

The wtPLSQL framework supports testing of source code during its execution.  That is, the source code is executed during testing.  It is not a static code analyzer or a guide for review meetings.

### White Box Testing
[Tests internal structures or workings of a program](https://en.wikipedia.org/wiki/Software_testing#White-box_testing)

The [essence of white box testing](https://en.wikipedia.org/wiki/White-box_testing#Overview) is the careful testing of the application at the source code level to prevent any hidden errors later on.  A key measure of completeness for this kind of testing is the [code coverage](https://en.wikipedia.org/wiki/Code_coverage) of the test.  A complete white box test will achieve 100% code coverage (*if the needed line feeds are in the PL/SQL source*).  This does not guarantee all aspects of the code have been tested but it does ensure that all code pathways have been tested (*if the needed line feeds are in the PL/SQL source*).

An important part of establishing code coverage is identifying what code is being tested. The Persist add-on uses a DBOUT (DataBase Object Under Test) to identify the code being tested. Upon identifying the DBOUT, code coverage information can be gathered and reported.

### Support for various Testing Levels

[Broadly speaking, there are at least three levels of testing: unit testing, integration testing, and system testing.](https://en.wikipedia.org/wiki/Software_testing#Testing_levels)

wtPLSQL is useful for all levels of testing.  White box testing is especially useful for testing at the unit level.  The flexibility of a Test Runner package is useful for testing at the integration and system levels.

An important part of establishing code coverage is identifying what code is being tested. The wtPLSQL framework uses a DBOUT (DataBase Object Under Test) to identify the code being tested. Upon identifying the DBOUT, the framework can gather and report information regarding code coverage.

### Oracle Database Objects
[Some of the (database) objects that schemas can contain are Packages, Procedures, Functions, Triggers, and Views.](https://docs.oracle.com/database/122/CNCPT/tables-and-table-clusters.htm#GUID-7567BE77-AFC0-446C-832A-FCC1337DEED8)

Many kinds of database objects need to be tested, not just packages. Triggers containing PL/SQL need to be tested.  With the addition of [inline functions in SQL](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/sqlrf/SELECT.html#GUID-CFA006CA-6FF1-4972-821E-6996142A51C6__BABJFIDC), views can contain PL/SQL as well.  [Oracle Type Bodies](https://docs.oracle.com/database/122/ADOBJ/object-methods.htm#ADOBJ00202) also include PL/SQL procedures and functions.  All of these database objects can be tested with wtPSQL.

In the wtPLSQL framework, the DBOUT can be any of the following PL/SQL objects:
* Packages
* Procedures (standalone)
* Functions (standalone)
* Triggers
* Views (Not yet implemented)

### Embedded Selftest

[Put Test Code in Same Package](https://utplsql.org/utPLSQL/v2.3.1/samepack.html)

With utPLSQL V1/V2, packages can include an embedded self-test. The required calls can be exposed within the package that is being tested. This is particularly useful for testing package internals like private variables and procedures. These embedded selftests also remove the need to expose private variables and procedures to public calls so they can be tested.

wtPLSQL continues this capability. However, with wtPLSQL, the addition of an embedded selftest requires only 1 additional procedure call in the package specification (WTPLSQL_RUN).

## Unit Testing
As mentioned above, white box testing can occur at various levels of development, including:
* **unit testing**
* integration testing
* regression testing.

The wtPLSQL project focuses on white box testing instead of **unit testing** in order to avoid some controversial aspects of unit testing, namely Test Isolation and Test Transience.

### Test Isolation
A unit test should [usually not go outside of its own class boundary](https://en.wikipedia.org/wiki/Unit_testing#Description)

In OO (object oriented) programming, object data is transient.  This is due to the nature of object instantiation.  Persistence of object data beyond the instance of an object is banished to non-OO components.  Since the unit test movement gained its largest following in OO, the idea of testing persisted object data is, unfortunately, a distraction.  This has evolved into the idea that testing a database interface should always involve the use of a [fake or mock](https://en.wikipedia.org/wiki/Test-driven_development#Fakes.2C_mocks_and_integration_tests) to **isolate** the unit under test from the influence of these non-OO components.

Transactional data (ACID compliance) introduces a complexity to the persistence of object data. Attempting to fake this complexity is very difficult.  Particularly difficult is the determination of how much functionality to include in the fake, especially when the storage of the data is the main purpose for the system.  Focusing on white box testing, instead of unit testing, allows the wtPLSQL framework to test integrated functionality from other system components.

### Test Transience
A unit test should set up a known good state before the tests and [return to the original state after the tests](https://en.wikipedia.org/wiki/XUnit#Test_fixtures)

There are many arguments to be made regarding the idea of a known good state in a database.  The only sure way to achieve a known good state is to leave the the database unchanged after a unit test.  Ideally, changes made by a test process would be **transient**, that is the process would setup (insert) and tear down (delete) data in the database.  However, many Oracle database implementations include additional functionality that can make this difficult.
* Complex data setup
* Additional processing that is unknown or poorly defined
* Built-in auditing

In the wtPLSQL framework, integration testing of multiple database objects (no mocks or fakes) is allowed (i.e. not bound by the **transience** aspect).  Artifacts from multiple test runs can remain in the database after the testing is complete.  Additionally, artifacts that remain after testing can help identify other problems in the database.

### Test Fixtures and Test Suites

[A test fixture ... is the set of preconditions or state needed to run a test](https://en.wikipedia.org/wiki/XUnit#Test_fixtures)

[A test suite is a set of tests that all share the same fixture.](https://en.wikipedia.org/wiki/XUnit#Test_suites)

Test fixtures and test suites are a part of the xUnit testing framework. At the core, wtPLSQL does not include test fixtures or test suites. If needed, these can be easily defined and implemented in a test runner package.

## Test Driven Development
With **TDD** (Test Driven Development), [you write a test before you write just enough production code to fulfill that test](http://agiledata.org/essays/tdd.html)

The wtPLSQL framework is not intended for Test Driven Development.  The wtPLSQL framework embraces 100% code coverage and does not require test isolation or test transience.

---
[Website Home Page](README.md)
