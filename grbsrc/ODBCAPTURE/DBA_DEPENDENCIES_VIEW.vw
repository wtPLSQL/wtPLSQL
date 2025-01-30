
--
--  Create ODBCAPTURE.DBA_DEPENDENCIES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "REFERENCED_OWNER", "REF_OWNER_BUILD_TYPE", "REFERENCED_NAME", "REFERENCED_TYPE", "REFERENCED_LINK_NAME", "DEPENDENCY_TYPE") AS 
  select scd.build_type                   OBJECT_OWNER_BUILD_TYPE
      ,dep.owner                          OBJECT_OWNER
      ,dep.name                           OBJECT_NAME
      ,dep.type                           OBJECT_TYPE
      ,dep.referenced_owner
      ,scr.build_type                     REF_OWNER_BUILD_TYPE
      ,dep.referenced_name
      ,dep.referenced_type
      ,dep.referenced_link_name
      ,dep.dependency_type
 from  schema_conf  scd
       join dba_dependencies  dep
            on  dep.owner = scd.username
       join schema_conf  scr
            on  scr.username = dep.referenced_owner
       -- Exclude Oracle Provided Object Owners
 where scd.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW


--  Grants


--  Synonyms


set define on
