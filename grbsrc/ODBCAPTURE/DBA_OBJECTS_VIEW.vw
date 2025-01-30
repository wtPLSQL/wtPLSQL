
--
--  Create ODBCAPTURE.DBA_OBJECTS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_OBJECTS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_OBJECTS_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "TABLE_FLAG", "SELTYPE") AS 
  select sc.build_type           OBJECT_OWNER_BUILD_TYPE
      ,obj.owner                 OBJECT_OWNER
      ,obj.object_name
      ,obj.object_type
      ,case when  nt.table_name is not null then  'NT'
            when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
                                            else NULL
       end                       TABLE_FLAG
      ,'BASE'                    SELTYPE
 from  schema_conf  sc
       join dba_objects  obj
            on  obj.owner = sc.username
  left join dba_tables  tab
            on  tab.owner       = obj.owner
            and tab.table_name  = obj.object_name
            and obj.object_type = 'TABLE'
  left join dba_xml_tables  xml
            on  xml.owner       = obj.owner
            and xml.table_name  = obj.object_name
            and obj.object_type = 'TABLE'
  left join dba_nested_tables  nt
            on  nt.owner        = obj.owner
            and nt.table_name   = obj.object_name
            and obj.object_type = 'TABLE'
 where sc.oracle_provided = 'N'      -- Exclude Oracle Provided Object Owner
 group by obj.owner
      ,sc.build_type
      ,obj.object_name
      ,obj.object_type
      ,case when  nt.table_name is not null then  'NT'
            when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
                                            else NULL
       end
UNION ALL
select sco.build_type            OBJECT_OWNER_BUILD_TYPE
      ,syn.owner                 OBJECT_OWNER
      ,syn.synonym_name          OBJECT_NAME
      ,'SYNONYM'                 OBJECT_TYPE
      ,NULL                      TABLE_FLAG
      ,'PUB'                     SELTYPE
 from  schema_conf  sco
       join dba_synonyms  syn
            on  syn.owner = sco.username
       join schema_conf  sct
            on  sct.username        = syn.table_owner
            and sct.oracle_provided = 'N'   -- Exclude Oracle Provided Synonym Owner
 where sco.build_type = 'pub'     -- Public Synonyms
UNION ALL
select sco.build_type            OBJECT_OWNER_BUILD_TYPE
      ,priv.owner                OBJECT_OWNER
      ,priv.table_name           OBJECT_NAME
      ,priv.type                 OBJECT_TYPE
      ,case when  nt.table_name is not null then  'NT'
            when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
                                            else NULL
       end                       TABLE_FLAG
      ,'SYS'                     SELTYPE
 from  schema_conf  sco
       join dba_tab_privs  priv
            on  priv.owner      = sco.username
       join schema_conf  sct
            on  sct.username        = priv.grantee
            and sct.oracle_provided = 'N'   -- Exclude Oracle Provided Grantee
  left join dba_tables  tab
            on  tab.owner      = priv.owner
            and tab.table_name = priv.table_name
            and priv.type      = 'TABLE'
  left join dba_xml_tables  xml
            on  xml.owner      = priv.owner
            and xml.table_name = priv.table_name
            and priv.type      = 'TABLE'
  left join dba_nested_tables  nt
            on  nt.owner      = priv.owner
            and nt.table_name = priv.table_name
            and priv.type     = 'TABLE'
 where sco.oracle_provided = 'Y'          -- ONLY Oracle Provided Object Owners
 group by priv.owner
      ,sco.build_type
      ,priv.table_name
      ,priv.type
      ,case when  nt.table_name is not null then  'NT'
            when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
                                            else NULL
       end;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_VIEW


--  Grants


--  Synonyms


set define on
