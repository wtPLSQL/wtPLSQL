
--
--  Create ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "ROLE_INSTALL_TYPE", "ROLENAME", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "DEFAULT_ROLE", "ADMIN_OPTION", "DELEGATE_OPTION", "COMMON", "INHERITED") AS 
  select case t.install_timing
            when 'CURRENT'
            then trc.install_type
            else uor.install_type
       end                     INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'ROLE'
            else 'GRANTEE'
       end                     INSTALL_TYPE_SELECTOR
      ,trc.install_type        ROLE_INSTALL_TYPE
      ,trc.rolename
      ,uor.install_type        GRANTEE_INSTALL_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.default_role
      ,priv.admin_option
      ,priv.delegate_option
      ,priv.common
      ,priv.inherited
 from  uor_install_view  uor
       join dba_role_privs  priv
            on  priv.grantee = uor.user_or_role
       join role_conf  trc
            on  trc.rolename = priv.granted_role
       -- Ensure the Grantee is available after installation of the Role
       join install_type_timing  t
            on  t.from_install_type = trc.install_type
            and t.to_install_type   = uor.install_type
       -- Exclude 'sys' and 'pub' Grantees
 where uor.install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW


--  Synonyms


set define on
