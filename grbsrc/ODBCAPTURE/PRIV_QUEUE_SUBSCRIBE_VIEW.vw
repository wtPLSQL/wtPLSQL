
--
--  Create ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "CONSUMER_BUILD_TYPE", "CONSUMER_NAME", "CONSUMER_UOR_TYPE", "ADDRESS", "PROTOCOL", "RULE", "TRANSFORMATION", "QUEUE_TO_QUEUE", "DELIVERY_MODE") AS 
  select case t.build_timing
            when 'CURRENT'
            then aq.build_type
            else uor.build_type
       end                           BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'CONSUMER'
       end                           BUILD_TYPE_SELECTOR
      ,aq.build_type                 QUEUE_BUILD_TYPE
      ,aq.object_owner               QUEUE_OWNER
      ,aq.object_name                QUEUE_NAME
      ,'QUEUE'                       OBJECT_TYPE
      ,uor.build_type                CONSUMER_BUILD_TYPE
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
       join schema_conf  own
            on  own.username = aq.object_owner
       -- Ensure Consumer is available when Queue is installed
       join build_type_timing  t
            on  t.from_build_type = aq.build_type
            and t.to_build_type   = uor.build_type
 where aq.object_type   = 'QUEUE'
       -- Exclude Oracle Provided queues
  and  own.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW


--  Grants


--  Synonyms


set define on
