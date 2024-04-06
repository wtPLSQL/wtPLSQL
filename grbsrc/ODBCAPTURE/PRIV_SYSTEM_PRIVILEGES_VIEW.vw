
--
--  Create ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "GRANTEE_INSTALL_TYPE", "GRANTEE_UOR_TYPE", "GRANTEE", "SYSTEM_PRIVILEGE_NAME", "ADMIN_OPTION", "COMMON", "INHERITED") AS 
  select uor.install_type
      ,'GRANTEE'               INSTALL_TYPE_SELECTOR
      ,uor.install_type        GRANTEE_INSTALL_TYPE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.grantee
      ,priv.privilege          SYSTEM_PRIVILEGE_NAME
      ,priv.admin_option
      ,priv.common
      ,priv.inherited
 from  uor_install_view  uor
       join dba_sys_privs  priv
            on  priv.grantee   = uor.user_or_role
            and priv.privilege not like '% ANY QUEUE'
 -- Exclude 'sys' and 'pub' Grantees
 where uor.install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on
