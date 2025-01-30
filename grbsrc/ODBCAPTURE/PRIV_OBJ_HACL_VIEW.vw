
--
--  Create ODBCAPTURE.PRIV_OBJ_HACL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_HACL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_HACL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_HACL_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "HACL_BUILD_TYPE", "HACL_NAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "HOST", "LOWER_PORT", "UPPER_PORT", "ACE_ORDER", "START_DATE", "END_DATE", "PRINCIPAL_TYPE", "GRANT_TYPE", "INVERTED_PRINCIPAL", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select case t.build_timing
            when 'CURRENT'
            then ol.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'OBJECT_NAME_REGEXP'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,ol.object_name_regexp
      ,ol.build_type                  HACL_BUILD_TYPE
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      HACL_NAME           -- Defined Length Concatenations Don't Need a CAST
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_host_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
       join element_conf  ec
            on  ec.element_name = 'HOST_ACL'
       join object_conf  ol
            on  ol.username     = uor.user_or_role
            and ol.build_type  != uor.build_type
            and ol.element_name = ec.element_name
            and regexp_like(a.host || ',' || a.lower_port || '-' || a.upper_port, ol.object_name_regexp)
       join build_type_timing  t
            -- Ensure the Grantee is available when the HACL is installed
            on  t.from_build_type = ol.build_type
            and t.to_build_type   = uor.build_type
 where (   uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
        OR uor.build_type = 'pub')    -- Include PUBLIC as the grantee
), q_dflt as (
  select uor.build_type
      ,'CURRENT'                      BUILD_TIMING
      ,'GRANTEE'                      BUILD_TYPE_SELECTOR
      ,NULL                           OBJECT_NAME_REGEXP
      ,'sys'                          HACL_BUILD_TYPE  -- Use the BUILD_TYPE of the Grantee
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      HACL_NAME          -- Defined Length Concatenations Don't Need a CAST
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
  from dba_host_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join element_conf  ec
            on  ec.element_name = 'HOST_ACL'
 where (a.principal, a.host || ',' || a.lower_port || '-' || a.upper_port) not in
       (select q_nondflt.grantee, q_nondflt.hacl_name from q_nondflt)
)
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","HACL_BUILD_TYPE","HACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","HACL_BUILD_TYPE","HACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_HACL_VIEW


--  Grants


--  Synonyms


set define on
