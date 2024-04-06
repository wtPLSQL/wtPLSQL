
--
--  Create ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW" ("INSTALL_TYPE", "INSTALL_TIMING", "ONAME_FILTER", "OBJECT_OWNER_INSTALL_TYPE", "OBJECT_OWNER", "OBJECT_INSTALL_TYPE", "OBJECT_NAME", "OBJECT_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  with q_nondflt as (
  select oc.install_type
      ,t.install_timing
      ,oc.oname_filter
      ,obj.object_owner_install_type
      ,obj.object_owner
      ,oc.install_type               OBJECT_INSTALL_TYPE
      ,obj.object_name
      ,obj.object_type
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  dba_objects_tab  obj
       join otype_conf  otc
            on  otc.object_type = obj.object_type
            and (   otc.object_type != 'INDEX'
                 or otc.install_otype = (select case ind.table_type
                                                when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                         else ind.table_type
                                                end      || '_INDEX'
                                          from  dba_indexes  ind
                                          where ind.owner = obj.object_owner
                                           and  ind.index_name = obj.object_name) )
            and (   otc.object_type != 'TRIGGER'
                 or otc.install_otype = (select case trg.base_object_type
                                                when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                         else trg.base_object_type
                                                end      || '_TRIGGER'
                                          from  dba_triggers  trg
                                          where trg.owner = obj.object_owner
                                           and  trg.trigger_name = obj.object_name) )
       join object_conf  oc
            on  oc.username      = obj.object_owner
            and oc.install_type != obj.object_owner_install_type
            and oc.install_otype = otc.install_otype
            and regexp_like(obj.object_name, oc.oname_filter)
       join install_type_timing  t
            -- Ensure the owner is installed before this object
            on  t.from_install_type = oc.install_type
            and t.to_install_type   = obj.object_owner_install_type
 where (   obj.table_flag != 'NT'    -- Nested Tables masquarade as tables in DBA_OBJECTS
        OR obj.table_flag is NULL)
  and  obj.object_name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
), q_dflt as (
  select obj.object_owner_install_type INSTALL_TYPE
      ,'CURRENT'                     INSTALL_TIMING
      ,NULL                          ONAME_FILTER
      ,obj.object_owner_install_type
      ,obj.object_owner
      ,obj.object_owner_install_type OBJECT_INSTALL_TYPE
      ,obj.object_name
      ,obj.object_type
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  dba_objects_tab  obj
       join otype_conf  otc
            on  otc.object_type = obj.object_type
            and (   otc.object_type != 'INDEX'
                 or otc.install_otype = (select case ind.table_type
                                                when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                         else ind.table_type
                                                end      || '_INDEX'
                                          from  dba_indexes  ind
                                          where ind.owner = obj.object_owner
                                           and  ind.index_name = obj.object_name) )
            and (   otc.object_type  != 'TRIGGER'
                 or otc.install_otype = (select case trg.base_object_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else trg.base_object_type
                                               end      || '_TRIGGER'
                                         from  dba_triggers  trg
                                         where trg.owner = obj.object_owner
                                          and  trg.trigger_name = obj.object_name) )
 where (   obj.table_flag != 'NT'    -- Nested Tables masquarade as tables in DBA_OBJECTS
        OR obj.table_flag is NULL)
  and  (obj.object_owner, obj.object_type, obj.object_name) not in (
        select q_nondflt.object_owner, q_nondflt.object_type, q_nondflt.object_name from q_nondflt)
  and  obj.object_name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
), q_sys as (
  select oc.install_type
      ,'CURRENT'                     INSTALL_TIMING
      ,oc.oname_filter
      ,oc.install_type               OBJECT_OWNER_INSTALL_TYPE
      ,obj.object_owner
      ,oc.install_type               OBJECT_INSTALL_TYPE
      ,obj.object_name
      ,obj.object_type
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  dba_objects_tab  obj
       join otype_conf  otc
            on  otc.object_type = obj.object_type
       join object_conf  oc
            on  oc.username      = obj.object_owner
            and oc.install_type != obj.object_owner_install_type
            and oc.install_otype = otc.install_otype
            and regexp_like(obj.object_name, oc.oname_filter)
 where obj.object_name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
  and  obj.object_owner = 'SYS'
  and  obj.object_type in ('CONTEXT', 'DIRECTORY')
)
select "INSTALL_TYPE","INSTALL_TIMING","ONAME_FILTER","OBJECT_OWNER_INSTALL_TYPE","OBJECT_OWNER","OBJECT_INSTALL_TYPE","OBJECT_NAME","OBJECT_TYPE","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_nondflt
UNION ALL
select "INSTALL_TYPE","INSTALL_TIMING","ONAME_FILTER","OBJECT_OWNER_INSTALL_TYPE","OBJECT_OWNER","OBJECT_INSTALL_TYPE","OBJECT_NAME","OBJECT_TYPE","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_dflt
UNION ALL
select "INSTALL_TYPE","INSTALL_TIMING","ONAME_FILTER","OBJECT_OWNER_INSTALL_TYPE","OBJECT_OWNER","OBJECT_INSTALL_TYPE","OBJECT_NAME","OBJECT_TYPE","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_sys;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW


--  Grants


--  Synonyms


set define on
