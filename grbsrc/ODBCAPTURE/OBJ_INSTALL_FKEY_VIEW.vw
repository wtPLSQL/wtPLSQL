
--
--  Create ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "BASE_TABLE_INSTALL_TYPE", "BASE_TABLE_ONAME_FILTER", "BASE_TABLE_OWNER", "BASE_TABLE_NAME", "BASE_TABLE_TYPE", "FOREIGN_KEY_NAME", "UNIQUE_KEY_NAME", "UNIQUE_KEY_TYPE", "REF_TABLE_INSTALL_TYPE", "REF_TABLE_ONAME_FILTER", "REF_TABLE_OWNER", "REF_TABLE_NAME", "REF_TABLE_TYPE", "INSTALL_OTYPE", "EXT", "EXT2", "EXT3") AS 
  select case t.install_timing
            when 'CURRENT'
            then base_t.install_type
            else ref_t.install_type
      end                              INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'BASE TABLE'
            else 'REF TABLE'
      end                              INSTALL_TYPE_SELECTOR
      ,base_t.install_type             BASE_TABLE_INSTALL_TYPE
      ,base_t.oname_filter             BASE_TABLE_ONAME_FILTER
      ,base_t.object_owner             BASE_TABLE_OWNER
      ,base_t.object_name              BASE_TABLE_NAME
      ,base_t.object_type              BASE_TABLE_TYPE
      ,fk.constraint_name              FOREIGN_KEY_NAME
      ,pk.constraint_name              UNIQUE_KEY_NAME
      ,pk.constraint_type              UNIQUE_KEY_TYPE
      ,ref_t.install_type              REF_TABLE_INSTALL_TYPE
      ,ref_t.oname_filter              REF_TABLE_ONAME_FILTER
      ,ref_t.object_owner              REF_TABLE_OWNER
      ,ref_t.object_name               REF_TABLE_NAME
      ,ref_t.object_type               REF_TABLE_TYPE
      ,otc.install_otype
      ,otc.ext
      ,otc.ext2
      ,otc.ext3
 from  obj_install_object_tab  base_t
       join otype_conf  otc
            on  otc.install_otype = case when base_t.object_type = 'MATERIALIZED VIEW'
                                         then 'MVIEW_FOREIGN_KEY'
                                         else base_t.object_type || '_FOREIGN_KEY'
                                    end
       join dba_constraints  fk
            on  fk.owner           = base_t.object_owner
            and fk.table_name      = base_t.object_name
            and fk.constraint_type = 'R'
       join dba_constraints  pk
            on  pk.owner           = fk.r_owner
            and pk.constraint_name = fk.r_constraint_name
            and pk.constraint_type in ('P','U')
       join obj_install_object_tab  ref_t
            on  ref_t.object_owner  = pk.owner
            and ref_t.object_name   = pk.table_name
            and ref_t.object_type  in ('MATERIALIZED VIEW', 'TABLE', 'VIEW')
       join install_type_timing  t
            -- Ensure the Ref Table is installed before this Foreign Key
            on  t.from_install_type = base_t.install_type
            and t.to_install_type   = ref_t.install_type
 where base_t.object_type             in ('MATERIALIZED VIEW', 'TABLE', 'VIEW')
  and  base_t.object_install_type not in ('sys','pub')    -- Exclude 'sys' or 'pub' database objects
  and  fk.constraint_name         not like common_util.get_RECYCLE_BIN_NAME_MATCH escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW


--  Grants


--  Synonyms


set define on
