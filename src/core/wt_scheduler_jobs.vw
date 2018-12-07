
--
--  User Scheduler Jobs View Installation
--

create view wt_scheduler_jobs_vw as
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

comment on table wt_scheduler_jobs_vw is 'User Scheduler Jobs, including running and not running jobs.';
comment on column wt_scheduler_jobs_vw.log_id is 'Unique identifier of the log entry (foreign key of the *_SCHEDULER_JOB_LOG views)';
comment on column wt_scheduler_jobs_vw.start_date is 'Actual date on which the job was run';
comment on column wt_scheduler_jobs_vw.job_name is 'Name of the Scheduler job';
comment on column wt_scheduler_jobs_vw.status is 'Status of the job run';
comment on column wt_scheduler_jobs_vw.inst is 'Identifier of the instance on which the job was run';
comment on column wt_scheduler_jobs_vw.session_id is 'Identifier of the session running the Scheduler job';
comment on column wt_scheduler_jobs_vw.os_pid is 'Process number of the slave process running the Scheduler job';
comment on column wt_scheduler_jobs_vw.error_num is 'Error number in the case of an error';
comment on column wt_scheduler_jobs_vw.additional_info is 'Additional information on the job run, if applicable';
