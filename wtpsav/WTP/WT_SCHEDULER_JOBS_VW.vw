
--
--  Create WTP.WT_SCHEDULER_JOBS_VW view
--
--  NOTE: Foreign keys are in a difference script
--        Triggers are in a difference script
--

set define off


--
--  Need to avoid errors granting permisions on a view that has errors
--  Found this technique on Ask Tom
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "WTP"."WT_SCHEDULER_JOBS_VW"
  as   select * from SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:WTP.WT_SCHEDULER_JOBS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WTP"."WT_SCHEDULER_JOBS_VW" ("LOG_ID", "START_DATE", "JOB_NAME", "STATUS", "INST", "SESSION_ID", "OS_PID", "ERROR_NUM", "ADDITIONAL_INFO") AS 
  select round(log_id)                  LOG_ID
      ,systimestamp - elapsed_time    START_DATE
      ,job_name
      ,'RUNNING'                      STATUS
      ,running_instance               INST
      ,session_id
      ,slave_process_id               OS_PID
      ,NULL                           ERROR_NUM
      ,NULL                           ADDITIONAL_INFO
 from  user_scheduler_running_jobs
union all
select log_id
      ,actual_start_date  START_DATE
      ,job_name
      ,status
      ,instance_id        INST
      ,NULL               SESSION_ID
      ,NULL               OS_PID
      ,error#             ERROR_NUM
      ,additional_info
 from  user_scheduler_job_run_details;

--  Comments

--DBMS_METADATA:WTP.WT_SCHEDULER_JOBS_VW

   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."LOG_ID" IS 'Unique identifier of the log entry (foreign key of the *_SCHEDULER_JOB_LOG views)';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."START_DATE" IS 'Actual date on which the job was run';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."JOB_NAME" IS 'Name of the Scheduler job';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."STATUS" IS 'Status of the job run';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."INST" IS 'Identifier of the instance on which the job was run';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."SESSION_ID" IS 'Identifier of the session running the Scheduler job';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."OS_PID" IS 'Process number of the slave process running the Scheduler job';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."ERROR_NUM" IS 'Error number in the case of an error';
   COMMENT ON COLUMN "WTP"."WT_SCHEDULER_JOBS_VW"."ADDITIONAL_INFO" IS 'Additional information on the job run, if applicable';
   COMMENT ON TABLE "WTP"."WT_SCHEDULER_JOBS_VW"  IS 'User Scheduler Jobs, including running and not running jobs.';


--  Grants


--  Synonyms


set define on
