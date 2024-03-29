
-- Unplug Pluggable Database
spool pdb_unplug.lst

-- Variable Definitions
define DFILE_PREFIX = "/opt/OraEE213/oradata"
define CDB_SID      = "EE213CDB"
define PDB_SID      = "DEVPDB"
define DB_DOMAIN    = ""
define SYS_PASS     = "Orac13is#1"

-- Derived Variables
define CDB_CONN     = "//localhost:1521/&CDB_SID.&DB_DOMAIN."
define PDB_DFILES   = "&DFILE_PREFIX./&CDB_SID./&PDB_SID."
define SYS_CRED     = "SYS/&SYS_PASS."
define CDB_SYS      = "&SYS_CRED.@&CDB_CONN. as sysdba"

@new_connection.sql &CDB_SYS.

alter pluggable database "&PDB_SID." close immediate;
alter pluggable database "&PDB_SID." unplug into '&PDB_DFILES./&PDB_SID..XML';
drop pluggable database "&PDB_SID." keep datafiles;
spool off

--prompt ============================================================
--prompt Zipping Pluggable Database
-- Quote the echo so the "&" in CD_DFILE_LOC is not executed
--
--host bash -c '(echo "Status of Mounted Files Systems"; df -k; echo "") &host_log.'
--
--host bash -c '(echo "KBytes of Disk Usage in ${PWD}"; du -sk .; echo "") &host_log.'
--host bash -c '(echo "Files in ${PWD}"; ls -al; echo "") &host_log.'
--
--host bash -c '(echo "KBytes of Disk Usage in &CD_DFILE_LOC."; &CD_DFILE_LOC. du -sk .; echo "") &host_log.'
--host bash -c '(echo "Files in &CD_DFILE_LOC."; &CD_DFILE_LOC. ls -al; echo "") &host_log.'
--
--define extra_pdbzip_files = "Jenkinsfile.reduced autobuild/*.csv autobuild/*.lst autobuild/*.xml install/*/*.csv install/*/*/*.log"
--host bash -c '(echo \$ cd ..; echo \$ zip -q &SHARED_PATH./&PDB_SID._PDB.zip &extra_pdbzip_files.) &host_log.'
--host bash -c '(cd ..; zip -q &SHARED_PATH./&PDB_SID._PDB.zip &extra_pdbzip_files.) &host_log.'
--host bash -c '(ls -al &SHARED_PATH./&PDB_SID._PDB.zip; echo "") &host_log.'
--
--host bash -c '(echo \$ &CD_DFILE_LOC. echo \$ zip -q &SHARED_PATH./&PDB_SID._PDB.zip) &host_log.'
--host bash -c '(&CD_DFILE_LOC. zip -q &SHARED_PATH./&PDB_SID._PDB.zip ./*) &host_log.'
--host bash -c '(ls -al &SHARED_PATH./&PDB_SID._PDB.zip; echo "") &host_log.'
--
--host bash -c '(echo \$ &run_sudo rm -rf &DFILE_LOC.; &run_sudo rm -rf &DFILE_LOC.; echo "") &host_log.'

prompt .
exit 0 
