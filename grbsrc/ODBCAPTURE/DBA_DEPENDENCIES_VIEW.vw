
--
--  Create ODBCAPTURE.DBA_DEPENDENCIES_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW" ("OBJECT_OWNER_INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "REFERENCED_OWNER", "REF_OWNER_INSTALL_TYPE", "REFERENCED_NAME", "REFERENCED_TYPE", "REFERENCED_LINK_NAME", "DEPENDENCY_TYPE") AS 
  select scd.install_type                   OBJECT_OWNER_INSTALL_TYPE
      ,dep.owner                          OBJECT_OWNER
      ,dep.name                           OBJECT_NAME
      ,dep.type                           OBJECT_TYPE
      ,dep.referenced_owner
      ,scr.install_type                   REF_OWNER_INSTALL_TYPE
      ,dep.referenced_name
      ,dep.referenced_type
      ,dep.referenced_link_name
      ,dep.dependency_type
 from  schema_conf  scd
       join dba_dependencies  dep
            on  dep.owner = scd.username
       join schema_conf  scr
            on  scr.username = dep.referenced_owner
              -- Exclude 'sys' and 'pub' database objects
 where scd.install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW


--  Synonyms


set define on
