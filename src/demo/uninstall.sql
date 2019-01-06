
spool uninstall
set serveroutput on size unlimited format truncated

@common_setup.sql

drop user &schema_owner. cascade;

spool off
