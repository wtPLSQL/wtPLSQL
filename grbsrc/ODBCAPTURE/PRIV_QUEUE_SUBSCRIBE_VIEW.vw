
--
--  Create ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW" ("INSTALL_TYPE", "INSTALL_TYPE_SELECTOR", "QUEUE_INSTALL_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "CONSUMER_INSTALL_TYPE", "CONSUMER_NAME", "CONSUMER_UOR_TYPE", "ADDRESS", "PROTOCOL", "RULE", "TRANSFORMATION", "QUEUE_TO_QUEUE", "DELIVERY_MODE") AS 
  select case t.install_timing
            when 'CURRENT'
            then aq.install_type
            else uor.install_type
       end                           INSTALL_TYPE
      ,case t.install_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'CONSUMER'
       end                           INSTALL_TYPE_SELECTOR
      ,aq.install_type               QUEUE_INSTALL_TYPE
      ,aq.object_owner               QUEUE_OWNER
      ,aq.object_name                QUEUE_NAME
      ,'QUEUE'                       OBJECT_TYPE
      ,uor.install_type              CONSUMER_INSTALL_TYPE
      ,uor.user_or_role              CONSUMER_NAME
      ,uor.uor_type                  CONSUMER_UOR_TYPE
      ,aqsub.address
      ,aqsub.protocol
      ,aqsub.rule
      ,aqsub.transformation
      ,aqsub.queue_to_queue
      ,aqsub.delivery_mode
 from  uor_install_view  uor
       join dba_queue_subscribers  aqsub
            on  aqsub.consumer_name = uor.user_or_role
       join obj_install_object_tab  aq
            on  aq.object_owner = aqsub.owner
            and aq.object_name  = aqsub.queue_name
       -- Ensure Consumer is available when Queue is installed
       join install_type_timing  t
            on  t.from_install_type = aq.install_type
            and t.to_install_type   = uor.install_type
 where aq.object_type   = 'QUEUE'
  -- Exclude 'sys' or 'pub' queues
  and  aq.object_owner_install_type not in ('sys','pub');

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW


--  Grants


--  Synonyms


set define on
