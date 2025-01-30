
--
--  Create ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "BASE_TABLE_BUILD_TYPE", "BASE_TABLE_OBJECT_NAME_REGEXP", "BASE_TABLE_OWNER", "BASE_TABLE_NAME", "BASE_TABLE_TYPE", "FOREIGN_KEY_NAME", "UNIQUE_KEY_NAME", "UNIQUE_KEY_TYPE", "REF_TABLE_BUILD_TYPE", "REF_TABLE_OBJECT_NAME_REGEXP", "REF_TABLE_OWNER", "REF_TABLE_NAME", "REF_TABLE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then base_t.build_type
            else ref_t.build_type
      end                              BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'BASE TABLE'
            else 'REF TABLE'
      end                              BUILD_TYPE_SELECTOR
      ,base_t.build_type               BASE_TABLE_BUILD_TYPE
      ,base_t.object_name_regexp       BASE_TABLE_OBJECT_NAME_REGEXP
      ,base_t.object_owner             BASE_TABLE_OWNER
      ,base_t.object_name              BASE_TABLE_NAME
      ,base_t.object_type              BASE_TABLE_TYPE
      ,fk.constraint_name              FOREIGN_KEY_NAME
      ,pk.constraint_name              UNIQUE_KEY_NAME
      ,pk.constraint_type              UNIQUE_KEY_TYPE
      ,ref_t.build_type                REF_TABLE_BUILD_TYPE
      ,ref_t.object_name_regexp        REF_TABLE_OBJECT_NAME_REGEXP
      ,ref_t.object_owner              REF_TABLE_OWNER
      ,ref_t.object_name               REF_TABLE_NAME
      ,ref_t.object_type               REF_TABLE_TYPE
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  obj_install_object_tab  base_t
       join schema_conf  own
            on  own.username        = base_t.object_owner
            and own.oracle_provided = 'N'    -- Exclude base tables owned by Oracle Provided
       join element_conf  ec
            on  ec.element_name = case when base_t.object_type = 'MATERIALIZED VIEW'
                                       then 'MVIEW_FOREIGN_KEY'
                                       else base_t.object_type || '_FOREIGN_KEY'
                                  end
       join dba_constraints  fk
            on  fk.owner           = base_t.object_owner
            and fk.table_name      = base_t.object_name
            and fk.constraint_type = 'R'
            and fk.constraint_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join dba_constraints  pk
            on  pk.owner           = fk.r_owner
            and pk.constraint_name = fk.r_constraint_name
            and pk.constraint_type in ('P','U')
       join obj_install_object_tab  ref_t
            on  ref_t.object_owner  = pk.owner
            and ref_t.object_name   = pk.table_name
            and ref_t.object_type  in ('MATERIALIZED VIEW', 'TABLE', 'VIEW')
       join build_type_timing  t
            -- Ensure the Ref Table is installed before this Foreign Key
            on  t.from_build_type = base_t.build_type
            and t.to_build_type   = ref_t.build_type
 where base_t.object_type  in ('MATERIALIZED VIEW', 'TABLE', 'VIEW');

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW


--  Grants


--  Synonyms


set define on
