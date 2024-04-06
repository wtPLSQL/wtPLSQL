
--
--  Create ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "OBJECT_OWNER_INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
  select priv.grantee_install_type      INSTALL_TYPE
      ,'GRANTEE'                        INSTALL_TYPE_SELECTOR
      ,priv.object_owner_install_type
      ,priv.object_owner
      ,priv.object_name
      ,priv.object_type
      ,priv.grantee_install_type
      ,priv.grantee
      ,priv.grantee_uor_type
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
 from  dba_tab_privs_tab  priv
       -- Include only 'sys' Objects
 where priv.object_owner_install_type  = 'sys'
       -- Exclude 'sys' and 'pub' Grantees
  and  priv.grantee_install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on
