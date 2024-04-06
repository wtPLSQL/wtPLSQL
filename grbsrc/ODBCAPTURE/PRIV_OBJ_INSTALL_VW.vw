
--
--  Create ODBCAPTURE.PRIV_OBJ_INSTALL_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "OBJECT_INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then obj.install_type
            else uor.install_type
       end                            INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'OBJECT'
            else 'GRANTEE'
       end                            INSTALL_TYPE_SELECTOR
      ,obj.install_type               OBJECT_INSTALL_TYPE
      ,obj.object_owner
      ,obj.object_name
      ,obj.object_type
      ,uor.install_type               GRANTEE_INSTALL_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join dba_tab_privs_tab  priv
            on  priv.grantee = uor.user_or_role
       join obj_install_object_tab  obj
            on  obj.object_owner  = priv.object_owner
            and obj.object_name   = priv.object_name
            and obj.object_type   = priv.object_type
       join otype_conf  otc
            on  otc.install_otype = 'GRANT'
       join install_type_timing  t
            -- Ensure Grantee is available after installation of object
            on  from_install_type = obj.object_install_type
            and to_install_type   = uor.install_type
 where priv.object_owner != 'SYS'   -- Exclude database objects owned by SYS
  and  (   uor.install_type not in ('sys','pub')  -- Exclude 'sys' and 'pub' Grantees
        OR (    uor.install_type                  = 'pub'             -- Include 'pub' Grantees
            AND obj.object_owner_install_type not in ('sys','pub') )  -- Only if owner not sys or pub
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW


--  Grants


--  Synonyms


set define on
