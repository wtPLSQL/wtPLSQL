
--
--  Create ODBCAPTURE.UOR_INSTALL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."UOR_INSTALL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."UOR_INSTALL_VIEW" ("BUILD_TYPE", "ORACLE_PROVIDED", "USER_OR_ROLE", "UOR_TYPE", "FILE_EXT1", "NOTES") AS 
  select sc.build_type
      ,sc.oracle_provided
      ,sc.username            USER_OR_ROLE
      ,'USER'                 UOR_TYPE
      ,ec.file_ext1
      ,sc.notes
 from  schema_conf  sc
       join element_conf  ec
            on  ec.element_name = 'USER'
UNION ALL
select rl.build_type
      ,rl.oracle_provided
      ,rl.rolename              USER_OR_ROLE
      ,'ROLE'                   UOR_TYPE
      ,ec.file_ext1
      ,rl.notes
 from  role_conf  rl
       join element_conf  ec
            on  ec.element_name = 'ROLE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW


--  Grants


--  Synonyms


set define on
