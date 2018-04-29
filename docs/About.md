[Website Home Page](README.md)

# About wtPLSQL

***
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

## Goals
This project focuses on providing a **simple**, yet **robust**, framework for **dynamic**, **white box** testing of **Oracle Database Objects**.

### Simple Framework
[Kent wants people to control their own environment, so he liked to have each team build the framework themselves](https://martinfowler.com/bliki/Xunit.html)

The wtPLSQL project is an attempt to allow PL/SQL developers to be PL/SQL developers.  The test runners are entirely user-written in PL/SQL.  The framework supplies resources for collecting and reporting information from those test runners.  Through its simplified architecture and open source approach, extensions of the functionality are relatively easy.

### Robust Framework
[Robustness is the ability of a computer system to cope with errors during execution](https://en.wikipedia.org/wiki/Robustness_(computer_science))

The wtPLSQL framework includes provisions for the following errors during execution:
* Un-handled test runner exceptions
* Storage of a large test result sets
* Isolation of test runner results during concurrent test runs.

### Dynamic Testing
[Testing that takes place when the program itself is run.](https://en.wikipedia.org/wiki/Software_testing#Static_vs._dynamic_testing)

The wtPLSQL framework supports testing of source code during its execution.  That is, the source code is executed during testing.  It is not a static code analyzer or a guide for review meetings.

### White Box Testing
[Tests internal structures or workings of a program](https://en.wikipedia.org/wiki/Software_testing#White-box_testing)

The [essence of white box testing](https://en.wikipedia.org/wiki/White-box_testing#Overview) is the careful testing of the application at the source code level to prevent any hidden errors later on.  A key measure of completeness for this kind of testing is the [code coverage](https://en.wikipedia.org/wiki/Code_coverage) of the test.  A complete white box test will achieve 100% code coverage.  This does not guarantee all aspects of the code have been tested, but it does ensure that all code pathways have been tested.

An important part of establishing code coverage is identifying what code is being tested. The wtPLSQL framework uses a DBOUT (DataBase Object Under Test) to identify the code being tested. Upon identifying the DBOUT, the framework can gather and report information regarding code coverage.

### Oracle Database Objects
[Some of the (database) objects that schemas can contain are Packages, Procedures, Functions, Triggers, and Views.](https://docs.oracle.com/database/122/CNCPT/tables-and-table-clusters.htm#GUID-7567BE77-AFC0-446C-832A-FCC1337DEED8)

utPLSQL V1 and V2 targeted PL/SQL packages for the testing.  However, other database objects need to be tested as well.  PL/SQL procedures and functions that are created outside of packages need to be tested.  Triggers containing PL/SQL need to be tested.  With the addition of inline functions in SQL, views can contain PL/SQL as well.  [Oracle Type Bodies](https://docs.oracle.com/database/122/ADOBJ/object-methods.htm#ADOBJ00202) also include PL/SQL procedures and functions.  All of these database objects can be tested with wtPSQL.

In the wtPLSQL framework, the DBOUT can be any of the following PL/SQL objects:
* Packages
* Procedures (standalone)
* Functions (standalone)
* Triggers
* Views (Not yet implemented)

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

## Test Driven Development
With **TDD** (Test Driven Development), [you write a test before you write just enough production code to fulfill that test](http://agiledata.org/essays/tdd.html)

The wtPLSQL framework is not intended for Test Driven Development.  100% code coverage is not desirable under the **TDD** approach.  Test isolation and test transience are welcomed mechanisms to assist in getting tests to pass quickly in **TDD**.  The wtPLSQL framework embraces 100% code coverage and does not require test isolation or test transience.

[Website Home Page](README.md)
