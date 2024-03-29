
--
--  Create ODBCAPTURE.ZX_PRIV_ALL_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."ZX_PRIV_ALL_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.ZX_PRIV_ALL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."ZX_PRIV_ALL_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "INSTALL_OTYPE", "SOURCE_VIEW") AS 
  select install_type
      ,install_type_selector
      ,queue_owner                       OBJECT_OWNER
      ,queue_name                        OBJECT_NAME
      ,'QUEUE_REGISTER'                  OBJECT_TYPE
      ,consumer_name                     GRANTEE
      ,consumer_uor_type                 GRANTEE_UOR_TYPE
      ,'QUEUE'                           INSTALL_OTYPE
      ,'PRIV_QUEUE_REGISTER_VIEW'        SOURCE_VIEW
 from  priv_queue_register_view
UNION ALL
select install_type
      ,install_type_selector
      ,queue_owner                       OBJECT_OWNER
      ,queue_name                        OBJECT_NAME
      ,'QUEUE_SUBSCRIBE'                 OBJECT_TYPE
      ,consumer_name                     GRANTEE
      ,consumer_uor_type                 GRANTEE_UOR_TYPE
      ,'QUEUE'                           INSTALL_OTYPE
      ,'PRIV_QUEUE_SUSCRIBE_VIEW'        SOURCE_VIEW
 from  priv_queue_subscribe_view
UNION ALL
select install_type
      ,install_type_selector
      ,object_owner
      ,object_name
      ,object_type
      ,grantee
      ,grantee_uor_type
      ,install_otype
      ,'PRIV_OBJ_INSTALL_VW'             SOURCE_VIEW
 from  priv_obj_install_vw
 where object_type != 'QUEUE'
UNION ALL
select install_type
      ,install_type_selector
      ,'SYS'                             OBJECT_OWNER
      ,rolename                          OBJECT_NAME
      ,'ROLE'                            OBJECT_TYPE
      ,grantee
      ,grantee_uor_type
      ,'ROLE'                            INSTALL_OTYPE
      ,'PRIV_ROLE_PRIVILEGES_VIEW'       SOURCE_VIEW
 from  priv_role_privileges_view
UNION ALL
select install_type
      ,install_type_selector
      ,'SYS'                             OBJECT_OWNER
      ,system_privilege_name             OBJECT_NAME
      ,'SYSTEM_PRIVILEGE'                OBJECT_TYPE
      ,grantee
      ,grantee_uor_type
      ,'SYSTEM_PRIVILEGE'                INSTALL_OTYPE
      ,'PRIV_SYSTEM_PRIVILEGES_VIEW'     SOURCE_VIEW
 from  priv_system_privileges_view
UNION ALL
select install_type
      ,install_type_selector
      ,object_owner
      ,object_name
      ,object_type
      ,grantee
      ,grantee_uor_type
      ,'SYSOBJ_PRIVILEGES'               INSTALL_OTYPE
      ,'PRIV_SYSOBJ_PRIVILEGES_VIEW'     SOURCE_VIEW
 from  priv_sysobj_privileges_view;

--  Comments

--DBMS_METADATA:ODBCAPTURE.ZX_PRIV_ALL_VIEW


--  Synonyms


set define on
