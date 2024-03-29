
--
--  Create ODBCAPTURE.UOR_INSTALL_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."UOR_INSTALL_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."UOR_INSTALL_VIEW" ("INSTALL_TYPE", "USER_OR_ROLE", "UOR_TYPE", "EXT", "NOTES") AS 
  select sc.install_type
      ,sc.username            USER_OR_ROLE
      ,'USER'                 UOR_TYPE
      ,otc.ext
      ,sc.notes
 from  schema_conf  sc
       join otype_conf  otc
            on  otc.install_otype = 'USER'
UNION ALL
select rl.install_type
      ,rl.rolename              USER_OR_ROLE
      ,'ROLE'                   UOR_TYPE
      ,otc.ext
      ,rl.notes
 from  role_conf  rl
       join otype_conf  otc
            on  otc.install_otype = 'ROLE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW


--  Synonyms


set define on
