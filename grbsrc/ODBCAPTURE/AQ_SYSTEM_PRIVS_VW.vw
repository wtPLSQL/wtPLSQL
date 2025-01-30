
--
--  Create ODBCAPTURE.AQ_SYSTEM_PRIVS_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."AQ_SYSTEM_PRIVS_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.AQ_SYSTEM_PRIVS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."AQ_SYSTEM_PRIVS_VW" ("GRANTEE", "PRIVILEGE", "DBMS_AQ_PRIV", "ADMIN_OPTION", "COMMON", "INHERITED") AS 
  select grantee
      ,privilege
      ,case privilege
       when 'ENQUEUE ANY QUEUE' then 'ENQUEUE_ANY'
       when 'DEQUEUE ANY QUEUE' then 'DEQUEUE_ANY'
       when 'MANAGE ANY QUEUE'  then 'MANAGE_ANY'
       else 'ERROR: Unknown Privilege ' || privilege
       end                             DBMS_AQ_PRIV
      ,admin_option
      ,common
      ,inherited
 from  dba_sys_privs
 where privilege like '% ANY QUEUE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.AQ_SYSTEM_PRIVS_VW


--  Grants


--  Synonyms


set define on
