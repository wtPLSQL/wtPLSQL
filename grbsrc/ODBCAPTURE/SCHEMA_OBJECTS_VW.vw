
--
--  Create ODBCAPTURE.SCHEMA_OBJECTS_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."SCHEMA_OBJECTS_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.SCHEMA_OBJECTS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."SCHEMA_OBJECTS_VW" ("OBJECT_OWNER", "INSTALL_TYPE", "INSTALL_OTYPE", "OBJECT_TYPE") AS 
  select object_owner
      ,install_type
      ,install_otype
      ,object_type
 from  zx_obj_install_tab
 group by object_owner
      ,install_type
      ,install_otype
      ,object_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.SCHEMA_OBJECTS_VW

   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_OBJECTS_VW"."OBJECT_OWNER" IS 'Schema name.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_OBJECTS_VW"."INSTALL_TYPE" IS 'Installation Type.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_OBJECTS_VW"."INSTALL_OTYPE" IS 'Installation Object Type.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_OBJECTS_VW"."OBJECT_TYPE" IS 'Oracle Name for Installation Object Type.';
   COMMENT ON TABLE "ODBCAPTURE"."SCHEMA_OBJECTS_VW"  IS 'All Installation Object Types in each Non-System Schema for all Installation Types.';


--  Synonyms


set define on
