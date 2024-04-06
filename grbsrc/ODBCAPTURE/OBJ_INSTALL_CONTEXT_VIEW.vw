
--
--  Create ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW" ("INSTALL_TYPE", "INSTALL_TIMING", "CONTEXT_INSTALL_TYPE", "CONTEXT_ONAME_FILTER", "CONTEXT_OWNER", "CONTEXT_NAME", "CONTEXT_TYPE", "TRACKING", "PACKAGE_INSTALL_TYPE", "PACKAGE_ONAME_FILTER", "PACKAGE_OWNER", "PACKAGE_NAME", "PACKAGE_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select obj.install_type
      ,t.install_timing
      ,obj.install_type               CONTEXT_INSTALL_TYPE
      ,obj.oname_filter               CONTEXT_ONAME_FILTER
      ,obj.object_owner               CONTEXT_OWNER
      ,ctx.namespace                  CONTEXT_NAME
      ,ctx.type                       CONTEXT_TYPE
      ,ctx.tracking
      ,pkg.install_type               PACKAGE_INSTALL_TYPE
      ,pkg.oname_filter               PACKAGE_ONAME_FILTER
      ,pkg.object_owner               PACKAGE_OWNER
      ,pkg.object_name                PACKAGE_NAME
      ,pkg.object_type                PACKAGE_TYPE
      ,obj.install_otype
      ,obj.ext
      ,obj.ext2
      ,obj.ext3
 from  obj_install_object_tab  obj
       join dba_context  ctx
            on  ctx.namespace = obj.object_name
       join obj_install_object_tab  pkg
            on  pkg.object_owner  = ctx.schema
            and pkg.object_name   = ctx.package
            and pkg.object_type   = 'PACKAGE'
       join install_type_timing  t
            -- Ensure the package is installed before this Context
            on  t.from_install_type = obj.install_type
            and t.to_install_type   = pkg.install_type
 where obj.object_owner = 'SYS'
  and  obj.object_type  = 'CONTEXT'
  and  ctx.namespace not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW


--  Grants


--  Synonyms


set define on
