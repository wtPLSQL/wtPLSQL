
--
--  Create ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,obj.build_type                 QUEUE_BUILD_TYPE
      ,obj.object_owner               QUEUE_OWNER
      ,obj.object_name                QUEUE_NAME
      ,'QUEUE'                        OBJECT_TYPE
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,tp.privilege
      ,tp.grantable
      ,tp.hierarchy
      ,tp.common
      ,tp.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from uor_install_view  uor
       join dba_tab_privs_tab  tp
            on  tp.grantee     = uor.user_or_role
            and tp.object_type = 'QUEUE'
       join dba_queues  aq
            on  aq.owner = tp.object_owner
            and aq.name  = tp.object_name
       join obj_install_object_tab  obj
            on  obj.object_owner = tp.object_owner
            and obj.object_name  = tp.object_name
            and obj.object_type  = 'QUEUE'
       join schema_conf  own
            on  own.username = obj.object_owner
       join element_conf  ec
            on  ec.element_name = 'GRANT'
       join build_type_timing  t
            -- Ensure the Grantee is available when the Queue is installed
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = uor.build_type
 where (   aq.queue_type is null
        or aq.queue_type != 'EXCEPTION_QUEUE')
  and  aq.name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
  and  (   uor.oracle_provided = 'N'          -- Exclude Oracle Provided Grantees
        OR (    uor.build_type    = 'pub'   -- Include 'pub' Grantess
            AND own.oracle_provided = 'N' )   -- Only if owner not Oracle Provided
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW


--  Grants


--  Synonyms


set define on
