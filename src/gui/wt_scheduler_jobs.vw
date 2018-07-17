
create or replace view wt_scheduler_jobs as
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

select owner from apex_applications where application_id = 700;
