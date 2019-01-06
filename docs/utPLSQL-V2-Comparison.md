[Website Home Page](README.md)

# utPLSQL V2 Comparison

---
This comparison assumes a familiarity with utPLSQL V1/V2.  The differences between wtPLSQL and utPLSQL V2 will be the focus.

### Test Transience
utPLSQL V2 included a focus on test transience by requiring "setup" and "tear down" procedures in a test package. wtPLSQL has no requirement. wtPLSQL also does not prevent any setup or tear down procedures from a test runner package.

### Non-Sequenced Testing
utPLSQL V2 did not include any specific order of test procedures in a test package.  By default, wtPLSQL orders the test procedures because these test procedures will be listed in sequence in the test runner package.  (Everything in the test runner package must be called by the "WTPLSQL_RUN" procedure.)

### UTL_FILE Setup
Much of the utPLSQL V2 functionality was centered on the UTL_FILE package. UTL_FILE was used to
* create empty/skeleton test packages
* save reports in various formats
* read source code to recompile/refresh database packages
* compare files

The configuration of UTL_FILE was one of the difficult parts of installing utPLSQL V2. Removing UTL_FILE from wtPLSQL core allows for a much simpler installation. Also, much of the functionality performed by UTL_FILE can be done easier with modern reporting and development tools.  Comparing Files 

### Record Comparison
In utPLSQL V2, the "utRecEq" package is used to to generate functions to compare record types. To avoid problems, this functionality has not been included in the wtPSQL core. Generating the functions needed to make the comparison require special database permissions. Separating this package into a separate add-on allows these special database permissions to be addressed only if needed.

### Test Procedure Prefixes
From the utPLSQL V2 documentation: "The unit test prefix is very important in utPLSQL; the utility uses the prefix to associate source code to be tested with the test package. The prefix also allows utPLSQL to automatically identify the programs within a test package that are to be executed as unit tests."

In wtPLSQL, these prefixes are not required. The lack of these prefixes greatly simplifies the setup of test runners. However, the prefixes can be used with wtPLSQL by building them into test runner packages.

### utPLSQL Trace
utPLSQL V2 has a trace facility that can be turned on and off. Because the test runner in wtPLSQL is in control of testing and because the test runner is user written, any desired tracing can be added to the test runner.

### utConfig
The utConfig package is no longer used in wtPLSQL. There are 29 settings in the utConfig package in utPLSQL V2. The only remaining settings are in the following packages.

WT_ASSERT Setting           | Description
----------------------------|------------
g_testcase                  | Name of the current test case
set_NLS_DATE_FORMAT         | Default format for date data type
set_NLS_TIMESTAMP_FORMAT    | Default format for timestamp data type
set_NLS_TIMESTAMP_TZ_FORMAT | Default format for timestamp with time zone data type

<br>

WT_TEXT_REPORT Setting | Description
-----------------------|------------
g_single_line_output   | Remove/replace new line characters in test result output
g_date_format          | Default format for date data type

### utOutput
utOutput in utPLSQL V2 has been replaced by WT_TEXT_REPORT in wtPLSQL.  Like utPLSQL V2, wtPLSQL calls WT_TEXT_REPORT (using a hook) after each Test Runner is complete. Unlike utPLSQL V2, WT_TEXT_REPORT is not called automatically when the Persist add-on is installed.  However, a hook can be created to restore this functionality, if needed.

WT_TEXT_REPORT is used to format the results of an ad-hoc assertion that is not part of a Test Runner call tree (call graph). The results of ad-hoc assertions are always sent to DBMS_OUTPUT.

### Custom Reporter
wtPLSQL has no custom reporter. An alternative to the WT_TEXT_REPORTER is a user written PL/SQL program. If the Persist add-on is installed, all test results are available in database tables. Reporting tools can be used to create custom reports from database tables.

### Links
* [utPLSQL V2.3.1 Website](https://utplsql.org/moving/2016/07/07/version-2-3-1-released.html)
* [utPLSQL V2.3.1 Documentation](https://utplsql.org/utPLSQL/v2.3.1/)


---
[Website Home Page](README.md)
