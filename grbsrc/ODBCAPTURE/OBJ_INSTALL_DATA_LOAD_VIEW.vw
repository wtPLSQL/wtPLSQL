
--
--  Create ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "TABLE_BUILD_TYPE", "TABLE_BUILD_TIMING", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "OBJECT_TABLE_TYPE", "LOADING_METHOD", "BEFORE_SELECT_SQL", "COLUMNS_REMOVED", "WHERE_CLAUSE", "ORDER_BY_COLUMNS", "AFTER_ORDER_BY_SQL", "NOTES", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select dlc.build_type
      ,t.build_timing
      ,tab.build_type                 TABLE_BUILD_TYPE
      ,tab.build_timing               TABLE_BUILD_TIMING
      ,tab.object_owner               TABLE_OWNER
      ,tab.object_name                TABLE_NAME
      ,tab.object_type                TABLE_TYPE
      ,ot.table_type                  OBJECT_TABLE_TYPE
      ,dlc.loading_method
      ,dlc.before_select_sql
      ,dlc.columns_removed
      ,dlc.where_clause
      ,dlc.order_by_columns
      ,dlc.after_order_by_sql
      ,dlc.notes
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  obj_install_object_tab  tab
       join dload_conf  dlc
            on  dlc.username   = tab.object_owner
            and dlc.table_name = tab.object_name
       join element_conf  ec
            on  ec.element_name = 'DATA_LOAD'
       join build_type_timing  t
            -- Ensure the Table is installed before this Data Load
            on  t.from_build_type = dlc.build_type
            and t.to_build_type   = tab.build_type
  left join dba_object_tables  ot
            on  ot.owner      = tab.object_owner
            and ot.table_name = tab.object_name;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW


--  Grants


--  Synonyms


set define on
