
--
--  Create ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "INDEX_INSTALL_TYPE", "INDEX_ONAME_FILTER", "INDEX_OWNER", "INDEX_NAME", "OBJECT_TYPE", "INDEX_TYPE", "UNIQUENESS", "TABLE_INSTALL_TYPE", "TARGET_ONAME_FILTER", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then obj.install_type
            else tgt.install_type
      end                          INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'INDEX'
            else 'TARGET'
      end                          INSTALL_TYPE_SELECTOR
      ,obj.install_type            INDEX_INSTALL_TYPE
      ,obj.oname_filter            INDEX_ONAME_FILTER
      ,obj.object_owner            INDEX_OWNER
      ,obj.object_name             INDEX_NAME
      ,obj.object_type
      ,ind.index_type
      ,ind.uniqueness
      ,tgt.install_type            TABLE_INSTALL_TYPE
      ,tgt.oname_filter            TARGET_ONAME_FILTER
      ,tgt.object_owner            TABLE_OWNER
      ,tgt.object_name             TABLE_NAME
      ,tgt.object_type             TABLE_TYPE
      ,obj.install_otype
      ,obj.ext
      ,obj.ext2
      ,obj.ext3
 from  obj_install_object_tab  obj
       join dba_indexes  ind
            on  ind.owner      = obj.object_owner
            and ind.index_name = obj.object_name
       join obj_install_object_tab  tgt
            on  tgt.object_owner = ind.table_owner
            and tgt.object_name  = ind.table_name
            and tgt.object_type  = ind.table_type
       join install_type_timing  t
            -- Ensure Target Table is installed before this Index
            on  t.from_install_type = obj.install_type
            and t.to_install_type   = tgt.install_type
 where obj.object_type              = 'INDEX'
  and  obj.object_install_type not in ('sys','pub')    -- Exclude 'sys' and 'pub' Index Schemas
  and  ind.index_name          not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW


--  Synonyms


set define on
