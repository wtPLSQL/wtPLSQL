
--
--  Create ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "GRANT_BUILD_TYPE", "GRANT_OWNER", "GRANT_NAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "ADMIN_OPTION", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                              BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                              BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                              BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                    OBJECT_NAME_REGEXP_BUILD_TYPE
      ,'sys'                            GRANT_BUILD_TYPE
      ,'SYS'                            GRANT_OWNER
      ,aqsp.dbms_aq_priv                GRANT_NAME
      ,uor.build_type                   GRANTEE_BUILD_TYPE
      ,uor.user_or_role                 GRANTEE
      ,uor.uor_type                     GRANTEE_UOR_TYPE
      ,aqsp.admin_option
      ,aqsp.common
      ,aqsp.inherited
      ,'GRANT'                          ELEMENT_NAME
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  aq_system_privs_vw  aqsp
       join uor_install_view  uor
            on  uor.user_or_role = aqsp.grantee
            and uor.oracle_provided = 'N'   -- Exclude Oracle Provided Grantees
       join element_conf  ec
            on  ec.element_name = 'GRANT'
  left join object_conf  oc
            on  oc.element_name = 'GRANT'
            and oc.username     = aqsp.grantee
            and regexp_like(aqsp.dbms_aq_priv, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW


--  Grants


--  Synonyms


set define on
