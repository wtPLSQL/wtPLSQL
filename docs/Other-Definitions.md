[Website Home Page](README.md)

# Other Definitions

---
## Oracle Database
Note: Some Oracle database terms overlap with Object Oriented terms.

**Database Object** - Listed in USER_OBJECTS.  Examples include packages, types, and tables.

**Schema** - Database owner of a database object.

***
## XUnit
These definitions were taken from [Xunit at Wikipedia](https://en.wikipedia.org/wiki/XUnit).  They include minor editing for clarification.

**Test runner** - An executable program that runs tests implemented using an xUnit framework and reports the test results.

**Test case** - The most elemental class. All unit tests are inherited from here.

**Test fixtures** - Also known as a test context. The set of preconditions or state needed to run a test. The developer should set up a known good state before the tests, and return to the original state after the tests.

**Test suites** - Set of tests that all share the same test fixture. The order of the tests shouldn't matter.

**Test execution** - The execution of an individual unit test including:
* **Setup** - First, we should prepare our 'world' to make an isolated environment for testing
* **Body of test** - Here we make all the tests
* **Teardown** - At the end, whether we succeed or fail, we should clean up our 'world' to not disturb other tests or code.

The setup and teardown serve to initialize and clean up test fixtures.

**Test result formatter** - Produces results in one or more output formats. In addition to a plain, human-readable format, there is often a test result formatter that produces XML output. The XML test result format originated with JUnit but is also used by some other xUnit testing frameworks, for instance build tools such as Jenkins and Atlassian Bamboo.

**Assertions** - A function or macro that verifies the behavior (or the state) of the unit under test. Usually an assertion expresses a logical condition that is true for results expected in a correctly running system under test (SUT). Failure of an assertion typically throws an exception, aborting the execution of the current test.

***
## JUnit
These definitions were taken from the [JUnit Team at GitHub](https://github.com/junit-team/junit/wiki)

**Assertion** - JUnit provides overloaded assertion methods for all primitive types and Objects and arrays (of primitives or Objects).

**Test Runners** - JUnit provides tools to define the suite to be run and to display its results. To run tests and see the results on the console, run this from a Java program.

**Suite** - Using Suite as a test runner allows you to manually build a suite containing tests from many classes.

**Execution Order** - From version 4.11, JUnit will by default use a deterministic, but not predictable, order(MethodSorters.DEFAULT). To change the test execution order simply annotate your test class using @FixMethodOrder and specify one of the available MethodSorters

**Test Fixture** - A test fixture is a fixed state of a set of objects used as a baseline for running tests. The purpose of a test fixture is to ensure that there is a well known and fixed environment in which tests are run so that results are repeatable.

***
## JUnit XML For Jenkins
These definitions are based around the JUnit XML for Jenkins requirement.  There is some translating required as the Oracle database is relational, not object oriented.  Additionally, the Jenkins XML specification has some nuances that are not obvious.

[How Jenkins CI Parses and Displays JUnit Output](http://nelsonwells.net/2012/09/how-jenkins-ci-parses-and-displays-junit-output/)

**Class** - Java Unit Under Tested (UUT).  In the Oracle database, this equates to a database object

**Package** - Collection of Classes.  In the Oracle database, this equates to a database schema.

**Assertion** - Simple PASS/FAIL test.

**TestCase** - Collection of Assertions with a common Class.

**TestSuite** - Collection of TestCases.

***
## Java
These Java definitions are provided for reference

**Object** - In computer science, an object can be a variable, a data structure, or a function, and as such, is a location in memory having a value and possibly referenced by an identifier.  See also [Object at Wikipedia](https://en.wikipedia.org/wiki/Object_(computer_science))

**Class** - In object-oriented programming, a class is an extensible program-code-template for creating objects, providing initial values for state (member variables) and implementations of behavior (member functions or methods).  See also [Class at Wikipedia](https://en.wikipedia.org/wiki/Class_(computer_programming))

---
[Website Home Page](README.md)