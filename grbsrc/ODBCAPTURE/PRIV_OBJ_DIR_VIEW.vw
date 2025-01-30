
--
--  Create ODBCAPTURE.PRIV_OBJ_DIR_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "OBJECT_NAME_REGEXP", "DIRECTORY_BUILD_TYPE", "DIRECTORY_OWNER", "DIRECTORY_NAME", "OBJECT_TYPE", "DIRECTORY_PATH", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select oc.build_type
      ,t.build_timing
      ,oc.object_name_regexp
      ,oc.build_type           DIRECTORY_BUILD_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.build_type          GRANTEE_BUILD_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'      -- Not Oracle Provided Grantee
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
            and dir.directory_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join element_conf  ec
            on  ec.element_name = priv.object_type
       join object_conf  oc
            -- OBJECT_CONF is configured based on Grantee, not Owner
            on  oc.username     = uor.user_or_role
            and oc.build_type  != uor.build_type
            and oc.element_name = priv.object_type
            and regexp_like(dir.directory_name, oc.object_name_regexp)
       join build_type_timing  t
            -- Ensure Grantee is available when Directory is installed
            on  t.from_build_type = oc.build_type
            and t.to_build_type   = uor.build_type
 where priv.object_owner = 'SYS'
  and  priv.object_type  = 'DIRECTORY'
), q_dflt as (
select uor.build_type
      ,'CURRENT'               BUILD_TIMING
      ,NULL                    OBJECT_NAME_REGEXP
      ,'sys'                   DIRECTORY_BUILD_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.build_type          GRANTEE_BUILD_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role    = priv.grantee
            and uor.oracle_provided = 'N'      -- Not Oracle Provided Grantee
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
            and dir.directory_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join element_conf  ec
            on  ec.element_name = priv.object_type
 where (priv.grantee, dir.directory_name) not in (select q_nondflt.grantee, q_nondflt.directory_name from q_nondflt)
  and  priv.object_owner = 'SYS'
  and  priv.object_type  = 'DIRECTORY'
)
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","DIRECTORY_BUILD_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","DIRECTORY_BUILD_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW


--  Grants


--  Synonyms


set define on
