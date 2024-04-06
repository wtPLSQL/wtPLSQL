
--
--  Create ODBCAPTURE.DBA_TAB_PRIVS_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW" ("OBJECT_OWNER_INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_TYPE", "OBJECT_NAME", "PRIVILEGE", "GRANTEE", "GRANTEE_UOR_TYPE", "GRANTEE_INSTALL_TYPE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
  select obj.object_owner_install_type
      ,priv.owner                       OBJECT_OWNER
      ,priv.type                        OBJECT_TYPE
      ,priv.table_name                  OBJECT_NAME
      ,priv.privilege
      ,priv.grantee
      ,gsl.uor_type                     GRANTEE_UOR_TYPE
      ,gsl.install_type                 GRANTEE_INSTALL_TYPE
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
 from  dba_objects_tab  obj
       join dba_tab_privs  priv
            on  priv.owner      = obj.object_owner
            and priv.table_name = obj.object_name
       join uor_install_view  gsl
            on  gsl.user_or_role = priv.grantee
 where (   gsl.install_type not in ('sys','pub')  -- No Grants to 'sys' or 'pub' grantees
        OR (    gsl.install_type                   = 'pub'           -- Grants to 'pub'
            and obj.object_owner_install_type not in ('sys','pub') )  -- But not owned by 'sys' or 'pub'
        OR (    gsl.install_type = 'pub'         -- Grants to 'pub'
            and priv.type        = 'DIRECTORY')  -- Directories are owned by 'SYS'
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW


--  Grants


--  Synonyms


set define on
