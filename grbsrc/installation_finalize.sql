
--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off
spool off


