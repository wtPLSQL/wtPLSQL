## Build Scripts

### Folder Descriptions

File Name              | Description
-----------------------|------------
OraEE122_AP191_ORDS222 | Oracle 12.1 Enterprise Edition, APEX 19.1, ORDS 22.2
OraXE184_AP191_ORDS222 | Oracle 18.4 Enterprise Edition, APEX 19.1, ORDS 22.2
OraEE193_AP212_ORDS222 | Oracle 19.3 Enterprise Edition, APEX 21.2, ORDS 22.2
OraEE213_AP212_ORDS222 | Oracle 21.3 Enterprise Edition, APEX 21.2, ORDS 22.2
OraXE213_AP212_ORDS222 | Oracle 21.3 Enterprise Edition, APEX 21.2, ORDS 22.2

### Build Results Reporting Notes

```
<h1 style="color:blue;">This is a heading</h1>
<p style="color:red;">This is a paragraph.</p>
```

<h1 style="color:blue;">This is a heading</h1>
<p style="color:red;">This is a paragraph.</p>

Create a build status HTML file and use "lframe" to publish it in the main README.md?

https://www.w3schools.com/html/html_iframe.asp

### Build Sequence

builds/*/build.sh (To Be Run in Jenkins?)

1. builds/*/build_initialize.sql
    1. builds/util/new_session.sql
    1. builds/util/create_pdb.sql
1. builds/*/build.sql
    1. builds/util/new_session.sql
    1. wtpsrc/install.sql
1. builds/*/build.sql
    1. builds/util/new_session.sql
    1. wtptst/install.sql
1. builds/pdb_test.sql
    1. builds/util/new_session.sql
    1. builds/util/run_all_wtplsql_tests.sql
    1. builds/util/timing_report.sql
    1. builds/util/JUnit_Test_DB_Build.sql
1. builds/gui_build.sh
    1. builds/util/new_session.sql - PDB SYSTEM
    1. builds/util/install_ords.sql - 2.22
    1. builds/util/install_apex.sql - 2.12
    1. apex/ODBCAPTURE_workspace.sql
    1. apex/f200.sql
    1. builds/util/timing_report.sql
    1. builds/util/JUnit_Test_DB_Build.sql
1. gui_test.sh
    1. *(Build/Deploy ORDS.war File)*
    1. Load/Run wtplsql Unit Testing
1. builds/*/build.sql
    1. builds/util/new_session.sql
    1. grbsrc/install.sql
1. builds/*/build.sql
    1. builds/util/new_session.sql
    1. wtpgrb/install.sql
1. builds/util/archive_pdb.sql
