
--
--  Finalize Installation
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

define FINAL_SYSTEM_CONNECT="&1."

prompt
prompt Drop_Temp_Publicly_Updateable_Table_SQL
drop table SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
@"fix_invalid_public_synonyms.sql" ""

prompt
prompt compile_all
@"compile_all.sql" ""

prompt
prompt alter_foreign_keys_ENABLE
@"alter_foreign_keys.sql" "ENABLE"

prompt
prompt alter_triggers_ENABLE
@"alter_triggers.sql" "ENABLE"

prompt
prompt update_id_sequences
@"update_id_sequences.sql" ""

--prompt
--prompt alter_queues_ENABLE
--@"alter_queues.sql" "ENABLE"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"alter_scheduler_jobs.sql" "ENABLE"

prompt
prompt Load Installation Files
@"odbcapture_installation_logs.cdl" "&FINAL_SYSTEM_CONNECT."
