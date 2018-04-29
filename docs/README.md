# wtPLSQL Home Page

---
To install/upgrade, download the [latest Release](https://github.com/DDieterich/wtPLSQL/releases)

Also see the [compatibility page](https://github.com/DDieterich/wtPLSQL/wiki/Compatibility) in the wtPLSQL repository wiki.

Use [GitHub "issues"](https://github.com/DDieterich/wtPLSQL/issues) for support.  A (free) GitHub account will be required to create a new issue.  Issues can be searched without an account.

## What is wtPLSQL?

wtPLSQL helps with white-box testing of Oracle database objects.  It is particularly well suited for unit testing and simple integration testing.  It is written in PL/SQL.  It contains a self-test which makes it easier to support and customize.

Like utPLSQL, wtPLSQL provides a set of assertion tests that can be used to determine how well an Oracle database object is performing. These assertions record the outcome (success or failure) of each test.  These assertions also record the time between calls. A test runner (PL/SQL package) must be created with these assertion tests included.  When the test runner is executed, the outcome and timing of the assertion tests are recorded.  The [Core Features page](Core-Features.md) introduces the main functionality of wtPLSQL.

A simple text based reporting package called "WT_TEXT_REPORT" is included with the core installation.  Custom reports are easy to create because the outcome and timing data is stored in the Oracle database.  A set of DBDocs and E-R diagrams are provided to assist with any reporting customization.

Because wtPLSQL is for PL/SQL developers, a [Best Practices page](Best-Practices.md) has some guidance for creating Test Runner packages in PL/SQL.

The [About page](About.md) has more information about the history and testing methodology of wtPLSQL.

The [Definitions page](Definitions.md) includes definitions from many sources to help define the terms used in various software testing methodologies.

## How does wtPLSQL compare to utPLSQL V3?

utPLSQL V3 is an excellent choice for unit testing.  It is well supported and includes extensive functionality.

wtPLSQL has a different focus than utPLSQL V3.  More information is available [in this link](utPLSQL-V3-Comparison).

## Demonstrations and Examples

[Under Construction](demo/README.md)

### Site Map

* [Core Features](Core-Features.md)
* [About](About.md)
* [Best Practices](Best-Practices.md)
* [Definitions](Definitions.md)
* [utPLSQL V3 Comparison](utPLSQL-V3-Comparison)

## Contribute

Help us improve by joining us at the [wtPLSQL repository](https://github.com/DDieterich/wtPLSQL).

---

_Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
