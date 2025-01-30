
--
--  Create ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW" ("BUILD_TYPE", "OBJECT_OWNER_BUILD_TYPE", "TABLE_OWNER", "TABLE_BUILD_TYPE", "TABLE_NAME", "TABLE_TYPE", "ELEMENT_NAME", "COLUMN_NAME", "COMMENTS") AS 
  select d.build_type
      ,d.object_owner_build_type
      ,c.owner                          TABLE_OWNER
      ,d.object_build_type              TABLE_BUILD_TYPE
      ,c.table_name
      ,d.object_type                    TABLE_TYPE
      ,d.element_name
      ,c.column_name
      ,c.comments
 from  obj_install_object_tab  d
       join schema_conf  o
            on  o.username = d.object_owner
            -- Don't need comments on Oracle Provided Object Owners
            and o.oracle_provided = 'N'
       join dba_col_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.comments is not null
 where d.object_type in ('TABLE','VIEW','MATERIALIZED VIEW')
UNION ALL
select d.build_type
      ,d.object_owner_build_type
      ,c.owner                          TABLE_OWNER
      ,d.object_build_type              TABLE_BUILD_TYPE
      ,c.table_name
      ,c.table_type
      ,d.element_name
      ,NULL                             COLUMN_NAME
      ,c.comments
 from  obj_install_object_tab  d
       join schema_conf  o
            on  o.username = d.object_owner
            -- Don't need comments on Oracle Provided Object Owners
            and o.oracle_provided = 'N'
       join dba_tab_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.table_type  = d.object_type
            and c.comments is not null;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW


--  Grants


--  Synonyms


set define on
