
--
--  Create ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE_UOR_TYPE", "GRANTEE", "SYSTEM_PRIVILEGE_NAME", "ADMIN_OPTION", "COMMON", "INHERITED") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                                       BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                                       BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                                       BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                             OBJECT_NAME_REGEXP_BUILD_TYPE
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.grantee
      ,priv.privilege                            SYSTEM_PRIVILEGE_NAME
      ,priv.admin_option
      ,priv.common
      ,priv.inherited
 from  dba_sys_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
  left join object_conf  oc
            on  oc.element_name = 'GRANT'
            and oc.username     = priv.grantee
            and regexp_like(priv.privilege, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
 where priv.privilege not like '% ANY QUEUE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on
