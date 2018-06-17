# wtPLSQL Home Page

---
To install/upgrade, download the [latest Release](https://github.com/DDieterich/wtPLSQL/releases)

Also see the [compatibility page](https://github.com/DDieterich/wtPLSQL/wiki/Compatibility) in the wtPLSQL repository wiki.

Use [GitHub "issues"](https://github.com/DDieterich/wtPLSQL/issues) for support.  A (free) GitHub account will be required to create a new issue.  Issues can be searched without an account.

## Example wtPLSQL Test Results

This is the summary from the WT_ASSERT package self-test.  It was created with the default DBMS_OUTPUT reporting package.  Because test results and code coverage is stored in Oracle tables, other report formats are simple to create.

```
    wtPLSQL 1.1.0 - Run ID 7: 09-Jun-2018 11:48:42 AM

  Test Results for WTP.WT_ASSERT
        Total Testcases:      150       Total Assertions:      404
  Minimum Interval msec:        0      Failed Assertions:        0
  Average Interval msec:        7       Error Assertions:        0
  Maximum Interval msec:      761             Test Yield:   100.00%
   Total Run Time (sec):      2.8

  Code Coverage for PACKAGE BODY WTP.WT_ASSERT
          Ignored Lines:     1103   Total Profiled Lines:     1464
         Excluded Lines:        6   Total Executed Lines:      309
  Minimum LineExec usec:        0     Not Executed Lines:        0
  Average LineExec usec:      394          Unknown Lines:       46
  Maximum LineExec usec:    65814          Code Coverage:   100.00%
  Trigger Source Offset:        0
```

To view the complete test results from the wtPLSQL self-test, go to the [test_allO.LST](https://github.com/DDieterich/wtPLSQL/blob/master/src/core/test_allO.LST) file in GitHub.  The [Demonstrations and Examples Page](demo/README.md) has more examples.

## What is wtPLSQL?

wtPLSQL helps with white-box testing of Oracle database objects.  It is particularly well suited for unit testing and simple integration testing.  It is written in PL/SQL.  It contains a self-test which makes it easier to support and customize.

Like utPLSQL, wtPLSQL provides a set of assertion tests that can be used to determine how well an Oracle database object is performing. These assertions record the outcome (success or failure) of each test. These assertions also record the time between calls. A test runner (PL/SQL package) must be created with these assertion tests included. The [Core Features page](Core-Features.md) introduces the main functionality of wtPLSQL.

A simple text based reporting package called "WT_TEXT_REPORT" is included with the core installation.  Custom reports are easy to create because the assertion outcomes and interval time between assertions are stored in the Oracle database.  A set of DBDocs and E-R diagrams are provided to assist with any reporting customization.

Because all testing with wtPLSQL is for driven by custom PL/SQL packages, a [Best Practices page](Best-Practices.md) has some guidance for creating test runner packages.

The [About wtPLSQL page](About-wtPLSQL.md) has more information about the history and testing methodology of wtPLSQL.

The [Definitions page](Definitions.md) includes definitions from many sources to help define the terms used in various software testing methodologies.

## How does wtPLSQL compare to utPLSQL V3?

utPLSQL V3 is an excellent choice for unit testing.  It is well supported and includes extensive functionality.

wtPLSQL has a different focus than utPLSQL V3.  More information is available [in this link](utPLSQL-V3-Comparison.md).

## How does wtPLSQL compare to utPLSQL V1 or utPLSQL V2?

utPLSQL V2 is an extension of utPLSQL V1. Since utPSQL V2 is being replaced by utPLSQL V3, neither utPLSQL V2 or utPLSQL V1 are good choices for starting a new software testing implementation.

The goal of wtPLSQL has been to implement the basic/core functionality of utPLSQL V2 while preserving the the programming investment in the assertion API (utAssert.eq, utAssert.isnotnull, etc.). The additional functionality of utPLSQL V2 that is not included in the wtPLSQL core will be added through optionally installed modules (also known as add-ons).

More information is available [in this link](utPLSQL-V2-Comparison.md).

### Site Links

User Help
* [Demonstrations and Examples Page](demo/README.md)
* [Reference](Reference.md)
* [Best Practices](Best-Practices.md)
* [DB Docs from SQL*Developer](core/DBDocs/index.html)
* [ER Diagram PDF](core/ER_Diagrams.pdf)
* [Call Tree Diagrams PDF](core/Call_Tree_Diagrams.pdf)

Background
* [Definitions](Definitions.md)
* [About wtPLSQL](About-wtPLSQL.md)
* [Core Features](Core-Features.md)
* [utPLSQL V3 Comparison](utPLSQL-V3-Comparison.md)
* [utPLSQL V1/V2 Comparison](utPLSQL-V2-Comparison.md)

## Contribute

Help us improve by joining us at the [wtPLSQL repository](https://github.com/DDieterich/wtPLSQL).

---

_Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
