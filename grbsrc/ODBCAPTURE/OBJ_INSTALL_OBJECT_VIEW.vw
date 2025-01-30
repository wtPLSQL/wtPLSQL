
--
--  Create ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "OBJECT_NAME_REGEXP", "OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_BUILD_TYPE", "OBJECT_NAME", "OBJECT_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select oc.build_type
      ,t.build_timing
      ,oc.object_name_regexp
      ,obj.object_owner_build_type
      ,obj.object_owner
      ,oc.build_type               OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
            and (   ec.object_type != 'INDEX'
                 or ec.element_name  = (select case ind.table_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else ind.table_type
                                               end      || '_INDEX'
                                         from  dba_indexes  ind
                                         where ind.owner = obj.object_owner
                                          and  ind.index_name = obj.object_name) )
            and (   ec.object_type != 'TRIGGER'
                 or ec.element_name  = (select case trg.base_object_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else trg.base_object_type
                                               end      || '_TRIGGER'
                                         from  dba_triggers  trg
                                         where trg.owner = obj.object_owner
                                          and  trg.trigger_name = obj.object_name) )
       join object_conf  oc
            on  oc.username     = obj.object_owner
            and oc.build_type  != obj.object_owner_build_type
            and oc.element_name = ec.element_name
            and regexp_like(obj.object_name, oc.object_name_regexp)
       join build_type_timing  t
            -- Ensure the owner is installed before this object
            on  t.from_build_type = oc.build_type
            and t.to_build_type   = obj.object_owner_build_type
 where (   obj.table_flag != 'NT'    -- Nested Tables masquarade as tables in DBA_OBJECTS
        OR obj.table_flag is NULL)
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
), q_dflt as (
  select obj.object_owner_build_type BUILD_TYPE
      ,'CURRENT'                     BUILD_TIMING
      ,NULL                          OBJECT_NAME_REGEXP
      ,obj.object_owner_build_type
      ,obj.object_owner
      ,obj.object_owner_build_type   OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
            and (   ec.object_type != 'INDEX'
                 or ec.element_name  = (select case ind.table_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else ind.table_type
                                               end      || '_INDEX'
                                         from  dba_indexes  ind
                                         where ind.owner = obj.object_owner
                                          and  ind.index_name = obj.object_name) )
            and (   ec.object_type  != 'TRIGGER'
                 or ec.element_name  = (select case trg.base_object_type
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
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
), q_sys as (
  select oc.build_type
      ,'CURRENT'                     BUILD_TIMING
      ,oc.object_name_regexp
      ,oc.build_type                 OBJECT_OWNER_BUILD_TYPE
      ,obj.object_owner
      ,oc.build_type                 OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
       join object_conf  oc
            on  oc.username     = obj.object_owner
            and oc.build_type  != obj.object_owner_build_type
            and oc.element_name = ec.element_name
            and regexp_like(obj.object_name, oc.object_name_regexp)
 where obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
  and  obj.object_owner = 'SYS'
  and  obj.object_type in ('CONTEXT', 'DIRECTORY')
)
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_sys;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW


--  Grants


--  Synonyms


set define on
