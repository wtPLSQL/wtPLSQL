
--
--  Create ODBCAPTURE.PRIV_OBJ_JAVA_FG_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_JAVA_FG_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_JAVA_FG_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_JAVA_FG_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "JAVA_CLASS_INSTALL_TYPE", "JAVA_CLASS_OWNER", "JAVA_CLASS_MASK", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "JAVA_CLASS_GRANT", "JAVA_CLASS_PERMISSION", "KIND", "SEQ", "ENABLED") AS 
  select case t.install_timing
            when 'CURRENT'
            then own.install_type
            else uor.install_type
       end                               INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'JAVA_CLASS'
            else 'GRANTEE'
       end                               INSTALL_TYPE_SELECTOR
      ,own.install_type                  JAVA_CLASS_INSTALL_TYPE
      ,djp.type_schema                   JAVA_CLASS_OWNER
      ,substr(djp.name, 1, 256)          JAVA_CLASS_MASK
      ,uor.install_type                  GRANTEE_INSTALL_TYPE
      ,uor.user_or_role                  GRANTEE
      ,uor.uor_type                      GRANTEE_UOR_TYPE
      ,substr(djp.type_name, 1, 256)     JAVA_CLASS_GRANT
      ,substr(djp.action, 1, 256)        JAVA_CLASS_PERMISSION
      ,djp.kind
      ,djp.seq
      ,djp.enabled
 from  uor_install_view  uor
       join dba_java_policy  djp
            on  djp.grantee = uor.user_or_role
       join uor_install_view  own
            on  own.user_or_role = djp.type_schema
       join install_type_timing  t
            -- Ensure the Grantee is available when the Java Owner is installed
            on  t.from_install_type = own.install_type
            and t.to_install_type   = uor.install_type
 -- Exclude 'sys' and 'pub' Grantees
 where uor.install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_JAVA_FG_VIEW


--  Synonyms


set define on
