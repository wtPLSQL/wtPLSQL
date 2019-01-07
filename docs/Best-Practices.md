[Website Home Page](README.md)

# Best Practices

---
Place the **"WTPLSQL_RUN" procedure at the end** of the package body. This allows the WTPLSQL_RUN procedure to call any procedure/function in the package.

Set the package variable **"wtplsql.g_DBOUT" at the top** of the WTPLSQL_RUN procedure definition in the package body. This is a common location for all Test Runner packages. 

**Separate "setup" and "teardown"** subroutines into their own Test Cases.

**Name Test Cases Consistently**
* Use the word "Setup" in Test Case names that perform setup operations.
* Use the word "Teardown" in Test Case names that perform tear-down operations.
* Use the words "Happy Path" in Test Case names that perform "happy path" tests.
* Use the words "Sad Path" in Test Case names that perform "sad path" tests.
   * expected failure testing.
   * fault insertion testing.

**Include tests for boundary conditions**
* Largest and smallest values
* Longest and shortest values
* All combinations of default and non-default values

Create **individual test procedures for each procedure/function** in a DBOUT package.
* Call all test procedures from the WTPLSQL_RUN procedure.
* Embed the test procedure just after the procedure/function it tests.
* Use a consistent prefix on all test procedure names, like "t_".

**Use conditional compilation** select directive "WTPLSQL_ENABLE" in the Oracle database initialization parameter "PLSQL_CCFLAGS" to enable and disable embedded test code in all PACKAGE BODYs.
* "WTPLSQL_ENABLE:TRUE" will enable test code.
* "WTPLSQL_ENABLE:FALSE" will disable test code.

**Use consistent begin and end test markers** for embedded tests. These examples will setup conditional compiling and annotate lines of code to be excluded from code coverage calculations.

Here is an example "begin test marker".

```
   $IF $$WTPLSQL_ENABLE  -------%WTPLSQL_begin_ignore_lines%-------
   $THEN
```

Here is an example "end test marker".

```
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
```

**Indent embedded test code** between the test code markers

**Add test markers** every 10 lines or less. This helps identify a long embedded test procedure while scrolling through source code. When in doubt, add more of these.

Here is an example test marker.

```
   --------------------------------------  WTPLSQL Testing --
```

**Check and/or set NLS settings** before testing. Many data types are implicitly converted to VARCHAR2 before comparison. The "wtplsql" package includes functions to check and set NLS settings. Note: Modifying these settings always includes a COMMIT.

---
[Website Home Page](README.md)
