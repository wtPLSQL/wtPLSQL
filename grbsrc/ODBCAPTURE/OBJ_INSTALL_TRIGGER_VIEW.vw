
--
--  Create ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "TRIGGER_BUILD_TYPE", "TRIGGER_OBJECT_NAME_REGEXP", "TRIGGER_OWNER", "TRIGGER_NAME", "OBJECT_TYPE", "TARGET_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else tab.build_type
      end                             BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'TRIGGER'
            else 'TARGET'
      end                             BUILD_TYPE_SELECTOR
      ,obj.build_type                 TRIGGER_BUILD_TYPE
      ,obj.object_name_regexp         TRIGGER_OBJECT_NAME_REGEXP
      ,obj.object_owner               TRIGGER_OWNER
      ,obj.object_name                TRIGGER_NAME
      ,obj.object_type
      ,tab.build_type                 TARGET_BUILD_TYPE
      ,tab.object_name_regexp         TARGET_OBJECT_NAME_REGEXP
      ,tab.object_owner               TARGET_OWNER
      ,tab.object_name                TARGET_NAME
      ,tab.object_type                TARGET_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join dba_triggers  trig
            on  trig.owner        = obj.object_owner
            and trig.trigger_name = obj.object_name
       join schema_conf  trigown
            on  trigown.username        = trig.owner
            and trigown.oracle_provided = 'N'  -- Exclude Oracle Provided Triggers
       join obj_install_object_tab  tab
            on  tab.object_owner  = trig.table_owner
            and tab.object_name   = trig.table_name
            and tab.object_type   = trig.base_object_type  -- Eliminates SYSTEM Triggers
       join schema_conf  tabown
            on  tabown.username        = tab.object_owner
            and tabown.oracle_provided = 'N'   -- Exclude Oracle Provided Base Tables
       join build_type_timing t
            -- Ensure the Table is installed before this Trigger
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = tab.build_type
 where obj.object_type  = 'TRIGGER'
  and  obj.element_name = case when trig.base_object_type = 'MATERIALIZED VIEW' then 'MVIEW_TRIGGER'
                                                                                else trig.base_object_type || '_TRIGGER'
                          end
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW


--  Grants


--  Synonyms


set define on
