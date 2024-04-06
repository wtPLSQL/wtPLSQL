
--
--  Create ODBCAPTURE.ZX_OBJ_INSTALL_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."ZX_OBJ_INSTALL_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.ZX_OBJ_INSTALL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."ZX_OBJ_INSTALL_VIEW" ("INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "INSTALL_OTYPE", "FILTER_SELECTOR", "SOURCE_VIEW") AS 
  select install_type
      ,base_table_owner                   OBJECT_OWNER
      ,foreign_key_name                   OBJECT_NAME
      ,NULL                               OBJECT_TYPE
      ,install_otype
      ,nvl2(install_type_selector, 'SEL:' || install_type_selector, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_FKEY_TAB'             SOURCE_VIEW
 from  obj_install_fkey_tab
UNION ALL
select install_type
      ,trigger_owner                      OBJECT_OWNER
      ,trigger_name                       OBJECT_NAME
      ,object_type
      ,install_otype
      ,nvl2(install_type_selector, 'SEL:' || install_type_selector, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_TRIGGER_TAB'          SOURCE_VIEW
 from  obj_install_trigger_tab
UNION ALL
select install_type
      ,object_owner
      ,object_name
      ,object_type
      ,install_otype
      ,nvl2(oname_filter, 'FLTR:' || oname_filter, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_OBJECT_TAB'           SOURCE_VIEW
 from  obj_install_object_tab
 where object_type not in ('INDEX', 'SYNONYM', 'TRIGGER')
  and  object_install_type not in ('sys','pub')  -- Exclude 'sys' or 'pub' database objects
UNION ALL
select install_type
      ,synonym_owner                      OBJECT_OWNER
      ,synonym_name                       OBJECT_NAME
      ,object_type
      ,install_otype
      ,nvl2(install_type_selector, 'SEL:' || install_type_selector, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_SYNONYM_TAB'          SOURCE_VIEW
 from  obj_install_synonym_TAB
UNION ALL
select install_type
      ,index_owner                        OBJECT_OWNER
      ,index_name                         OBJECT_NAME
      ,object_type
      ,install_otype
      ,nvl2(install_type_selector, 'SEL:' || install_type_selector, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_INDEX_TAB'            SOURCE_VIEW
 from  obj_install_index_tab
UNION ALL
select install_type
      ,context_owner                      OBJECT_OWNER
      ,context_name                       OBJECT_NAME
      ,context_type                       OBJECT_TYPE
      ,install_otype
      ,NULL                               FILTER_SELECTOR
      ,'OBJ_INSTALL_CONTEXT_TAB'          SOURCE_VIEW
 from  obj_install_context_tab
UNION ALL
select install_type
      ,table_owner                        OBJECT_OWNER
      ,table_name                         OBJECT_NAME
      ,NULL                               OBJECT_TYPE
      ,install_otype
      ,nvl2(where_clause, 'FLTR:' || where_clause, NULL)
                                          FILTER_SELECTOR
      ,'OBJ_INSTALL_DATA_LOAD_TAB'        SOURCE_VIEW
 from  obj_install_data_load_tab;

--  Comments

--DBMS_METADATA:ODBCAPTURE.ZX_OBJ_INSTALL_VIEW


--  Grants


--  Synonyms


set define on
