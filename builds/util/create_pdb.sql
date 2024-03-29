
--
--  Pluggable Database Build Script for Local Environment
--
--  Command Line Parameters:
--    -) 1: CPDB_PDB_SID         - Database SID for the new pluggable database.
--

define CPDB_PDB_SID="&1."

----------------------------------------
--prompt Show Parameters
--show parameters

----------------------------------------
prompt
prompt Show PDBs
show pdbs

----------------------------------------
prompt
prompt Create PDB
declare
   database_name   varchar2(128);
   users_datafile  varchar2(256);
   procedure run_stxt (in_stxt  in varchar2) is
   begin
      dbms_output.put_line(in_stxt || ';');
      execute immediate in_stxt;
   end run_stxt;
begin
   select name
    into  database_name
    from  v$database;
   select replace(min(file_name), database_name, database_name || '/&CPDB_PDB_SID.')
    into  users_datafile
    from  dba_data_files
    where tablespace_name = 'USERS';
   for buff in (select name from v$pdbs where name = '&CPDB_PDB_SID.')
   loop
      begin
         run_stxt('ALTER PLUGGABLE DATABASE "' || buff.name || '" CLOSE IMMEDIATE INSTANCES=ALL');
      exception when others then
         dbms_output.put_line(SQLERRM);
      end;
      run_stxt('DROP PLUGGABLE DATABASE "' || buff.name || '" INCLUDING DATAFILES');
   end loop;
   run_stxt('create pluggable database "&CPDB_PDB_SID."'                                           || CHR(10) ||
          '  admin user "PDB_ADMIN" identified by "PDB_ADMIN_Password"'                            || CHR(10) ||
          '  default tablespace users datafile ''' || users_datafile || ''' size 5M autoextend on' || CHR(10) ||
          '  FILE_NAME_CONVERT = (''pdbseed'', ''&CPDB_PDB_SID.'')'                                || CHR(10) ||
          '  STORAGE UNLIMITED TEMPFILE REUSE');
end;
/

-------------------------
prompt
prompt Open PDB
alter pluggable database "&CPDB_PDB_SID." open;

----------------------------------------
prompt
prompt Show Services
select name from v$services;

----------------------------------------
prompt
prompt Update DEFAULT Profile
alter session set container = "&CPDB_PDB_SID.";
alter profile "DEFAULT" limit password_life_time unlimited;
alter session set container = "CDB$ROOT";
