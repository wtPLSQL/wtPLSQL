
  White Box PL/SQL Testing
  V1.0.0 to V1.1.0 ReadMe

FILE                    DESCRIPTION
----------------------  -----------------------
update_all_stats.sql    Populate the new STATS tables
upgrade.sql             Main upgrade script
upgradeO.LST            Example of successful results from Demo Installation


Install Procedure:
------------------
1) sqlplus SYS/password as SYSDBA @upgrade
2) exit
3) Compare upgrade.LST to upgradeO.LST
