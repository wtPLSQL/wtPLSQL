
--
--  Create ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_REGISTER_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_REGISTER_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "CONSUMER_BUILD_TYPE", "CONSUMER_NAME", "CONSUMER_UOR_TYPE", "SUBSCRIPTION_NAME", "NAMESPACE", "LOCATION_NAME", "USER_CONTEXT", "QOSFLAGS", "TIMEOUT", "NTFN_GROUPING_CLASS", "NTFN_GROUPING_VALUE", "NTFN_GROUPING_TYPE", "NTFN_GROUPING_START_TIME", "NTFN_GROUPING_REPEAT_COUNT", "CONTEXT_SIZE") AS 
  select case t.build_timing
            when 'CURRENT'
            then aq.build_type
            else uor.build_type
       end                               BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'CONSUMER'
       end                               BUILD_TYPE_SELECTOR
      ,aq.build_type                     QUEUE_BUILD_TYPE
      ,aq.object_owner                   QUEUE_OWNER
      ,aq.object_name                    QUEUE_NAME
      ,'QUEUE'                           OBJECT_TYPE
      ,uor.build_type                    CONSUMER_BUILD_TYPE
      ,uor.user_or_role                  CONSUMER_NAME
      ,uor.uor_type                      CONSUMER_UOR_TYPE
      ,aqreg.subscription_name           -- "subscription_name" defines the datatype
      ,aqreg.namespace
      ,aqreg.location_name
      ,aqreg.user_context
      ,aqreg.qosflags
      ,aqreg.timeout
      ,aqreg.ntfn_grouping_class
      ,aqreg.ntfn_grouping_value
      ,aqreg.ntfn_grouping_type
      ,aqreg.ntfn_grouping_start_time
      ,aqreg.ntfn_grouping_repeat_count
      ,aqreg.context_size
 from  uor_install_view  uor
       join dba_subscr_registrations  aqreg
            on  substr(aqreg.subscription_name
                      ,instr(aqreg.subscription_name,':') + 1
                      ,4000) = uor.user_or_role
       join obj_install_object_tab  aq
            on  aq.object_owner = substr(aqreg.subscription_name
                                        ,1
                                        ,instr(aqreg.subscription_name,'.') - 1)
            and aq.object_name = substr(aqreg.subscription_name
                                       ,instr(aqreg.subscription_name,'.') + 1
                                       ,instr(aqreg.subscription_name,':') -
                                        instr(aqreg.subscription_name,'.') - 1)
       join schema_conf  own
            on  own.username = aq.object_owner
       join build_type_timing  t
            -- Ensure the Consumer is avaialable when this Queue is installed
            on  t.from_build_type = aq.build_type
            and t.to_build_type   = uor.build_type
 where aq.object_type   = 'QUEUE'
       -- Exclude Oracle Provided queues
  and  own.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW


--  Grants


--  Synonyms


set define on
