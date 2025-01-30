
--
--  Create ODBCAPTURE.DBA_TAB_PRIVS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_TYPE", "OBJECT_NAME", "PRIVILEGE", "GRANTEE", "GRANTEE_UOR_TYPE", "GRANTEE_BUILD_TYPE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
  select obj.object_owner_build_type
      ,priv.owner                       OBJECT_OWNER
      ,priv.type                        OBJECT_TYPE
      ,priv.table_name                  OBJECT_NAME
      ,priv.privilege
      ,priv.grantee
      ,gsl.uor_type                     GRANTEE_UOR_TYPE
      ,gsl.build_type                   GRANTEE_BUILD_TYPE
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
       join schema_conf  own
            on  own.username = priv.owner
 where (   gsl.oracle_provided = 'N'             -- Not Oracle Provided Grantee
        OR (    gsl.build_type      = 'pub'      -- Grants to 'pub'
            and own.oracle_provided = 'N' )      -- But not owned by Oracle Provided
        OR (    gsl.build_type = 'pub'           -- Grants to 'pub'
            and priv.type      = 'DIRECTORY')    -- Directories are owned by 'SYS'
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW


--  Grants


--  Synonyms


set define on
