[Website Home Page](README.md)

# utPLSQL V3 Comparison

---

utPLSQL V3 is an excellent choice for unit testing.  It is well supported and includes extensive functionality. wtPLSQL has a different focus than utPLSQL V3.

## utPLSQL V3

utPLSQL V3 is a comprehensive project. Its capabilities are large and diverse. It incorporates a wide variety of technologies and platforms. It also has a large and diverse set of capabilities that will reduce the need for customization. It is supported by many people around the world.

If your development environment includes a wide variety of platforms and technologies, you should consider using utPLSQL V3.

## wtPLSQL

wtPLSQL is Oracle database focused. It is built entirely with PL/SQL and Application Express.  All testing and reporting is done in the database.  Because it is centered on the Oracle database, it is a very simple implementation. With hooks and add-ons, it easy to customize.

If your development environment is heavily invested in PL/SQL and the Oracle database, wtPLSQL is built for you.

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

White box testing is centered on 100% code coverage. "Happy path" and "sad path" testing are typically required to achieve 100% code coverage.

Here is more discussion on [Test Driven Development](About-wtPLSQL.md#test-driven-development)

### Links
* [utPLSQL V3 Website](https://utplsql.org)
* [utPLSQL V3 Documentation](http://utplsql.org/documentation/)

---
[Website Home Page](README.md)
