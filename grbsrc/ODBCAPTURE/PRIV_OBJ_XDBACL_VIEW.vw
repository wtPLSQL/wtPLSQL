
--
--  Create ODBCAPTURE.PRIV_OBJ_XDBACL_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_XDBACL_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_XDBACL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_XDBACL_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "ONAME_FILTER", "XDBACL_INSTALL_TYPE", "XDBACL_NAME", "XDBACL_TYPE", "GRANTEE_INSTALL_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "XDBACL_HOST", "LOWER_PORT", "UPPER_PORT", "ACE_ORDER", "START_DATE", "END_DATE", "INVERTED_PRINCIPAL", "PRINCIPAL_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  with q_nondflt as (
  select case t.install_timing
            when 'CURRENT'
            then ol.install_type
            else uor.install_type
       end                            INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'ONAME_FILTER'
            else 'GRANTEE'
       end                            INSTALL_TYPE_SELECTOR
      ,ol.oname_filter
      ,ol.install_type                XDBACL_INSTALL_TYPE
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      XDBACL_NAME           -- Defined Length Concatenations Don't Need a CAST
      ,'XDB ACL (Host Aces)'          XDBACL_TYPE
      ,uor.install_type               GRANTEE_INSTALL_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host                         XDBACL_HOST
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.inverted_principal
      ,a.principal_type
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join dba_host_aces  a
            on  a.principal_type     = 'DATABASE'       -- xs_acl.ptype_db
            and a.grant_type         = 'GRANT'
            and a.inverted_principal = 'NO'
            and a.privilege         is not null
            and a.principal          = uor.user_or_role
       join otype_conf  otc
            on  otc.install_otype = 'XDB_ACL'
       join object_conf  ol
            on  ol.username      = uor.user_or_role
            and ol.install_type != uor.install_type
            and ol.install_otype = otc.install_otype
            and regexp_like(a.host || ',' || a.lower_port || '-' || a.upper_port, ol.oname_filter)
       join install_type_timing  t
            -- Ensure the Grantee is available when the XDBACL is installed
            on  t.from_install_type = ol.install_type
            and t.to_install_type   = uor.install_type
 -- Exclude 'sys' Grantees
 where uor.install_type not in ('sys','pub')
), q_dflt as (
  select uor.install_type
      ,'GRANTEE'                      INSTALL_TYPE_SELECTOR
      ,NULL                           ONAME_FILTER
      ,'sys'                          XDBACL_INSTALL_TYPE  -- Use the INSTALL_TYPE of the Grantee
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      XDBACL_NAME          -- Defined Length Concatenations Don't Need a CAST
      ,'XDB ACL (Host Aces)'          XDBACL_TYPE
      ,uor.install_type               GRANTEE_INSTALL_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host                         XDBACL_HOST
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.inverted_principal
      ,a.principal_type
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  uor_install_view  uor
       join dba_host_aces  a
            on  a.principal_type     = 'DATABASE'       -- xs_acl.ptype_db
            and a.grant_type         = 'GRANT'
            and a.inverted_principal = 'NO'
            and a.privilege         is not null
            and a.principal          = uor.user_or_role
       join otype_conf  otc
            on  otc.install_otype = 'XDB_ACL'
 where (a.principal, a.host || ',' || a.lower_port || '-' || a.upper_port) not in
       (select q_nondflt.grantee, q_nondflt.xdbacl_name from q_nondflt  q_nondflt)
       -- Exclude 'sys' Grantees
  and  uor.install_type not in ('sys','pub')
)
select "INSTALL_TYPE","INSTALL_TYPE_SELECTOR","ONAME_FILTER","XDBACL_INSTALL_TYPE","XDBACL_NAME","XDBACL_TYPE","GRANTEE_INSTALL_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","XDBACL_HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","INVERTED_PRINCIPAL","PRINCIPAL_TYPE","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_nondflt
UNION ALL
select "INSTALL_TYPE","INSTALL_TYPE_SELECTOR","ONAME_FILTER","XDBACL_INSTALL_TYPE","XDBACL_NAME","XDBACL_TYPE","GRANTEE_INSTALL_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","XDBACL_HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","INVERTED_PRINCIPAL","PRINCIPAL_TYPE","INSTALL_OTYPE","EXT","EXT2","EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_XDBACL_VIEW


--  Synonyms


set define on
