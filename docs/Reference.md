[Website Home Page](README.md)

# Reference

---
## Datatypes Supported
Oracle Data Type Families<br>
https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/predefined.htm#LNPLS2047

* VARCHAR2 - Includes ROWID, LONG*, RAW, LONG RAW*, and NVARCHAR2
* DATE** - Includes TIMESTAMP and INTERVAL
* NUMBER** - Includes PLS_INTEGER
* BOOLEAN
* XMLTYPE
* CLOB - Includes NCLOB
* BLOB

*LONG and LONG RAW data length is limited to VARCHAR2 length in PL/SQL (32K).<br>
**VARCHAR2 includes DATE and NUMBER using Implicit Data Conversions:<br>
https://docs.oracle.com/cd/E11882_01/server.112/e41084/sql_elements002.htm#i163326

Many data types are converted to VARCHAR2 before comparison. This ensures most results are captured and reported exactly as they were tested.

There is a balance to strike between simplicity and localization. Many data types must be converted to "strings" before display. Converting a data type at the time it is displayed can lead to confusing results. Since each assertion includes the capture of the values that were compared, the values that are captured are the actual values tested.

An obvious drawback of this approach is running assertions when NLS settings must be set to something other than the setting that is needed for comparison. In this case, an explicit conversion can be made in the Test Runnner using the needed format.

## Custom Error Codes
* ORA-20001 - WTPLSQL Package: RUNNER_NAME is NULL
* ORA-20002 - WTPLSQL Package: RUNNER_NAME (name) is not valid
* ORA-20003 - WT_ASSERT Package: User Test Result is FAIL (g_raise_exception is TRUE)
* ORA-20004 - WT_PROFILER Package: in_test_run_id is NULL
* ORA-20005 - WT_PROFILER Package: dbms_profiler.INTERNAL_VERSION_CHECK returned (error)
* ORA-20006 - WT_PROFILER Package: dbms_profiler.START_PROFILER returned (error)
* ORA-20009 - WT_RESULT Package: "in_test_run_id" cannot be NULL
* ORA-20010 - WT_TEST_RUN_STAT Package: Unknown Result status
* ORA-20011 - WT_TEST_RUN_STAT Package: Unknown Profile status
* ORA-20012 - HOOK Package: Unknown HOOK_NAME Case

## WT_TEXT_REPORT Detail Levels
* **Less than 10 (including null)** - No Detail
   * Assertion results summary.
   * Profiled lines summary.
* **10 to 19** - Minimal Detail
   * Assertion results summary.
   * Profiled lines summary.
   * Failed assertion result details.
   * Profiled source lines that were "not executed".
* **20 to 29** - Partial Full Detail
   * Assertion results summary.
   * Profiled lines summary.
   * All assertion result details.
   * Profiled source lines that were "not executed".
* **30 or more** - Full Detail
   * Assertion results summary.
   * Profiled lines summary.
   * All assertion result details.
   * All profiled source lines.

---
[Website Home Page](README.md)
