
--
--  Unplug Pluggable Database
--
-- Variables:
--   SYS_LOGIN: Connect String for SYS in the Container Database
--   CDB_SID:   Name of the Container Database
--   PDB_SID:   Name of the Pluggable Database
--

spool archive_pdb.lst

-- Variable Definitions
define PDB_DFILES = "/opt/OraEE213/oradata/&CDB_SID./&PDB_SID."
set define off
define host_log   = ">> archive_pdb.lst 2>&1"
define extra_pdbzip_files = "*.csv *.lst *.xml */*.csv */*.log"
set define on

@"../util/new_session.sql" "&SYS_LOGIN." "" ""

alter pluggable database "&PDB_SID." close immediate;
alter pluggable database "&PDB_SID." unplug into '&PDB_SID..XML';
drop pluggable database "&PDB_SID." keep datafiles;
spool off

prompt ============================================================
prompt Zipping Pluggable Database
-- Quote the echo so the "&" in PDB_DFILES is not executed

host bash -c '(echo "Status of Mounted Files Systems"; df -k; echo "") &host_log.'

host bash -c '(echo "KBytes of Disk Usage in ${PWD}"; du -sk .; echo "") &host_log.'
host bash -c '(echo "Files in ${PWD}"; ls -al; echo "") &host_log.'

host bash -c '(echo "KBytes of Disk Usage in &PDB_DFILES."; cd &PDB_DFILES.; du -sk .; echo "") &host_log.'
host bash -c '(echo "Files in &PDB_DFILES."; cd &PDB_DFILES.; ls -al; echo "") &host_log.'

host bash -c '(echo \$ zip -q &PDB_SID._PDB.zip &extra_pdbzip_files.) &host_log.'
host bash -c '(zip -q &PDB_SID._PDB.zip &extra_pdbzip_files.) &host_log.'
host bash -c '(ls -al &PDB_SID._PDB.zip; echo "") &host_log.'

host bash -c '(echo \$ zip -q &PDB_SID._PDB.zip) &host_log.'
host bash -c '(zip -q &PDB_SID._PDB.zip &PDB_DFILES./*) &host_log.'
host bash -c '(ls -al &PDB_SID._PDB.zip; echo "") &host_log.'

host bash -c '(echo \$ rm -rf &PDB_DFILES.; rm -rf &PDB_DFILES.; echo "") &host_log.'

prompt .
exit 0 
