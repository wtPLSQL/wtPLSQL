# wtPLSQL Home Page

---
[Click here](https://github.com/DDieterich/wtPLSQL/releases/latest) for the latest release on GitHub.

[Click here](https://github.com/DDieterich/wtPLSQL/wiki/Compatibility) for the compatibility wiki page on GitHub.

Use [GitHub "issues"](https://github.com/DDieterich/wtPLSQL/issues) for support.  A (free) GitHub account will be required to create a new issue.  Issues can be searched without an account.

### Overview

wtPLSQL is a test automation server that runs in an Oracle database to provide the following services for Test Runner packages written in PL/SQL.
* Execution of One or More Test Runners
* Assertion Results including Timing Between Assertions
* Capture/Storage/Reporting of Assertion Results
* Source Code Coverage of Test Runner
* Web Based Graphical User Interface (APEX)

### Core Component Example Test Results

Here is an example result summary from the core component.  Only core is needed to produce this result.

<img src="images/Core Example wtPLSQL Test Results.PNG" alt="Sample DBMS_OUTPUT from wtPLSQL core">

To view the complete test results from the wtPLSQL core self-test, go to the "[src/core/test_allO.LST](https://github.com/DDieterich/wtPLSQL/blob/master/src/core/test_allO.LST)" file in GitHub.

### Persist Add-on Example Test Results

Here is the summary from the WT_ASSERT package self-test.  It was created with the default DBMS_OUTPUT reporting package.  Because test results and code coverage are stored in Oracle tables, other report formats are simple to create.

<img src="images/Persist Example wtPLSQL Test Results.PNG" alt="Sample DBMS_OUTPUT from wtPLSQL Persist">

To view the complete test results from the wtPLSQL persist self-test, go to the "[src/persist/test_allO.LST](https://github.com/DDieterich/wtPLSQL/blob/master/src/persist/test_allO.LST)" file in GitHub.

### GUI Add-on Example Test Results

The GUI module uses the Oracle APEX to enhance the UI experience.  Many useful reports are available with the GUI module.  This is an example of ???

<img src="images/GUI Example wtPLSQL Test Results.PNG" alt="Sample Graphical from wtPLSQL GUI">

### General Documentation

* [About wtPLSQL](About-wtPLSQL.md)
* [Examples and Documentation](demo/README.md)
* [Definitions](Definitions.md)
* [Best Practices](Best-Practices.md)
* [Reference](Reference.md)
* [utPLSQL V1/V2 Comparison](utPLSQL-V2-Comparison.md)
* [utPLSQL V3 Comparison](utPLSQL-V3-Comparison.md)
* [OO Style Unit Testing is not for Databases](OO-Style-Unit-Testing.md)

Component                             | Description
--------------------------------------|------------
[core](core-component.md)             | Required for all wtPLSQL functionality. Small, fast, and maintenance free.
[conversion](conversion-component.md) | Convert Test Runner packages from utPLSQL V1/V2 to wtPLSQL

<br>

Add-on                       | Description
-----------------------------|------------
[persist](persist-add-on.md) | Adds storage in tables. Adds code coverage.
[gui](gui-add-on.md)         | Adds Oracle APEX screens and reports. Requires persist add-on.
[junit](junit-add-on.md)     | Adds JUnit XML reporting.

<br>

DB Docs                                   | E-R Diagrams                            | Call Tree Diags
------------------------------------------|-----------------------------------------|----------------
[core docs](core/DBDocs/index.html)       | [core ERDs](core/ER_Diagrams.pdf)       | [core trees](core/Call_Tree_Diagrams.pdf)
[persist docs](persist/DBDocs/index.html) | [persist ERDs](persist/ER_Diagrams.pdf) | [persist trees](persist/Call_Tree_Diagrams.pdf)
[gui docs](gui/DBDocs/index.html)         | [gui ERDs](gui/ER_Diagrams.pdf)         | [gui trees](gui/Call_Tree_Diagrams.pdf)

* **DB Docs** has web pages similar to JavaDocs created by Oracle's SQL*Developer.
* **E-R Diagrams** show relationships between tables (entities).
* **Call Tree Diagrams** show the PL/SQL programs, tables, and common (global) memory structures called by all PL/SQL programs.

To determine which components and add-ons have been installed, run this query:

```
select wtplsql.show_version from dual;
```

## Contribute

Help us improve by joining us at the [wtPLSQL repository](https://github.com/DDieterich/wtPLSQL).

The web pages in this website contain information about the wtPLSQL software. Documentation on design and usage are included here. This website is version specific. Each release includes its own version of this website. The "master" branch (latest release) is always displayed at Github.io. Un-released updates are not displayed here.

For project information, see the [wtPLSQL wiki](https://github.com/DDieterich/wtPLSQL/wiki).  Documentation on procedures and compatibility are included in the wiki.  The wiki includes information for all releases of wtPLSQL. Any updates are immediately displayed.

---

*The following applies to files and directories at this location in the documentation repository.*

### Files and Directories

File Name     | Description
--------------|------------
core          | Core Documentation Directory
demo          | Demonstration Documentation Directory
gui           | Graphical User Interface Documentation
images        | Image Files referenced by MD and HTML
persist       | Persist Documentation Directory
_config.yml   | YAML Configuration File for Markdown
*.md          | Markdown files for "github.io"
*.htm         | HTML files for local documentation
md-to-htm.bat | MS-Dos Batch File to convert MD to HTML
md-to-htm.lua | Lua script used by Pandoc for MD to HTML

To view documentation use the URL "file://README.htm" or Double-click on the README.htm file.

NOTE: All HTML files are sourced from Markdown files.
  Modify the Markdown files, then build HTML from the
  Markdown files using "md-to-htm.bat".

---

_Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
