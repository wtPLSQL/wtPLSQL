
--
--  Create ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "QUEUE_INSTALL_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then obj.install_type
            else uor.install_type
       end                            INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'GRANTEE'
       end                            INSTALL_TYPE_SELECTOR
      ,obj.install_type               QUEUE_INSTALL_TYPE
      ,obj.object_owner               QUEUE_OWNER
      ,obj.object_name                QUEUE_NAME
      ,'QUEUE'                        OBJECT_TYPE
      ,uor.install_type               GRANTEE_INSTALL_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,tp.privilege
      ,tp.grantable
      ,tp.hierarchy
      ,tp.common
      ,tp.inherited
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from uor_install_view  uor
       join dba_tab_privs_tab  tp
            on  tp.grantee     = uor.user_or_role
            and tp.object_type = 'QUEUE'
      join dba_queues  aq
            on  aq.owner = tp.object_owner
            and aq.name  = tp.object_name
       join obj_install_object_tab  obj
            on  obj.object_owner = tp.object_owner
            and obj.object_name  = tp.object_name
            and obj.object_type  = 'QUEUE'
       join otype_conf  otc
            on  otc.install_otype = 'GRANT'
       join install_type_timing  t
            -- Ensure the Grantee is available when the Queue is installed
            on  t.from_install_type = obj.install_type
            and t.to_install_type   = uor.install_type
 where (   aq.queue_type is null
        or aq.queue_type != 'EXCEPTION_QUEUE')
  and  aq.name not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\'
  and  (   uor.install_type not in ('sys','pub')  -- Exclude 'sys' and 'pub' Grantees
        OR (    uor.install_type            = 'pub'             -- Include 'pub' Grantess
            AND obj.object_install_type not in ('sys','pub') )  -- Only if owner not sys or pub
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW


--  Synonyms


set define on
