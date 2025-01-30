
--
--  Create ODBCAPTURE.PRIV_OBJ_INSTALL_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'OBJECT'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,obj.build_type                 OBJECT_BUILD_TYPE
      ,obj.object_owner
      ,obj.object_name
      ,obj.object_type
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
       join obj_install_object_tab  obj
            on  obj.object_owner  = priv.object_owner
            and obj.object_name   = priv.object_name
            and obj.object_type   = priv.object_type
       join schema_conf  own
            on  own.username = obj.object_owner
       join element_conf  ec
            on  ec.element_name = 'GRANT'
       join build_type_timing  t
            -- Ensure Grantee is available after installation of object
            on  from_build_type = obj.object_build_type
            and to_build_type   = uor.build_type
 where priv.object_owner != 'SYS'             -- Exclude database objects owned by SYS
  and  (   uor.oracle_provided = 'N'          -- Not Oracle Provided Grantee
        OR (    uor.build_type    = 'pub'   -- Include 'pub' Grantees
            AND own.oracle_provided = 'N' )   -- Only if owner not Oracle Provided
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW


--  Grants


--  Synonyms


set define on
