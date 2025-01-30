
--
--  Create ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "ROLE_BUILD_TYPE", "ROLENAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "DEFAULT_ROLE", "ADMIN_OPTION", "DELEGATE_OPTION", "COMMON", "INHERITED") AS 
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
      ,trc.build_type                            ROLE_BUILD_TYPE
      ,trc.rolename
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.user_or_role                          GRANTEE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.default_role
      ,priv.admin_option
      ,priv.delegate_option
      ,priv.common
      ,priv.inherited
 from  dba_role_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join role_conf  trc
            on  trc.rolename        = priv.granted_role
            and trc.oracle_provided = 'Y'    -- Only Oracle Provided Roles
  left join object_conf  oc
            on  oc.element_name = 'ROLE'
            and oc.username     = priv.grantee
            and regexp_like(trc.rolename, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
UNION ALL
  select case t.build_timing
          when 'FUTURE' then trc.build_type
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
      ,NULL                                      OBJECT_NAME_REGEXP
      ,NULL                                      OBJECT_NAME_REGEXP_BUILD_TYPE
      ,trc.build_type                            ROLE_BUILD_TYPE
      ,trc.rolename
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.user_or_role                          GRANTEE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.default_role
      ,priv.admin_option
      ,priv.delegate_option
      ,priv.common
      ,priv.inherited
 from  dba_role_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join role_conf  trc
            on  trc.rolename        = priv.granted_role
            and trc.oracle_provided = 'N'    -- Not Oracle Provided Role
       -- Ensure the Grantee is available after installation of the Role
       join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = trc.build_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on
