
--
--  Create ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
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
      ,priv.object_owner_build_type
      ,priv.object_owner
      ,priv.object_name
      ,priv.object_type
      ,priv.grantee_build_type
      ,priv.grantee
      ,priv.grantee_uor_type
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
  left join object_conf  oc
            on  oc.element_name = 'SYS_GRANT'
            and oc.username     = priv.grantee
            and regexp_like(priv.object_name, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
       -- Include only 'sys' Objects
 where priv.object_owner  = 'SYS';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on
