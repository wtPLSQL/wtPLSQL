
  White Box PL/SQL Testing
  src/core/upgrades/V1.0.0_to_Current/README.txt

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
