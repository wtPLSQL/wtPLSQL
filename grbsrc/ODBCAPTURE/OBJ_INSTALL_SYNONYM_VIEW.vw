
--
--  Create ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "SYNONYM_BUILD_TYPE", "SYNONYM_OBJECT_NAME_REGEXP", "SYNONYM_OWNER", "SYNONYM_NAME", "OBJECT_TYPE", "DB_LINK", "TARGET_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then tgt.build_type
            else obj.build_type
      end                             BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'SYNONYM'
            else 'TARGET'
      end                             BUILD_TYPE_SELECTOR
      ,obj.build_type                 SYNONYM_BUILD_TYPE
      ,obj.object_name_regexp         SYNONYM_OBJECT_NAME_REGEXP
      ,obj.object_owner               SYNONYM_OWNER
      ,obj.object_name                SYNONYM_NAME
      ,'SYNONYM'                      OBJECT_TYPE
      ,syn.db_link
      ,tgt.build_type                 TARGET_BUILD_TYPE
      ,tgt.object_name_regexp         TARGET_OBJECT_NAME_REGEXP
      ,tgt.object_owner               TARGET_OWNER
      ,tgt.object_name                TARGET_NAME
      ,tgt.object_type                TARGET_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join sys.dba_synonyms  syn
            on  syn.owner        = obj.object_owner
            and syn.synonym_name = obj.object_name
       join schema_conf  own
            on  own.username = syn.owner
       join obj_install_object_tab  tgt
            on  tgt.object_owner  = syn.table_owner
            and tgt.object_name   = syn.table_name
            and tgt.object_type  in ('FUNCTION', 'OPERATOR', 'PACKAGE', 'PROCEDURE',
                                     'SEQUENCE', 'SYNONYM', 'TABLE', 'TYPE', 'VIEW',
                                     'MATERIALIZED VIEW', 'JAVA SOURCE', 'QUEUE')
       join build_type_timing  t
            -- Ensure the Target is installed before this Synonym
            on  t.from_build_type = tgt.build_type
            and t.to_build_type   = obj.build_type
 where obj.object_type                    = 'SYNONYM'
  and  (   own.oracle_provided = 'N'                -- Exclude Oracle Provided Synonyms
        OR obj.object_owner_build_type = 'pub' )  -- Include Public Synonyms
  and  syn.synonym_name              not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW


--  Grants


--  Synonyms


set define on
