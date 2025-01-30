
--
--  Create ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "INDEX_BUILD_TYPE", "INDEX_OBJECT_NAME_REGEXP", "INDEX_OWNER", "INDEX_NAME", "OBJECT_TYPE", "UNIQUENESS", "INDEX_TYPE", "ITYP_OWNER", "ITYP_NAME", "TABLE_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else tgt.build_type
      end                          BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'INDEX'
            else 'TARGET'
      end                          BUILD_TYPE_SELECTOR
      ,obj.build_type              INDEX_BUILD_TYPE
      ,obj.object_name_regexp      INDEX_OBJECT_NAME_REGEXP
      ,obj.object_owner            INDEX_OWNER
      ,obj.object_name             INDEX_NAME
      ,obj.object_type
      ,ind.uniqueness
      ,ind.index_type
      ,ind.ityp_owner
      ,ind.ityp_name
      ,tgt.build_type              TABLE_BUILD_TYPE
      ,tgt.object_name_regexp      TARGET_OBJECT_NAME_REGEXP
      ,tgt.object_owner            TABLE_OWNER
      ,tgt.object_name             TABLE_NAME
      ,tgt.object_type             TABLE_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join schema_conf  own
            on  own.username        = obj.object_owner
            and own.oracle_provided = 'N'    -- Exclude Oracle Provided Index Schemas
       join dba_indexes  ind
            on  ind.owner      = obj.object_owner
            and ind.index_name = obj.object_name
            and ind.index_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join obj_install_object_tab  tgt
            on  tgt.object_owner = ind.table_owner
            and tgt.object_name  = ind.table_name
            and tgt.object_type  = ind.table_type
       join build_type_timing  t
            -- Ensure Target Table is installed before this Index
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = tgt.build_type
 where obj.object_type = 'INDEX';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW


--  Grants


--  Synonyms


set define on
