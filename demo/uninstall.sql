
spool uninstall
set serveroutput on size unlimited format truncated

@../common_setup.sql

drop user &demo_owner. cascade;

spool off
