
--
--  Create ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "SYNONYM_INSTALL_TYPE", "SYNONYM_ONAME_FILTER", "SYNONYM_OWNER", "SYNONYM_NAME", "OBJECT_TYPE", "DB_LINK", "TARGET_INSTALL_TYPE", "TARGET_ONAME_FILTER", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then tgt.install_type
            else obj.install_type
      end                             INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'SYNONYM'
            else 'TARGET'
      end                             INSTALL_TYPE_SELECTOR
      ,obj.install_type               SYNONYM_INSTALL_TYPE
      ,obj.oname_filter               SYNONYM_ONAME_FILTER
      ,obj.object_owner               SYNONYM_OWNER
      ,obj.object_name                SYNONYM_NAME
      ,'SYNONYM'                      OBJECT_TYPE
      ,syn.db_link
      ,tgt.install_type               TARGET_INSTALL_TYPE
      ,tgt.oname_filter               TARGET_ONAME_FILTER
      ,tgt.object_owner               TARGET_OWNER
      ,tgt.object_name                TARGET_NAME
      ,tgt.object_type                TARGET_TYPE
      ,obj.install_otype
      ,obj.ext
      ,obj.ext2
      ,obj.ext3
 from  obj_install_object_tab  obj
       join sys.dba_synonyms  syn
            on  syn.owner        = obj.object_owner
            and syn.synonym_name = obj.object_name
       join obj_install_object_tab  tgt
            on  tgt.object_owner  = syn.table_owner
            and tgt.object_name   = syn.table_name
            and tgt.object_type  in ('FUNCTION', 'OPERATOR', 'PACKAGE', 'PROCEDURE',
                                     'SEQUENCE', 'SYNONYM', 'TABLE', 'TYPE', 'VIEW',
                                     'MATERIALIZED VIEW', 'JAVA SOURCE', 'QUEUE')
       join install_type_timing  t
            -- Ensure the Target is installed before this Synonym
            on  t.from_install_type = tgt.install_type
            and t.to_install_type   = obj.install_type
 where obj.object_type                    = 'SYNONYM'
  and  obj.object_owner_install_type not in ('sys')    -- Exclude 'sys' Synonyms
  and  syn.synonym_name              not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW


--  Synonyms


set define on
