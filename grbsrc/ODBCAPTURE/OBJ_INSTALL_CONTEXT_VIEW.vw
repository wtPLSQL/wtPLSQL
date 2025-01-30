
--
--  Create ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "CONTEXT_BUILD_TYPE", "CONTEXT_OBJECT_NAME_REGEXP", "CONTEXT_OWNER", "CONTEXT_NAME", "CONTEXT_TYPE", "PACKAGE_BUILD_TYPE", "PACKAGE_OBJECT_NAME_REGEXP", "PACKAGE_OWNER", "PACKAGE_NAME", "PACKAGE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select obj.build_type
      ,t.build_timing
      ,obj.build_type                 CONTEXT_BUILD_TYPE
      ,obj.object_name_regexp         CONTEXT_OBJECT_NAME_REGEXP
      ,obj.object_owner               CONTEXT_OWNER
      ,ctx.namespace                  CONTEXT_NAME
      ,ctx.type                       CONTEXT_TYPE
      ,pkg.build_type                 PACKAGE_BUILD_TYPE
      ,pkg.object_name_regexp         PACKAGE_OBJECT_NAME_REGEXP
      ,pkg.object_owner               PACKAGE_OWNER
      ,pkg.object_name                PACKAGE_NAME
      ,pkg.object_type                PACKAGE_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join dba_context  ctx
            on  ctx.namespace = obj.object_name
       join obj_install_object_tab  pkg
            on  pkg.object_owner  = ctx.schema
            and pkg.object_name   = ctx.package
            and pkg.object_type   = 'PACKAGE'
       join build_type_timing  t
            -- Ensure the package is installed before this Context
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = pkg.build_type
 where obj.object_owner = 'SYS'
  and  obj.object_type  = 'CONTEXT'
  and  ctx.namespace not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW


--  Grants


--  Synonyms


set define on
