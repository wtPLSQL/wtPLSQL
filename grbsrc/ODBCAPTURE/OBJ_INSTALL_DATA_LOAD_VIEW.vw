
--
--  Create ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW" ("INSTALL_TYPE", "INSTALL_TIMING", "TABLE_INSTALL_TYPE", "TABLE_INSTALL_TIMING", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "BEFORE_SELECT_SQL", "WHERE_CLAUSE", "ORDER_BY_COLUMNS", "AFTER_ORDER_BY_SQL", "NOTES", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select dlc.install_type
      ,t.install_timing
      ,tab.install_type               TABLE_INSTALL_TYPE
      ,tab.install_timing             TABLE_INSTALL_TIMING
      ,tab.object_owner               TABLE_OWNER
      ,tab.object_name                TABLE_NAME
      ,tab.object_type                TABLE_TYPE
      ,dlc.before_select_sql
      ,dlc.where_clause
      ,dlc.order_by_columns
      ,dlc.after_order_by_sql
      ,dlc.notes
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  obj_install_object_tab  tab
       join dload_conf  dlc
            on  dlc.username   = tab.object_owner
            and dlc.table_name = tab.object_name
       join otype_conf  otc
            on  otc.install_otype = 'DATA_LOAD'
       join install_type_timing  t
            -- Ensure the Table is installed before this Data Load
            on  t.from_install_type = dlc.install_type
            and t.to_install_type   = tab.install_type
       -- Exclude 'sys' or 'pub' database objects
 where tab.object_install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW


--  Grants


--  Synonyms


set define on
