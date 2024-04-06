
--
--  Create ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "GRANT_INSTALL_TYPE", "GRANT_OWNER", "GRANT_NAME", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "ADMIN_OPTION", "COMMON", "INHERITED", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select uor.install_type
      ,'GRANTEE'               INSTALL_TYPE_SELECTOR
      ,'sys'                   GRANT_INSTALL_TYPE
      ,'SYS'                   GRANT_OWNER
      ,aqsp.dbms_aq_priv       GRANT_NAME
      ,uor.install_type        GRANTEE_INSTALL_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,aqsp.admin_option
      ,aqsp.common
      ,aqsp.inherited
      ,'GRANT'                 INSTALL_OTYPE
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join aq_system_privs_vw  aqsp
            on  aqsp.grantee = uor.user_or_role
       join otype_conf  otc
            on  otc.install_otype = 'GRANT'
 -- Exclude 'sys' and 'pub' Grantees
 where uor.install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW


--  Grants


--  Synonyms


set define on
