# wtPLSQL Home Page

***
## Install Now

To install/upgrade, download the [latest Release](https://github.com/DDieterich/wtPLSQL/releases)

[Compatability page](https://github.com/DDieterich/wtPLSQL/wiki/Compatibility) in the wtPLSQL repository wiki.

### Site Map

* [Core Features](Core-Features.md)
* [About](About.md)
* [Best Practices](Best-Practices.md)
* [Definitions](Definitions.md)
* [utPLSQL V3 Comparison](utPLSQL-V3-vs.-wtPLSQL.md)

***
## What is wtPLSQL?

wtPLSQL helps with white-box testing of Oracle database objects.  It is particularly well suited for unit testing and simple integration testing.  It is written in PL/SQL.  It contains a self-test which makes it easier to support and customize.

Like utPLSQL, wtPLSQL provides a set of assertion tests that can be used to determine how well an Oracle database object is performing. These assertions record the outcome (success or failure) of each test.  These assertions also record the time between calls. These assertion tests are writting into a test runner (PL/SQL package).  When the test runner is executed, the assertions record the results.  The [Core Features page](Core-Features.md) introduces the main functionality of wtPLSQL.

Because wtPLSQL is for PL/SQL developers, a [Best Practices page](Best-Practices.md) has some guidance for creating Test Runner packages in PL/SQL.

The [About page](About.md) has more information about the history and testing methodology of wtPLSQL.

The [Definitions page](Definitions.md) includes definitions from many sources to help define the terms used in various software testing methodologies.

## How does wtPLSQL compare to utPLSQL V3?

utPLSQL V3 is an excellent choice for unit testing.  It is well supported and included extensive functionality.

wtPLSQL has a different focus than utPLSQL V3.  More information is available [in this link](utPLSQL-V3-vs.-wtPLSQL).

## Demonstrations and Examples

[Under Construction](demo/README.md)

## Contribute

Help us improve by joining us at the [wtPLSQL repository](https://github.com/DDieterich/wtPLSQL).

---

_Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
