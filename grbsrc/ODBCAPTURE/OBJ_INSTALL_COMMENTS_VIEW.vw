
--
--  Create ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW" ("INSTALL_TYPE", "OBJECT_OWNER_INSTALL_TYPE", "TABLE_OWNER", "TABLE_INSTALL_TYPE", "TABLE_NAME", "TABLE_TYPE", "INSTALL_OTYPE", "COLUMN_NAME", "COMMENTS") AS 
  select d.install_type
      ,d.object_owner_install_type
      ,c.owner                          TABLE_OWNER
      ,d.object_install_type            TABLE_INSTALL_TYPE
      ,c.table_name
      ,d.object_type                    TABLE_TYPE
      ,d.install_otype
      ,c.column_name
      ,c.comments
 from  obj_install_object_view  d
       join dba_col_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.comments is not null
 where d.object_type in ('TABLE','VIEW','MATERIALIZED VIEW')
       -- Don't need comments on sys or pub
  and  d.object_install_type not in ('sys','pub')
UNION ALL
select d.install_type
      ,d.object_owner_install_type
      ,c.owner                          TABLE_OWNER
      ,d.object_install_type            TABLE_INSTALL_TYPE
      ,c.table_name
      ,c.table_type
      ,d.install_otype
      ,NULL                             COLUMN_NAME
      ,c.comments
 from  obj_install_object_view  d
       join dba_tab_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.table_type  = d.object_type
            and c.comments is not null
       -- Don't need comments on sys or pub
 where d.object_install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW


--  Synonyms


set define on
