[Website Home Page](README.md)

# OO Style Unit Testing

---

The wtPLSQL project focuses on white box testing instead of OO style unit testing.  This is done to avoid some aspects of OO style unit testing that are not database friendly:
* Test Isolation 
* Test Transience
* Test Fixtures
* Test Suites

### Test Isolation

A unit test should [usually not go outside of its own class boundary](https://en.wikipedia.org/wiki/Unit_testing#Description)

In OO (object oriented) programming, object data is transient.  This is due to the nature of object instantiation.  Persistence of object data beyond the instance of an object is banished to non-OO components.  Since the unit test movement gained its largest following in OO, the idea of testing persisted object data is, unfortunately, a distraction.  This has evolved into the idea that testing a database interface should always involve the use of a [fake or mock](https://en.wikipedia.org/wiki/Test-driven_development#Fakes.2C_mocks_and_integration_tests) to **isolate** the unit under test from the influence of these non-OO components.

Transactional data (ACID compliance) introduces a complexity to the persistence of object data. Attempting to fake this complexity is very difficult.  Particularly difficult is the determination of how much functionality to include in the fake, especially when the storage of the data is the main purpose for the system.  Focusing on white box testing, instead of unit testing, allows Test Runners that use the wtPLSQL server to test integrated functionality from other system components.

### Test Transience

A unit test should set up a known good state before the tests and [return to the original state after the tests](https://en.wikipedia.org/wiki/XUnit#Test_fixtures)

There are many arguments to be made regarding the idea of a known good state in a database.  The only sure way to achieve a known good state is to leave the the database unchanged after a unit test.  Ideally, changes made by a test process would be **transient**, that is the process would setup (insert) and tear down (delete) data in the database.  However, many Oracle database implementations include additional functionality that can make this difficult.
* Complex data setup
* Additional processing that is unknown or poorly defined
* Built-in auditing

With the wtPLSQL server, Test Runners are allow to perform integration testing of multiple database objects (no mocks or fakes). That is, the Test Runners are not bounded by the **transience** aspect of unit testing. Artifacts from multiple test runs can remain in the database after the testing is complete. Additionally, artifacts that remain after testing can help identify other problems in the database.

### Test Fixtures

[A test fixture ... is the set of preconditions or state needed to run a test](https://en.wikipedia.org/wiki/XUnit#Test_fixtures)

An Oracle database loaded with test data is a fixture. In OO terms, it is a persistent store that is pre-loaded with data. If the test data is pre-loaded, there is no need to setup test fixtures. wtPLSQL does not require test fixtures. They are optional.

### Test Suites

[A test suite is a set of tests that all share the same fixture.](https://en.wikipedia.org/wiki/XUnit#Test_suites)

wtPLSQL does not require test suites. If needed, test suites can be defined and implemented in Test Runner packages.  The "test_all" functionality of wtPLSQL creates a form of test suite at the database schema level.

## Testing Methodologies

Fundamentally, the Oracle database is a relational database. The relational database is based on transaction processing. Data is stored and shared in a precise manner between processes.

JUnit testing is OO (Object Oriented programming) based. Encapsulation is a core part of OO. Data sharing is done through APIs (Application Programmatic Interfaces), i.e. no fundamental data persistence.

The principle of "store and share" is the opposite of data encapsulation. As a result, OO testing approaches are inappropriate for relational databases.

Here are several differences in testing methodologies between relational databases and Object Oriented.

### Testing Persistence of Data
* Object Oriented - Use fakes or mocks to avoid any data persistence.
* Relational Database - Testing of data persistence is fundamental.

### Isolation of Tests
* Object Oriented - Use fakes or mocks to avoid any "integration" testing.
* Relational Database - Isolating PL/SQL code from database CRUD (Create, Retrieve, Update, Delete) defeats the purpose of most PL/SQL testing.

### Test Transience
* Object Oriented - Return object to original state.
* Relational Database - Integrity constraints on complex persisted data and/or complex data operations make simple test transience more difficult. An alternative is to add new data during each test and/or reset the database to a known test data set before testing.

### Non-Sequenced Testing
* Object Oriented - All unit tests should be able to run in any order.
* Relational Database - Testing with integrity constraints on complex persisted data and/or complex data operations can be simpler with test sequencing.

---
[Website Home Page](README.md)
