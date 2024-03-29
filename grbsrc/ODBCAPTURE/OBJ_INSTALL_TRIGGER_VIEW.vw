
--
--  Create ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "TRIGGER_INSTALL_TYPE", "TRIGGER_ONAME_FILTER", "TRIGGER_OWNER", "TRIGGER_NAME", "OBJECT_TYPE", "TARGET_INSTALL_TYPE", "TARGET_ONAME_FILTER", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then obj.install_type
            else tab.install_type
      end                             INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'TRIGGER'
            else 'TARGET'
      end                             INSTALL_TYPE_SELECTOR
      ,obj.install_type               TRIGGER_INSTALL_TYPE
      ,obj.oname_filter               TRIGGER_ONAME_FILTER
      ,obj.object_owner               TRIGGER_OWNER
      ,obj.object_name                TRIGGER_NAME
      ,obj.object_type
      ,tab.install_type               TARGET_INSTALL_TYPE
      ,tab.oname_filter               TARGET_ONAME_FILTER
      ,tab.object_owner               TARGET_OWNER
      ,tab.object_name                TARGET_NAME
      ,tab.object_type                TARGET_TYPE
      ,obj.install_otype
      ,obj.ext
      ,obj.ext2
      ,obj.ext3
 from  obj_install_object_tab  obj
       join dba_triggers  trig
            on  trig.owner        = obj.object_owner
            and trig.trigger_name = obj.object_name
       join obj_install_object_tab  tab
            on  tab.object_owner  = trig.table_owner
            and tab.object_name   = trig.table_name
            and tab.object_type   = trig.base_object_type  -- Eliminates SYSTEM Triggers
            and tab.install_type not in ('sys','pub')   -- Exclude 'sys' or 'pub' base tables
       join install_type_timing t
            -- Ensure the Table is installed before this Trigger
            on  t.from_install_type = obj.install_type
            and t.to_install_type   = tab.install_type
 where obj.object_type   = 'TRIGGER'
  and  obj.install_otype = case when trig.base_object_type = 'MATERIALIZED VIEW' then 'MVIEW_TRIGGER'
                                                                                 else trig.base_object_type || '_TRIGGER'
                           end
  and  obj.object_install_type not in ('sys','pub')   -- Exclude 'sys' or 'pub' database objects
  and  obj.object_name         not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW


--  Synonyms


set define on
