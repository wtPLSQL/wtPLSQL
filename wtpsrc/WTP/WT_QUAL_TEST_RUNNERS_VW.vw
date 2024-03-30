
--
--  Create WTP.WT_QUAL_TEST_RUNNERS_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_QUAL_TEST_RUNNERS_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants
grant SELECT on "WTP"."WT_QUAL_TEST_RUNNERS_VW" to "PUBLIC";



--DBMS_METADATA:WTP.WT_QUAL_TEST_RUNNERS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_QUAL_TEST_RUNNERS_VW" ("OWNER", "PACKAGE_NAME") AS 
  select owner
      ,object_name    PACKAGE_NAME
 from  dba_procedures
 where procedure_name = wtplsql.get_runner_entry_point
  and  object_type    = 'PACKAGE';

--  Comments

--DBMS_METADATA:WTP.WT_QUAL_TEST_RUNNERS_VW

   COMMENT ON COLUMN "WTP"."WT_QUAL_TEST_RUNNERS_VW"."OWNER" IS 'Owner of the Qualified Test Runner Package';
   COMMENT ON COLUMN "WTP"."WT_QUAL_TEST_RUNNERS_VW"."PACKAGE_NAME" IS 'Name of the Qualified Test Runner Package';
   COMMENT ON TABLE "WTP"."WT_QUAL_TEST_RUNNERS_VW"  IS 'All PL/SQL Packages with the required Test Runner Entry Point.';


--  Synonyms


set define on
