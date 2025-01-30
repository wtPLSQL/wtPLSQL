
--
--  Create ODBCAPTURE.BUILD_PATH_REVIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."BUILD_PATH_REVIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_REVIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."BUILD_PATH_REVIEW" ("PARENT_BUILD_SEQ", "PARENT_BUILD_TYPE", "PARENT_NOTES", "BUILD_SEQ", "BUILD_TYPE", "NOTES") AS 
  select m.parent_build_seq
      ,p.build_type          parent_build_type
      ,p.notes               parent_notes
      ,m.build_seq
      ,t.build_type
      ,t.notes
 from  build_path  m
       join build_conf  p
            on  p.build_seq = m.parent_build_seq
       join build_conf  t
            on  t.build_seq = m.build_seq
UNION ALL
select NULL                  parent_build_seq
      ,NULL                  parent_build_type
      ,NULL                  parent_notes
      ,t.build_seq
      ,t.build_type
      ,t.notes
 from  build_conf  t
 where t.build_seq not in (
       select m.build_seq from build_path m)
 order by parent_build_seq nulls first, build_seq;

--  Comments

--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_REVIEW


--  Grants


--  Synonyms


set define on
