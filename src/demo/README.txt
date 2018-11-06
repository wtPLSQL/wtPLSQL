
  White Box PL/SQL Testing
  src/demo/README.txt

FILE                      DESCRIPTION
------------------------  ----------------------------
common_setup.sql          Common Installation Settings
install.sql               Installation Script
installO.sql              Sample Installation Log
Package-Test.sql          Package Test Example
Table-Test.sql            Table Test Example
Test-Runner.sql           Test Runner Example
Trigger-Test.sql          Trigger Test Example
Type-Test.sql             Type Test Example
uninstall.sql             Uninstall Script
ut_betwnstr.sql           utPLSQL 2.3 ut_betwnstr Example
ut_calc_secs_between.sql  utPLSQL 2.3 ut_calc_secs_between Example
ut_str.sql                utPLSQL 2.3 ut_str Example
ut_truncit.sql            utPLSQL 2.3 ut_truncit Example


Install Procedure:
------------------
1) sqlplus SYS/password as SYSDBA @install
2) exit
3) Compare install.LST to installO.LST


UnInstall Procedure:
--------------------
1) sqlplus SYS/password as SYSDBA @uninstall
2) exit
3) Compare uninstall.LST to uninstallO.LST
