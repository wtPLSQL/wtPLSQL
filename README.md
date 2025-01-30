[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# wtPLSQL - Whitebox Testing for PLSQL

Welcome to the wtPLSQL source code repository on GitHub.

The http://wtPLSQL.org website (hosted on GitHub.io) has more information about how to use wtPLSQL and why it is different.

[Click here](https://github.com/DDieterich/wtPLSQL/releases/latest) for the latest release.

[Click here](https://github.com/DDieterich/wtPLSQL/wiki/Compatibility) for the compatibility wiki page.

*NOTE:* Issues are tracked in the Wiki.  See: [Issues Summary](https://github.com/wtPLSQL/wtPLSQL/wiki/Z-Issues-Summary)


### Versions

* The "master" branch contains this website, other documentation, and source code for the latest release
* The default "V1.2" branch contains the website, other documentation, and source code that is under development for the next release.  


### Participation

See the ["V1.2 Hooks and GUI" Milestone](https://github.com/DDieterich/wtPLSQL/milestone/4) for issues that are ready to work.

The [repository wiki](https://github.com/DDieterich/wtPLSQL/wiki) includes helpful procedures and discussions for code development and repository maintenance.

All software documentation is on the http://wtPLSQL.org website. The document repository is in the "docs" directory (see table below).


## File/Folder List

File Name                  | Description
---------------------------|------------
apex                       | Consolidated Install Scripts for APEX DB on OCI
builds                     | Build/Test Scripts/Log
conv                       | Conversion Utility Scripts Folder
demo                       | Demonstrations and Examples Folder
diffs                      | Upgrade/Downgrade Scripts
docs                       | User Documentation Folder. Also contains wtPLSQL website (GitHub.io) source.
grb_linked_install_scripts | Common Scripts Linked by Installation Scripts
grbsrc                     | Main ODBCapture Installation Scripts
junit                      | JUnit XML Report Scripts Folder
wtpgrb                     | Configuration Data for ODBCapture Folder
wtpsav                     | Persisting Test Results Add-on Scripts Folder
wtpsrc                     | Core wtPLSQL Component Scripts Folder
LICENSE                    | Open Source Terms and Conditions.


## Installation

1. cd wtpsrc
2. sqlplus / as sysdba @install.sql
3. select * from odbcapture_installation_logs;
4. If problems found: more *.log


---

_Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
