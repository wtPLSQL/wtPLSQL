
--
--  Create ODBCAPTURE.PRIV_OBJ_DIR_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW" ("INSTALL_TYPE", "INSTALL_TIMING", "ONAME_FILTER", "DIRECTORY_INSTALL_TYPE", "DIRECTORY_OWNER", "DIRECTORY_NAME", "OBJECT_TYPE", "DIRECTORY_PATH", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  with q_nondflt as (
  select oc.install_type
      ,t.install_timing
      ,oc.oname_filter
      ,oc.install_type         DIRECTORY_INSTALL_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.install_type        GRANTEE_INSTALL_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join dba_tab_privs_tab  priv
            on  priv.grantee      = uor.user_or_role
            and priv.object_owner = 'SYS'
            and priv.object_type  = 'DIRECTORY'
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
       join otype_conf  otc
            on  otc.install_otype = priv.object_type
       join object_conf  oc
            -- OBJECT_CONF is configured based on Grantee, not Owner
            on  oc.username      = uor.user_or_role
            and oc.install_type != uor.install_type
            and oc.install_otype = priv.object_type
            and regexp_like(dir.directory_name, oc.oname_filter)
       join install_type_timing  t
            -- Ensure Grantee is available when Directory is installed
            on  t.from_install_type = oc.install_type
            and t.to_install_type   = uor.install_type
 where uor.install_type not in ('sys','pub')  -- Exclude 'sys' Grantees
  and  dir.directory_name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
), q_dflt as (
select uor.install_type
      ,'CURRENT'               INSTALL_TIMING
      ,NULL                    ONAME_FILTER
      ,'sys'                   DIRECTORY_INSTALL_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name 
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.install_type        GRANTEE_INSTALL_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join dba_tab_privs_tab  priv
            on  priv.grantee      = uor.user_or_role
            and priv.object_owner = 'SYS'
            and priv.object_type  = 'DIRECTORY'
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
       join otype_conf  otc
            on  otc.install_otype = priv.object_type
 where (priv.grantee, dir.directory_name) not in (select q_nondflt.grantee, q_nondflt.directory_name from q_nondflt)
  and  uor.install_type not in ('sys','pub')  -- Exclude 'sys' Grantees
  and  dir.directory_name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
)
select "INSTALL_TYPE","INSTALL_TIMING","ONAME_FILTER","DIRECTORY_INSTALL_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_INSTALL_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_nondflt
UNION ALL
select "INSTALL_TYPE","INSTALL_TIMING","ONAME_FILTER","DIRECTORY_INSTALL_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_INSTALL_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW


--  Synonyms


set define on
