[Website Home Page](README.md)

# wtPLSQL Core Component

---
### Overview
The Core component is built to be very small and very fast.  It has 5 packages, 3 tables, 1 view, and 1 procedure.  During execution of a Test Runner, it stores all assertion results in memory.  It can be run without any add-ons.  It is the backbone of the wtPLSQL whitebox testing server.

### Assertion Storage
The core component stores all assertion results in the CORE_DATA package.  Previous assertion results are erased before the execution of the next Test Runner.  The average assertion record is about 256 bytes.  4,000 assertion results will require about a Megabyte of memory.  Detailed results from the last assertion are also available as global variables in the CORE_DATA package.

### Assertions
The WT_ASSERT package contains the assertion API.  There are 10 basic assertions.
   * eq
   * isnotnull
   * isnull
   * raises
   * eqqueryvalue
   * eqquery
   * eqtable
   * eqtabcount
   * objexists
   * objnotexists

The WT_ASSERT package includes an internal self-test.  The following data types are tested in this self-test.
   * varchar2
   * nvarchar2
   * clob
   * nclob
   * number
   * pls_integer
   * boolean
   * date
   * timestamp
   * timestamp with local time zone
   * timestamp with time zone
   * interval day to second
   * interval year to month
   * xmltype
   * long
   * raw
   * long raw
   * blob
   * rowid

### Assertion Reporting
The WT_TEST_REPORT package is provided for reporting assertion results from a Test Runner.  The package has several settings to vary the levels of detail.  All output goes to DBMS_OUTPUT.  See the WT_TEST_REPORT package specification for details.

Without any add-ons, the Core package automatically writes test results to the DBMS_OUTPUT buffer.  This behavior can be changed by modifying the records in the HOOKS table.  The Persist add-on removes this behavior during installation.

Ad-hoc assertions (executed outside a Test Runner) always report results to DBMS_OUTPUT.

### Hooks
The HOOKS table provides a mechanism for add-ons and customization.  The table makes various execution points available via unnamed PL/SQL blocks.  The following execution points are available in HOOKS.
   * Before test_all
   * Before test_run
   * Execute Test Runner
   * After Assertion
   * After test_run
   * After test_all
   * Ad Hoc Report

### Important Note:
No Test Runner will be executed if there is no "execute_test_runner" hook in the HOOKS table.

hook_name           | run_string
--------------------|-----------
execute_test_runner | begin wt_execute_test_runner; end;

See the README.md file in the src/core directory for installation instructions.

---
[Website Home Page](README.md)