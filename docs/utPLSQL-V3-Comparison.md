[Website Home Page](README.md)

# utPLSQL V3 Comparison

---
Under Construction

Abbreviations:
* "ut3" - utPLSQL V3
* "wt" - wtPLSQL

## The Basics
"ut3" is a comprehensive project.  Its capabilities are a large and diverse.  It is supported by many people around the world.  If your development environment includes a wide variety of platforms and technologies, this is the best project for you.

"wt" is an Oracle database focused project.  It is built entirely with PL/SQL and Application Express.  All testing and reporting is done in the database.

## Goals
The "ut3" project ["follows industry standards and best patterns of modern Unit Testing frameworks like JUnit and RSpec"](https://github.com/utPLSQL/utPLSQL).

The "wt" project avoids "unit testing" by adopting practices for ["white box testing"](https://github.com/DDieterich/wtPLSQL/wiki/About-wtPLSQL#white-box-testing).

## Customization
The "ut3" project incorporates a wide variety of technologies and platforms. It also has a large and diverse set of capabilities that will reduce the need for customization.

The "wt" project is centered on one platform with a very simple implementation. It is easier to customize smaller, simpler systems.

## Testing Methodologies
There is a longer discussion about unit testing methodologies in the [About wtPSQL Page](https://github.com/DDieterich/wtPLSQL/wiki/About-wtPLSQL#unit-testing).

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

### Test Driven Development (TDD/RSpec)
In the fast-paced development cycle, defining how the software accomplishes the needs of the business is the typical focus. This is also called "happy path" functionality. Conversely, error handling and error recovery (sad path) requirements typically don't accomplish business needs. That is to say, sad path testing focuses on things going badly, not on things going well. Unfortunately, efforts to develop and define sad path requirements are typically avoided.

TDD places no value on 100% code coverage. TDD typically avoids testing sad path testing during development.

White box testing is centered on 100% code coverage. "Happy path" and "sad path" testing are typically required to achieve 100% code coverage.

Here is more discussion on [Test Driven Development](About-wtPLSQL.html#test-driven-development)

---
[Website Home Page](README.md)
