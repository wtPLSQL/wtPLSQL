
prompt Converted/Consolidated SQL Script for APEX Instance on OCI

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

prompt
prompt Confirm/Create odbcapture_installation_logs Table
declare
   jnk  number := 0;
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   begin
      execute immediate 'insert into odbcapture_installation_logs(load_dtm, build_type, file_name)' ||
                        ' values(sysdate, ''Test'', ''Test'')';
      rollback;
      jnk := 1;
   exception when others then
      if SQLCODE != -942    -- Table or view does not exist
      then
         dbms_output.put_line('odbcapture_installation_logs table: ' || SQLERRM);
      end if;
      jnk := -1;
   end;
   if jnk = -1
   then
      run_sql('create table odbcapture_installation_logs' || CHR(10) ||
         ' (load_dtm date' || CHR(10) ||
         ' ,build_type varchar2(10)' || CHR(10) ||
         ' ,file_name varchar2(512)' || CHR(10) ||
         ' ,contents clob)');
      run_sql('comment on column odbcapture_installation_logs.load_dtm is ''Date/Time the installation log file was loaded.''');
      run_sql('comment on column odbcapture_installation_logs.build_type is ''Type of Build (from BUILD_CONF).''');
      run_sql('comment on column odbcapture_installation_logs.file_name is ''Name of installation log file.''');
      run_sql('comment on column odbcapture_installation_logs.contents is ''Contents/Text of the installation log file.''');
      run_sql('comment on table odbcapture_installation_logs is ''ODBCAPTURE installation log files.''');
      run_sql('grant select on odbcapture_installation_logs to public');
      run_sql('create public synonym odbcapture_installation_logs for odbcapture_installation_logs');
   end if;
end;
/

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
-- USER Install


prompt ============================================================
prompt Running: grbsrc SYS/ODBCAPTURE.user
prompt ============================================================

--
--  Create ODBCAPTURE Schema
--

set define off

create user "ODBCAPTURE"
   no authentication
   profile DEFAULT
   temporary tablespace TEMP
   default tablespace USERS
   quota 512M on USERS
   ;

--  Current Grant of SYS Objects (but not directories)

grant SELECT on "SYS"."DBA_ALL_TABLES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_ASSOCIATIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_AUDIT_POLICIES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_AUDIT_TRAIL" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CLUSTERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_COL_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CONSTRAINTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CONS_COLUMNS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CONTEXT" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CUBES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CUBE_BUILD_PROCESSES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_CUBE_DIMENSIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_DB_LINKS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_DEPENDENCIES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_DIMENSIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_DIRECTORIES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_EDITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_EDITION_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_EVALUATION_CONTEXTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_HOST_ACES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_INDEXES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_INDEXTYPES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_INDEXTYPE_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_IND_COLUMNS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_IND_PARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_IND_SUBPARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_LIBRARIES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_LOBS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_LOB_PARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_LOB_SUBPARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_MEASURE_FOLDERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_MINING_MODELS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_MVIEWS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_MVIEW_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_MVIEW_LOGS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_NESTED_TABLES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_OBJECTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_OPERATORS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_OPERATOR_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_PDBS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_PDB_HISTORY" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_PROCEDURES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_PROFILES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_QUEUES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_QUEUE_SCHEDULES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_QUEUE_SUBSCRIBERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_QUEUE_TABLES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_REWRITE_EQUIVALENCES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_ROLES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_ROLE_PRIVS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_RSRC_CONSUMER_GROUPS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_RSRC_PLANS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_RULES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_RULE_SETS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_CHAINS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_CREDENTIALS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_DESTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_FILE_WATCHERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_GROUPS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_JOBS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_JOB_CLASSES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_PROGRAMS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_PROGRAM_ARGS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_SCHEDULES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SCHEDULER_WINDOWS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SEQUENCES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SOURCE" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SUBSCR_REGISTRATIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SYNONYMS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_SYS_PRIVS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TABLES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_COLS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_COLUMNS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_COMMENTS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_IDENTITY_COLS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_PARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_PRIVS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TAB_SUBPARTITIONS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TRIGGERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TS_QUOTAS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_TYPES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_USERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_VIEWS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_WALLET_ACES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XML_TABLES" to "ODBCAPTURE";

-- Real Application Security System Grants


prompt XS Admin Grant "ADMIN_ANY_SEC_POLICY" to "ODBCAPTURE"
begin
   execute immediate 'begin' ||
                     '  xs_admin_util.grant_system_privilege(''ADMIN_ANY_SEC_POLICY'', ''ODBCAPTURE''); ' ||
                     'end;';
exception when others then
   if    SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
     AND SQLERRM not like '%ORA-01031: insufficient privileges%'
   then
      raise;
   end if;
end;
/

prompt XS Admin Cloud Grant "ADMIN_ANY_SEC_POLICY" to "ODBCAPTURE"
begin
   execute immediate 'begin' ||
                     '  xs_admin_cloud_util.grant_system_privilege(''ADMIN_ANY_SEC_POLICY'', ''ODBCAPTURE''); ' ||
                     'end;';
exception when others then
   if SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_CLOUD_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
   then
      raise;
   end if;
end;
/


set define on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
-- GRANT Install


prompt ============================================================
prompt Running: grbsrc SYSTEM/ODBCAPTURE_usr.grnt
prompt ============================================================


--
--  Create ODBCAPTURE Grants
--

set define off



--  Database System Privileges

grant CREATE ANY DIRECTORY to "ODBCAPTURE";
grant CREATE PUBLIC SYNONYM to "ODBCAPTURE";
grant PURGE DBA_RECYCLEBIN to "ODBCAPTURE";
grant SELECT ANY TABLE to "ODBCAPTURE";
grant UNLIMITED TABLESPACE to "ODBCAPTURE";


--  "sys" BUILD_TYPE Role Grants
--  "GRANTEE" (delayed) Role Grants
--  Note: "OBJECT" Schema Object Grants are given during Role creation

grant "CONNECT" to "ODBCAPTURE";
grant "RESOURCE" to "ODBCAPTURE";
grant "SELECT_CATALOG_ROLE" to "ODBCAPTURE";


set define on


----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbsrc Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbsrc ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbsrc"');
end;
/


----------------------------------------
-- PACKAGE Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/COMMON_UTIL.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.COMMON_UTIL Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.COMMON_UTIL

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."COMMON_UTIL" AUTHID DEFINER
as

   BASE64_ENCODE_HEADER     CONSTANT varchar2(30) := '(Base64 with Linefeeds)';
   MAXIMUM_SQL_LENGTH       CONSTANT integer := 2499-2; -- SQL*Plus (Allow 2 EOL characters)
   MAXIMUM_LOADER_LENGTH    CONSTANT integer := 32767-2; -- SQL*Loader Data File (Allow 2 EOL characters)
   MAXIMUM_BASH_LENGTH      CONSTANT integer := 32000-2; -- UNIX/Linux scripts (Allow 2 EOL characters)
   MAXIMUM_CMD_LENGTH       CONSTANT integer := 8191-2; -- Windows scripts (Allow 2 EOL characters)
   SYS_TYPE_REGEXP          CONSTANT varchar2(10) := 'SYSTP%=='; -- Type Specification and Type Body
   RECYCLE_BIN_PATTERN      CONSTANT varchar2(10) := 'BIN$%';
   ORACLE_TEXT_TABLE_REGEXP CONSTANT varchar2(25) := '^DR[$].*[$][A-Z]{1,2}$'; -- Oracle Text Table/Index
   SDO_TABLE_REGEXP         CONSTANT varchar2(25) := '^MDR[ST]_'; -- Spatial Data Table/Sequence
   MVIEW_AUTO_INDEX_PREFIX  CONSTANT varchar2(10) := 'I_SNAP$_';
   SYS_PIPELINE_PATTERN     CONSTANT varchar2(20) := 'SYS\_PLSQL\_%'; -- pipeline package/function
   -- https://blogs.oracle.com/db/entry/oracle_support_master_note_for_troubleshooting_advanced_queuing_and_oracle_streams_propagation_issue
   ADV_QUEUE_VIEW_PATTERN   CONSTANT varchar2(20) := 'QT%\_BUFFER';
   ADV_QUEUE_PREFIX_REGEXP  CONSTANT varchar2(20) := '^AQ[$][_]{0,1}';
   --                                                 ^              - anchor to the start of the line
   --                                                  AQ[$][_]{0,1} - Matches 'AQ$' or 'AQ$_'
   ADV_QUEUE_SUFFIX_REGEXP  CONSTANT varchar2(20) := '([_][A-Z]){0,1}$';
   --                                                 ([_][A-Z]){0,1}  - Matches '', '_A', '_B', '_C', ..., '_Z'
   --                                                                $ - anchor to the end of the line
   STORAGE_CLAUSE_PATTERN   CONSTANT varchar2(30) := '     storage_clause     => %'; -- removal of storage clause from SQL

   LF    constant varchar2(1) := CHR(10);
   CRTN  constant varchar2(1) := CHR(13);

   procedure add_sysgrants_file_header
      (fh  in out nocopy  fh2.sf_ptr_type);

   procedure add_grants_file_header
      (fh          in out nocopy  fh2.sf_ptr_type
      ,in_grantee  in             varchar2);

   procedure dbms_metadata_settings;

   function old_rpad
      (in_expr1  in varchar2
      ,in_n      in number
      ,in_expr2  in varchar2 default null)
   return varchar2;

   function get_RECYCLE_BIN_PATTERN
   return varchar2;

   function split_sql_length
      (in_str  IN CLOB)
   return CLOB;

   function escape_at_sign
      (in_str      IN   CLOB)
   return CLOB;

   procedure check_windows_filenames
      (in_build_type  in varchar2);

   procedure update_vieW_tabs;

   function b64_encode
      (in_blob     in BLOB
      ,in_add_hdr  in boolean default FALSE)
   return CLOB;

end common_util;
/


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/FH2.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.FH2 Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.FH2

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."FH2" 
   authid current_user
as

   LF    constant varchar2(1) := CHR(10);
   CRTN  constant varchar2(1) := CHR(13);

   -- Script File Pointer (similar to a file handle)
   TYPE sf_ptr_type is record
      (bld_type    varchar2(10)
      ,bld_ord    pls_integer
      ,file_id     pls_integer
      ,num_lines   pls_integer);

   -- Buffer Records: One Line of Text in a Script/File
   TYPE buffer_rec_type is record
      (len       number(5)
      ,buffer    varchar2(32767));
   -- Associative Array of Script/File Lines
   TYPE buffer_aa_type is table
      of buffer_rec_type
      index by pls_integer;                      -- Line Number
   -- File Header Record
   TYPE file_rec_type is record
      (max_linesize  number(5)
      ,total_bytes   number(14)
      ,num_buffers   number(9)
      ,is_open       varchar2(1)
      ,schema_name   varchar2(128)
      ,filename      varchar2(500)
      ,buffer_aa     buffer_aa_type);
   -- Associative Array of Files
   TYPE file_aa_type is table
      of file_rec_type
      index by pls_integer;                      -- File ID
   -- Associative Array of ELEMENT SEQ
   TYPE seq_aa_type is table
      of file_aa_type
      index by pls_integer;                      -- ELEMENT SEQ
   -- Associative Array of Build Type
   TYPE it_aa_type is table
      of seq_aa_type
      index by varchar2(10);                     -- Build Type
   -- Associative Array of Script Files by Build Type, ELEMENT SEQ, File ID, and Buffers
   sf_aa     it_aa_type;

   function script_is_open
      (file   in fh2.sf_ptr_type)
   return boolean;

   PROCEDURE script_close_all;

   function script_open
      (in_filename      in varchar2
      ,in_elmnt         in varchar2
      ,in_max_linesize  in binary_integer default 1024)
   return fh2.sf_ptr_type;

   procedure script_put
      (file       IN OUT NOCOPY fh2.sf_ptr_type
      ,buffer     IN            VARCHAR2);

   procedure script_put_line
      (file       IN OUT NOCOPY fh2.sf_ptr_type
      ,buffer     IN            VARCHAR2);

   PROCEDURE script_new_line
      (file  IN OUT NOCOPY fh2.sf_ptr_type
      ,lines IN     NATURAL default 1);

   PROCEDURE script_close
      (file   IN OUT NOCOPY fh2.sf_ptr_type);

   procedure put_big_line
      (in_fh      in out NOCOPY fh2.sf_ptr_type
      ,in_loc     in            varchar2
      ,in_txt     in            CLOB
      ,in_max_len in            number);

   procedure remove_storage_clause
      (in_fh       in out NOCOPY fh2.sf_ptr_type
      ,in_loc      in            varchar2
      ,in_txt      in            CLOB
      ,in_max_len  in            number);

   ----------------------------------------------------

   procedure write_scripts
      (in_zip_file_name  in varchar2
      ,in_folder_name    in varchar2 default '');

   procedure show_file
      (in_bld_type  in  varchar2
      ,in_element   in  varchar2);

   procedure clear_buffers
      (in_build_type   in varchar2 default null);

end fh2;
/


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/GRAB_SCRIPTS.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_SCRIPTS Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_SCRIPTS

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."GRAB_SCRIPTS" 
   authid current_user
as

   --
   -- DBA OBJECT TYPES
   --   (https://renenyffenegger.ch/notes/development/databases/Oracle/installed/data-dictionary/objects/index)
   --
   -- CHAIN
   -- CLUSTER
   -- CONSUMER GROUP
   -- CONTEXT
   -- DATABASE LINK
   -- DESTINATION
   -- DIRECTORY
   -- EDITION
   -- EVALUATION CONTEXT
   -- FUNCTION
   -- INDEX
   -- INDEX PARTITION
   -- INDEX SUBPARTITION
   -- INDEXTYPE
   -- JOB
   -- JOB CLASS
   -- LIBRARY
   -- LOB
   -- LOB PARTITION
   -- MATERIALIZED VIEW
   -- OPERATOR
   -- PACKAGE
   -- PACKAGE BODY
   -- PROCEDURE
   -- PROGRAM
   -- QUEUE
   -- RESOURCE PLAN
   -- RULE
   -- RULE SET
   -- SCHEDULE
   -- SCHEDULER GROUP
   -- SEQUENCE
   -- SYNONYM
   -- TABLE
   -- TABLE PARTITION
   -- TABLE SUBPARTITION
   -- TRIGGER
   -- TYPE
   -- TYPE BODY
   -- UNDEFINED
   -- VIEW
   -- WINDOW
   -- XML SCHEMA

   LF    constant varchar2(1) := CHR(10);
   CRTN  constant varchar2(1) := CHR(13);

   -- Installed Types
   TYPE installed_types_aa_type is table of varchar2(1)
      index by build_conf.build_type%TYPE;
   installed_types_aa   installed_types_aa_type;

   -- INTERNALs Made Public for Modularization

   TYPE grb_cldr_delim_nt_type is table of varchar2(1);
   grb_cldr_delim_nt   grb_cldr_delim_nt_type :=
                       grb_cldr_delim_nt_type (CHR(11), CHR(12), CHR(28),
                                               CHR(29), CHR(30), CHR(31));
   grb_cldr_array_lvl  pls_integer;

   g_build_type      varchar2(10);
   g_schema_name     varchar2(128);

   procedure grb_object_grants
      (in_fh           in out NOCOPY fh2.sf_ptr_type
      ,in_object_name  in            varchar2
      ,in_object_type  in            varchar2);
   procedure grb_object_synonyms
      (in_fh             in out NOCOPY fh2.sf_ptr_type
      ,in_object_name    in            varchar2
      ,in_object_type    in            varchar2
      ,in_max_len        in            number);

   ----------------------------------------------------

   procedure set_installed_types;

   procedure all_scripts
      (in_build_type   in varchar2);

   function get_version
   return varchar2;

end grab_scripts;
/


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ROOT_SCRIPTS.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.ROOT_SCRIPTS Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.ROOT_SCRIPTS

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."ROOT_SCRIPTS" 
   authid current_user
as

   function dbi_sql
      (in_build_type  in varchar2)
   return varchar2;

   function installation_finalize_sql
      (in_build_type  in varchar2)
   return varchar2;

   function installation_prepare_sql
      (in_build_type  in varchar2)
   return varchar2;

   function odbcapture_installation_logs_cldr
      (in_build_type  in varchar2)
   return varchar2;

   function odbcapture_installation_logs_csv
      (in_build_type  in varchar2)
   return varchar2;

   function odbcapture_installation_logs_ctl
      (in_build_type  in varchar2)
   return varchar2;

   function report_status_sql
      (in_build_type  in varchar2)
   return varchar2;

   function list_invalids_csv
      (in_build_type  in varchar2)
   return varchar2;

   function set_user_authentication_sql
      (in_build_type  in varchar2)
   return varchar2;

end root_scripts;
/


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ZIP_UTIL_PKG.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.ZIP_UTIL_PKG Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.ZIP_UTIL_PKG

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."ZIP_UTIL_PKG" authid definer
is

  /*

  Purpose:      Package handles zipping and unzipping of files

  Remarks:      by Anton Scheffer, see http://forums.oracle.com/forums/thread.jspa?messageID=9289744#9289744

                for unzipping, see http://technology.amis.nl/blog/8090/parsing-a-microsoft-word-docx-and-unzip-zipfiles-with-plsql
                for zipping, see http://forums.oracle.com/forums/thread.jspa?threadID=1115748&tstart=0

  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     09.01.2011  Created

  */

  type t_file_list is table of clob;
--
  function get_file_list(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return t_file_list;
--
  function get_file_list(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null /* Use CP850 for zip files created with a German Winzip to see umlauts, etc */
  )
    return t_file_list;
--
  function get_file(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  function get_file(
    p_zipped_blob in blob
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  procedure add_file(
    p_zipped_blob in out nocopy blob
  , p_name in varchar2
  , p_content in blob
  );
--
  procedure finish_zip(
    p_zipped_blob in out nocopy blob
  );
--
  procedure save_zip(
    p_zipped_blob in blob
  , p_dir in varchar2
  , p_filename in varchar2
  );

end zip_util_pkg;
/


--  Grants


--  Synonyms


set define on

----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.BUILD_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.BUILD_CONF

  CREATE TABLE "ODBCAPTURE"."BUILD_CONF" 
   (	"BUILD_SEQ" NUMBER(2,0) NOT NULL ENABLE, 
	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"NOTES" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."BUILD_CONF" ADD CONSTRAINT "BUILD_CONF_PK" PRIMARY KEY ("BUILD_SEQ")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."BUILD_CONF" ADD CONSTRAINT "BUILD_CONF_NK1" UNIQUE ("BUILD_TYPE")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.BUILD_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_CONF"."BUILD_SEQ" IS 'Unique Sequence of the build type (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_CONF"."BUILD_TYPE" IS 'Name of the build type (Unique Key) (Required)';
   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."BUILD_CONF"  IS 'List of Build Types.  Also defines the names of the top level directories';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_PATH.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.BUILD_PATH Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.BUILD_PATH

  CREATE TABLE "ODBCAPTURE"."BUILD_PATH" 
   (	"PARENT_BUILD_SEQ" NUMBER(2,0) NOT NULL ENABLE, 
	"BUILD_SEQ" NUMBER(2,0) NOT NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."BUILD_PATH" ADD CONSTRAINT "BUILD_PATH_PK" PRIMARY KEY ("PARENT_BUILD_SEQ", "BUILD_SEQ")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."BUILD_PATH" ADD CONSTRAINT "BUILD_PATH_CK1" CHECK (parent_build_seq < build_seq) ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.BUILD_PATH

   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_PATH"."PARENT_BUILD_SEQ" IS 'Parent Unique Sequence of the build type (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_PATH"."BUILD_SEQ" IS 'Unique Sequence of the build type (Primary Key)';
   COMMENT ON TABLE "ODBCAPTURE"."BUILD_PATH"  IS 'Multi-path Hierarchy of BUILD_TYPEs';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_TYPE_TIMING.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.BUILD_TYPE_TIMING Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.BUILD_TYPE_TIMING

  CREATE TABLE "ODBCAPTURE"."BUILD_TYPE_TIMING" 
   (	"FROM_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TIMING" CHAR(7 BYTE), 
	"TO_BUILD_TYPE" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.BUILD_TYPE_TIMING

   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_TYPE_TIMING"."FROM_BUILD_TYPE" IS 'Mapped "from" BUILD_TYPE';
   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_TYPE_TIMING"."BUILD_TIMING" IS 'Timing (Future or Current) of BUILD_TYPE installations';
   COMMENT ON COLUMN "ODBCAPTURE"."BUILD_TYPE_TIMING"."TO_BUILD_TYPE" IS 'Mapped "ro" BUILD_TYPE';
   COMMENT ON TABLE "ODBCAPTURE"."BUILD_TYPE_TIMING"  IS 'De-Normalized Permutated Data from BUILD_CONF and BUILD_PATH.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_DEPENDENCIES_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_DEPENDENCIES_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_TAB

  CREATE TABLE "ODBCAPTURE"."DBA_DEPENDENCIES_TAB" 
   (	"OBJECT_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"OBJECT_OWNER" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"OBJECT_NAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"OBJECT_TYPE" VARCHAR2(19 BYTE), 
	"REFERENCED_OWNER" VARCHAR2(128 BYTE), 
	"REF_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"REFERENCED_NAME" VARCHAR2(128 BYTE), 
	"REFERENCED_TYPE" VARCHAR2(19 BYTE), 
	"REFERENCED_LINK_NAME" VARCHAR2(128 BYTE), 
	"DEPENDENCY_TYPE" VARCHAR2(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_OBJECTS_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_OBJECTS_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_TAB

  CREATE TABLE "ODBCAPTURE"."DBA_OBJECTS_TAB" 
   (	"OBJECT_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_OWNER" VARCHAR2(128 BYTE), 
	"OBJECT_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" VARCHAR2(23 BYTE), 
	"TABLE_FLAG" VARCHAR2(3 BYTE), 
	"SELTYPE" VARCHAR2(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_TAB_PRIVS_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_TAB_PRIVS_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_TAB

  CREATE TABLE "ODBCAPTURE"."DBA_TAB_PRIVS_TAB" 
   (	"OBJECT_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_OWNER" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" VARCHAR2(24 BYTE), 
	"OBJECT_NAME" VARCHAR2(128 BYTE), 
	"PRIVILEGE" VARCHAR2(40 BYTE), 
	"GRANTEE" VARCHAR2(128 BYTE), 
	"GRANTEE_UOR_TYPE" CHAR(4 BYTE), 
	"GRANTEE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"GRANTABLE" VARCHAR2(3 BYTE), 
	"HIERARCHY" VARCHAR2(3 BYTE), 
	"COMMON" VARCHAR2(3 BYTE), 
	"INHERITED" VARCHAR2(3 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DLOAD_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.DLOAD_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.DLOAD_CONF

  CREATE TABLE "ODBCAPTURE"."DLOAD_CONF" 
   (	"USERNAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"TABLE_NAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"ORDER_BY_COLUMNS" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"BEFORE_SELECT_SQL" VARCHAR2(4000 BYTE), 
	"COLUMNS_REMOVED" VARCHAR2(4000 BYTE), 
	"WHERE_CLAUSE" VARCHAR2(4000 BYTE), 
	"AFTER_ORDER_BY_SQL" VARCHAR2(4000 BYTE), 
	"NOTES" VARCHAR2(4000 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."DLOAD_CONF" ADD CONSTRAINT "DLOAD_CONF_PK" PRIMARY KEY ("USERNAME", "TABLE_NAME", "BUILD_TYPE")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DLOAD_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."USERNAME" IS 'Name of the database schema (Primary Key Column 1). Value must be in SCHEMA_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."TABLE_NAME" IS 'Name of the database table/view (Primary Key Column 2).';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."BUILD_TYPE" IS 'Name of the database schema (Primary Key Column 3). Value must be in BUILD_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."ORDER_BY_COLUMNS" IS 'ORDER BY columns for the selected data load to capture.  List the column names as they would appear in an ORDER BY clause.';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."BEFORE_SELECT_SQL" IS 'Any SQL before " select * from owner.table " for the selected data load to capture (Optional).';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."COLUMNS_REMOVED" IS 'REGEXP Filter of Columns to Remove from Data Load (Optional)';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."WHERE_CLAUSE" IS 'WHERE clause for the selected data load to capture (Optional). Do not add the WHERE keyword';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."AFTER_ORDER_BY_SQL" IS 'Any SQL after the ORDER BY clause for the selected data load to capture (Optional). Do not add ";" at the end.';
   COMMENT ON COLUMN "ODBCAPTURE"."DLOAD_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."DLOAD_CONF"  IS 'DATA LOAD filter for each table/view in a schema for a build type.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ELEMENT_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.ELEMENT_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.ELEMENT_CONF

  CREATE TABLE "ODBCAPTURE"."ELEMENT_CONF" 
   (	"ELEMENT_SEQ" NUMBER(5,0) NOT NULL ENABLE, 
	"ELEMENT_NAME" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"FILE_EXT1" VARCHAR2(6 BYTE) NOT NULL ENABLE, 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE), 
	"OBJECT_TYPE" VARCHAR2(30 BYTE), 
	"NAME_CHECK_OBJECT_TYPE" VARCHAR2(30 BYTE), 
	"NOTES" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."ELEMENT_CONF" ADD CONSTRAINT "ELEMENT_CONF_PK" PRIMARY KEY ("ELEMENT_SEQ")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."ELEMENT_CONF" ADD CONSTRAINT "ELEMENT_CONF_UK1" UNIQUE ("ELEMENT_NAME")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.ELEMENT_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."ELEMENT_SEQ" IS 'Sequence for this element (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."ELEMENT_NAME" IS 'Name of the element (Unique Key) (Required)';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."FILE_EXT1" IS 'Primary filename extension this element (Required)';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."FILE_EXT2" IS 'Secondary filename extension this element (Optional)';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."FILE_EXT3" IS 'Tertiary filename extension this element (Optional)';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."OBJECT_TYPE" IS 'Actual DBA_OBJECTS Object Type for this element';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."NAME_CHECK_OBJECT_TYPE" IS 'Object Type used for Windows file name checking';
   COMMENT ON COLUMN "ODBCAPTURE"."ELEMENT_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."ELEMENT_CONF"  IS 'List of Elements to install.  Also defines the filename extensions that are used';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/METADATA_TRANSFORM_PARAMS.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.METADATA_TRANSFORM_PARAMS Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.METADATA_TRANSFORM_PARAMS

  CREATE TABLE "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" 
   (	"NAME" VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	"VALUE_TYPE" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"VALUE" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ADD CONSTRAINT "METADATA_TRANSFORM_PARAMS_CK1" CHECK (value_type in ('BOOLEAN','NUMBER','VARCHAR')) ENABLE;
ALTER TABLE "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ADD CONSTRAINT "METADATA_TRANSFORM_PARAMS_PK" PRIMARY KEY ("NAME")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.METADATA_TRANSFORM_PARAMS

   COMMENT ON COLUMN "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS"."NAME" IS 'Parameter Name';
   COMMENT ON COLUMN "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS"."VALUE_TYPE" IS 'Type of Parameter: "BOOLEAN", "NUMBER", or "VARCHAR"';
   COMMENT ON COLUMN "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS"."VALUE" IS 'Parameter Value';
   COMMENT ON TABLE "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS"  IS 'DBMS_METADATA Transformation Paramters.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJECT_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJECT_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJECT_CONF

  CREATE TABLE "ODBCAPTURE"."OBJECT_CONF" 
   (	"USERNAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"ELEMENT_NAME" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"NOTES" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."OBJECT_CONF" ADD CONSTRAINT "OBJECT_CONF_PK" PRIMARY KEY ("USERNAME", "ELEMENT_NAME", "BUILD_TYPE")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."OBJECT_CONF" ADD CONSTRAINT "OBJECT_CONF_CK1" CHECK (element_name not in ('USER','QUEUE_TABLE','DATA_LOAD','TABLE_FOREIGN_KEY','VIEW_FOREIGN_KEY','MVIEW_FOREIGN_KEY')) ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJECT_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."OBJECT_CONF"."USERNAME" IS 'Name of the database schema (Primary Key Column 1). Value must be in SCHEMA_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."OBJECT_CONF"."ELEMENT_NAME" IS 'Name of the element (Primary Key Column 2). Value must be in ELEMENT_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."OBJECT_CONF"."BUILD_TYPE" IS 'Name of the build type (Primary Key Column 3). Value must be in BUILD_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."OBJECT_CONF"."OBJECT_NAME_REGEXP" IS 'Where clause of the selected object to capture (Required).';
   COMMENT ON COLUMN "ODBCAPTURE"."OBJECT_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."OBJECT_CONF"  IS 'Object name filter for each element in a schema for an build type.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_COMMENTS_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_COMMENTS_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TABLE_OWNER" VARCHAR2(128 BYTE), 
	"TABLE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TABLE_NAME" VARCHAR2(128 BYTE), 
	"TABLE_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"COLUMN_NAME" VARCHAR2(128 BYTE), 
	"COMMENTS" VARCHAR2(4000 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_CONTEXT_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_CONTEXT_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TIMING" CHAR(7 BYTE), 
	"CONTEXT_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"CONTEXT_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"CONTEXT_OWNER" VARCHAR2(128 BYTE), 
	"CONTEXT_NAME" VARCHAR2(128 BYTE), 
	"CONTEXT_TYPE" VARCHAR2(22 BYTE), 
	"PACKAGE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"PACKAGE_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"PACKAGE_OWNER" VARCHAR2(128 BYTE), 
	"PACKAGE_NAME" VARCHAR2(128 BYTE), 
	"PACKAGE_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"FILE_EXT1" VARCHAR2(6 BYTE), 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_DATA_LOAD_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"BUILD_TIMING" CHAR(7 BYTE), 
	"TABLE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TABLE_BUILD_TIMING" CHAR(7 BYTE), 
	"TABLE_OWNER" VARCHAR2(128 BYTE), 
	"TABLE_NAME" VARCHAR2(128 BYTE), 
	"TABLE_TYPE" VARCHAR2(23 BYTE), 
	"BEFORE_SELECT_SQL" VARCHAR2(4000 BYTE), 
	"COLUMNS_REMOVED" VARCHAR2(4000 BYTE), 
	"WHERE_CLAUSE" VARCHAR2(4000 BYTE), 
	"ORDER_BY_COLUMNS" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"AFTER_ORDER_BY_SQL" VARCHAR2(4000 BYTE), 
	"NOTES" VARCHAR2(4000 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"FILE_EXT1" VARCHAR2(6 BYTE) NOT NULL ENABLE, 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_FKEY_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_FKEY_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_FKEY_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TYPE_SELECTOR" VARCHAR2(20 BYTE), 
	"BASE_TABLE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BASE_TABLE_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"BASE_TABLE_OWNER" VARCHAR2(128 BYTE), 
	"BASE_TABLE_NAME" VARCHAR2(128 BYTE), 
	"BASE_TABLE_TYPE" VARCHAR2(23 BYTE), 
	"FOREIGN_KEY_NAME" VARCHAR2(128 BYTE), 
	"UNIQUE_KEY_NAME" VARCHAR2(128 BYTE), 
	"UNIQUE_KEY_TYPE" VARCHAR2(1 BYTE), 
	"REF_TABLE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"REF_TABLE_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"REF_TABLE_OWNER" VARCHAR2(128 BYTE), 
	"REF_TABLE_NAME" VARCHAR2(128 BYTE), 
	"REF_TABLE_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"FILE_EXT1" VARCHAR2(6 BYTE) NOT NULL ENABLE, 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_INDEX_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_INDEX_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_INDEX_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TYPE_SELECTOR" VARCHAR2(6 BYTE), 
	"INDEX_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"INDEX_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"INDEX_OWNER" VARCHAR2(128 BYTE), 
	"INDEX_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" VARCHAR2(23 BYTE), 
	"UNIQUENESS" VARCHAR2(9 BYTE), 
	"INDEX_TYPE" VARCHAR2(27 BYTE), 
	"ITYP_OWNER" VARCHAR2(128 BYTE), 
	"ITYP_NAME" VARCHAR2(128 BYTE), 
	"TABLE_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TARGET_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"TABLE_OWNER" VARCHAR2(128 BYTE), 
	"TABLE_NAME" VARCHAR2(128 BYTE), 
	"TABLE_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"FILE_EXT1" VARCHAR2(6 BYTE), 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_OBJECT_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_OBJECT_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_OBJECT_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TIMING" CHAR(7 BYTE), 
	"OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"OBJECT_OWNER_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_OWNER" VARCHAR2(128 BYTE), 
	"OBJECT_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"FILE_EXT1" VARCHAR2(6 BYTE), 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_SYNONYM_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TYPE_SELECTOR" VARCHAR2(20 BYTE), 
	"SYNONYM_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"SYNONYM_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"SYNONYM_OWNER" VARCHAR2(128 BYTE), 
	"SYNONYM_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" CHAR(7 BYTE), 
	"DB_LINK" VARCHAR2(128 BYTE), 
	"TARGET_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TARGET_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"TARGET_OWNER" VARCHAR2(128 BYTE), 
	"TARGET_NAME" VARCHAR2(128 BYTE), 
	"TARGET_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"FILE_EXT1" VARCHAR2(6 BYTE), 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_TRIGGER_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB

  CREATE TABLE "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"BUILD_TYPE_SELECTOR" VARCHAR2(20 BYTE), 
	"TRIGGER_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TRIGGER_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"TRIGGER_OWNER" VARCHAR2(128 BYTE), 
	"TRIGGER_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_TYPE" VARCHAR2(23 BYTE), 
	"TARGET_BUILD_TYPE" VARCHAR2(10 BYTE), 
	"TARGET_OBJECT_NAME_REGEXP" VARCHAR2(4000 BYTE), 
	"TARGET_OWNER" VARCHAR2(128 BYTE), 
	"TARGET_NAME" VARCHAR2(128 BYTE), 
	"TARGET_TYPE" VARCHAR2(23 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	"FILE_EXT1" VARCHAR2(6 BYTE), 
	"FILE_EXT2" VARCHAR2(6 BYTE), 
	"FILE_EXT3" VARCHAR2(6 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ROLE_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.ROLE_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.ROLE_CONF

  CREATE TABLE "ODBCAPTURE"."ROLE_CONF" 
   (	"ROLENAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"ORACLE_PROVIDED" VARCHAR2(1 BYTE) NOT NULL ENABLE, 
	"NOTES" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."ROLE_CONF" ADD CONSTRAINT "ROLE_CONF_PK" PRIMARY KEY ("ROLENAME", "BUILD_TYPE")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."ROLE_CONF" ADD CONSTRAINT "ROLE_CONF_CK1" CHECK ("ORACLE_PROVIDED" in ('Y','N')) ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.ROLE_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."ROLE_CONF"."ROLENAME" IS 'Name of the database role (Primary Key Column 1)';
   COMMENT ON COLUMN "ODBCAPTURE"."ROLE_CONF"."BUILD_TYPE" IS 'Build Type for this database role (Primary Key Column 2). Value must exist in BUILD_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."ROLE_CONF"."ORACLE_PROVIDED" IS 'Identifies a Role already provided with the database';
   COMMENT ON COLUMN "ODBCAPTURE"."ROLE_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."ROLE_CONF"  IS 'List of Roles to install in each Build Type.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/SCHEMA_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.SCHEMA_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.SCHEMA_CONF

  CREATE TABLE "ODBCAPTURE"."SCHEMA_CONF" 
   (	"USERNAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"BUILD_TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"ORACLE_PROVIDED" VARCHAR2(1 BYTE) NOT NULL ENABLE, 
	"PROFILE" VARCHAR2(128 BYTE), 
	"TEMPORARY_TSPACE" VARCHAR2(30 BYTE), 
	"DEFAULT_TSPACE" VARCHAR2(30 BYTE), 
	"TS_QUOTA" VARCHAR2(10 BYTE), 
	"NOTES" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."SCHEMA_CONF" ADD CONSTRAINT "SCHEMA_CONF_CK1" CHECK ( REGEXP_LIKE ("TS_QUOTA",'^UNLIMITED$|^[0-9]+[KMG]$')) ENABLE;
ALTER TABLE "ODBCAPTURE"."SCHEMA_CONF" ADD CONSTRAINT "SCHEMA_CONF_PK" PRIMARY KEY ("USERNAME")
  USING INDEX  ENABLE;
ALTER TABLE "ODBCAPTURE"."SCHEMA_CONF" ADD CONSTRAINT "SCHEMA_CONF_CK2" CHECK (oracle_provided in ('Y','N')) ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.SCHEMA_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."USERNAME" IS 'Name of the database schema (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."BUILD_TYPE" IS 'Build Type for this database schema (Required). All objects for this schema are generated for this build type unless filtered by OBJECT_CONF. Value must be in BUILD_CONF table.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."ORACLE_PROVIDED" IS 'Identifies a Schema/User already provided with the database (Required)';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."PROFILE" IS 'Profile for the User.  NULL is DEFAULT.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."TEMPORARY_TSPACE" IS 'Name of the temporary tablespace.  NULL is TEMP';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."DEFAULT_TSPACE" IS 'Default Tablespace Name for this Schema (optional)';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."TS_QUOTA" IS 'Tablespace quota for this schema. NULL is UNLIMITED.';
   COMMENT ON COLUMN "ODBCAPTURE"."SCHEMA_CONF"."NOTES" IS 'Free text field (Optional)';
   COMMENT ON TABLE "ODBCAPTURE"."SCHEMA_CONF"  IS 'List of Schema to install in each Build Type.';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/SCHEMA_OBJECTS_TAB.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.SCHEMA_OBJECTS_TAB Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.SCHEMA_OBJECTS_TAB

  CREATE TABLE "ODBCAPTURE"."SCHEMA_OBJECTS_TAB" 
   (	"BUILD_TYPE" VARCHAR2(10 BYTE), 
	"OBJECT_OWNER" VARCHAR2(128 BYTE), 
	"ELEMENT_NAME" VARCHAR2(20 BYTE), 
	 CONSTRAINT "SCHEMA_OBJECTS_TAB_PK" PRIMARY KEY ("BUILD_TYPE", "OBJECT_OWNER", "ELEMENT_NAME") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS ;

--  Comments

--DBMS_METADATA:ODBCAPTURE.SCHEMA_OBJECTS_TAB


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/TSPACE_CONF.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.TSPACE_CONF Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.TSPACE_CONF

  CREATE TABLE "ODBCAPTURE"."TSPACE_CONF" 
   (	"USERNAME" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"TSPACE_NAME" VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	"TS_QUOTA" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."TSPACE_CONF" ADD CONSTRAINT "TSPACE_CONF_PK" PRIMARY KEY ("USERNAME", "TSPACE_NAME")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.TSPACE_CONF

   COMMENT ON COLUMN "ODBCAPTURE"."TSPACE_CONF"."USERNAME" IS 'Name of the database schema (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."TSPACE_CONF"."TSPACE_NAME" IS 'Name of the tablespace (Primary Key)';
   COMMENT ON COLUMN "ODBCAPTURE"."TSPACE_CONF"."TS_QUOTA" IS 'Tablespace quota for this schema and tablespace. NULL is UNLIMITED.';
   COMMENT ON TABLE "ODBCAPTURE"."TSPACE_CONF"  IS 'Additional Tablespace Quotas for Schema';


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ZIP_FILES.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.ZIP_FILES Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.ZIP_FILES

  CREATE TABLE "ODBCAPTURE"."ZIP_FILES" 
   (	"FILE_NAME" VARCHAR2(1000 BYTE), 
	"DATE_CREATED" DATE DEFAULT sysdate, 
	"FILE_SIZE" NUMBER(38,0) DEFAULT 0, 
	"FILE_BLOB" BLOB
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."ZIP_FILES" ADD CONSTRAINT "ZIP_FILES_PK" PRIMARY KEY ("FILE_NAME")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.ZIP_FILES


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.BUILD_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."BUILD_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/BUILD_CONF.ctl

prompt Translating ../grbsrc/ODBCAPTURE/BUILD_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-99,'sys','N/A System Users.  (Not Installed, Always available for Grants and Synonyms)');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-95,'pub','N/A PUBLIC.  (Not Installed, Always available for Grants and Synonyms)');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-90,'grbsrc','ODBCapture Source Code Script Generation');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-85,'grbras','RAS - Real Application Security (XS$NULL)');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-82,'grbjava','JAVAVM,CATJAVA,XML - JServer JAVA Virtual Machine, Oracle Database Java Packages (OJVMSYS), Oracle XDK');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-78,'grbsdo','SDO,LCTR (Placeholder) - Spatial - Oracle Locator - Graph (MDSYS, MDDATA)');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-50,'grbendp','ODBCapture Common Endpoint for Hierarchy and Non-Generated Objects');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-48,'grbdat','ODBCapture Self-Capture Configuration Data');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/BUILD_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_PATH.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.BUILD_PATH data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."BUILD_PATH"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/BUILD_PATH.ctl

prompt Translating ../grbsrc/ODBCAPTURE/BUILD_PATH.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-99,-95);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-95,-90);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-90,-85);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-90,-82);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-90,-78);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-90,-50);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-85,-50);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-82,-50);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-78,-50);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-50,-48);


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/BUILD_PATH.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ELEMENT_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.ELEMENT_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'ELEMENT_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'ELEMENT_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."ELEMENT_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'ELEMENT_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/ELEMENT_CONF.ctl

prompt Translating ../grbsrc/ODBCAPTURE/ELEMENT_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-999,'INSTALL_SCRIPT','N/A',NULL,NULL,NULL,NULL,'Non-Schema Installation Script (The "EXT" is Not Applicable)');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-990,'RAS_ACL','racl',NULL,NULL,NULL,NULL,'Real Application Security (RAS) Access Control List (ACL) and supporting metadata');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-150,'ROLE','role',NULL,NULL,NULL,NULL,'SYS Only, Includes SYS Grants');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-140,'USER','user',NULL,NULL,NULL,NULL,'SYS Only, Includes SYS Grants');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-130,'SYS_GRANT','sgrnt',NULL,NULL,NULL,NULL,'SYS Only, FUTURE Grants on OBJECT_NAME_REGEXP for Grants to SYS Objects');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-125,'HOST_ACL','hacl',NULL,NULL,NULL,NULL,'SYS Only. Host Access Control Lists');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-120,'WALLET_ACL','wacl',NULL,NULL,NULL,NULL,'SYS Only. Wallet Access Control Lists');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-110,'DATABASE_TRIGGER','dbtrg',NULL,NULL,'TRIGGER',NULL,'System Triggers "ON DATABASE"');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-20,'DIRECTORY','dir','sh','bat','DIRECTORY','DIRECTORY','SYSTEM Only, FUTURE Directories and used in OBJECT_NAME_REGEXP');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (-10,'GRANT','grnt',NULL,NULL,NULL,NULL,'SYSTEM Only, FUTURE Grants on OBJECT_NAME_REGEXP for SYSTEM Objects and System Priveleges');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (10,'SYNONYM','syn',NULL,NULL,'SYNONYM',NULL,'FUTURE Synonyms.');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (30,'DB_LINK','dblnk',NULL,NULL,'DATABASE LINK','DATABASE LINK',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (40,'SEQUENCE','seq',NULL,NULL,'SEQUENCE','SEQUENCE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (110,'TYPE_SPEC','tps',NULL,NULL,'TYPE','TYPE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (130,'FUNCTION','func',NULL,NULL,'FUNCTION','FUNCTION',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (140,'PROCEDURE','proc',NULL,NULL,'PROCEDURE','PROCEDURE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (150,'PACKAGE_SPEC','pkssql',NULL,NULL,'PACKAGE','PACKAGE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (210,'QUEUE_TABLE','aqt',NULL,NULL,NULL,'TABLE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (220,'QUEUE','aq',NULL,NULL,'QUEUE','QUEUE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (310,'TABLE','tbl',NULL,NULL,'TABLE','TABLE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (320,'DATA_LOAD','cldr','ctl','csv',NULL,'TABLE','DATA_LOAD references are not allowed in OBJECT_CONF.  Also disables Foreign Keys and Triggers');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (330,'TABLE_INDEX','tidx',NULL,NULL,'INDEX',NULL,'FUTURE Indexes. CURRENT Indexes are included with object creation');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (350,'MVIEW_INDEX','mvidx',NULL,NULL,'INDEX',NULL,NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (360,'VIEW','vw',NULL,NULL,'VIEW','VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (370,'MVIEW','mvw',NULL,NULL,'MATERIALIZED VIEW','MATERIALIZED VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (410,'TYPE_BODY','tpb',NULL,NULL,'TYPE BODY','TYPE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (420,'JAVA_SOURCE','pjv',NULL,NULL,'JAVA SOURCE','JAVA SOURCE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (450,'PACKAGE_BODY','pkbsql',NULL,NULL,'PACKAGE BODY','PACKAGE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (510,'TABLE_FOREIGN_KEY','tfk',NULL,NULL,NULL,'TABLE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (520,'VIEW_FOREIGN_KEY','vfk',NULL,NULL,NULL,'VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (530,'MVIEW_FOREIGN_KEY','mvfk',NULL,NULL,NULL,'MATERIALIZED VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (540,'TABLE_TRIGGER','ttrg',NULL,NULL,'TRIGGER','TABLE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (550,'VIEW_TRIGGER','vtrg',NULL,NULL,'TRIGGER','VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (560,'MVIEW_TRIGGER','mvtrg',NULL,NULL,'TRIGGER','MATERIALIZED VIEW',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (570,'SCHEMA_TRIGGER','utrg',NULL,NULL,'TRIGGER',NULL,'System Triggers "ON SCHEMA"');

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (610,'SCHEDULER_SCHEDULE','schdsd',NULL,NULL,'SCHEDULE','SCHEDULE',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (620,'SCHEDULER_PROGRAM','schdpg',NULL,NULL,'PROGRAM','PROGRAM',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (630,'SCHEDULER_JOB','schdjb',NULL,NULL,'JOB','JOB',NULL);

insert into "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_SEQ","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3","OBJECT_TYPE","NAME_CHECK_OBJECT_TYPE","NOTES")
  values (710,'CONTEXT','ctxt',NULL,NULL,'CONTEXT','CONTEXT','Memory Based Application Context (NOT Oracle Text) (Don''t match OBJECT_TYPE)');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/ELEMENT_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/METADATA_TRANSFORM_PARAMS.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.METADATA_TRANSFORM_PARAMS data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'METADATA_TRANSFORM_PARAMS'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'METADATA_TRANSFORM_PARAMS'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'METADATA_TRANSFORM_PARAMS'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/METADATA_TRANSFORM_PARAMS.ctl

prompt Translating ../grbsrc/ODBCAPTURE/METADATA_TRANSFORM_PARAMS.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('CONSTRAINTS','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('CONSTRAINTS_AS_ALTER','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('FORCE','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('LOB_STORAGE','VARCHAR','NO_CHANGE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('OID','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('PARTITIONING','BOOLEAN','FALSE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('PRETTY','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('REF_CONSTRAINTS','BOOLEAN','FALSE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('SEGMENT_ATTRIBUTES','BOOLEAN','FALSE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('SIZE_BYTE_KEYWORD','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('SQLTERMINATOR','BOOLEAN','TRUE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('STORAGE','BOOLEAN','FALSE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('TABLESPACE','BOOLEAN','FALSE');

insert into "ODBCAPTURE"."METADATA_TRANSFORM_PARAMS" ("NAME","VALUE_TYPE","VALUE")
  values ('TABLE_COMPRESSION_CLAUSE','VARCHAR','NONE');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/METADATA_TRANSFORM_PARAMS.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ROLE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.ROLE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."ROLE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/ROLE_CONF.ctl

prompt Translating ../grbsrc/ODBCAPTURE/ROLE_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('ACCHK_READ','sys','Y','Allows users with no administrative privileges to query the DBA_ACCHK_STATISTICS view');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('ADM_PARALLEL_EXECUTE_TASK','sys','Y','Perform administrative routines (qualified by the prefix ADM_ in DBMS_PARALLEL_EXECUTE) and access the DBA_PARALLEL_EXECUTE_CHUNKS and DBA_PARALLEL_EXECUTE_TASKS views');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('APEX_ADMINISTRATOR_ROLE','sys','Y','(grbapex) APEX/REST/ORDS Role');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('APEX_GRANTS_FOR_NEW_USERS_ROLE','sys','Y','(grbapex) APEX/REST/ORDS Role');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('APPLICATION_TRACE_VIEWER','sys','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AQ_ADMINISTRATOR_ROLE','sys','Y','Privilege to administer Advanced Queuing.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AQ_USER_ROLE','sys','Y','De-supported but maintained for backward compatibility to version 8.0.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AUDIT_ADMIN','sys','Y','Provides privileges to create unified and fine-grained audit policies, use the AUDIT and NOAUDIT SQL statements, view audit data, and manage the audit trail administration.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AUDIT_VIEWER','sys','Y','Provides privileges to view and analyze audit data.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AUTHENTICATEDUSER','sys','Y','(grbxrep) Used by the XDB protocols to define any user who has logged in to the system.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('AVTUNE_PKG_ROLE','sys','Y','Utility functions for Analytic View auto cache auto tune.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('BDSQL_ADMIN','sys','Y','Big Data SQL Admin Role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('BDSQL_USER','sys','Y','Big Data SQL User Role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('CAPTURE_ADMIN','sys','Y','Provides the privileges necessary to create and manage privilege analysis policies.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('CDB_DBA','sys','Y','Provides the privileges required for administering a CDB, such as SET CONTAINER, SELECT ON PDB_PLUG_IN_VIOLATIONS, and SELECT ON CDB_LOCAL_ADMIN_PRIVS. If your site requires additional privileges, then you can create a role (either common or local) to cover these privileges, and then grant this role to the CDB_DBA role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('CONNECT','sys','Y','Contains the CREATE SESSION and SET CONTAINER system privileges.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('CTXAPP','sys','Y','(grbctx) Enables developers create Oracle Text indexes and index preferences, and to use PL/SQL packages.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DATAPATCH_ROLE','sys','Y','Access to DBMS_QOPATCH package which will give details of Oracle Patches applied on the database.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DATAPUMP_EXP_FULL_DATABASE','sys','Y','Granted EXP_FULL_DATABASE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DATAPUMP_IMP_FULL_DATABASE','sys','Y','Granted EXP_FULL_DATABASE and IMP_FULL_DATABASE roles.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DBA','sys','Y','Example Database Administrator role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DBFS_ROLE','sys','Y','Provides access to the DBFS (the Database Filesystem) packages and objects.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DBMS_MDX_INTERNAL','sys','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DELETE_CATALOG_ROLE','sys','Y','Grant this role to allow users to delete records from the system audit tables SYS.AUD$ and SYS.FGA_LOG$.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_ACCTMGR','sys','Y','(grbsec) Use the DV_ACCTMGR role to create and maintain database accounts and database profiles. In this manual, the example DV_ACCTMGR role is assigned to a user named amalcolm_dvacctmgr.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_ADMIN','sys','Y','(grbsec) The DV_ADMIN role controls the Oracle Database Vault PL/SQL packages.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_AUDIT_CLEANUP','sys','Y','(grbsec) Grant to any user who is responsible for purging the Database Vault auit trail in a non-unified auditing environment.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_DATAPUMP_NETWORK_LINK','sys','Y','(grbsec) Needed by any user who is responsible for conducting the NETWORK_LINK transportable Data Pump import operation in an Oracle Database Vault environment. Enables the management of the Oracle Data Pump NETWORK_LINK transportable import processes to be tightly controlled by Database Vault, but does not change or restrict the way you would normally conduct Oracle Data Pump operations.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_GOLDENGATE_ADMIN','sys','Y','Intended for any user with responsibility for GoldenGate configuration by default it contains no privileges.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_GOLDENGATE_REDO_ACCESS','sys','Y','(grbsec) For any user who is responsible for using the Oracle GoldenGate TRANLOGOPTIONS DBLOGREADER method to access redo logs in an Oracle Database Vault environment.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_MONITOR','sys','Y','(grbsec) Enables the Oracle Enterprise Manager Grid Control agent to monitor Oracle Database Vault for attempted violations and configuration issues with realm or command rule definitions. This enables Grid Control to read and propagate realm definitions and command rule definitions between databases.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_OWNER','sys','Y','(grbsec) The DV_OWNER role has the administrative capabilities that the DV_ADMIN role provides, and the reporting capabilities the DV_SECANALYST role provides.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_PATCH_ADMIN','sys','Y','(grbsec) Temporarily grant the DV_PATCH_ADMIN role to any database administrator who is responsible for performing database patching or adding languages to Database Vault. After the patch operation or language addition is complete, you should immediately revoke this role. The role does not provide access to any secured data.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_POLICY_OWNER','sys','Y','(grbsec) Enables database users to manage to a limited degree Oracle Database Vault policies.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_PUBLIC','sys','Y','(grbsec) Oracle Database Vault does not enable you to directly grant object privileges in the DVSYS schema to PUBLIC. You must grant the object privilege on the DVSYS schema object the DV_PUBLIC role, and then grant DV_PUBLIC to PUBLIC.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_REALM_OWNER','sys','Y','(grbsec) Use the DV_REALM_OWNER role to manage database objects in multiple schemas that define a realm. Grant this role to the database account owner who is responsible for managing one or more schema database accounts within a realm and the roles associated with the realm.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_REALM_RESOURCE','sys','Y','(grbsec) Use the DV_REALM_RESOURCE role for operations such as creating tables, views, triggers, synonyms, and other objects that a realm would typically use.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_SECANALYST','sys','Y','(grbsec) DV_SECANALYST can query DVSYS schema objects through Oracle Database Vault-supplied views only.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_STREAMS_ADMIN','sys','Y','(grbsec) Grant to a user who is responsible for configuring Streams replication in an Oracle Database Vault environment.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('DV_XSTREAM_ADMIN','sys','Y','(grbsec) Grant to a user who is responsible for configuring XStreams replication in an Oracle Database Vault environment.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('EM_EXPRESS_ALL','sys','Y','(grbemdc) Enables users to connect to Oracle Enterprise Manager (EM) Express and use all the functionality provided by EM Express (read and write access to all EM Express features). The EM_EXPRESS_ALL role includes the EM_EXPRESS_BASIC role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('EM_EXPRESS_BASIC','sys','Y','(grbemdc) Enables users to connect to EM Express and to view the pages in read-only mode. The EM_EXPRESS_BASIC role includes the SELECT_CATALOG_ROLE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('EXECUTE_CATALOG_ROLE','sys','Y','Allow users EXECUTE privileges for packages and procedures in the data dictionary. Granted HS_ADMIN_EXECUTE_ROLE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('EXP_FULL_DATABASE','sys','Y','Provides the privileges required to perform full and incremental database export. Granted EXECUTE_CATALOG_ROLE and SELECT_CATALOG_ROLE roles.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GATHER_SYSTEM_STATISTICS','sys','Y','To update the dictionary system statistics a user must have DBA privileges or the GATHER_SYSTEM_STATISTICS role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GDS_CATALOG_SELECT','sys','Y','(grbrac) Provides access to 10 objects owned by GSMADMIN_INTERNAL.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GGSYS_ROLE','sys','Y','Golden Gate Administrator Privileges.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GLOBAL_AQ_USER_ROLE','sys','Y','Required to register through LDAP using JDBC connection parameters as this requires the ability to write access to the connection factory entries in the LDAP server (which requires the LDAP user to be either the database itself or be granted GLOBAL_AQ_USER_ROLE).');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GSMADMIN_ROLE','sys','Y','(grbrac) Granted AQ_ADMINISTRATOR_ROLE and CONNECT roles: Inlcudes EXECUTE on DBMS_GSM_UTILITY and related resources.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GSMROOTUSER_ROLE','sys','Y','(grbrac) GSMROOTUSER is a database account specific to Oracle Sharding that is only used when pluggable database (PDB) shards are present. The account is used by GDSCTL and global service managers to connect to the root container of container databases (CDBs) to perform administrative tasks.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GSMUSER_ROLE','sys','Y','(grbrac) Granted CONNECT role: Includes EXECUTE on DBMS_GSM_DBADMIN.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GSM_POOLADMIN_ROLE','sys','Y','(grbrac) Granted CONNECT role: Inlcudes EXECUTE on DBMS_GSM_POOLADMIN.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('HS_ADMIN_EXECUTE_ROLE','sys','Y','Provides the EXECUTE privilege for users who want to use the Heterogeneous Services (HS) PL/SQL packages.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('HS_ADMIN_ROLE','sys','Y','Provides privileges for DBAs who need to use the DBA role using Oracle Database Heterogeneous Services to access appropriate tables in the data dictionary. Used to protect access to the Heterogeneous Services (HS) data dictionary tables (grants SELECT) and packages (grants EXECUTE). It is granted to SELECT_CATALOG_ROLE and EXECUTE_CATALOG_ROLE such that users with generic data dictionary access also can access the HS data dictionary.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('HS_ADMIN_SELECT_ROLE','sys','Y','Provides privileges to query the Heterogeneous Services data dictionary views.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('IMP_FULL_DATABASE','sys','Y','Provides the privileges required to perform full database imports. Includes an extensive list of system privileges (use view DBA_SYS_PRIVS to view privileges) and the following roles: EXECUTE_CATALOG_ROLE and SELECT_CATALOG_ROLE. This role is provided for convenience in using the export and import utilities.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('LBAC_DBA','sys','Y','Provides permissions to use the SA_SYSDBA PL/SQL package.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('LOGSTDBY_ADMINISTRATOR','sys','Y','A prototype role created by default with the RESOURCE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('MAINTPLAN_APP','sys','Y','A maintenance plan can be queried in a PDB via the DB_NOTIFICATIONS view by a user that has the MAINTPLAN_APP system privilege.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('MGMT_USER','sys','Y','(grbemdc) Enterprise Manager Database Control');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OEM_ADVISOR','sys','Y','(grbemdc) Provides privileges to create, drop, select (read), load (write), and delete a SQL tuning set through the DBMS_SQLTUNE PL/SQL package, and to access to the Advisor framework using the ADVISOR PL/SQL package.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OEM_MONITOR','sys','Y','(grbemdc) Provides privileges needed by the Management Agent component of Oracle Enterprise Manager to monitor and manage a database.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OLAP_DBA','sys','Y','(grbolap) Provides privileges needed by the Management Agent component of Oracle Enterprise Manager to monitor and manage the database.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OLAP_USER','sys','Y','(grbolap) Provides application developers privileges to create dimensional objects in their own schemas for Oracle OLAP.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OLAP_XS_ADMIN','sys','Y','(grbolap) Administer OLAP data security. Granted the XS_RESOURCE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('OPTIMIZER_PROCESSING_RATE','sys','Y','Provides privileges to execute the GATHER_PROCESSING_RATE, SET_PROCESSING_RATE, and DELETE_PROCESSING_RATE procedures in the DBMS_STATS package. These procedures manage the processing rate of a system for automatic degree of parallelism (Auto DOP). Auto DOP uses these processing rates to determine the optimal degree of parallelism for a SQL statement.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('ORDS_ADMINISTRATOR_ROLE','sys','Y','(grbapex) APEX/REST/ORDS Role');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('ORDS_RUNTIME_ROLE','sys','Y','(grbapex) APEX/REST/ORDS Role');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('PDB_DBA','sys','Y','Granted automatically to the local user that is created when you create a new pluggable database (PDB) from the seed PDB. No privileges are provided with this role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('PLUSTRACE','sys','Y','Grants privlileges on V$ views required to use AUTOTRACE. Can be created in a PDB but not in the CDB.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('PPLB_ROLE','sys','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('PROVISIONER','sys','Y','Provides privileges to register and update global callbacks for Oracle Database Real Application sessions and to provision principals.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('RDFCTX_ADMIN','sys','Y','Privileges required to add a new extractor type in the schema RDFCTXU for Oracle Database Semantic Technologies.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('RECOVERY_CATALOG_OWNER','sys','Y','Must be granted to the recovery catalog owner for RMAN.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('RECOVERY_CATALOG_OWNER_VPD','sys','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('RECOVERY_CATALOG_USER','sys','Y','Prerequisite for Adding Data Collectors (Oracle Recovery Manager - RMAN)');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('RESOURCE','sys','Y','Provides the following system privileges: CREATE CLUSTER, CREATE INDEXTYPE, CREATE OPERATOR, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE, CREATE TRIGGER, CREATE TYPE. This role is provided for compatibility with previous releases of Oracle Database. You can determine the privileges encompassed by this role by querying the DBA_SYS_PRIVS data dictionary view.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SCHEDULER_ADMIN','sys','Y','Allows the grantee to execute the procedures of the DBMS_SCHEDULER package. It includes all of the job scheduler system privileges and is included in the DBA role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SELECT_CATALOG_ROLE','sys','Y','Provides SELECT privilege on objects in the data dictionary. Granted the HS_ADMIN_SELECT_ROLE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SODA_APP','sys','Y','Simple Oracle Document Access (SODA) permissions in PL/SQL for a SODA User.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SYSUMF_ROLE','sys','Y','Permission needed for Universal Message Format, UMF, which provides an interface for deploying Remote Management Framework (RMF) topology');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('WM_ADMIN_ROLE','sys','Y','(grbowm) Contains all Workspace Manager privileges with the grant option. By default, the database administrator (DBA role) is granted the WM_ADMIN_ROLE role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XDBADMIN','sys','Y','(grbxrep) Allows the grantee to register an XML schema globally, as opposed to registering it for use or access only by its owner. It also lets the grantee bypass access control list (ACL) checks when accessing Oracle XML DB Repository.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XDB_SET_INVOKER','sys','Y','(grbxrep) Allows the grantee to define invoker''s rights handlers and to create or update the resource configuration for XML repository triggers. By default, Oracle Database grants this role to the DBA role but not to the XDBADMIN role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XDB_WEBSERVICES','sys','Y','(grbxrep) Allows the grantee to access Oracle Database Web services over HTTPS. However, it does not provide the user access to objects in the database that are public. To allow public access, you need to grant the user the XDB_WEBSERVICES_WITH_PUBLIC role. For a user to use these Web services, SYS must enable the Web service servlets.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XDB_WEBSERVICES_OVER_HTTP','sys','Y','(grbxrep) Allows the grantee to access Oracle Database Web services over HTTP. However, it does not provide the user access to objects in the database that are public. To allow public access, you need to grant the user the XDB_WEBSERVICES_WITH_PUBLIC role.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XDB_WEBSERVICES_WITH_PUBLIC','sys','Y','(grbxrep) Allows the grantee access to public objects through Oracle Database Web services.');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/ROLE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/SCHEMA_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.SCHEMA_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."SCHEMA_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/SCHEMA_CONF.ctl

prompt Translating ../grbsrc/ODBCAPTURE/SCHEMA_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('ANONYMOUS','sys','Y',NULL,NULL,NULL,NULL,'(grbxrep) XDB - XML Database Repository (XDB,ANONYMOUS)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('APEX_220100','sys','Y',NULL,NULL,NULL,NULL,'(grbapex) Oracle Application Express Version 22.1');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('APEX_220200','sys','Y',NULL,NULL,NULL,NULL,'(grbapex) Oracle Application Express Version 22.2');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('APEX_230100','sys','Y',NULL,NULL,NULL,NULL,'(grbapex) Oracle Application Express Version 23.1');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('APEX_230200','sys','Y',NULL,NULL,NULL,NULL,'(grbapex) Oracle Application Express Version 23.2');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('APPQOSSYS','sys','Y',NULL,NULL,NULL,NULL,'Storing and Managing All Data and Metadata Required by Oracle Quality of Service Management');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('CTXSYS','sys','Y',NULL,NULL,NULL,NULL,'(grbctx) CONTEXT - Oracle Text (CTXSYS)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('DIP','sys','Y',NULL,NULL,NULL,NULL,'Directory Integration and Provisioning Account');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('DVF','sys','Y',NULL,NULL,NULL,NULL,'(grbsec) OLS,DV - Oracle Label Security (LBACSYS), Oracle Database Vault (DVSYS, DVF)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('DVSYS','sys','Y',NULL,NULL,NULL,NULL,'(grbsec) OLS,DV - Oracle Label Security (LBACSYS), Oracle Database Vault (DVSYS, DVF)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('LBACSYS','sys','Y',NULL,NULL,NULL,NULL,'(grbsec) OLS,DV - Oracle Label Security (LBACSYS), Oracle Database Vault (DVSYS, DVF)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('MGMT_VIEW','sys','Y',NULL,NULL,NULL,NULL,'(grbemdc) Enterprise Manager Grid Control Schema Name');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('ODBCAPTURE','grbsrc','N',NULL,NULL,'USERS','512M','Oracle Database Source Code Capture Application');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('OLAPSYS','sys','Y',NULL,NULL,NULL,NULL,'(grbolap) XOQ,APS,AMD - OLAP API, OLAP Analytic Workspace (OLAPSYS), OLAP Catalog');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('OUTLN','sys','Y',NULL,NULL,NULL,NULL,'Stored Outlines');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('PUBLIC','pub','Y',NULL,NULL,NULL,NULL,'Public Grants and Synonyms');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('SYS','sys','Y',NULL,NULL,NULL,NULL,'Database Owner');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('SYSMAN','sys','Y',NULL,NULL,NULL,NULL,'(grbemdc) Enterprise Manager Grid Control Schema Name');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('SYSTEM','sys','Y',NULL,NULL,NULL,NULL,'Default Database Administrator Account');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('WMSYS','sys','Y',NULL,NULL,NULL,NULL,'(grbowm) OWM - Oracle Workspace Manager (WMSYS)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('XDB','sys','Y',NULL,NULL,NULL,NULL,'(grbxrep) XDB - XML Database Repository (XDB,ANONYMOUS)');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/SCHEMA_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/TSPACE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.TSPACE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."TSPACE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/TSPACE_CONF.ctl

prompt Translating ../grbsrc/ODBCAPTURE/TSPACE_CONF.csv to 'INSERT INTO'


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/TSPACE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- INDEX Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_DEPENDENCIES_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.DBA_DEPENDENCIES_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_TAB_IDX2

  CREATE INDEX "ODBCAPTURE"."DBA_DEPENDENCIES_TAB_IDX2" ON "ODBCAPTURE"."DBA_DEPENDENCIES_TAB" ("REFERENCED_OWNER", "REFERENCED_NAME", "REFERENCED_TYPE") 
  ;

--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."DBA_DEPENDENCIES_TAB_IX1" ON "ODBCAPTURE"."DBA_DEPENDENCIES_TAB" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_OBJECTS_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.DBA_OBJECTS_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."DBA_OBJECTS_TAB_IX1" ON "ODBCAPTURE"."DBA_OBJECTS_TAB" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_TAB_PRIVS_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.DBA_TAB_PRIVS_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."DBA_TAB_PRIVS_TAB_IX1" ON "ODBCAPTURE"."DBA_TAB_PRIVS_TAB" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_COMMENTS_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_COMMENTS_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_TAB" ("BUILD_TYPE", "TABLE_OWNER", "TABLE_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_CONTEXT_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_CONTEXT_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_TAB" ("BUILD_TYPE", "CONTEXT_OWNER", "CONTEXT_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_DATA_LOAD_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_TAB" ("BUILD_TYPE", "TABLE_OWNER", "TABLE_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_FKEY_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_FKEY_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_FKEY_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_FKEY_TAB" ("BUILD_TYPE", "BASE_TABLE_OWNER", "FOREIGN_KEY_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_INDEX_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_INDEX_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_INDEX_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_INDEX_TAB" ("BUILD_TYPE", "TABLE_OWNER", "TABLE_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_OBJECT_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_OBJECT_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_OBJECT_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_OBJECT_TAB" ("BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_SYNONYM_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_TAB" ("BUILD_TYPE", "SYNONYM_OWNER", "SYNONYM_NAME") 
  ;

--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_TAB_IX2

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_TAB_IX2" ON "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_TAB" ("BUILD_TYPE", "TARGET_OWNER", "TARGET_NAME") 
  ;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_TRIGGER_TAB.tidx
prompt ============================================================

--
--  Create Indexes for ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB_IX1

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_TAB_IX1" ON "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_TAB" ("BUILD_TYPE", "TRIGGER_OWNER", "TRIGGER_NAME") 
  ;

--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_TAB_IX2

  CREATE INDEX "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_TAB_IX2" ON "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_TAB" ("BUILD_TYPE", "TARGET_OWNER", "TARGET_NAME") 
  ;

set define on

----------------------------------------
-- VIEW Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/AQ_SYSTEM_PRIVS_VW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.AQ_SYSTEM_PRIVS_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."AQ_SYSTEM_PRIVS_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.AQ_SYSTEM_PRIVS_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."AQ_SYSTEM_PRIVS_VW" ("GRANTEE", "PRIVILEGE", "DBMS_AQ_PRIV", "ADMIN_OPTION", "COMMON", "INHERITED") AS 
  select grantee
      ,privilege
      ,case privilege
       when 'ENQUEUE ANY QUEUE' then 'ENQUEUE_ANY'
       when 'DEQUEUE ANY QUEUE' then 'DEQUEUE_ANY'
       when 'MANAGE ANY QUEUE'  then 'MANAGE_ANY'
       else 'ERROR: Unknown Privilege ' || privilege
       end                             DBMS_AQ_PRIV
      ,admin_option
      ,common
      ,inherited
 from  dba_sys_privs
 where privilege like '% ANY QUEUE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.AQ_SYSTEM_PRIVS_VW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_PATH_REVIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.BUILD_PATH_REVIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."BUILD_PATH_REVIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_REVIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."BUILD_PATH_REVIEW" ("PARENT_BUILD_SEQ", "PARENT_BUILD_TYPE", "PARENT_NOTES", "BUILD_SEQ", "BUILD_TYPE", "NOTES") AS 
  select m.parent_build_seq
      ,p.build_type          parent_build_type
      ,p.notes               parent_notes
      ,m.build_seq
      ,t.build_type
      ,t.notes
 from  build_path  m
       join build_conf  p
            on  p.build_seq = m.parent_build_seq
       join build_conf  t
            on  t.build_seq = m.build_seq
UNION ALL
select NULL                  parent_build_seq
      ,NULL                  parent_build_type
      ,NULL                  parent_notes
      ,t.build_seq
      ,t.build_type
      ,t.notes
 from  build_conf  t
 where t.build_seq not in (
       select m.build_seq from build_path m)
 order by parent_build_seq nulls first, build_seq;

--  Comments

--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_REVIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_DEPENDENCIES_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_DEPENDENCIES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_DEPENDENCIES_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "REFERENCED_OWNER", "REF_OWNER_BUILD_TYPE", "REFERENCED_NAME", "REFERENCED_TYPE", "REFERENCED_LINK_NAME", "DEPENDENCY_TYPE") AS 
  select scd.build_type                   OBJECT_OWNER_BUILD_TYPE
      ,dep.owner                          OBJECT_OWNER
      ,dep.name                           OBJECT_NAME
      ,dep.type                           OBJECT_TYPE
      ,dep.referenced_owner
      ,scr.build_type                     REF_OWNER_BUILD_TYPE
      ,dep.referenced_name
      ,dep.referenced_type
      ,dep.referenced_link_name
      ,dep.dependency_type
 from  schema_conf  scd
       join dba_dependencies  dep
            on  dep.owner = scd.username
       join schema_conf  scr
            on  scr.username = dep.referenced_owner
       -- Exclude Oracle Provided Object Owners
 where scd.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_DEPENDENCIES_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_OBJECTS_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_OBJECTS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_OBJECTS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_OBJECTS_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "TABLE_FLAG", "SELTYPE") AS 
  select sc.build_type           OBJECT_OWNER_BUILD_TYPE
      ,obj.owner                 OBJECT_OWNER
      ,obj.object_name
      ,obj.object_type
      ,case when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
            when  nt.table_name is not null then  'NT'
                                            else NULL
       end                       TABLE_FLAG
      ,'BASE'                    SELTYPE
 from  schema_conf  sc
       join dba_objects  obj
            on  obj.owner = sc.username
  left join dba_tables  tab
            on  tab.owner       = obj.owner
            and tab.table_name  = obj.object_name
            and obj.object_type = 'TABLE'
  left join dba_xml_tables  xml
            on  xml.owner       = obj.owner
            and xml.table_name  = obj.object_name
            and obj.object_type = 'TABLE'
  left join dba_nested_tables  nt
            on  nt.owner        = obj.owner
            and nt.table_name   = obj.object_name
            and obj.object_type = 'TABLE'
 where sc.oracle_provided = 'N'      -- Exclude Oracle Provided Object Owner
 group by obj.owner
      ,sc.build_type
      ,obj.object_name
      ,obj.object_type
      ,case when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
            when  nt.table_name is not null then  'NT'
                                            else NULL
       end
UNION ALL
select sco.build_type            OBJECT_OWNER_BUILD_TYPE
      ,syn.owner                 OBJECT_OWNER
      ,syn.synonym_name          OBJECT_NAME
      ,'SYNONYM'                 OBJECT_TYPE
      ,NULL                      TABLE_FLAG
      ,'PUB'                     SELTYPE
 from  schema_conf  sco
       join dba_synonyms  syn
            on  syn.owner = sco.username
       join schema_conf  sct
            on  sct.username        = syn.table_owner
            and sct.oracle_provided = 'N'   -- Exclude Oracle Provided Synonym Owner
 where sco.build_type = 'pub'     -- Public Synonyms
UNION ALL
select sco.build_type            OBJECT_OWNER_BUILD_TYPE
      ,priv.owner                OBJECT_OWNER
      ,priv.table_name           OBJECT_NAME
      ,priv.type                 OBJECT_TYPE
      ,case when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
            when  nt.table_name is not null then  'NT'
                                            else NULL
       end                       TABLE_FLAG
      ,'SYS'                     SELTYPE
 from  schema_conf  sco
       join dba_tab_privs  priv
            on  priv.owner      = sco.username
       join schema_conf  sct
            on  sct.username        = priv.grantee
            and sct.oracle_provided = 'N'   -- Exclude Oracle Provided Grantee
  left join dba_tables  tab
            on  tab.owner      = priv.owner
            and tab.table_name = priv.table_name
            and priv.type      = 'TABLE'
  left join dba_xml_tables  xml
            on  xml.owner      = priv.owner
            and xml.table_name = priv.table_name
            and priv.type      = 'TABLE'
  left join dba_nested_tables  nt
            on  nt.owner      = priv.owner
            and nt.table_name = priv.table_name
            and priv.type     = 'TABLE'
 where sco.oracle_provided = 'Y'          -- ONLY Oracle Provided Object Owners
 group by priv.owner
      ,sco.build_type
      ,priv.table_name
      ,priv.type
      ,case when tab.table_name is not null then 'TAB'
            when xml.table_name is not null then 'XML'
            when  nt.table_name is not null then  'NT'
                                            else NULL
       end;

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_OBJECTS_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DBA_TAB_PRIVS_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.DBA_TAB_PRIVS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."DBA_TAB_PRIVS_VIEW" ("OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_TYPE", "OBJECT_NAME", "PRIVILEGE", "GRANTEE", "GRANTEE_UOR_TYPE", "GRANTEE_BUILD_TYPE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
  select obj.object_owner_build_type
      ,priv.owner                       OBJECT_OWNER
      ,priv.type                        OBJECT_TYPE
      ,priv.table_name                  OBJECT_NAME
      ,priv.privilege
      ,priv.grantee
      ,gsl.uor_type                     GRANTEE_UOR_TYPE
      ,gsl.build_type                   GRANTEE_BUILD_TYPE
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
 from  dba_objects_tab  obj
       join dba_tab_privs  priv
            on  priv.owner      = obj.object_owner
            and priv.table_name = obj.object_name
       join uor_install_view  gsl
            on  gsl.user_or_role = priv.grantee
       join schema_conf  own
            on  own.username = priv.owner
 where (   gsl.oracle_provided = 'N'             -- Not Oracle Provided Grantee
        OR (    gsl.build_type      = 'pub'      -- Grants to 'pub'
            and own.oracle_provided = 'N' )      -- But not owned by Oracle Provided
        OR (    gsl.build_type = 'pub'           -- Grants to 'pub'
            and priv.type      = 'DIRECTORY')    -- Directories are owned by 'SYS'
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.DBA_TAB_PRIVS_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_COMMENTS_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_COMMENTS_VIEW" ("BUILD_TYPE", "OBJECT_OWNER_BUILD_TYPE", "TABLE_OWNER", "TABLE_BUILD_TYPE", "TABLE_NAME", "TABLE_TYPE", "ELEMENT_NAME", "COLUMN_NAME", "COMMENTS") AS 
  select d.build_type
      ,d.object_owner_build_type
      ,c.owner                          TABLE_OWNER
      ,d.object_build_type              TABLE_BUILD_TYPE
      ,c.table_name
      ,d.object_type                    TABLE_TYPE
      ,d.element_name
      ,c.column_name
      ,c.comments
 from  obj_install_object_tab  d
       join schema_conf  o
            on  o.username = d.object_owner
            -- Don't need comments on Oracle Provided Object Owners
            and o.oracle_provided = 'N'
       join dba_col_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.comments is not null
 where d.object_type in ('TABLE','VIEW','MATERIALIZED VIEW')
UNION ALL
select d.build_type
      ,d.object_owner_build_type
      ,c.owner                          TABLE_OWNER
      ,d.object_build_type              TABLE_BUILD_TYPE
      ,c.table_name
      ,c.table_type
      ,d.element_name
      ,NULL                             COLUMN_NAME
      ,c.comments
 from  obj_install_object_tab  d
       join schema_conf  o
            on  o.username = d.object_owner
            -- Don't need comments on Oracle Provided Object Owners
            and o.oracle_provided = 'N'
       join dba_tab_comments  c
            on  c.owner       = d.object_owner
            and c.table_name  = d.object_name
            and c.table_type  = d.object_type
            and c.comments is not null;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_COMMENTS_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_CONTEXT_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_CONTEXT_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "CONTEXT_BUILD_TYPE", "CONTEXT_OBJECT_NAME_REGEXP", "CONTEXT_OWNER", "CONTEXT_NAME", "CONTEXT_TYPE", "PACKAGE_BUILD_TYPE", "PACKAGE_OBJECT_NAME_REGEXP", "PACKAGE_OWNER", "PACKAGE_NAME", "PACKAGE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select obj.build_type
      ,t.build_timing
      ,obj.build_type                 CONTEXT_BUILD_TYPE
      ,obj.object_name_regexp         CONTEXT_OBJECT_NAME_REGEXP
      ,obj.object_owner               CONTEXT_OWNER
      ,ctx.namespace                  CONTEXT_NAME
      ,ctx.type                       CONTEXT_TYPE
      ,pkg.build_type                 PACKAGE_BUILD_TYPE
      ,pkg.object_name_regexp         PACKAGE_OBJECT_NAME_REGEXP
      ,pkg.object_owner               PACKAGE_OWNER
      ,pkg.object_name                PACKAGE_NAME
      ,pkg.object_type                PACKAGE_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join dba_context  ctx
            on  ctx.namespace = obj.object_name
       join obj_install_object_tab  pkg
            on  pkg.object_owner  = ctx.schema
            and pkg.object_name   = ctx.package
            and pkg.object_type   = 'PACKAGE'
       join build_type_timing  t
            -- Ensure the package is installed before this Context
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = pkg.build_type
 where obj.object_owner = 'SYS'
  and  obj.object_type  = 'CONTEXT'
  and  ctx.namespace not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_CONTEXT_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_DATA_LOAD_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_DATA_LOAD_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "TABLE_BUILD_TYPE", "TABLE_BUILD_TIMING", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "BEFORE_SELECT_SQL", "COLUMNS_REMOVED", "WHERE_CLAUSE", "ORDER_BY_COLUMNS", "AFTER_ORDER_BY_SQL", "NOTES", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select dlc.build_type
      ,t.build_timing
      ,tab.build_type                 TABLE_BUILD_TYPE
      ,tab.build_timing               TABLE_BUILD_TIMING
      ,tab.object_owner               TABLE_OWNER
      ,tab.object_name                TABLE_NAME
      ,tab.object_type                TABLE_TYPE
      ,dlc.before_select_sql
      ,dlc.columns_removed
      ,dlc.where_clause
      ,dlc.order_by_columns
      ,dlc.after_order_by_sql
      ,dlc.notes
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  obj_install_object_tab  tab
       join dload_conf  dlc
            on  dlc.username   = tab.object_owner
            and dlc.table_name = tab.object_name
       join element_conf  ec
            on  ec.element_name = 'DATA_LOAD'
       join build_type_timing  t
            -- Ensure the Table is installed before this Data Load
            on  t.from_build_type = dlc.build_type
            and t.to_build_type   = tab.build_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_DATA_LOAD_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_FKEY_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_FKEY_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "BASE_TABLE_BUILD_TYPE", "BASE_TABLE_OBJECT_NAME_REGEXP", "BASE_TABLE_OWNER", "BASE_TABLE_NAME", "BASE_TABLE_TYPE", "FOREIGN_KEY_NAME", "UNIQUE_KEY_NAME", "UNIQUE_KEY_TYPE", "REF_TABLE_BUILD_TYPE", "REF_TABLE_OBJECT_NAME_REGEXP", "REF_TABLE_OWNER", "REF_TABLE_NAME", "REF_TABLE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then base_t.build_type
            else ref_t.build_type
      end                              BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'BASE TABLE'
            else 'REF TABLE'
      end                              BUILD_TYPE_SELECTOR
      ,base_t.build_type               BASE_TABLE_BUILD_TYPE
      ,base_t.object_name_regexp       BASE_TABLE_OBJECT_NAME_REGEXP
      ,base_t.object_owner             BASE_TABLE_OWNER
      ,base_t.object_name              BASE_TABLE_NAME
      ,base_t.object_type              BASE_TABLE_TYPE
      ,fk.constraint_name              FOREIGN_KEY_NAME
      ,pk.constraint_name              UNIQUE_KEY_NAME
      ,pk.constraint_type              UNIQUE_KEY_TYPE
      ,ref_t.build_type                REF_TABLE_BUILD_TYPE
      ,ref_t.object_name_regexp        REF_TABLE_OBJECT_NAME_REGEXP
      ,ref_t.object_owner              REF_TABLE_OWNER
      ,ref_t.object_name               REF_TABLE_NAME
      ,ref_t.object_type               REF_TABLE_TYPE
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  obj_install_object_tab  base_t
       join schema_conf  own
            on  own.username        = base_t.object_owner
            and own.oracle_provided = 'N'    -- Exclude base tables owned by Oracle Provided
       join element_conf  ec
            on  ec.element_name = case when base_t.object_type = 'MATERIALIZED VIEW'
                                       then 'MVIEW_FOREIGN_KEY'
                                       else base_t.object_type || '_FOREIGN_KEY'
                                  end
       join dba_constraints  fk
            on  fk.owner           = base_t.object_owner
            and fk.table_name      = base_t.object_name
            and fk.constraint_type = 'R'
            and fk.constraint_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join dba_constraints  pk
            on  pk.owner           = fk.r_owner
            and pk.constraint_name = fk.r_constraint_name
            and pk.constraint_type in ('P','U')
       join obj_install_object_tab  ref_t
            on  ref_t.object_owner  = pk.owner
            and ref_t.object_name   = pk.table_name
            and ref_t.object_type  in ('MATERIALIZED VIEW', 'TABLE', 'VIEW')
       join build_type_timing  t
            -- Ensure the Ref Table is installed before this Foreign Key
            on  t.from_build_type = base_t.build_type
            and t.to_build_type   = ref_t.build_type
 where base_t.object_type  in ('MATERIALIZED VIEW', 'TABLE', 'VIEW');

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_FKEY_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_INDEX_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_INDEX_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "INDEX_BUILD_TYPE", "INDEX_OBJECT_NAME_REGEXP", "INDEX_OWNER", "INDEX_NAME", "OBJECT_TYPE", "UNIQUENESS", "INDEX_TYPE", "ITYP_OWNER", "ITYP_NAME", "TABLE_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TABLE_OWNER", "TABLE_NAME", "TABLE_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else tgt.build_type
      end                          BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'INDEX'
            else 'TARGET'
      end                          BUILD_TYPE_SELECTOR
      ,obj.build_type              INDEX_BUILD_TYPE
      ,obj.object_name_regexp      INDEX_OBJECT_NAME_REGEXP
      ,obj.object_owner            INDEX_OWNER
      ,obj.object_name             INDEX_NAME
      ,obj.object_type
      ,ind.uniqueness
      ,ind.index_type
      ,ind.ityp_owner
      ,ind.ityp_name
      ,tgt.build_type              TABLE_BUILD_TYPE
      ,tgt.object_name_regexp      TARGET_OBJECT_NAME_REGEXP
      ,tgt.object_owner            TABLE_OWNER
      ,tgt.object_name             TABLE_NAME
      ,tgt.object_type             TABLE_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join schema_conf  own
            on  own.username        = obj.object_owner
            and own.oracle_provided = 'N'    -- Exclude Oracle Provided Index Schemas
       join dba_indexes  ind
            on  ind.owner      = obj.object_owner
            and ind.index_name = obj.object_name
            and ind.index_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join obj_install_object_tab  tgt
            on  tgt.object_owner = ind.table_owner
            and tgt.object_name  = ind.table_name
            and tgt.object_type  = ind.table_type
       join build_type_timing  t
            -- Ensure Target Table is installed before this Index
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = tgt.build_type
 where obj.object_type = 'INDEX';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_INDEX_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_OBJECT_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_OBJECT_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "OBJECT_NAME_REGEXP", "OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_BUILD_TYPE", "OBJECT_NAME", "OBJECT_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select oc.build_type
      ,t.build_timing
      ,oc.object_name_regexp
      ,obj.object_owner_build_type
      ,obj.object_owner
      ,oc.build_type               OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
            and (   ec.object_type != 'INDEX'
                 or ec.element_name  = (select case ind.table_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else ind.table_type
                                               end      || '_INDEX'
                                         from  dba_indexes  ind
                                         where ind.owner = obj.object_owner
                                          and  ind.index_name = obj.object_name) )
            and (   ec.object_type != 'TRIGGER'
                 or ec.element_name  = (select case trg.base_object_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else trg.base_object_type
                                               end      || '_TRIGGER'
                                         from  dba_triggers  trg
                                         where trg.owner = obj.object_owner
                                          and  trg.trigger_name = obj.object_name) )
       join object_conf  oc
            on  oc.username     = obj.object_owner
            and oc.build_type  != obj.object_owner_build_type
            and oc.element_name = ec.element_name
            and regexp_like(obj.object_name, oc.object_name_regexp)
       join build_type_timing  t
            -- Ensure the owner is installed before this object
            on  t.from_build_type = oc.build_type
            and t.to_build_type   = obj.object_owner_build_type
 where (   obj.table_flag != 'NT'    -- Nested Tables masquarade as tables in DBA_OBJECTS
        OR obj.table_flag is NULL)
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
), q_dflt as (
  select obj.object_owner_build_type BUILD_TYPE
      ,'CURRENT'                     BUILD_TIMING
      ,NULL                          OBJECT_NAME_REGEXP
      ,obj.object_owner_build_type
      ,obj.object_owner
      ,obj.object_owner_build_type   OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
            and (   ec.object_type != 'INDEX'
                 or ec.element_name  = (select case ind.table_type
                                               when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                        else ind.table_type
                                               end      || '_INDEX'
                                         from  dba_indexes  ind
                                         where ind.owner = obj.object_owner
                                          and  ind.index_name = obj.object_name) )
            and (   ec.object_type  != 'TRIGGER'
                 or ec.element_name  = (select case trg.base_object_type
                                              when 'MATERIALIZED VIEW' then 'MVIEW'
                                                                       else trg.base_object_type
                                              end      || '_TRIGGER'
                                        from  dba_triggers  trg
                                        where trg.owner = obj.object_owner
                                         and  trg.trigger_name = obj.object_name) )
 where (   obj.table_flag != 'NT'    -- Nested Tables masquarade as tables in DBA_OBJECTS
        OR obj.table_flag is NULL)
  and  (obj.object_owner, obj.object_type, obj.object_name) not in (
        select q_nondflt.object_owner, q_nondflt.object_type, q_nondflt.object_name from q_nondflt)
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
), q_sys as (
  select oc.build_type
      ,'CURRENT'                     BUILD_TIMING
      ,oc.object_name_regexp
      ,oc.build_type                 OBJECT_OWNER_BUILD_TYPE
      ,obj.object_owner
      ,oc.build_type                 OBJECT_BUILD_TYPE
      ,obj.object_name
      ,obj.object_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_objects_tab  obj
       join element_conf  ec
            on  ec.object_type = obj.object_type
       join object_conf  oc
            on  oc.username     = obj.object_owner
            and oc.build_type  != obj.object_owner_build_type
            and oc.element_name = ec.element_name
            and regexp_like(obj.object_name, oc.object_name_regexp)
 where obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
  and  obj.object_owner = 'SYS'
  and  obj.object_type in ('CONTEXT', 'DIRECTORY')
)
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","OBJECT_OWNER_BUILD_TYPE","OBJECT_OWNER","OBJECT_BUILD_TYPE","OBJECT_NAME","OBJECT_TYPE","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_sys;

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_OBJECT_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_SYNONYM_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_SYNONYM_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "SYNONYM_BUILD_TYPE", "SYNONYM_OBJECT_NAME_REGEXP", "SYNONYM_OWNER", "SYNONYM_NAME", "OBJECT_TYPE", "DB_LINK", "TARGET_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then tgt.build_type
            else obj.build_type
      end                             BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'SYNONYM'
            else 'TARGET'
      end                             BUILD_TYPE_SELECTOR
      ,obj.build_type                 SYNONYM_BUILD_TYPE
      ,obj.object_name_regexp         SYNONYM_OBJECT_NAME_REGEXP
      ,obj.object_owner               SYNONYM_OWNER
      ,obj.object_name                SYNONYM_NAME
      ,'SYNONYM'                      OBJECT_TYPE
      ,syn.db_link
      ,tgt.build_type                 TARGET_BUILD_TYPE
      ,tgt.object_name_regexp         TARGET_OBJECT_NAME_REGEXP
      ,tgt.object_owner               TARGET_OWNER
      ,tgt.object_name                TARGET_NAME
      ,tgt.object_type                TARGET_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join sys.dba_synonyms  syn
            on  syn.owner        = obj.object_owner
            and syn.synonym_name = obj.object_name
       join schema_conf  own
            on  own.username = syn.owner
       join obj_install_object_tab  tgt
            on  tgt.object_owner  = syn.table_owner
            and tgt.object_name   = syn.table_name
            and tgt.object_type  in ('FUNCTION', 'OPERATOR', 'PACKAGE', 'PROCEDURE',
                                     'SEQUENCE', 'SYNONYM', 'TABLE', 'TYPE', 'VIEW',
                                     'MATERIALIZED VIEW', 'JAVA SOURCE', 'QUEUE')
       join build_type_timing  t
            -- Ensure the Target is installed before this Synonym
            on  t.from_build_type = tgt.build_type
            and t.to_build_type   = obj.build_type
 where obj.object_type                    = 'SYNONYM'
  and  (   own.oracle_provided = 'N'                -- Exclude Oracle Provided Synonyms
        OR obj.object_owner_build_type = 'pub' )  -- Include Public Synonyms
  and  syn.synonym_name              not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_SYNONYM_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJ_INSTALL_TRIGGER_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."OBJ_INSTALL_TRIGGER_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "TRIGGER_BUILD_TYPE", "TRIGGER_OBJECT_NAME_REGEXP", "TRIGGER_OWNER", "TRIGGER_NAME", "OBJECT_TYPE", "TARGET_BUILD_TYPE", "TARGET_OBJECT_NAME_REGEXP", "TARGET_OWNER", "TARGET_NAME", "TARGET_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else tab.build_type
      end                             BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'TRIGGER'
            else 'TARGET'
      end                             BUILD_TYPE_SELECTOR
      ,obj.build_type                 TRIGGER_BUILD_TYPE
      ,obj.object_name_regexp         TRIGGER_OBJECT_NAME_REGEXP
      ,obj.object_owner               TRIGGER_OWNER
      ,obj.object_name                TRIGGER_NAME
      ,obj.object_type
      ,tab.build_type                 TARGET_BUILD_TYPE
      ,tab.object_name_regexp         TARGET_OBJECT_NAME_REGEXP
      ,tab.object_owner               TARGET_OWNER
      ,tab.object_name                TARGET_NAME
      ,tab.object_type                TARGET_TYPE
      ,obj.element_name
      ,obj.file_ext1
      ,obj.file_ext2
      ,obj.file_ext3
 from  obj_install_object_tab  obj
       join dba_triggers  trig
            on  trig.owner        = obj.object_owner
            and trig.trigger_name = obj.object_name
       join schema_conf  trigown
            on  trigown.username        = trig.owner
            and trigown.oracle_provided = 'N'  -- Exclude Oracle Provided Triggers
       join obj_install_object_tab  tab
            on  tab.object_owner  = trig.table_owner
            and tab.object_name   = trig.table_name
            and tab.object_type   = trig.base_object_type  -- Eliminates SYSTEM Triggers
       join schema_conf  tabown
            on  tabown.username        = tab.object_owner
            and tabown.oracle_provided = 'N'   -- Exclude Oracle Provided Base Tables
       join build_type_timing t
            -- Ensure the Table is installed before this Trigger
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = tab.build_type
 where obj.object_type  = 'TRIGGER'
  and  obj.element_name = case when trig.base_object_type = 'MATERIALIZED VIEW' then 'MVIEW_TRIGGER'
                                                                                else trig.base_object_type || '_TRIGGER'
                          end
  and  obj.object_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\';

--  Comments

--DBMS_METADATA:ODBCAPTURE.OBJ_INSTALL_TRIGGER_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_OBJ_DIR_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_DIR_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_DIR_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "OBJECT_NAME_REGEXP", "DIRECTORY_BUILD_TYPE", "DIRECTORY_OWNER", "DIRECTORY_NAME", "OBJECT_TYPE", "DIRECTORY_PATH", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select oc.build_type
      ,t.build_timing
      ,oc.object_name_regexp
      ,oc.build_type           DIRECTORY_BUILD_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.build_type          GRANTEE_BUILD_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'      -- Not Oracle Provided Grantee
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
            and dir.directory_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join element_conf  ec
            on  ec.element_name = priv.object_type
       join object_conf  oc
            -- OBJECT_CONF is configured based on Grantee, not Owner
            on  oc.username     = uor.user_or_role
            and oc.build_type  != uor.build_type
            and oc.element_name = priv.object_type
            and regexp_like(dir.directory_name, oc.object_name_regexp)
       join build_type_timing  t
            -- Ensure Grantee is available when Directory is installed
            on  t.from_build_type = oc.build_type
            and t.to_build_type   = uor.build_type
 where priv.object_owner = 'SYS'
  and  priv.object_type  = 'DIRECTORY'
), q_dflt as (
select uor.build_type
      ,'CURRENT'               BUILD_TIMING
      ,NULL                    OBJECT_NAME_REGEXP
      ,'sys'                   DIRECTORY_BUILD_TYPE
      ,'SYS'                   DIRECTORY_OWNER
      ,dir.directory_name
      ,'DIRECTORY'             OBJECT_TYPE
      ,dir.directory_path      DIRECTORY_PATH
      ,uor.build_type          GRANTEE_BUILD_TYPE
      ,uor.user_or_role        GRANTEE
      ,uor.uor_type            GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role    = priv.grantee
            and uor.oracle_provided = 'N'      -- Not Oracle Provided Grantee
       join dba_directories  dir
            on  dir.directory_name = priv.object_name
            and dir.directory_name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
       join element_conf  ec
            on  ec.element_name = priv.object_type
 where (priv.grantee, dir.directory_name) not in (select q_nondflt.grantee, q_nondflt.directory_name from q_nondflt)
  and  priv.object_owner = 'SYS'
  and  priv.object_type  = 'DIRECTORY'
)
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","DIRECTORY_BUILD_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","OBJECT_NAME_REGEXP","DIRECTORY_BUILD_TYPE","DIRECTORY_OWNER","DIRECTORY_NAME","OBJECT_TYPE","DIRECTORY_PATH","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","GRANTABLE","HIERARCHY","COMMON","INHERITED","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_DIR_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_OBJ_HACL_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_HACL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_HACL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_HACL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_HACL_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "HACL_BUILD_TYPE", "HACL_NAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "HOST", "LOWER_PORT", "UPPER_PORT", "ACE_ORDER", "START_DATE", "END_DATE", "PRINCIPAL_TYPE", "GRANT_TYPE", "INVERTED_PRINCIPAL", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select case t.build_timing
            when 'CURRENT'
            then ol.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'OBJECT_NAME_REGEXP'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,ol.object_name_regexp
      ,ol.build_type                  HACL_BUILD_TYPE
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      HACL_NAME           -- Defined Length Concatenations Don't Need a CAST
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_host_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
       join element_conf  ec
            on  ec.element_name = 'HOST_ACL'
       join object_conf  ol
            on  ol.username     = uor.user_or_role
            and ol.build_type  != uor.build_type
            and ol.element_name = ec.element_name
            and regexp_like(a.host || ',' || a.lower_port || '-' || a.upper_port, ol.object_name_regexp)
       join build_type_timing  t
            -- Ensure the Grantee is available when the HACL is installed
            on  t.from_build_type = ol.build_type
            and t.to_build_type   = uor.build_type
 where (   uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
        OR uor.build_type = 'pub')    -- Include PUBLIC as the grantee
), q_dflt as (
  select uor.build_type
      ,'CURRENT'                      BUILD_TIMING
      ,'GRANTEE'                      BUILD_TYPE_SELECTOR
      ,NULL                           OBJECT_NAME_REGEXP
      ,'sys'                          HACL_BUILD_TYPE  -- Use the BUILD_TYPE of the Grantee
      ,a.host || ',' || a.lower_port || '-' || a.upper_port
                                      HACL_NAME          -- Defined Length Concatenations Don't Need a CAST
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.host
      ,nvl(to_char(a.lower_port),'NULL')
                                      LOWER_PORT
      ,nvl(to_char(a.upper_port),'NULL')
                                      UPPER_PORT
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
  from dba_host_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join element_conf  ec
            on  ec.element_name = 'HOST_ACL'
 where (a.principal, a.host || ',' || a.lower_port || '-' || a.upper_port) not in
       (select q_nondflt.grantee, q_nondflt.hacl_name from q_nondflt)
)
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","HACL_BUILD_TYPE","HACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","HACL_BUILD_TYPE","HACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","HOST","LOWER_PORT","UPPER_PORT","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_HACL_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_OBJ_INSTALL_VW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_INSTALL_VW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_INSTALL_VW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'OBJECT'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,obj.build_type                 OBJECT_BUILD_TYPE
      ,obj.object_owner
      ,obj.object_name
      ,obj.object_type
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
       join obj_install_object_tab  obj
            on  obj.object_owner  = priv.object_owner
            and obj.object_name   = priv.object_name
            and obj.object_type   = priv.object_type
       join schema_conf  own
            on  own.username = obj.object_owner
       join element_conf  ec
            on  ec.element_name = 'GRANT'
       join build_type_timing  t
            -- Ensure Grantee is available after installation of object
            on  from_build_type = obj.object_build_type
            and to_build_type   = uor.build_type
 where priv.object_owner != 'SYS'             -- Exclude database objects owned by SYS
  and  (   uor.oracle_provided = 'N'          -- Not Oracle Provided Grantee
        OR (    uor.build_type    = 'pub'   -- Include 'pub' Grantees
            AND own.oracle_provided = 'N' )   -- Only if owner not Oracle Provided
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_INSTALL_VW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_OBJ_QUEUE_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_QUEUE_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
            when 'CURRENT'
            then obj.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,obj.build_type                 QUEUE_BUILD_TYPE
      ,obj.object_owner               QUEUE_OWNER
      ,obj.object_name                QUEUE_NAME
      ,'QUEUE'                        OBJECT_TYPE
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,tp.privilege
      ,tp.grantable
      ,tp.hierarchy
      ,tp.common
      ,tp.inherited
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from uor_install_view  uor
       join dba_tab_privs_tab  tp
            on  tp.grantee     = uor.user_or_role
            and tp.object_type = 'QUEUE'
       join dba_queues  aq
            on  aq.owner = tp.object_owner
            and aq.name  = tp.object_name
       join obj_install_object_tab  obj
            on  obj.object_owner = tp.object_owner
            and obj.object_name  = tp.object_name
            and obj.object_type  = 'QUEUE'
       join schema_conf  own
            on  own.username = obj.object_owner
       join element_conf  ec
            on  ec.element_name = 'GRANT'
       join build_type_timing  t
            -- Ensure the Grantee is available when the Queue is installed
            on  t.from_build_type = obj.build_type
            and t.to_build_type   = uor.build_type
 where (   aq.queue_type is null
        or aq.queue_type != 'EXCEPTION_QUEUE')
  and  aq.name not like common_util.get_RECYCLE_BIN_PATTERN escape '\'
  and  (   uor.oracle_provided = 'N'          -- Exclude Oracle Provided Grantees
        OR (    uor.build_type    = 'pub'   -- Include 'pub' Grantess
            AND own.oracle_provided = 'N' )   -- Only if owner not Oracle Provided
       );

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_QUEUE_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_OBJ_WACL_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_WACL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_WACL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_WACL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_WACL_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "WACL_BUILD_TYPE", "WACL_NAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "WALLET_PATH", "ACE_ORDER", "START_DATE", "END_DATE", "PRINCIPAL_TYPE", "GRANT_TYPE", "INVERTED_PRINCIPAL", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  with q_nondflt as (
  select case t.build_timing
            when 'CURRENT'
            then ol.build_type
            else uor.build_type
       end                            BUILD_TYPE
      ,t.build_timing
      ,case t.build_timing
            when 'CURRENT'
            then 'OBJECT_NAME_REGEXP'
            else 'GRANTEE'
       end                            BUILD_TYPE_SELECTOR
      ,ol.object_name_regexp
      ,ol.build_type                  WACL_BUILD_TYPE
      ,regexp_replace(regexp_replace(substr(a.wallet_path
                                           ,greatest(0-length(a.wallet_path)
                                                    ,-255) )
                                    ,'^file:','')
                     ,'[\/]','_')     WACL_NAME
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.wallet_path
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  dba_wallet_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
       join element_conf  ec
            on  ec.element_name = 'WALLET_ACL'
       join object_conf  ol
            on  ol.username     = uor.user_or_role
            and ol.build_type  != uor.build_type
            and ol.element_name = ec.element_name
            and regexp_like(a.wallet_path, ol.object_name_regexp)
       join build_type_timing  t
            -- Ensure the Grantee is available when the WACL is installed
            on  t.from_build_type = ol.build_type
            and t.to_build_type   = uor.build_type
 where (   uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
        OR uor.build_type = 'pub')    -- Include PUBLIC as the grantee
), q_dflt as (
  select uor.build_type
      ,'CURRENT'                      BUILD_TIMING
      ,'GRANTEE'                      BUILD_TYPE_SELECTOR
      ,NULL                           OBJECT_NAME_REGEXP
      ,'sys'                          WACL_BUILD_TYPE  -- Use the BUILD_TYPE of the Grantee
      ,regexp_replace(regexp_replace(substr(a.wallet_path
                                           ,greatest(0-length(a.wallet_path)
                                                    ,-255) )
                                    ,'^file:','')
                     ,'[\/]','_')     WACL_NAME
      ,uor.build_type                 GRANTEE_BUILD_TYPE
      ,uor.user_or_role               GRANTEE
      ,uor.uor_type                   GRANTEE_UOR_TYPE
      ,a.privilege
      ,a.wallet_path
      ,a.ace_order
      ,nvl(to_char(a.start_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      START_DATE
      ,nvl(to_char(a.end_date,'YYYYMMDDHH24MISS.FF'), 'NULL')
                                      END_DATE
      ,a.principal_type
      ,a.grant_type
      ,a.inverted_principal
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
  from dba_wallet_aces  a
       join uor_install_view  uor
            on  uor.user_or_role    = a.principal
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join element_conf  ec
            on  ec.element_name = 'WALLET_ACL'
 where (a.principal, a.wallet_path) not in
       (select q_nondflt.grantee, q_nondflt.wacl_name from q_nondflt)
)
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","WACL_BUILD_TYPE","WACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","WALLET_PATH","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_nondflt
UNION ALL
select "BUILD_TYPE","BUILD_TIMING","BUILD_TYPE_SELECTOR","OBJECT_NAME_REGEXP","WACL_BUILD_TYPE","WACL_NAME","GRANTEE_BUILD_TYPE","GRANTEE","GRANTEE_UOR_TYPE","PRIVILEGE","WALLET_PATH","ACE_ORDER","START_DATE","END_DATE","PRINCIPAL_TYPE","GRANT_TYPE","INVERTED_PRINCIPAL","ELEMENT_NAME","FILE_EXT1","FILE_EXT2","FILE_EXT3" from q_dflt;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_WACL_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_QUEUE_REGISTER_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_REGISTER_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_REGISTER_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "CONSUMER_BUILD_TYPE", "CONSUMER_NAME", "CONSUMER_UOR_TYPE", "SUBSCRIPTION_NAME", "NAMESPACE", "LOCATION_NAME", "USER_CONTEXT", "QOSFLAGS", "TIMEOUT", "NTFN_GROUPING_CLASS", "NTFN_GROUPING_VALUE", "NTFN_GROUPING_TYPE", "NTFN_GROUPING_START_TIME", "NTFN_GROUPING_REPEAT_COUNT", "CONTEXT_SIZE") AS 
  select case t.build_timing
            when 'CURRENT'
            then aq.build_type
            else uor.build_type
       end                               BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'CONSUMER'
       end                               BUILD_TYPE_SELECTOR
      ,aq.build_type                     QUEUE_BUILD_TYPE
      ,aq.object_owner                   QUEUE_OWNER
      ,aq.object_name                    QUEUE_NAME
      ,'QUEUE'                           OBJECT_TYPE
      ,uor.build_type                    CONSUMER_BUILD_TYPE
      ,uor.user_or_role                  CONSUMER_NAME
      ,uor.uor_type                      CONSUMER_UOR_TYPE
      ,aqreg.subscription_name           -- "subscription_name" defines the datatype
      ,aqreg.namespace
      ,aqreg.location_name
      ,aqreg.user_context
      ,aqreg.qosflags
      ,aqreg.timeout
      ,aqreg.ntfn_grouping_class
      ,aqreg.ntfn_grouping_value
      ,aqreg.ntfn_grouping_type
      ,aqreg.ntfn_grouping_start_time
      ,aqreg.ntfn_grouping_repeat_count
      ,aqreg.context_size
 from  uor_install_view  uor
       join dba_subscr_registrations  aqreg
            on  substr(aqreg.subscription_name
                      ,instr(aqreg.subscription_name,':') + 1
                      ,4000) = uor.user_or_role
       join obj_install_object_tab  aq
            on  aq.object_owner = substr(aqreg.subscription_name
                                        ,1
                                        ,instr(aqreg.subscription_name,'.') - 1)
            and aq.object_name = substr(aqreg.subscription_name
                                       ,instr(aqreg.subscription_name,'.') + 1
                                       ,instr(aqreg.subscription_name,':') -
                                        instr(aqreg.subscription_name,'.') - 1)
       join schema_conf  own
            on  own.username = aq.object_owner
       join build_type_timing  t
            -- Ensure the Consumer is avaialable when this Queue is installed
            on  t.from_build_type = aq.build_type
            and t.to_build_type   = uor.build_type
 where aq.object_type   = 'QUEUE'
       -- Exclude Oracle Provided queues
  and  own.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_REGISTER_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_QUEUE_SUBSCRIBE_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SUBSCRIBE_VIEW" ("BUILD_TYPE", "BUILD_TYPE_SELECTOR", "QUEUE_BUILD_TYPE", "QUEUE_OWNER", "QUEUE_NAME", "OBJECT_TYPE", "CONSUMER_BUILD_TYPE", "CONSUMER_NAME", "CONSUMER_UOR_TYPE", "ADDRESS", "PROTOCOL", "RULE", "TRANSFORMATION", "QUEUE_TO_QUEUE", "DELIVERY_MODE") AS 
  select case t.build_timing
            when 'CURRENT'
            then aq.build_type
            else uor.build_type
       end                           BUILD_TYPE
      ,case t.build_timing
            when 'CURRENT'
            then 'QUEUE'
            else 'CONSUMER'
       end                           BUILD_TYPE_SELECTOR
      ,aq.build_type                 QUEUE_BUILD_TYPE
      ,aq.object_owner               QUEUE_OWNER
      ,aq.object_name                QUEUE_NAME
      ,'QUEUE'                       OBJECT_TYPE
      ,uor.build_type                CONSUMER_BUILD_TYPE
      ,uor.user_or_role              CONSUMER_NAME
      ,uor.uor_type                  CONSUMER_UOR_TYPE
      ,aqsub.address
      ,aqsub.protocol
      ,aqsub.rule
      ,aqsub.transformation
      ,aqsub.queue_to_queue
      ,aqsub.delivery_mode
 from  uor_install_view  uor
       join dba_queue_subscribers  aqsub
            on  aqsub.consumer_name = uor.user_or_role
       join obj_install_object_tab  aq
            on  aq.object_owner = aqsub.owner
            and aq.object_name  = aqsub.queue_name
       join schema_conf  own
            on  own.username = aq.object_owner
       -- Ensure Consumer is available when Queue is installed
       join build_type_timing  t
            on  t.from_build_type = aq.build_type
            and t.to_build_type   = uor.build_type
 where aq.object_type   = 'QUEUE'
       -- Exclude Oracle Provided queues
  and  own.oracle_provided = 'N';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SUBSCRIBE_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_QUEUE_SYSPRIVS_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_QUEUE_SYSPRIVS_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "GRANT_BUILD_TYPE", "GRANT_OWNER", "GRANT_NAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "ADMIN_OPTION", "COMMON", "INHERITED", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                              BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                              BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                              BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                    OBJECT_NAME_REGEXP_BUILD_TYPE
      ,'sys'                            GRANT_BUILD_TYPE
      ,'SYS'                            GRANT_OWNER
      ,aqsp.dbms_aq_priv                GRANT_NAME
      ,uor.build_type                   GRANTEE_BUILD_TYPE
      ,uor.user_or_role                 GRANTEE
      ,uor.uor_type                     GRANTEE_UOR_TYPE
      ,aqsp.admin_option
      ,aqsp.common
      ,aqsp.inherited
      ,'GRANT'                          ELEMENT_NAME
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  aq_system_privs_vw  aqsp
       join uor_install_view  uor
            on  uor.user_or_role = aqsp.grantee
            and uor.oracle_provided = 'N'   -- Exclude Oracle Provided Grantees
       join element_conf  ec
            on  ec.element_name = 'GRANT'
  left join object_conf  oc
            on  oc.element_name = 'GRANT'
            and oc.username     = aqsp.grantee
            and regexp_like(aqsp.dbms_aq_priv, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_QUEUE_SYSPRIVS_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_ROLE_PRIVILEGES_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_ROLE_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "ROLE_BUILD_TYPE", "ROLENAME", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "DEFAULT_ROLE", "ADMIN_OPTION", "DELEGATE_OPTION", "COMMON", "INHERITED") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                                       BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                                       BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                                       BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                             OBJECT_NAME_REGEXP_BUILD_TYPE
      ,trc.build_type                            ROLE_BUILD_TYPE
      ,trc.rolename
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.user_or_role                          GRANTEE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.default_role
      ,priv.admin_option
      ,priv.delegate_option
      ,priv.common
      ,priv.inherited
 from  dba_role_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join role_conf  trc
            on  trc.rolename        = priv.granted_role
            and trc.oracle_provided = 'Y'    -- Only Oracle Provided Roles
  left join object_conf  oc
            on  oc.element_name = 'ROLE'
            and oc.username     = priv.grantee
            and regexp_like(trc.rolename, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
UNION ALL
  select case t.build_timing
          when 'FUTURE' then trc.build_type
                        else uor.build_type
       end                                       BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                                       BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                                       BUILD_TYPE_SELECTOR
      ,NULL                                      OBJECT_NAME_REGEXP
      ,NULL                                      OBJECT_NAME_REGEXP_BUILD_TYPE
      ,trc.build_type                            ROLE_BUILD_TYPE
      ,trc.rolename
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.user_or_role                          GRANTEE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.default_role
      ,priv.admin_option
      ,priv.delegate_option
      ,priv.common
      ,priv.inherited
 from  dba_role_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
       join role_conf  trc
            on  trc.rolename        = priv.granted_role
            and trc.oracle_provided = 'N'    -- Not Oracle Provided Role
       -- Ensure the Grantee is available after installation of the Role
       join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = trc.build_type;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_ROLE_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_SYSOBJ_PRIVILEGES_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSOBJ_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "OBJECT_OWNER_BUILD_TYPE", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE", "GRANTEE_UOR_TYPE", "PRIVILEGE", "GRANTABLE", "HIERARCHY", "COMMON", "INHERITED") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                              BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                              BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                              BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                    OBJECT_NAME_REGEXP_BUILD_TYPE
      ,priv.object_owner_build_type
      ,priv.object_owner
      ,priv.object_name
      ,priv.object_type
      ,priv.grantee_build_type
      ,priv.grantee
      ,priv.grantee_uor_type
      ,priv.privilege
      ,priv.grantable
      ,priv.hierarchy
      ,priv.common
      ,priv.inherited
 from  dba_tab_privs_tab  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
  left join object_conf  oc
            on  oc.element_name = 'SYS_GRANT'
            and oc.username     = priv.grantee
            and regexp_like(priv.object_name, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
       -- Include only 'sys' Objects
 where priv.object_owner  = 'SYS';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSOBJ_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/PRIV_SYSTEM_PRIVILEGES_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_SYSTEM_PRIVILEGES_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "OBJECT_NAME_REGEXP_BUILD_TYPE", "GRANTEE_BUILD_TYPE", "GRANTEE_UOR_TYPE", "GRANTEE", "SYSTEM_PRIVILEGE_NAME", "ADMIN_OPTION", "COMMON", "INHERITED") AS 
  select case t.build_timing
          when 'FUTURE' then oc.build_type
                        else uor.build_type
       end                                       BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                                       BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                                       BUILD_TYPE_SELECTOR
      ,oc.object_name_regexp
      ,oc.build_type                             OBJECT_NAME_REGEXP_BUILD_TYPE
      ,uor.build_type                            GRANTEE_BUILD_TYPE
      ,uor.uor_type                              GRANTEE_UOR_TYPE
      ,priv.grantee
      ,priv.privilege                            SYSTEM_PRIVILEGE_NAME
      ,priv.admin_option
      ,priv.common
      ,priv.inherited
 from  dba_sys_privs  priv
       join uor_install_view  uor
            on  uor.user_or_role = priv.grantee
            and uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
  left join object_conf  oc
            on  oc.element_name = 'GRANT'
            and oc.username     = priv.grantee
            and regexp_like(priv.privilege, oc.object_name_regexp)
  left join build_type_timing  t
            on  t.from_build_type = uor.build_type
            and t.to_build_type   = oc.build_type
 where priv.privilege not like '% ANY QUEUE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_SYSTEM_PRIVILEGES_VIEW


--  Grants


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/UOR_INSTALL_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.UOR_INSTALL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."UOR_INSTALL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."UOR_INSTALL_VIEW" ("BUILD_TYPE", "ORACLE_PROVIDED", "USER_OR_ROLE", "UOR_TYPE", "FILE_EXT1", "NOTES") AS 
  select sc.build_type
      ,sc.oracle_provided
      ,sc.username            USER_OR_ROLE
      ,'USER'                 UOR_TYPE
      ,ec.file_ext1
      ,sc.notes
 from  schema_conf  sc
       join element_conf  ec
            on  ec.element_name = 'USER'
UNION ALL
select rl.build_type
      ,rl.oracle_provided
      ,rl.rolename              USER_OR_ROLE
      ,'ROLE'                   UOR_TYPE
      ,ec.file_ext1
      ,rl.notes
 from  role_conf  rl
       join element_conf  ec
            on  ec.element_name = 'ROLE';

--  Comments

--DBMS_METADATA:ODBCAPTURE.UOR_INSTALL_VIEW


--  Grants


--  Synonyms


set define on

----------------------------------------
-- PACKAGE BODY Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/COMMON_UTIL.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.COMMON_UTIL Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.COMMON_UTIL

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."COMMON_UTIL" 
as

------------------------------------------------------------
-- Add SYS Grants File Header to Script File
procedure add_sysgrants_file_header
      (fh  in out nocopy  fh2.sf_ptr_type)
is
begin
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Future Grant SYS Objects (but not directories)');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'set define off');
   fh2.script_put_line(fh, '');
end add_sysgrants_file_header;


------------------------------------------------------------
-- Add Grants File Header to Script File
procedure add_grants_file_header
      (fh          in out nocopy  fh2.sf_ptr_type
      ,in_grantee  in             varchar2)
is
begin
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Create ' || in_grantee || ' Grants');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'set define off');
   fh2.script_put_line(fh, '');
end add_grants_file_header;


------------------------------------------------------------
-- Set DBMS_METADATA Transformation Parameters
procedure dbms_metadata_settings
is
begin
   -- http://docs.oracle.com/database/121/ARPLS/d_metada.htm#ARPLS66910
   for buff in (select * from metadata_transform_params)
   loop
      case buff.value_type
         when 'BOOLEAN' then
            dbms_metadata.set_transform_param
               (transform_handle => dbms_metadata.session_transform
               ,name             => buff.name
               ,value            => regexp_like(buff.value, '^[TY]', 'i'));
         when 'NUMBER' then
            dbms_metadata.set_transform_param
               (transform_handle => dbms_metadata.session_transform
               ,name             => buff.name
               ,value            => to_number(buff.value));
         when 'VARCHAR' then
            dbms_metadata.set_transform_param
               (transform_handle => dbms_metadata.session_transform
               ,name             => buff.name
               ,value            => buff.value);
      end case;
   end loop;
end dbms_metadata_settings;


------------------------------------------------------------
-- RPAD changed to include truncate.
-- This function brings back the old functionality.
function old_rpad
      (in_expr1  in varchar2
      ,in_n      in number
      ,in_expr2  in varchar2 default null)
   return varchar2
is
begin
   if in_expr1 is null or length(in_expr1) >= in_n
   then
      return in_expr1;
   end if;
   return rpad(in_expr1, in_n, nvl(in_expr2,' '));
end old_rpad;

------------------------------------------------------------
-- Return RECYCLE_BIN_PATTERN for SQL Queries
function get_RECYCLE_BIN_PATTERN
   return varchar2
is
begin
   return RECYCLE_BIN_PATTERN;
end get_RECYCLE_BIN_PATTERN;


------------------------------------------------------------
-- Add linefeeds before MAXIMUM_SQL_LENGTH at commas, if possible.
function split_sql_length
      (in_str  IN CLOB)
   return CLOB
is
   olen     number;           -- Original Length of IN_STR
   ptr      number;           -- Current Position in IN_STR
   out_str  CLOB;             -- Output String
   oset     number;           -- Line Cut-off at the comma
begin
   olen    := length(in_str);
   ptr     := 1;
   out_str := '';
   while olen - ptr + 1 > MAXIMUM_SQL_LENGTH
   loop
      oset := instr(substr(in_str, ptr, MAXIMUM_SQL_LENGTH), LF, -1);
      if oset <= 0
      then
         oset := instr(substr(in_str, ptr, MAXIMUM_SQL_LENGTH), ',', -1);
         if oset <= 0
         then
            raise_application_error(-20000
                                   ,substr('Unable to find "," in string: ' ||
                                            substr(in_str, ptr, MAXIMUM_SQL_LENGTH)
                                          ,1,4000                              ) );
         end if;
         out_str := out_str || substr(substr(in_str, ptr, MAXIMUM_SQL_LENGTH), 1, oset) || LF;
      else
         out_str := out_str || substr(substr(in_str, ptr, MAXIMUM_SQL_LENGTH), 1, oset);
      end if;
      ptr   := ptr + oset;
   end loop;
   return(out_str || substr(in_str, ptr, MAXIMUM_SQL_LENGTH));
end split_sql_length;


------------------------------------------------------------
-- Must escape "@" with a CHR(16): ^P, Control-P, DLE
--   Otherwise, SQL*Plus will attempt to run a script
function escape_at_sign
      (in_str      IN   CLOB)
   return CLOB
is
begin
   return regexp_replace(in_str, '('||LF||'[[:space:]]*)@', '\1'||CHR(16)||'@');
end escape_at_sign;


------------------------------------------------------------
-- Check for invalid Windows characters in filenames
--
--http://stackoverflow.com/questions/1976007/what-characters-are-forbidden-in-windows-and-linux-directory-names
-- < (less than)
-- > (greater than)
-- : (colon)
-- " (double quote)
-- / (forward slash)
-- \ (backslash)
-- | (vertical bar or pipe)
-- ? (question mark)
-- * (asterisk)
--
procedure check_windows_filenames
      (in_build_type  in varchar2)
is
begin
   for buff in (
      select obj.object_owner || '.' || obj.object_name || '(' || obj.object_type || ')'  oname
       from  dba_objects_tab  obj
             join element_conf  otl
                  on  otl.name_check_object_type = obj.object_type
       where (   obj.object_type != 'TYPE'
              or obj.object_name not like SYS_TYPE_REGEXP escape '\')
        and  regexp_like (obj.object_name, '[<>:"/\|?*]')
        and  obj.object_name not like RECYCLE_BIN_PATTERN escape '\'
        order by obj.object_owner, obj.object_name, obj.object_type)
   loop
      raise_application_error (-20000,
         'Found Forbidden Windows Filename Character in ' || buff.oname);
   end loop;
   -- Several Object Types have Sub-Object Types.
   --   Also this is not necessary for Linux.  It is only a problem for Windows
   for buff in (
      select obj.object_owner
            ,upper(obj.object_name)   object_name
            ,obj.object_type
            ,count(*)                 num_names
       from  dba_objects_tab  obj
       where obj.object_owner_build_type = in_build_type
        and  obj.object_type in (select otl.name_check_object_type from element_conf otl)
        and  (   obj.object_type != 'TYPE'
              or obj.object_name not like SYS_TYPE_REGEXP escape '\')
        and  obj.object_name not like RECYCLE_BIN_PATTERN escape '\'
       group by obj.object_owner, upper(obj.object_name), obj.object_type
       having count(*) > 1
       order by obj.object_owner, upper(obj.object_name), obj.object_type)
   loop
      raise_application_error (-20000,
         'Schema ' || buff.object_owner || ' has ' ||
                      buff.num_names    || ' ' ||
                      buff.object_type  || 's with a name like ' ||
                      buff.object_name  );
   end loop;
end check_windows_filenames;


-------------------------------------------
-- Refresh Data Tables
procedure update_view_tabs
is
   --
   procedure do_it (in_text varchar2) is
      dbi_beg_secs    number := dbms_utility.get_time;
   begin
      --dbms_output.put_line(in_text);
      execute immediate in_text;
      dbms_output.put_line('SUCCESS(' || to_char(SQL%ROWCOUNT,'B9999') ||
                          ' rows in ' || substr(to_char((dbms_utility.get_time -
                                                         dbi_beg_secs
                                                        )/100
                                                       ,'B99.9')
                                               ,2   -- Remove Leading space (sign is not needed)
                                               ,100) ||
                            ' sec): ' || substr(in_text,1,100)  );
   exception when others then
      raise_application_error (-20000, 'FAILED: ' || SQLERRM || CHR(10) ||
                                       substr(in_text,1,100) || CHR(10) ||
                                       dbms_utility.format_error_backtrace);
   end do_it;
   --
   procedure update_build_type_timing is
      dbi_beg_secs    number      := dbms_utility.get_time;
      num_rows        pls_integer := 0;
   begin
      for buff in (select build_type from build_conf)
      loop
         insert into build_type_timing (from_build_type, build_timing, to_build_type)
         with qcur as (
         select buff.build_type                  FROM_BUILD_TYPE
               ,'CURRENT'                        BUILD_TIMING
               ,t.build_type                     TO_BUILD_TYPE
          from  build_path  m
                join build_conf  t
                     on  t.build_seq = m.build_seq
          connect by prior m.parent_build_seq = m.build_seq
          start with t.build_type = buff.build_type
         ), qfut as (
         select buff.build_type                  FROM_BUILD_TYPE
               ,'FUTURE'                         BUILD_TIMING
               ,t.build_type                     TO_BUILD_TYPE
          from  build_path  m
                join build_conf  t
                     on  t.build_seq = m.parent_build_seq
          connect by m.parent_build_seq = prior m.build_seq
          start with t.build_type = buff.build_type
         )
         select FROM_BUILD_TYPE, BUILD_TIMING, TO_BUILD_TYPE from qcur
         UNION
         select FROM_BUILD_TYPE, BUILD_TIMING, TO_BUILD_TYPE from qfut
          where TO_BUILD_TYPE != buff.build_type
         UNION
         select buff.build_type       FROM_BUILD_TYPE
               ,'CURRENT'             BUILD_TIMING
               ,'sys'                 TO_BUILD_TYPE
          from  dual;
         num_rows := num_rows + SQL%ROWCOUNT;
      end loop;
      dbms_output.put_line('SUCCESS(' || to_char(num_rows,'B9999') ||
                          ' rows in ' || substr(to_char((dbms_utility.get_time -
                                                         dbi_beg_secs
                                                        )/100
                                                       ,'B99.9')
                                               ,2   -- Remove Leading space (sign is not needed)
                                               ,100) ||
                            ' sec): update_build_type_timing');
   exception when others then
      raise_application_error (-20000, 'update_build_type_timing FAILED: ' || SQLERRM);
   end update_build_type_timing;
   --
begin
   dbms_output.put_line('Running ' || $$PLSQL_UNIT || '.update_view_tabs');
   --
   dbms_output.put_line('');
   grab_scripts.set_installed_types;
   dbms_output.put_line('');
   --
   do_it('truncate table schema_objects_tab');
   do_it('truncate table obj_install_comments_tab');
   do_it('truncate table obj_install_trigger_tab');
   do_it('truncate table obj_install_synonym_tab');
   do_it('truncate table obj_install_data_load_tab');
   do_it('truncate table obj_install_index_tab');
   do_it('truncate table obj_install_fkey_tab');
   do_it('truncate table obj_install_context_tab');
   do_it('truncate table obj_install_object_tab');
   do_it('truncate table dba_dependencies_tab');
   do_it('truncate table dba_tab_privs_tab');
   do_it('truncate table dba_objects_tab');
   --
   do_it('truncate table build_type_timing');
   update_build_type_timing;
   --
   do_it('insert into dba_objects_tab           select * from dba_objects_view');
   do_it('insert into dba_tab_privs_tab         select * from dba_tab_privs_view');
   do_it('insert into dba_dependencies_tab      select * from dba_dependencies_view');
   do_it('insert into obj_install_object_tab    select * from obj_install_object_view');
   do_it('insert into obj_install_context_tab   select * from obj_install_context_view');
   do_it('insert into obj_install_fkey_tab      select * from obj_install_fkey_view');
   do_it('insert into obj_install_index_tab     select * from obj_install_index_view');
   do_it('insert into obj_install_data_load_tab select * from obj_install_data_load_view');
   do_it('insert into obj_install_synonym_tab   select * from obj_install_synonym_view');
   do_it('insert into obj_install_trigger_tab   select * from obj_install_trigger_view');
   do_it('insert into obj_install_comments_tab  select * from obj_install_comments_view');
   --
   -- DISTINCT is required instead of GROUP BY for Oracle Database
   --   23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free Version 23.4.0.24.05
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,    context_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_context_tab' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,      table_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_data_load_tab' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type, base_table_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_fkey_tab' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,      index_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_index_tab' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT             obj.build_type, obj.object_owner, obj.element_name  ' || CHR(10) ||
         ' from obj_install_object_tab  obj '                                               || CHR(10) ||
         '      join schema_conf  own '                                                     || CHR(10) ||
         '           on  own.username = obj.object_owner '                                  || CHR(10) ||
         '           and own.oracle_provided = ''N'' '                                      || CHR(10) ||  -- Exclude Oracle Provided objects
         ' where obj.object_type not in (''INDEX'', ''SYNONYM'', ''TRIGGER'')' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,    synonym_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_synonym_TAB' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,    trigger_owner,     element_name  ' || CHR(10) ||
         ' from obj_install_trigger_tab' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,          grantee,     element_name  ' || CHR(10) ||
         ' from priv_obj_dir_view' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,          grantee,     element_name  ' || CHR(10) ||
         ' from priv_obj_hacl_view' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,          grantee,     element_name  ' || CHR(10) ||
         ' from priv_obj_queue_view' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,          grantee,     element_name  ' || CHR(10) ||
         ' from priv_obj_wacl_view' );
   --
   do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
         'select DISTINCT                 build_type,          grantee,     element_name  ' || CHR(10) ||
         ' from priv_queue_sysprivs_view' );
   --
   if grab_scripts.installed_types_aa.EXISTS('grbras')
   then
      do_it('insert into schema_objects_tab (BUILD_TYPE,     OBJECT_OWNER,     ELEMENT_NAME) ' || CHR(10) ||
            'select DISTINCT                 build_type,            owner,     element_name  ' || CHR(10) ||
            ' from priv_obj_racl_view' );
   end if;
   --
   commit;
   --
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''DBA_OBJECTS_TAB'',           cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''DBA_TAB_PRIVS_TAB'',         cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''DBA_DEPENDENCIES_TAB'',      cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_OBJECT_TAB'',    cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_CONTEXT_TAB'',   cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_FKEY_TAB'',      cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_INDEX_TAB'',     cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_DATA_LOAD_TAB'', cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_SYNONYM_TAB'',   cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_TRIGGER_TAB'',   cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''OBJ_INSTALL_COMMENTS_TAB'',  cascade => TRUE); end;');
   do_it('begin sys.dbms_stats.gather_table_stats(ownname => ''ODBCAPTURE'', tabname => ''SCHEMA_OBJECTS_TAB'',        cascade => TRUE); end;');
   commit;
   --
   do_it('purge recyclebin');
   --
end update_view_tabs;


-------------------------------------------
-- Base64 Encoding
function b64_encode
      (in_blob     in BLOB
      ,in_add_hdr  in boolean default FALSE)
   return CLOB
is
   SPLIT_LEN   constant pls_integer  := 21843;    -- Must be divisible by 3
   l_clob               clob;
   len_blob             pls_integer;
   ptr                  pls_integer;
begin
   if in_blob is null then return null; end if;
   len_blob := length(in_blob);
   if len_blob = 0 then return empty_clob(); end if;
   dbms_lob.createtemporary(l_clob, true);
   if in_add_hdr
   then
      dbms_lob.append(l_clob, BASE64_ENCODE_HEADER || chr(10));
   end if;
   ptr := 1;
   while ptr <= len_blob
   loop
      dbms_lob.append(l_clob
                     ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(dbms_lob.substr(in_blob
                                                                                       ,SPLIT_LEN
                                                                                       ,ptr
                                                                       )               )
                     )                        );
      ptr := ptr + SPLIT_LEN;
   end loop;
   return l_clob || CHR(10);
end b64_encode;


end common_util;
/

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/FH2.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.FH2 Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.FH2

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."FH2" 
as

--
-- Table of Functions/Procedures
--
-- Script Handling Utilities
--  -) function script_is_open
--  -) PROCEDURE script_close_all
--  -) function script_open
--  -) procedure script_put
--  -) procedure script_put_line
--  -) PROCEDURE script_new_line
--  -) PROCEDURE script_close
--  -) procedure put_big_line
--  -) procedure remove_storage_clause
-- PUBLIC API
--  -) procedure write_scripts
--  -) procedure clear_buffers
--  -) function get_version
--


------------------------------------------------------------
---   Script Handling Utilities  ---
------------------------------------------------------------


-----------------------------------------------------
--  Check if a Script File is Open
function script_is_open
      (file   in fh2.sf_ptr_type)
   return boolean
is
begin
   return sf_aa.exists(file.bld_type)
      and sf_aa(file.bld_type).exists(file.bld_ord)
      and sf_aa(file.bld_type)(file.bld_ord).exists(file.file_id)
      and sf_aa(file.bld_type)(file.bld_ord)(file.file_id).is_open = 'Y';
end script_is_open;

-----------------------------------------------------
--  Close all Script Files
PROCEDURE script_close_all
is
   bld_ord   pls_integer;
   file_id    pls_integer;
begin
   if NOT sf_aa.EXISTS(grab_scripts.g_build_type)
   then
      return;
   end if;
   -- ELEMENT SEQ Loop
   bld_ord := sf_aa(grab_scripts.g_build_type).FIRST;
   <<DIR_LOOP>>
   loop
      -- File ID
      file_id := sf_aa(grab_scripts.g_build_type)(bld_ord).FIRST;
      <<FILE_LOOP>>
      loop
         --
         if sf_aa(grab_scripts.g_build_type)(bld_ord)(file_id).is_open = 'Y'
         then
            sf_aa(grab_scripts.g_build_type)(bld_ord)(file_id).is_open := 'N';
            dbms_output.put_line('SCRIPT_CLOSE_ALL: bld_type: ' || grab_scripts.g_build_type ||
                                                 ', bld_ord: '  || bld_ord ||
                                                 ', file_id: '   || file_id ||
                                                 ' was open.'    );
         end if;
         --
         exit FILE_LOOP when file_id = sf_aa(grab_scripts.g_build_type)(bld_ord).LAST;
         file_id := sf_aa(grab_scripts.g_build_type)(bld_ord).NEXT(file_id);
      end loop;  --FILE_LOOP
      --
      exit DIR_LOOP when bld_ord = sf_aa(grab_scripts.g_build_type).LAST;
      bld_ord := sf_aa(grab_scripts.g_build_type).NEXT(bld_ord);
   end loop;  --DIR_LOOP
end script_close_all;

-----------------------------------------------------
--  Open a Script File
function script_open
      (in_filename      in varchar2
      ,in_elmnt         in varchar2
      ,in_max_linesize  in binary_integer default 1024)
   return fh2.sf_ptr_type
is
   sf_ptr       fh2.sf_ptr_type;
   schema_name  varchar2(128);
   filename     varchar2(500);
   init_sf_aa   boolean;
   ----------------------------------------
   -- Find the ELEMENT SEQ for the in_elmnt
   procedure get_element_seq is
   begin
      sf_ptr.bld_ord := null;
      select element_seq into sf_ptr.bld_ord
       from  element_conf
       where element_name = in_elmnt;
   exception when OTHERS
   then
      script_close_all;
      raise_application_error(-20000, 'in_elmnt "' || in_elmnt ||
         '" not found in ELEMENT_CONF in script_open function' || LF ||
         SQLERRM);
   end get_element_seq;
   ----------------------------------------
   -- Find the File ID for the sf_ptr.bld_ord, and filename
   procedure get_file_id is
      file_id    pls_integer;
   begin
      -- Find Filename in Script File Array
      file_id := sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord).FIRST;
      loop
         if    (   sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord)(file_id).schema_name = schema_name
                OR (    sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord)(file_id).schema_name is null
                    AND                                                 schema_name is null) )
           AND sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord)(file_id).filename = filename
         then
            sf_ptr.file_id := file_id;
            if script_is_open(sf_ptr)
            then
               raise_application_error(-20000, 'Script Name: "' || grab_scripts.g_build_type ||
                                                            '/' || schema_name ||
                                                            '/' || filename ||
                                                   '" (ELMNT: ' || in_elmnt ||
                                            ') is already open.');
            end if;
            exit;
         end if;
         --
         exit when file_id = sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord).LAST;
         file_id := sf_aa(grab_scripts.g_build_type)(sf_ptr.bld_ord).NEXT(file_id);
      end loop;
   end get_file_id;
begin
   sf_ptr.bld_type := grab_scripts.g_build_type;
   -- Set the Schema Name
   schema_name := case when grab_scripts.g_schema_name is null    then NULL
                       when grab_scripts.g_schema_name = 'PUBLIC' then 'SYSTEM'
                                                                  else grab_scripts.g_schema_name
                  end;
   -- Get the ELEMENT SEQ to sf_ptr
   get_element_seq;
   -- Starting from Oracle Database release 19c, version 19.3, file names
   --   with the $ character will no longer run on Windows.
   if instr(in_filename,'$') != 0
   then
      --dbms_output.put_line('  Warning: Changed "$" to "_" in filename: ' || in_filename);
      raise_application_error(-20000,'File names with the $ character will no longer run on Windows: ' || in_filename);
   end if;
   -- Windows also has trouble with "%" in a script name
   --    https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/Database-Object-Names-and-Qualifiers.html
   --    Quoted identifiers can contain any characters and punctuations marks as well as spaces
   if instr(in_filename,'%') != 0
   then
      --dbms_output.put_line('  Warning: Changed "%" to "_" in filename: ' || in_filename);
      raise_application_error(-20000,'Windows also has trouble with "%" in a script name: ' || in_filename);
   end if;
   -- Set Filename
   --  (This "replace(replace(" has been moved to the calling procedure.)
   --  filename := replace(replace(in_filename,'$','_'),'%','_');
   filename := in_filename;
   dbms_output.put_line('Script Open: ' || grab_scripts.g_build_type ||
                                    '/' || schema_name    ||
                                    '/' || filename       );
   -- Find File ID
   sf_ptr.file_id := null;
   if     sf_aa.EXISTS(grab_scripts.g_build_type)
      AND sf_aa(grab_scripts.g_build_type).EXISTS(sf_ptr.bld_ord)
   then
      -- Get the File ID for sf_ptr
      get_file_id;
      if sf_ptr.file_id is not null
      then
         sf_ptr.num_lines := sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).num_buffers;
         init_sf_aa       := FALSE;
         sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).is_open := 'Y';
      else
         sf_ptr.file_id   := sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord).COUNT + 1;
         sf_ptr.num_lines := 1;
         init_sf_aa       := TRUE;
      end if;
   else
      sf_ptr.file_id   := 1;
      sf_ptr.num_lines := 1;
      init_sf_aa       := TRUE;
   end if;
   if init_sf_aa
   then
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).max_linesize := in_max_linesize;
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).total_bytes  := 0;
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).num_buffers  := 1;
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).is_open      := 'Y';
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).schema_name  := schema_name;
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).filename     := filename;
      sf_aa(sf_ptr.bld_type)(sf_ptr.bld_ord)(sf_ptr.file_id).buffer_aa(1).len := 0;
   end if;
   return sf_ptr;
end script_open;

-----------------------------------------------------
--  Add Characters to a Script File
procedure script_put
      (file       IN OUT NOCOPY fh2.sf_ptr_type
      ,buffer     IN            VARCHAR2)
is
   SEARCH_STRING CONSTANT varchar2(30) := '[^' || chr(1) || '-' || chr(127) || ']';
   len           number(5);
   ascii_buffer  varchar2(32767);
begin
   --
   if nvl(lengthb(buffer),0) <= 0
   then
      return;
   end if;
   ascii_buffer := regexp_replace(buffer, SEARCH_STRING, '?');
   len := length(ascii_buffer);
   --dbms_output.put_line('/'||file.bld_ord||'/'||file.file_id||'('||file.num_lines||')len='||len||
   --                     '('||sf_aa(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).len||')');
   --
   if sf_aa(file.bld_type)(file.bld_ord)(file.file_id).max_linesize >
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).len + len
   then
      --
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).buffer    :=
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).buffer || ascii_buffer;
      --
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).len   :=
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).len + len;
      --
   else
      --
      file.num_lines := file.num_lines + 1;
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).num_buffers := file.num_lines;
      --
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).buffer := ascii_buffer;
      sf_aa(file.bld_type)(file.bld_ord)(file.file_id).buffer_aa(file.num_lines).len    := len;
      --
   end if;
   --
   sf_aa(file.bld_type)(file.bld_ord)(file.file_id).total_bytes   :=
   sf_aa(file.bld_type)(file.bld_ord)(file.file_id).total_bytes + len;
   --
exception when others then
   raise_application_error(-20000,
      substr('script_put error: len = ' || len || LF ||
             '  sf_aa('||file.bld_type||')('||file.bld_ord||')('||file.file_id||').buffer_aa('||file.num_lines||').len = ' ||
                sf_aa(   file.bld_type   )(   file.bld_ord   )(   file.file_id   ).buffer_aa(   file.num_lines   ).len || LF ||
             '  sf_aa('||file.bld_type||')('||file.bld_ord||')('||file.file_id||').max_linesize = ' ||
                sf_aa(   file.bld_type   )(   file.bld_ord   )(   file.file_id   ).max_linesize || LF ||
              SQLERRM || LF || dbms_utility.format_error_backtrace || dbms_utility.format_call_stack ||
             '|' || ascii_buffer || '|'
             ,1,2000));
end script_put;

-----------------------------------------------------
--  Add a Line to a Script File
procedure script_put_line
      (file       IN OUT NOCOPY fh2.sf_ptr_type
      ,buffer     IN            VARCHAR2)
is
begin
   script_put(file, buffer || LF);
end script_put_line;

-----------------------------------------------------
--  Add a Line to a Script File
PROCEDURE script_new_line
      (file  IN OUT NOCOPY fh2.sf_ptr_type
      ,lines IN     NATURAL default 1)
is
   buff  varchar2(4000);
begin
   for i in 1 .. lines
   loop
      buff := buff || LF;
   end loop;
   script_put(file, buff);
end script_new_line;

-----------------------------------------------------
--  Close a Script File
PROCEDURE script_close
      (file   IN OUT NOCOPY fh2.sf_ptr_type)
is
begin
   sf_aa(file.bld_type)(file.bld_ord)(file.file_id).is_open := 'N';
end script_close;

------------------------------------------------------------
-- Put Big Line
--
procedure put_big_line
      (in_fh      in out NOCOPY fh2.sf_ptr_type
      ,in_loc     in            varchar2
      ,in_txt     in            CLOB
      ,in_max_len in            number)
is
   orig_len  number;         -- Original Length of IN_TXT
   ptr       number;         -- Current Position in IN_TXT
   ptr_len   number;         -- Length of IN_TXT from PTR, including PTR
   oset      number;         -- Candidate Offset from PTR
   oset_len   number;        -- Length of IN_TXT from PTR to OSET,
                             --   including PTR but excluding OSET
begin
   orig_len := DBMS_LOB.GETLENGTH(in_txt);
   oset := 0;
   loop
      -- Update PTR
      ptr     := oset + 1;
      ptr_len := orig_len - ptr + 1;
      -- Find a linefeed.
      oset := instr(in_txt, LF, ptr);
      -- Exit if no more LF and line is small enough.
      -- To process all LF, don't exit loop until here.
      exit when oset = 0 and ptr_len <= in_max_len;
      -- oset_len does not include LF
      oset_len := oset - ptr;
      -- Allow for empty line
      if oset_len between 0 and in_max_len
      then
         -- Small enough
         if substr(in_txt, oset-1, 1) = CRTN
         then
            -- Remove the CRTN and the LF.
            script_put_line(in_fh, substr(in_txt, ptr, oset_len-1));
         else
            script_put_line(in_fh, substr(in_txt, ptr, oset_len));
         end if;
      else
         -- Cut-off the line
         oset := in_max_len + ptr - 1;
         script_put_line(in_fh, substr(in_txt, ptr, in_max_len));
         script_put_line(in_fh, '---------- The previous line was cut-off at ' ||
                                in_max_len || ' characters.  ----------' );
         --raise_application_error
         --   (-20000, substr('Line too long, exceeds ' ||
         --                    in_max_len || ' characters at location "' ||
         --                    substr(in_loc, 1, 150) || '"' || LF ||
         --                    substr(in_txt, ptr)
         --                  ,1,2000) );
      end if;
   end loop;
   -- IN_TXT remaining is shorter than IN_MAX_LEN
  script_put_line(in_fh, substr(in_txt, ptr));
end put_big_line;

------------------------------------------------------------
-- Remove STORAGE_CLAUSE_PATTERN
procedure remove_storage_clause
      (in_fh       in out NOCOPY fh2.sf_ptr_type
      ,in_loc      in            varchar2
      ,in_txt      in            CLOB
      ,in_max_len  in            number)
is
   len     number := length(in_txt);
   ptr     number := 1;               -- Current Position in IN_TXT
   oset    number;                    -- Offset from PTR to next LF
begin
   while ptr <= len
   loop
      oset := instr(substr(in_txt, ptr),LF);
      if oset = 0
      then
         put_big_line(in_fh, in_loc, substr(in_txt, ptr), in_max_len);
         ptr := len + 1;
      else
         if substr(in_txt, ptr, oset-1) not like common_util.STORAGE_CLAUSE_PATTERN escape '\'
         then
            put_big_line(in_fh, in_loc, substr(in_txt, ptr, oset-1), in_max_len);
         end if;
      end if;
      ptr := ptr + oset;
   end loop;
end remove_storage_clause;


------------------------------------------------------------
---   PUBLIC API  ---
------------------------------------------------------------


------------------------------------------------------------
-- Write Scripts
procedure write_scripts
      (in_zip_file_name  in varchar2
      ,in_folder_name    in varchar2 default '')
is
   FH_BUFFER_SIZE  CONSTANT pls_integer := 32767;
   fh              UTL_FILE.FILE_TYPE;
   fh_ptr          pls_integer;
   bld_type       varchar2(10);
   bld_ord        pls_integer;
   file_id         pls_integer;
   schema_name     varchar2(128);
   dir_path        varchar2(256);
   filename        varchar2(500);
   root_dir_name   varchar2(128);
   zip_file_size   pls_integer;
   sql_txt         varchar2(4000);
   root_dir_path   varchar2(128);
   buffer_blob     BLOB;
   zipped_blob     BLOB;
begin
   dbms_output.put_line('Running ' || $$PLSQL_UNIT || '.write_scripts' ||
                             '(in_zip_file_name "' || in_zip_file_name ||
                           '", in_folder_name "'   || in_folder_name   || '")' );
   if in_zip_file_name is null
   then
      raise_application_error(-20000, 'No Zip File Specified');
   end if;
   if NOT sf_aa.COUNT > 0
   then
      raise_application_error(-20000, 'No files to write from Buffers: ' || sf_aa.COUNT);
   end if;
   ----------------------------------------------
   -- Write Scripts from sf_aa to ZIP_FILES Table
   -- Build Type Loop
   bld_type := sf_aa.FIRST;
   <<TYPE_LOOP1>>
   loop
      -- ELEMENT SEQ Loop
      bld_ord := sf_aa(bld_type).FIRST;
      <<ORD_LOOP1>>
      loop
         --
         -- File ID Loop
         file_id := sf_aa(bld_type)(bld_ord).FIRST;
         <<FILE_LOOP1>>
         loop
            --
            schema_name := sf_aa(bld_type)(bld_ord)(file_id).schema_name;
            dir_path    := bld_type;
            if schema_name is not null
            then
               dir_path := dir_path || '/' || schema_name;
            end if;
            filename    := sf_aa(bld_type)(bld_ord)(file_id).filename;
            if sf_aa(bld_type)(bld_ord)(file_id).is_open != 'N'
            then
               DBMS_OUTPUT.PUT_LINE('WARNING: ' || dir_path ||
                                            '/' || filename || ' was not closed');
            end if;
            --
            dbms_output.put(dir_path || '/' || filename ||
                           ' total_bytes: ' || sf_aa(bld_type)(bld_ord)(file_id).total_bytes);
            DBMS_LOB.CREATETEMPORARY(buffer_blob, FALSE);
            --
            -- BUFFER_LOOP
            for i in 1 .. sf_aa(bld_type)(bld_ord)(file_id).num_buffers
            loop
               DBMS_LOB.APPEND(buffer_blob
                              ,UTL_RAW.CAST_TO_RAW(sf_aa(bld_type)(bld_ord)(file_id).buffer_aa(i).buffer));
               dbms_output.put(', ' || i || ':' || sf_aa(bld_type)(bld_ord)(file_id).buffer_aa(i).len);
            end loop;  --BUFFER_LOOP
            dbms_output.put_line('.');
            --
            --  There should not be any leading "/" in "dir_path"
            --     ("bld_type" cannot be NULL because Associative Array Indexes cannot be NULL)
            zip_util_pkg.add_file(zipped_blob
                                 ,dir_path || '/' || filename
                                 ,buffer_blob);
            DBMS_LOB.TRIM(buffer_blob, 0);
            --
            exit FILE_LOOP1 when file_id = sf_aa(bld_type)(bld_ord).LAST;
            file_id := sf_aa(bld_type)(bld_ord).NEXT(file_id);
         end loop;  --FILE_LOOP1
         --
         exit ORD_LOOP1 when bld_ord = sf_aa(bld_type).LAST;
         bld_ord := sf_aa(bld_type).NEXT(bld_ord);
      end loop;  --ORD_LOOP1
      --
      exit TYPE_LOOP1 when bld_type = sf_aa.LAST;
      bld_type := sf_aa.NEXT(bld_type);
   end loop;  --TYPE_LOOP1
   --
   zip_util_pkg.finish_zip(zipped_blob);
   insert into zip_files
         (file_name
         ,file_size
         ,file_blob)
      values
         (in_zip_file_name
         ,DBMS_LOB.GETLENGTH(zipped_blob)
         ,zipped_blob);
   commit;
   if length(in_folder_name) > 0
   then
      ---------------------------------------
      -- Write Zip File to UTL_FILE
      select zf.file_size
       into  zip_file_size
       from  zip_files  zf
       where zf.file_name = in_zip_file_name;
      begin
         select dir.directory_name, dir.directory_path
          into      root_dir_name ,     root_dir_path
          from  dba_directories  dir
          where dir.directory_path = in_folder_name;
      exception
         when NO_DATA_FOUND
         then
            root_dir_name := 'GRAB_SCRIPTS_DIR';
            root_dir_path := in_folder_name;
            execute immediate 'create directory "' || root_dir_name ||
                              '" as ''' || root_dir_path || '''';
         when others
         then
            raise_application_error(-20000, 'Error with DIRECTORY_PATH: ' ||
                                            in_folder_name || '. ' || SQLERRM);
            DBMS_LOB.TRIM(zipped_blob, 0);
      end;
      dbms_output.put_line('Writing file "' || in_zip_file_name ||
                            '" to folder "' || root_dir_path    || '"');
      fh := utl_file.fopen(location     => root_dir_name
                          ,filename     => in_zip_file_name
                          ,open_mode    => 'wb'
                          ,max_linesize => FH_BUFFER_SIZE);
      fh_ptr := 1;
      while fh_ptr <= zip_file_size
      loop
         utl_file.put_raw(fh, dbms_lob.substr(zipped_blob, FH_BUFFER_SIZE, fh_ptr), TRUE);
         fh_ptr := fh_ptr + FH_BUFFER_SIZE;
      end loop;
      utl_file.fflush(fh);
      utl_file.fclose(fh);
   end if;
   --
   DBMS_LOB.TRIM(zipped_blob, 0);
end write_scripts;


------------------------------------------------------------
-- Report File Contents from Memory Array
procedure show_file
      (in_bld_type  in  varchar2
      ,in_element   in  varchar2)
is
   bld_ord        pls_integer;
   file_id         pls_integer;
begin
   select element_seq into bld_ord from element_conf
    where element_name = in_element;
   file_id := sf_aa(in_bld_type)(bld_ord).FIRST;
   dbms_output.put_line('FNAME: ' || sf_aa(in_bld_type)(bld_ord)(file_id).filename);
   loop
      for i in 1 .. sf_aa(in_bld_type)(bld_ord)(file_id).num_buffers
      loop
         dbms_output.put_line(sf_aa(in_bld_type)(bld_ord)(file_id).buffer_aa(i).buffer);
      end loop;
      exit when file_id = sf_aa(in_bld_type)(bld_ord).LAST;
      file_id := sf_aa(in_bld_type)(bld_ord).NEXT(file_id);
   end loop;
end show_file;


------------------------------------------------------------
-- Clear Buffers
procedure clear_buffers
      (in_build_type  in varchar2 default null)
is
begin
   if in_build_type is null
   then
      sf_aa.DELETE;
   else
      sf_aa(in_build_type).DELETE;
   end if;
end clear_buffers;


end fh2;
/

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/GRAB_SCRIPTS.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_SCRIPTS Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_SCRIPTS

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."GRAB_SCRIPTS" 
as

--
-- Table of Functions/Procedures
--
-- Script Generating Procedures
--  -) procedure grb_object_grants       - Create Object Based Grant
--  -) procedure grb_future_sys_grants   - Create "Delayed" 'SYS' Object Grants
--  -) procedure grb_future_grants       - Create Future Grants
--  -) procedure grb_object_synonyms     - Create Object Based Synonym
--  -) procedure grb_future_synonyms     - Create Future Synonym
--  -) procedure grb_advanced_queues     - Create Advanced Queue
--  -) procedure grb_aq_tables           - Create Advanced Queue Table
--  -) procedure grb_application_context - Create Context
--  -) procedure grb_ras_acls            - Create Real Application Security ACLs
--  -) procedure grb_host_acls           - Create Host ACLs
--  -) procedure grb_wallet_acls         - Create Wallet ACLs
--  -) procedure grb_common
--     -) Create FUNCTION
--     -) Create PACKAGE_BODY
--     -) Create PACKAGE_SPEC
--     -) Create PROCEDURE
--     -) Create SCHEDULER_JOB
--     -) Create SCHEDULER_PROGRAM
--     -) Create SCHEDULER_SCHEDULE
--     -) Create SEQUENCE
--     -) Create TYPE_BODY
--     -) Create TYPE_SPEC
--  -) procedure grb_comp_data_loader    - Create Comprehensive Data Loader
--  -) procedure grb_database_links      - Create Database Link
--  -) procedure grb_database_triggers   - Create Database Trigger
--  -) procedure grb_directories         - Create Directory
--  -) procedure grb_foreign_keys        - Create Foreign Key
--  -) procedure grb_indexes             - Create Index
--  -) procedure grb_install_master      - Create Master Call Script
--  -) procedure grb_install_schemas     - Create Schema/Owner Call Script
--  -) procedure grb_install_sys         - Create SYS Call Script
--  -) procedure grb_install_system      - Create SYSTEM Call Script
--  -) procedure grb_materialized_views  - Create Materialized View
--  -) procedure grb_plsql_java          - Create PL/SQL Java Source
--  -) procedure grb_roles               - Create Role and 'SYS' Object Grants
--  -) procedure grb_tables              - Create Table
--  -) procedure grb_triggers            - Create Table/View Trigger
--  -) procedure grb_users               - Create User and 'SYS' Object Grants
--  -) procedure grb_user_triggers     - Create Schema Trigger
--  -) procedure grb_views               - Create View
-- Setup and Main Control
--  -) procedure initialize
--  -) procedure set_schema_name
--  -) procedure gen_installs
--  -) procedure gen_schemas
-- PUBLIC API
--  -) procedure all_scripts
--  -) function get_version
--


------------------------------------------------------------
---   Script Generating Procedures  ---
------------------------------------------------------------


------------------------------------------------------------
-- Get Object Grants for CURRENT, FUTURE is handled in grb_grnt
procedure grb_object_grants
      (in_fh           in out NOCOPY fh2.sf_ptr_type
      ,in_object_name  in            varchar2
      ,in_object_type  in            varchar2)
is
   --
   -- Oracle Database 12c Release 1 Database SQL Language Reference
   -- "on_object_clause"
   -- Users, directory schema objects, editions, data mining models, Java
   --   source and resource schema objects, and SQL translation profiles
   --   are identified separately because they reside in separate namespaces.
   --
   --  See Also: http://docs.oracle.com/database/121/SQLRF/sql_elements008.htm#SQLRF51129
   --
   --  "USER" Object Type not yet implemented.
   --
   sql_txt   varchar2(32767);
begin
   fh2.script_put_line(in_fh, '');
   fh2.script_put_line(in_fh, '--  Grants');
--   DBMS_METADATA.get_dependent_dll('OBJECT_GRANT') is VERY SLOW
--   fh2.script_put_line(in_fh, '--DBMS_METADATA:' || g_schema_name ||
--                                             '.' || in_object_name );
--   fh2.put_big_line(in_fh, dbms_metadata.get_dependent_ddl(object_type        => 'OBJECT_GRANT'
--                                                          ,base_object_name   => in_object_name
--                                                          ,base_object_schema => g_schema_name)  );
--   Note: EXECPTION BLOCK BELOW
   for buff in (select grantee
                      ,privilege
                      ,object_type
                      ,max(grantable)               GRANTABLE
                 from  priv_obj_install_vw   -- Includes PUBLIC Grantee, Does not Include SYS Owned Objects
                 where build_type   = g_build_type
                  and  build_timing = 'CURRENT'     -- Grantee installed before this Object
                  and  object_owner = g_schema_name
                  and  object_name  = in_object_name
                  and  object_type  = in_object_type
                 group by grantee
                      ,privilege
                      ,object_type
                 order by grantee
                      ,privilege
                      ,object_type)
   loop
      -- Directories are handled by "grb_directories"
      --when 'DIRECTORY'               then 'DIRECTORY '
      -- Grants are not implemented in ELEMENT_CONF
      -- https://docs.oracle.com/database/121/SQLRF/statements_9014.htm#SQLRF01603
      --when '(Data Mining) MODEL'     then 'MINING MODEL '
      --when 'SQL TRANSLATION PROFILE' then 'SQL TRANSLATION PROFILE '
      sql_txt := 'grant ' || buff.privilege ||     -- Taken from DBA_TAB_PRIVS SQL definition
                   ' on ' || case buff.object_type when 'JAVA CLASS'    then 'JAVA SOURCE "'   || g_schema_name  || '"."'
                                                   when 'JAVA SOURCE'   then 'JAVA SOURCE "'   || g_schema_name  || '"."'
                                                   when 'JAVA RESOURCE' then 'JAVA RESOURCE "' || g_schema_name  || '"."'
                                                   when 'EDITION'       then 'EDITION "'
                                                   when 'USER'          then 'USER "'
                                                                        else '"'               || g_schema_name  || '"."'
                             end                                                               || in_object_name ||
                 '" to "' || buff.grantee   || '"';
      -- Missing "with hierarchy option"...
      if buff.grantable = 'YES'
      then
         sql_txt := sql_txt || ' with grant option';
      end if;
     fh2.script_put_line(in_fh, sql_txt || ';');
   end loop;
   fh2.script_put_line(in_fh, '');
--exception
--   when DBMS_METADATA.object_not_found2
--   then
--      fh2.script_put_line(in_fh, '');
end grb_object_grants;

------------------------------------------------------------
-- Create Future SYS Grants
procedure grb_future_sys_grants
is
   ELMNT            CONSTANT varchar2(100) := 'SYS_GRANT';
   fh               fh2.sf_ptr_type;           -- object script file handle
   header_printed   boolean;
   sql_txt          varchar2(32767);
begin
   for buf1 in (with q1 as (
                select username                        GRANTEE
                      ,'_usr.'                         FILE_SUFFIX
                 from  schema_conf
                 where oracle_provided = 'N'
                UNION ALL
                select rolename                        GRANTEE
                      ,'_rol.'                         FILE_SUFFIX
                 from  role_conf
                       join element_conf  ec
                            on  ec.element_name = ELMNT
                 where oracle_provided = 'N'
                )
                select q1.grantee
                      ,replace(replace(q1.grantee,'$','_'),'%','_') ||
                       q1.file_suffix || ec.file_ext1  FILE_NAME
                 from  q1
                       join element_conf  ec
                            on  ec.element_name = ELMNT
                 order by q1.grantee)
   loop
      header_printed := FALSE;
      for buf2 in (select p1.object_owner
                         ,p1.object_name
                         ,p1.object_type
                         ,p1.privilege
                         ,max(p1.grantable)              GRANTABLE
                    from  priv_sysobj_privileges_view  p1
                    where p1.build_type   = g_build_type
                     and  p1.grantee      = buf1.grantee
                     and  p1.build_timing = 'FUTURE'
                     and  p1.object_type != 'DIRECTORY' -- All directories are owned by SYS
                          -- Keep LCR$ Logical Change Record
                          -- Keep AQ$ Queue Tables and Views
                          -- SYS_PLSQL Pipelined Type Objects are recreated automatically
                     and  p1.object_name  not like common_util.SYS_PIPELINE_PATTERN   escape '\'
                          -- Skip QT*_BUFFER Queue Views here. Grant Views with Advanced Queue
                          --   https://blogs.oracle.com/db/entry/oracle_support_master_note_for_troubleshooting_advanced_queuing_and_oracle_streams_propagation_issue
                          --   "Note that when queue table is created, a view called QT<nnn>_BUFFER is created in the SYS schema, and the queue table owner is given
                          --    SELECT privileges on it. The <nnn> corresponds to the object_id of the associated queue table"
                     and  p1.object_name  not like common_util.ADV_QUEUE_VIEW_PATTERN escape '\'
                    group by p1.object_owner
                         ,p1.object_name
                         ,p1.object_type
                         ,p1.privilege
                    order by p1.object_owner
                         ,p1.object_name
                         ,p1.object_type
                         ,p1.privilege)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => buf1.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_sysgrants_file_header(fh);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  "SYS" Object Grants');
            fh2.script_put_line(fh, '');
         end if;
         -- No appropriate DBMS_METADATA. Manually create the SQL.
         --
         --  These "types" don't require a grant quailifier:
         --    -) FUNCTION
         --    -) INDEXTYPE
         --    -) LIBRARY
         --    -) MATERIALIZED VIEW
         --    -) OPERATOR
         --    -) PACKAGE
         --    -) PROCEDURE
         --    -) SEQUENCE
         --    -) TABLE
         --    -) TYPE
         --    -) VIEW
         --
         --  Other forms (and "types") include:
         --    -) ON DIRECTORY (DIRECTORY)         - Handled in "grb_directories"
         --    -) ON USER (USER)                   - Handled HERE and in "grb_object_grants"
         --    -) ON EDITION (EDITION)             - Handled HERE and in "grb_object_grants"
         --    -) ON JAVA SOURCE (JAVA CLASS)      - Handled HERE and in "grb_object_grants" and "grb_plsql_java"
         --    -) ON JAVA RESOURCE (JAVA RESOURCE) - Handled HERE and in "grb_object_grants"
         --    -) ON MINING MODEL (MLE LANGUAGE?)  - Not Handled
         --    -) ON SQL TRANSLATION PROFILE (???) - Not Handled
         --
         sql_txt := 'grant ' || buf2.privilege ||
                      ' on ' || case buf2.object_type when 'JAVA CLASS'    then 'JAVA SOURCE "'   || buf2.object_owner || '"."'
                                                      when 'JAVA SOURCE'   then 'JAVA SOURCE "'   || buf2.object_owner || '"."'
                                                      when 'JAVA RESOURCE' then 'JAVA RESOURCE "' || buf2.object_owner || '"."'
                                                      when 'EDITION'       then 'EDITION "'
                                                      when 'USER'          then 'USER "'
                                                                           else '"'               || buf2.object_owner || '"."'
                                end                                                               || buf2.object_name  ||
                    '" to "' || buf1.grantee || '"';
         -- Missing "with hierarchy option" ...
         if buf2.grantable = 'YES'
         then
            sql_txt := sql_txt || ' with grant option';
         end if;
         fh2.put_big_line(fh, buf2.object_owner || '"."' || buf2.object_name ||
                         ' Grant', sql_txt || ';'
                         ,common_util.MAXIMUM_SQL_LENGTH);
      end loop;
      --
      if installed_types_aa.EXISTS('grbjava')
      then
         sql_txt := 'begin GRAB_JAVA.GRB_SYSGRNT(:1, ''' || buf1.grantee   ||
                                               ''', ''' || buf1.file_name ||
                                               ''', ''' || ELMNT          ||
                                               ''', ''FUTURE''); end;';
         begin
            execute immediate sql_txt using in out fh;
         exception when others then
            if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_JAVA.GRB_SYSGRNT'' must be declared')
            then
               raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                SQL_TXT                  || CHR(10) ||
                                                SQLERRM                  || CHR(10) ||
                                                dbms_utility.format_error_backtrace );
            end if;
         end;
      end if;
      --
      if fh2.script_is_open(fh)
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define on');
         fh2.script_put_line(fh, '');
         fh2.script_close(fh);
      end if;
   end loop;
end grb_future_sys_grants;

------------------------------------------------------------
-- Create FUTURE Grants
procedure grb_future_grants
is
   ELMNT                  CONSTANT varchar2(100) := 'GRANT';
   fh                     fh2.sf_ptr_type;  -- object script file handle
   sql_txt                varchar2(32767);
   default_build_type   build_conf.build_type%TYPE;
   header_printed   boolean;
begin
   for gtee in (with q1 as (
                select username                        GRANTEE
                      ,'_usr.'                         FILE_SUFFIX
                 from  schema_conf
                 where oracle_provided = 'N'
                UNION ALL
                select rolename                        GRANTEE
                      ,'_rol.'                         FILE_SUFFIX
                 from  role_conf
                       join element_conf  ec
                            on  ec.element_name = ELMNT
                 where oracle_provided = 'N'
                )
                select q1.grantee
                      ,replace(replace(q1.grantee,'$','_'),'%','_') ||
                       q1.file_suffix || ec.file_ext1  FILE_NAME
                 from  q1
                       join element_conf  ec
                            on  ec.element_name = ELMNT
                 order by q1.grantee)
   loop
      header_printed := FALSE;
      -- Cant use DBMS_METADATA because some Privileges may be delayed
      --script_put_line(fh, '--DBMS_METADATA:' || gtee.grantee);
      --BEGIN
      --   fh2.put_big_line(fh, ELMNT || ' ' || gtee.grantee || ' FUTURE Grants'
      --                   ,dbms_metadata.get_granted_ddl(object_type => 'SYSTEM_GRANT'
      --                                                 ,grantee     => gtee.grantee)
      --                   ,common_util.MAXIMUM_SQL_LENGTH);
      --EXCEPTION
      --   WHEN DBMS_METADATA.object_not_found2
      --   THEN
      --      null;
      --END;
      for syspriv in (select system_privilege_name
                       from  priv_system_privileges_view
                       where build_type = g_build_type
                     -- Either CURRENT or FUTURE is OK for non-object privileges
                     -- and  build_timing in ('CURRENT','FUTURE')
                        and  grantee    = gtee.grantee
                       order by system_privilege_name)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  Database System Privileges');
            fh2.script_put_line(fh, '');
         end if;
         fh2.script_put_line(fh, 'grant ' || syspriv.system_privilege_name || ' to "' || gtee.grantee || '";');
      end loop;
      header_printed := FALSE;
      --  DBMS_METADATA grants all roles.
      --script_put_line(fh, '--DBMS_METADATA:' || gtee.grantee);
      --fh2.put_big_line(fh, ELMNT || ' ' || gtee.grantee || ' FUTURE Grants'
      --                ,dbms_metadata.get_granted_ddl(object_type => 'ROLE_GRANT'
      --                                              ,grantee     => gtee.grantee));
      for rol in (select rolename
                        ,delegate_option
                        ,admin_option
                   from  priv_role_privileges_view
                   where build_type = g_build_type
                 -- Either CURRENT or FUTURE is OK for non-object privileges
                 -- and  build_timing in ('CURRENT','FUTURE')
                    and  grantee    = gtee.grantee
                   order by rolename)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  "sys" BUILD_TYPE Role Grants');
            fh2.script_put_line(fh, '--  "GRANTEE" (delayed) Role Grants');
            fh2.script_put_line(fh, '--  Note: "OBJECT" Schema Object Grants are given during Role creation');
            fh2.script_put_line(fh, '');
         end if;
         -- Missing "with hierarchy option" ...
         case
            when rol.admin_option = 'YES'
            then
               fh2.script_put_line(fh, 'grant "' || rol.rolename || '" to "' || gtee.grantee || '" with admin option;');
            when rol.delegate_option = 'YES'
            then
               fh2.script_put_line(fh, 'grant "' || rol.rolename || '" to "' || gtee.grantee || '" with delegate option;');
            else
               fh2.script_put_line(fh, 'grant "' || rol.rolename || '" to "' || gtee.grantee || '";');
         end case;
      end loop;
      header_printed := FALSE;
      for sobj in (select object_owner                TABLE_OWNER
                         ,object_name                 TABLE_NAME
                         ,privilege
                         ,max(grantable)              GRANTABLE
                    from  priv_obj_install_vw   -- Includes PUBLIC Grantee, Does not Include SYS Owned Objects
                    where object_build_type = g_build_type
                     and  build_timing      = 'FUTURE'  -- Grant delayed for this Grantee
                     and  grantee           = gtee.grantee
                     and  privilege    not in ('ENQUEUE','DEQUEUE')
                    group by object_owner
                         ,object_name
                         ,privilege
                    order by object_owner
                         ,object_name
                         ,privilege)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  "sys" BUILD_TYPE Schema Object Grants, excluding SYS objects');
            fh2.script_put_line(fh, '--  "GRANTEE" (delayed) Schema Object Grants');
            fh2.script_put_line(fh, '--  Note: "OBJECT" Schema Object Grants are given during object creation');
            fh2.script_put_line(fh, '');
         end if;
         -- No appropriate DBMS_METADATA.  Manually create the SQL.
         sql_txt := 'grant ' || sobj.privilege   ||
                     ' on "' || sobj.table_owner || '"."' || sobj.table_name || '"' ||
                     ' to "' || gtee.grantee     || '"';
         -- Missing "with hierarchy option" ...
         if sobj.grantable = 'YES'
         then
            sql_txt := sql_txt || ' with grant option';
         end if;
         fh2.script_put_line(fh, sql_txt || ';');
      end loop;
      header_printed := FALSE;
      for qspv in (select grant_name                  DBMS_AQ_PRIV
                    from  priv_queue_sysprivs_view
                    where build_type = g_build_type
                  -- Either CURRENT or FUTURE is OK for non-object privileges
                  -- and  build_timing in ('CURRENT','FUTURE')
                     and  grantee    = gtee.grantee
                    order by dbms_aq_priv)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  Advanced Queue System Privileges');
            fh2.script_put_line(fh, '');
         end if;
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.grant_system_privilege(');
         fh2.script_put_line(fh, '      privilege    => ''' || qspv.DBMS_AQ_PRIV || ''', ');
         fh2.script_put_line(fh, '      grantee      => ''' || gtee.grantee      || ''', ');
         fh2.script_put_line(fh, '      admin_option =>  FALSE);');
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
      end loop;
      header_printed := FALSE;
      for cque in (select queue_owner
                         ,queue_name
                         ,privilege
                         ,max(grantable)              GRANTABLE
                    from  priv_obj_queue_view
                    where build_type   = g_build_type
                     and  build_timing = 'FUTURE'   -- Grant delayed for this Grantee
                     and  grantee      = gtee.grantee
                    group by queue_owner
                         ,queue_name
                         ,privilege)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  Advanced Queue Grants');
            fh2.script_put_line(fh, '--  "GRANTEE" (Delayed) Advanced Queue Grants');
            fh2.script_put_line(fh, '--  Note: "QUEUE" Advanced Queue Grants are given during object creation');
            fh2.script_put_line(fh, '');
         end if;
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.grant_queue_privilege');
         fh2.script_put_line(fh, '      (privilege    => '''  || cque.privilege    || ''''  );
         fh2.script_put_line(fh, '      ,queue_name   => ''"' || cque.queue_owner || '"."' ||
                                                                 cque.queue_name  || '"''' );
         fh2.script_put_line(fh, '      ,grantee      => '''  || gtee.grantee      || ''''  );
         if cque.grantable = 'YES'
         then
            fh2.script_put_line(fh, '      ,grant_option => TRUE);');
         else
            fh2.script_put_line(fh, '      ,grant_option => FALSE);');
         end if;
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
      end loop;
      header_printed := FALSE;
      for pqsv in (
         select queue_owner     -- Owner of the queue
               ,queue_name      -- Name of the queue
               ,consumer_name   -- Name of the subscriber
               ,address         -- Address of the subscriber
               ,protocol        -- Protocol of the subscriber
               ,rule            -- Rule condition for the subscriber
               ,transformation  -- Transformation for the subscriber
               ,queue_to_queue  -- Is subscriber is a queue-to-queue subscriber?
               ,delivery_mode   -- Message delivery mode: PERSISTENT, BUFFERED, or PERSISTENT_OR_BUFFERED
          from  priv_queue_subscribe_view
          where build_type          = g_build_type
           and  build_type_selector = 'GRANTEE'
           and  consumer_name       = gtee.grantee
          order by queue_owner
               ,queue_name
               ,consumer_name)
      loop
         if NOT fh2.script_is_open(fh)
         then
            fh := fh2.script_open(in_filename     => gtee.file_name
                                 ,in_elmnt        => ELMNT
                                 ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
            common_util.add_grants_file_header(fh         => fh
                                              ,in_grantee => gtee.grantee);
         end if;
         if NOT header_printed
         then
            header_printed := TRUE;
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, '--  Advanced Queue Subscriptions');
            fh2.script_put_line(fh, '--  "GRANTEE" (Delayed) Advanced Queue Subscription');
            fh2.script_put_line(fh, '--  Note: "QUEUE" Advanced Queue Subscriptions are given during object creation');
            fh2.script_put_line(fh, '');
         end if;
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.add_subscriber');
         fh2.script_put_line(fh, '      (queue_name     => ''' || pqsv.queue_owner ||
                                                           '.' || pqsv.queue_name  || '''');
         fh2.script_put_line(fh, '      ,subscriber     => sys.aq$_agent');
         fh2.script_put_line(fh, '                            (name     => ''' || pqsv.consumer_name || '''');
         fh2.script_put_line(fh, '                            ,address  => ''' || pqsv.address       || '''');
         fh2.script_put_line(fh, '                            ,protocol => '   || pqsv.protocol      || ')');
         fh2.script_put_line(fh, '      ,rule           => ''' || pqsv.rule           || '''');
         fh2.script_put_line(fh, '      ,transformation => ''' || pqsv.transformation || '''');
         fh2.script_put_line(fh, '      ,queue_to_queue => '   || pqsv.queue_to_queue );
         fh2.script_put_line(fh, '      ,delivery_mode  => DBMS_AQADM.' || pqsv.delivery_mode || ');');
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
         fh2.script_put_line(fh, '');
      end loop;
      if installed_types_aa.EXISTS('grbjava')
      then
         sql_txt := 'begin GRAB_JAVA.GRB_GRNT(:1, ''' || gtee.grantee   ||
                                            ''', ''' || gtee.file_name ||
                                            ''', ''' || ELMNT          ||
                                            '''); end;';
         begin
            execute immediate sql_txt using in out fh;
         exception when others then
            if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_JAVA.GRB_GRNT'' must be declared')
            then
               raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                SQL_TXT                  || CHR(10) ||
                                                SQLERRM                  || CHR(10) ||
                                                dbms_utility.format_error_backtrace );
            end if;
         end;
      end if;
      if fh2.script_is_open(fh)
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define on');
         fh2.script_put_line(fh, '');
         fh2.script_close(fh);
      end if;
   END LOOP;
end grb_future_grants;

------------------------------------------------------------
-- Get CURRENT synonyms. FUTURE synonyms are handled in grb_future_synonyms
procedure grb_object_synonyms
      (in_fh             in out NOCOPY fh2.sf_ptr_type
      ,in_object_name    in            varchar2
      ,in_object_type    in            varchar2
      ,in_max_len        in            number)
is
begin
   fh2.script_put_line(in_fh, '');
   fh2.script_put_line(in_fh, '--  Synonyms');
   for buff in (select synonym_owner, synonym_name
                 from  obj_install_synonym_tab
                 where build_type          = g_build_type
                  and  build_type_selector = 'SYNONYM'       -- Target installed before this Synonym
                  and  target_owner        = g_schema_name
                  and  target_name         = in_object_name
                  and  target_type         = in_object_type
                 order by synonym_owner, synonym_name)
   loop
      fh2.script_put_line(in_fh, '');
      fh2.script_put_line(in_fh, '--DBMS_METADATA:' || buff.synonym_owner ||
                                                '.' || buff.synonym_name );
      -- Includes DB_LINK in Synonym
      fh2.put_big_line(in_fh, buff.synonym_owner || '.' || buff.synonym_name || ' Synonym'
                      ,dbms_metadata.get_ddl(object_type => 'SYNONYM'
                                            ,name        => buff.synonym_name
                                            ,schema      => buff.synonym_owner)
                      ,in_max_len);
   end loop;
   fh2.script_put_line(in_fh, '');
end grb_object_synonyms;

------------------------------------------------------------
-- Create Synonym
procedure grb_future_synonyms
is
   ELMNT    CONSTANT varchar2(100) := 'SYNONYM';
   fh       fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in
      (select synonym_name
             ,file_ext1
        from  obj_install_synonym_tab
        where build_type          = g_build_type
         and  build_type_selector = 'TARGET'      -- Synonym install delayed for this Target
         and  synonym_owner       = g_schema_name
        group by synonym_name, file_ext1
        order by synonym_name )
   loop
      if NOT fh2.script_is_open(fh)
      then
         fh := fh2.script_open(in_filename     => replace(replace(g_schema_name,'$','_'),'%','_') || '.' || buf1.file_ext1
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create ' || g_schema_name || ' Synonyms');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Synonyms from objects owned by "sys" Build Type Schema');
         fh2.script_put_line(fh, '--  Also, synonyms delayed waiting for target installation.');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buf1.synonym_name);
      -- Includes DB_LINK in Synonym
      fh2.put_big_line(fh, g_schema_name || '.' || buf1.synonym_name || ' Synonym'
                      ,dbms_metadata.get_ddl(object_type => 'SYNONYM'
                                            ,name        => buf1.synonym_name
                                            ,schema      => g_schema_name)
                      ,common_util.MAXIMUM_SQL_LENGTH);
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_future_synonyms;

------------------------------------------------------------
-- Create Advanced Queues
procedure grb_advanced_queues
is
   --
   --  AQ Notifications (Subscribers)
   --
   --TYPE aq$_agent AS OBJECT
   --( name          varchar2(30),    -- M_IDEN, name of a message producer or consumer
   --  address       varchar2(1024),  -- address where message must be sent
   --  protocol      number)          -- protocol for communication, must be 0
   --
   --TYPE aq$_reg_info AS OBJECT (
   --        name                  VARCHAR2(128),  -- name of the subscription
   --        namespace             NUMBER,         -- namespace of the subscription
   --        callback              VARCHAR2(4000), -- callback function
   --        context               RAW(2000),      -- context for the callback func.
   --   ***  anyctx  ***           SYS.ANYDATA,    -- anydata ctx for callback func
   --        ctxtype               NUMBER,         -- raw/anydata context
   --        qosflags              NUMBER,         -- QOS flags
   --        payloadcbk            VARCHAR2(4000), -- payload callback
   --        timeout               NUMBER,         -- registration expiration
   --        ntfn_grouping_class        NUMBER,    -- ntfn grouping class
   --        ntfn_grouping_value        NUMBER,    -- ntfn grouping value
   --        ntfn_grouping_type         NUMBER,    -- ntfn grouping type
   --        ntfn_grouping_start_time   TIMESTAMP WITH TIME ZONE, -- grp start time
   --        ntfn_grouping_repeat_count NUMBER)    -- ntfn grp repeat count
   --
   --Not Implementing "anyctx", "anyctx" is for Streams Only:
   --https://docs.oracle.com/database/121/REFRN/GUID-0976B325-BCA0-4205-9E3A-0E9D88BA1FDD.htm#REFRN23657
   --  Streams is Deprecated:
   --https://docs.oracle.com/database/121/UPGRD/deprecated.htm#UPGRD60159
   -- ' ,anyctx => ''' || case sys.ANYDATA.gettypename(any_context)
   --                     when  null
   --                     then 'NULL'
   --                     when 'NUMBER'
   --                     then 'ConvertNumber(num => to_number(''' ||
   --                           to_char(sys.ANYDATA.AccessNumber(any_context)) || '''))'
   --                     when 'DATE'
   --                     then 'ConvertDate(dat => to_date('''    ||
   --                           to_char(sys.ANYDATA.AccessDate(any_context)
   --                                  ,'DD-MON-YYYY HH24:MI:SS') ||
   --                              ''',''DD-MON-YYYY HH24:MI:SS''))'
   --                     when 'CHAR'
   --                     then 'ConvertChar(c => CAST(''' ||
   --                           sys.ANYDATA.AccessChar(any_context) || ''' as CHAR))'
   --                     when 'VARCHAR'
   --                     then 'ConvertVarchar(c => CAST(''' ||
   --                           sys.ANYDATA.AccessVarchar(any_context) || ''' as VARCHAR))'
   --                     when 'VARCHAR2'
   --                     then 'ConvertVarchar2(c => CAST(''' ||
   --                           sys.ANYDATA.AccessVarchar2(any_context) || ''' as VARCHAR2))'
   --                     when 'RAW'
   --                     then 'ConvertRaw(r => hextoraw(''' ||
   --                           rawtohex(sys.ANYDATA.AccessRaw(any_context)) || '''))'
   --                     when 'BLOB'
   --                     then 'ConvertBlob(b => to_blob(hextoraw(''' ||
   --                           dbms_lob.substr(sys.ANYDATA.AccessBlob(any_context)
   --                                          ,32767,1) || ''')))'
   --                     when 'CLOB'
   --                     then 'ConvertClob(c => to_clob(''' ||
   --                           dbms_lob.substr(sys.ANYDATA.AccessClob(any_context)
   --                                          ,32767,1) || '''))'
   --                     when 'TIMESTAMP'
   --                     then 'ConvertTimestamp(ts => to_timestamp(''' ||
   --                           to_char(sys.ANYDATA.AccessTimestamp(any_context)
   --                                  ,'DD-MON-YYYY HH24:MI:SS.FF9')   ||
   --                              ''',''DD-MON-YYYY HH24:MI:SS.FF9''))'
   --                     when 'TIMESTAMP WITH TIME ZONE'
   --                     then 'ConvertTimestampTZ(ts => to_timestamp_tz(''' ||
   --                           to_char(sys.ANYDATA.AccessTimestampTZ(any_context)
   --                                  ,'DD-MON-YYYY HH24:MI:SS.FF9 TH:TM')  ||
   --                              ''',''DD-MON-YYYY HH24:MI:SS.FF9 TH:TM''))'
   --                     when 'TIMESTAMP WITH LOCAL TIME ZONE'
   --                     then 'ConvertTimestampLTZ(ts => CAST(to_timestamp_tz(''' ||
   --                           to_timestamp_tz(sys.ANYDATA.AccessTimestampLTZ(any_context)
   --                                  ,'DD-MON-YYYY HH24:MI:SS.FF9 TH:TM')   ||
   --                              ''',''DD-MON-YYYY HH24:MI:SS.FF9 TH:TM'')' ||
   --                                                    ' as timestamp with local time zone))'
   --                     when 'INTERVAL YEAR TO MONTH'
   --                     then 'ConvertIntervalYM(inv => INTERVAL ''' ||
   --                           to_char(sys.ANYDATA.AccessIntervalYM(any_context)) ||
   --                                  ' YEAR TO MONTH)'
   --                     when 'INTERVAL DAY TO SECOND'
   --                     then 'ConvertIntervalDS(inv => INTERVAL ''' ||
   --                           to_char(sys.ANYDATA.AccessIntervalDS(any_context)
   --                                  ,'DD HH24:MI:SS.FF') ||
   --                                  ' DAY TO SECOND)'
   --                     when 'BINARY_FLOAT'
   --                     then 'ConvertBFloat(fl => CAST(to_number(''' ||
   --                           sys.ANYDATA.AccessBFloat(any_context) || ''') as BINARY_FLOAT))'
   --                     when 'BINARY_DOUBLE'
   --                     then 'ConvertBFloat(dbl => CAST(to_number(''' ||
   --                          sys.ANYDATA.AccessBDouble(any_context) || ''') as BINARY_DOUBLE))'
   --                     when 'ROWID'
   --                     then 'ConvertURowid(rid => CHARTOROWID(''' ||
   --                           ROWIDTOCHAR(sys.ANYDATA.AccessURowid(any_context)) || '''))'
   --                     --  BFILE Conversion not Implemented
   --                     --when 'BFILE'
   --                     --then 'ConvertBfile(b => BFILENAME ''' ||
   --                     --      sys.ANYDATA.AccessBfile(any_context) || ''')'
   --                     --  Not Implemented
   --                     --when 'NCHAR'
   --                     --then 'ConvertNchar(nc => to_nchar(''' ||
   --                     --      sys.ANYDATA.AccessNchar(any_context) || '''))'
   --                     --  Not Implemented
   --                     --when 'NVARCHAR2'
   --                     --then 'ConvertNVarchar2(nc => to_nchar(''' ||
   --                     --      sys.ANYDATA.AccessNVarchar2(any_context) || '''))'
   --                     --  Not Implemented
   --                     --when 'NCLOB'
   --                     --then 'ConvertNClob(nc => to_nclob(''' ||
   --                     --      sys.ANYDATA.AccessNClob(any_context) || '''))'
   --                     --  Also Not Implemented:
   --                     --ConvertObject(obj => "<ADT_1>")
   --                     --ConvertObject(obj => "<OPAQUE_1>")
   --                     --ConvertRef(rf => REF "<ADT_1>")
   --                     --ConvertCollection(col => "<COLLECTION_1>")
   --                     else 'ERROR: Unknown Datatype "' || context_type || '"'
   --                     end                                              || LF ||
   --
   ELMNT      CONSTANT varchar2(100) := 'QUEUE';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in (select obj.object_name                          QUEUE_NAME
                      ,replace(replace(obj.object_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                                FILE_NAME
                      ,obj.build_timing
                 from  obj_install_object_tab  obj
                       join dba_queues  aq
                            on  aq.owner = obj.object_owner
                            and aq.name  = obj.object_name
                            and (   aq.queue_type is null
                                 or aq.queue_type != 'EXCEPTION_QUEUE')
                 where obj.build_type   = g_build_type
                  and  obj.object_owner = g_schema_name
                  and  obj.object_type  = ELMNT
                 order by obj.object_name
                      ,obj.file_ext1
                      ,obj.build_timing)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buf1.queue_name || ' Queue');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--  NOTE: This is a "' || buf1.build_timing || '" Queue');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name   ||
                                             '.' || buf1.queue_name );
      fh2.put_big_line(fh, g_schema_name || '.' || buf1.queue_name || ' Queue'
                      ,dbms_metadata.get_ddl(object_type => 'AQ_QUEUE'
                                            ,name        => buf1.queue_name
                                            ,schema      => g_schema_name)
                      ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Grants');
      -- Grant syntax does not support Advanced Queues
      --grb_object_grants(fh, buf1.queue_name, 'QUEUE');
      fh2.script_put_line(fh, '');
      for buf2 in (select grantee                 GRANTEE
                         ,privilege
                         ,max(grantable)          GRANTABLE
                    from  priv_obj_queue_view
                    where build_type   = g_build_type
                     and  build_timing = 'CURRENT'     -- Grantee is installed before Queue
                     and  queue_owner  = g_schema_name
                     and  queue_name   = buf1.queue_name
                    group by grantee
                         ,privilege
                    order by grantee
                         ,privilege)
      loop
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.grant_queue_privilege');
         fh2.script_put_line(fh, '      (privilege    => '''  || buf2.privilege  || ''''  );
         fh2.script_put_line(fh, '      ,queue_name   => ''"' || g_schema_name   || '"."' ||
                                                                 buf1.queue_name || '"''' );
         fh2.script_put_line(fh, '      ,grantee      => '''  || buf2.grantee    || ''''  );
         if buf2.grantable = 'YES'
         then
            fh2.script_put_line(fh, '      ,grant_option => TRUE);');
         else
            fh2.script_put_line(fh, '      ,grant_option => FALSE);');
         end if;
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
      end loop;
      grb_object_synonyms(fh, buf1.queue_name, 'QUEUE', common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Subscribe');
      fh2.script_put_line(fh, '');
      for buf3 in (
         select queue_owner     -- Owner of the queue
               ,queue_name      -- Name of the queue
               ,consumer_name   -- Name of the subscriber
               ,address         -- Address of the subscriber
               ,protocol        -- Protocol of the subscriber
               ,rule            -- Rule condition for the subscriber
               ,transformation  -- Transformation for the subscriber
               ,queue_to_queue  -- Is subscriber is a queue-to-queue subscriber?
               ,delivery_mode   -- Message delivery mode: PERSISTENT, BUFFERED, or PERSISTENT_OR_BUFFERED
               ,build_type_selector
          from  priv_queue_subscribe_view
          where build_type          = g_build_type
           and  build_type_selector = 'QUEUE'
           and  queue_owner         = g_schema_name
           and  queue_name          = buf1.queue_name
          order by queue_owner
               ,queue_name
               ,consumer_name)
      loop
         fh2.script_put_line(fh, '-- This is a "' || buf3.build_type_selector || '" Queue Subscription');
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.add_subscriber');
         fh2.script_put_line(fh, '      (queue_name     => ''' || buf3.queue_owner ||
                                                           '.' || buf3.queue_name  || '''');
         fh2.script_put_line(fh, '      ,subscriber     => sys.aq$_agent');
         fh2.script_put_line(fh, '                            (name     => ''' || buf3.consumer_name || '''');
         fh2.script_put_line(fh, '                            ,address  => ''' || buf3.address       || '''');
         fh2.script_put_line(fh, '                            ,protocol => '   || buf3.protocol      || ')');
         fh2.script_put_line(fh, '      ,rule           => ''' || buf3.rule           || '''');
         fh2.script_put_line(fh, '      ,transformation => ''' || buf3.transformation || '''');
         fh2.script_put_line(fh, '      ,queue_to_queue => '   || buf3.queue_to_queue );
         fh2.script_put_line(fh, '      ,delivery_mode  => DBMS_AQADM.' || buf3.delivery_mode || ');');
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Register');
      fh2.script_put_line(fh, '');
      -- https://docs.oracle.com/database/121/REFRN/GUID-0976B325-BCA0-4205-9E3A-0E9D88BA1FDD.htm#REFRN23657
      for buf4 in (
         select subscription_name          -- Name of the subscription registration of the form schema.queue:consumer_name
               ,namespace                  -- Namespace of the subscription registration: ANONYMOUS, AQ, or DBCHANGE
               ,location_name              -- Location endpoint of the registration
               ,user_context               -- Context the user provided during registration of PL/SQL registrations
               ,qosflags                   -- Quality of service of the registration: RELIABLE, PAYLOAD, or PURGE_ON_NTFN
               ,timeout                    -- Registration timeout
               ,ntfn_grouping_class        -- Notification grouping class
               ,ntfn_grouping_value        -- Notification grouping value
               ,ntfn_grouping_type         -- Notification grouping type: SUMMARY or LAST
               ,ntfn_grouping_start_time   -- Notification grouping start time
               ,ntfn_grouping_repeat_count -- Notification grouping repeat count, or FOREVER
               ,context_size               -- Size of the context
          from  priv_queue_register_view    -- grant SELECT on "SYS"."DBA_SUBSCR_REGISTRATIONS" to "ODBCAPTURE";
          where queue_build_type = g_build_type
           and  regexp_like (subscription_name, '^["]{0,1}'           ||   -- Zero or One Double Quotes at the begining
                                                g_schema_name         ||
                                                '["]{0,1}[.]["]{0,1}' ||   -- Zero or One Double Quotes, a Period, and Zero or One Double Quotes
                                                buf1.queue_name        )
          order by subscription_name
               ,namespace)
      loop
         -- Advanced Queue Registrations are "QUEUE" only.
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aq.register');
         fh2.script_put_line(fh, '      (reg_list => sys.aq$_reg_info_list');
         fh2.script_put_line(fh, '                      (sys.aq$_reg_info');
         fh2.script_put_line(fh, '                         (name                       => ''' || buf4.subscription_name                    || '''');
         fh2.script_put_line(fh, '                         ,namespace                  => DBMS_AQ.NAMESPACE_' || to_char(buf4.namespace));
         fh2.script_put_line(fh, '                         ,callback                   => ''' || buf4.location_name                     || '''');
         fh2.script_put_line(fh, '                         ,context                    => hextoraw(''' || rawtohex(buf4.user_context)      || ''')');
         if    buf4.qosflags is not null
           AND buf4.timeout  is not null
         then
            fh2.script_put_line(fh, '                         ,qosflags                   => ' || to_char(buf4.qosflags));
            fh2.script_put_line(fh, '                         ,timeout                    => ' || to_char(buf4.timeout));
            if     buf4.ntfn_grouping_class        is not null
               AND buf4.ntfn_grouping_value        is not null
               AND buf4.ntfn_grouping_type         is not null
               AND buf4.ntfn_grouping_start_time   is not null
               AND buf4.ntfn_grouping_repeat_count is not null
            then
               fh2.script_put_line(fh, '                         ,ntfn_grouping_class        => ' || to_char(buf4.ntfn_grouping_class));
               fh2.script_put_line(fh, '                         ,ntfn_grouping_value        => ' || to_char(buf4.ntfn_grouping_value));
               fh2.script_put_line(fh, '                         ,ntfn_grouping_type         => ' || to_char(buf4.ntfn_grouping_type));
               fh2.script_put_line(fh, '                         ,ntfn_grouping_start_time   => ' || 'to_timstamp_tz(' ||
                                                                                                      to_char(buf4.ntfn_grouping_start_time
                                                                                                             ,'DD-MON-YYYY HH24:MI:SS.FF9 TH:TM') ||
                                                                                                           ',''DD-MON-YYYY HH24:MI:SS.FF9 TH:TM'')' || ' )');
               fh2.script_put_line(fh, '                         ,ntfn_grouping_repeat_count => ' || to_char(buf4.ntfn_grouping_repeat_count));
            end if;
         end if;
         fh2.script_put_line(fh, '                      )  )');
         fh2.script_put_line(fh, '      ,reg_count => ' || nvl(to_char(buf4.context_size),'NULL') || ' );');
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Schedule');
      fh2.script_put_line(fh, '');
      -- https://docs.oracle.com/database/121/REFRN/GUID-65C3B9EB-BFD5-4BAB-A810-D0B705E92DCA.htm
      for buf5 in (
         select schema              -- Source queue owner
               ,qname               -- Source queue name
               ,destination         -- Destination name, currently limited to be a DBLINK name
               ,start_date          -- Date at which to start propagation
               ,propagation_window  -- Duration for the propagation window (in seconds)
               ,next_time           -- Function to compute the start of the next propagation window
               ,latency             -- Maximum wait time to propagate a message during the propagation window
          from  dba_queue_schedules
          where schema = g_schema_name
           and  qname  = buf1.queue_name
          order by schema
               ,qname)
      loop
         fh2.script_put_line(fh, 'begin');
         fh2.script_put_line(fh, '   dbms_aqadm.schedule_propagation');
         fh2.script_put_line(fh, '      (queue_name         => ''"' || buf5.schema      || '"."' ||
                                                                       buf5.qname       || '"''' );
         fh2.script_put_line(fh, '      ,destination        => '''  || buf5.destination || ''''  );
         fh2.script_put_line(fh, '      ,start_time         => to_date(''' || to_char(buf5.start_date
                                                                                     ,'DD-MON-YYYY HH24:MI:SS')  ||
                                                                                ''', ''DD-MON-YYYY HH24:MI:SS'')');
         fh2.script_put_line(fh, '      ,duration           =>   '  || buf5.propagation_window   );
         fh2.script_put_line(fh, '      ,next_time          => '''  || buf5.next_time   || ''''  );
         fh2.script_put_line(fh, '      ,latency            =>   '  || buf5.latency);
         fh2.script_put_line(fh, '      ,destination_queue  => NULL);');
         fh2.script_put_line(fh, 'end;');
         fh2.script_put_line(fh, '/');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_advanced_queues;

------------------------------------------------------------
-- Create Advanced Queue Tables
procedure grb_aq_tables
is
   ELMNT      CONSTANT varchar2(100) := 'QUEUE_TABLE';
   fh         fh2.sf_ptr_type;  -- object script file handle
   gsm_save   varchar2(128);
begin
   for buff in (select aqt.queue_table
                      ,replace(replace(aqt.queue_table,'$','_'),'%','_') || '.' || elem.file_ext1
                                                           FILE_NAME
                      ,obj.object_name
                      ,obj.object_type
                      ,obj.build_timing
                 from  dba_queue_tables  aqt
                       join element_conf  elem
                            on  elem.element_name = ELMNT
                       join obj_install_object_tab  obj
                            on  obj.build_type = g_build_type
                            and obj.object_owner = aqt.owner
                            and obj.object_name  = aqt.queue_table
                            and obj.object_type  in ('TABLE','VIEW')
                 where aqt.owner = g_schema_name
                 order by aqt.queue_table)
   loop
      fh := fh2.script_open(in_filename     => buff.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buff.queue_table ||' Queue Table');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buff.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- NOTE: This is a "' || buff.build_timing || '" Queue Table');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buff.queue_table);
      -- DBMS_METADATA throws an error when LOB_STORAGE is set to DEFAULT or BASICFILE for AQ_QUEUE_TABLE
      fh2.remove_storage_clause(fh, g_schema_name || '.' || buff.queue_table || ' Table'
                               ,dbms_metadata.get_ddl(object_type => 'AQ_QUEUE_TABLE'
                                                     ,name        => buff.queue_table
                                                     ,schema      => g_schema_name)
                               ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '-- https://docs.oracle.com/en/database/oracle/oracle-database/23/adque/managing-aq.html');
      fh2.script_put_line(fh, '-- The queue table owner must be granted EXECUTE privileges on the');
      fh2.script_put_line(fh, '--  DBMS_AQADM package. Otherwise, the Oracle Database snapshot');
      fh2.script_put_line(fh, '--  processes do not propagate, but generates trace files with the');
      fh2.script_put_line(fh, '--  error identifier SYS.DBMS_AQADM not defined');
      fh2.script_put_line(fh, '--');
      grb_object_grants(fh, buff.queue_table, buff.object_type);
      grb_object_synonyms(fh, buff.queue_table, buff.object_type, common_util.MAXIMUM_SQL_LENGTH);
      for buf2 in (
          select obj.object_name,
                 obj.object_type
           from  dba_objects_tab  obj
           where obj.object_owner = g_schema_name
            and  obj.object_type in ('TABLE','VIEW')
            and  regexp_like(obj.object_name, common_util.ADV_QUEUE_PREFIX_REGEXP || buff.queue_table || common_util.ADV_QUEUE_SUFFIX_REGEXP)
           order by obj.object_name,
                 obj.object_type)
      loop
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, ' -- ' || buf2.object_name || ' ' || buf2.object_type);
         fh2.script_put_line(fh, '');
         grb_object_grants(fh, buf2.object_name, buf2.object_type);
         grb_object_synonyms(fh, buf2.object_name, buf2.object_type, common_util.MAXIMUM_SQL_LENGTH);
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_aq_tables;

------------------------------------------------------------
-- Create Application Context object script
PROCEDURE grb_application_context
IS
   ELMNT      CONSTANT varchar2(100) := 'CONTEXT';
   fh         fh2.sf_ptr_type;  -- object script file handle
   sql_txt    varchar2(32767);
begin
   for buf1 in (select obj.context_owner
                      ,obj.context_name
                      ,obj.context_type
                      ,replace(replace(obj.context_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                             FILE_NAME
                      ,obj.package_owner
                      ,obj.package_name
                      ,obj.build_timing
                 from  obj_install_context_tab  obj
                 where obj.build_type    = g_build_type
                  and  obj.context_owner = g_schema_name
                  and  obj.element_name = ELMNT
                 order by obj.context_name
                      ,obj.context_owner
                      ,obj.package_name)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create '  || buf1.context_name ||' Context');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- Note: This is a "' || buf1.build_timing || '" Context');
      end if;
      fh2.script_put_line(fh, '');
      sql_txt := 'create or replace context "' || buf1.context_name  ||
                                         '"."' || buf1.context_name  ||
                                   '" using "' || buf1.package_owner ||
                                         '"."' || buf1.package_name  ||
                                         '"  ' || buf1.context_type  ;
      fh2.put_big_line(fh, buf1.package_owner || '.' || buf1.context_name || ' Context'
                      ,sql_txt || ';'
                      ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   END LOOP;
end grb_application_context;

------------------------------------------------------------
-- Create Real Application Security
procedure grb_ras_acls
is
   SQL_TXT   constant varchar2(1000) := 'begin GRAB_RAS.GRB_RACL; end;';
begin
   if NOT installed_types_aa.EXISTS('grbras') then return; end if;
   execute immediate SQL_TXT;
exception when others then
   if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_RAS.GRB_RACL'' must be declared')
   then
      raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                       SQL_TXT                  || CHR(10) ||
                                       SQLERRM                  || CHR(10) ||
                                       dbms_utility.format_error_backtrace );
   end if;
end grb_ras_acls;

------------------------------------------------------------
-- Create Host Access Control Lists
procedure grb_host_acls
is
   --
   -- Oracle Database Security Guide Release 21
   -- F31285-17, April 2024
   -- Chapter 8 Managing Fine-Grained Access in PL/SQL Packages and Types
   -- 8.5 Configuring Access Control for External Network Services
   -- https://docs.oracle.com/en/database/oracle/oracle-database/21/dbseg/managing-fine-grained-access-in-pl-sql-packages-and-types.html#GUID-9C14581A-163F-48ED-98CC-790E6B8D20D6
   --
   -- privilege_list: Enter one or more of the following privileges, which
   --   are case insensitive. Enclose each privilege with single quotation
   --   marks and separate each with a comma (for example, 'http', 'http_proxy').
   -- For tighter access control, grant only the http, http_proxy, or smtp
   --   privilege instead of the connect privilege if the user uses the
   --   UTL_HTTP, HttpUriType, UTL_SMTP, or UTL_MAIL only.
   --   -) http: Makes an HTTP request to a host through the UTL_HTTP package and the HttpUriType type
   --   -) http_proxy: Makes an HTTP request through a proxy through the UTL_HTTP package and the HttpUriType type. You must include http_proxy in conjunction to the http privilege if the user makes the HTTP request through a proxy.
   --   -) smtp: Sends SMTP to a host through the UTL_SMTP and UTL_MAIL packages
   --   -) resolve: Resolves a network host name or IP address through the UTL_INADDR package
   --   -) connect: Grants the user permission to connect to a network service at a host through the UTL_TCP, UTL_SMTP, UTL_MAIL, UTL_HTTP, and DBMS_LDAP packages, or the HttpUriType type
   --   -) jdwp: Used for Java Debug Wire Protocol debugging operations for Java or PL/SQL stored procedures.
   --
   --  This was implemented in Real Application Security:
   --DECLARE
   -- ace_list      XS$ACE_LIST;
   --BEGIN
   -- ace_list := XS$ACE_LIST(
   --   XS$ACE_TYPE(
   --     privilege_list => XS$NAME_LIST('"CONNECT"'),
   --     principal_name=>'"APP_OWNER"',
   --     principal_type=>XS_ACL.PTYPE_DB,
   --     start_date => to_timestamp_tz('16-SEP-16 09.42.47.423377 PM',
   --          'DD-MON-YY HH.MI.SS.FF PM TZH:TZM')),
   --   XS$ACE_TYPE(
   --     privilege_list => XS$NAME_LIST('"CONNECT"'),
   --     principal_name=>'"APP_OWNER"',
   --     principal_type=>XS_ACL.PTYPE_DB));
   --
   -- xs_acl.create_acl(
   --     name=>'"SYS"."NETWORK_ACL_3CA7D022F7DCA526E054A0369FA25254"',
   --     ace_list=>ace_list,
   --     sec_class=>'"SYS"."NETWORK_SC"',
   --     description=>'ACL for Application');
   --END;
   --/
   --
   ELMNT        CONSTANT varchar2(100) := 'HOST_ACL';
   fh           fh2.sf_ptr_type;  -- object script file handle
   old_file     varchar2(1000) := 'This is not a real file name !@#$%^';
   ----------------------------------------
begin
   --dbms_output.put_line('ELMNT: ' || ELMNT || ', g_build_type: ' || g_build_type ||
   --                     ', g_schema_name: ' || g_schema_name || ', ' || ELMNT);
   for buff in (select replace(replace(replace(host,'*','_'),'$','_'),'%','_') || '.' || file_ext1
                                                              FILE_NAME
                      ,host
                      ,object_name_regexp
                      ,lower_port
                      ,upper_port
                      ,host || ' from port ' || lower_port || ' to ' || upper_port
                                                              HOST_PORT_RANGE
                      ,grantee                                PRINCIPAL
                      ,privilege
                      ,build_type_selector
                 from  priv_obj_hacl_view
                 where build_type         = g_build_type
                  and  principal_type     = 'DATABASE'       -- xs_acl.ptype_db
                  and  grant_type         = 'GRANT'
                  and  inverted_principal = 'NO'
                  and  privilege         is not null
                 group by replace(replace(replace(host,'*','_'),'$','_'),'%','_') || '.' || file_ext1
                      ,host
                      ,object_name_regexp
                      ,lower_port
                      ,upper_port
                      ,grantee
                      ,privilege
                      ,build_type_selector
                 order by replace(replace(replace(host,'*','_'),'$','_'),'%','_') || '.' || file_ext1
                      ,host
                      ,object_name_regexp
                      ,lower_port
                      ,upper_port
                      ,grantee
                      ,privilege
                      ,build_type_selector)
   loop
      if old_file != buff.file_name
      then
         old_file := buff.file_name;
         if fh2.script_is_open(fh)
         then
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         fh := fh2.script_open(in_filename     => buff.file_name
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Host ACL/ACE');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '-- Host ACLs with the following:');
         fh2.script_put_line(fh, '--    PRINCIPAL_TYPE      = ''DATABASE'' (xs_acl.ptype_db)');
         fh2.script_put_line(fh, '--    GRANT_TYPE          = ''GRANT''');
         fh2.script_put_line(fh, '--    INVERTED_PRINICIPAL = ''NO''');
         fh2.script_put_line(fh, '--    PRIVILEGE          is not null');
         fh2.script_put_line(fh, '-- Start Dates and End Dates are ignored (set to NULL).');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create Host ACL/ACE for ' || buff.host_port_range || ' ');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_type_selector || '" Host ACL');
      if buff.object_name_regexp is not null
      then
         fh2.script_put_line(fh, '--   (OBJECT_NAME_REGEXP: ' || buff.object_name_regexp || ')');
      end if;
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'begin');
      fh2.script_put_line(fh, '   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE');
      fh2.script_put_line(fh, '      (host        => ''' || buff.host || '''');
      if upper(buff.privilege) != 'RESOLVE'
      then
         -- Oracle 12c Release 1 Database PL/SQL Packages and Types Reference
         -- 101 DBMS_NETWORK_ACL_ADMIN
         -- An ACE with a "resolve" privilege can be appended only to a host''s ACL without a port range.
         fh2.script_put_line(fh, '      ,lower_port  => ' || nvl(to_char(buff.lower_port),'NULL'));
         fh2.script_put_line(fh, '      ,upper_port  => ' || nvl(to_char(buff.upper_port),'NULL'));
      end if;
      fh2.script_put_line(fh, '      ,ace         => xs$ace_type');
      fh2.script_put_line(fh, '                         (privilege_list   => xs$name_list(''' || buff.privilege || ''')');
      fh2.script_put_line(fh, '                         ,granted          => TRUE');
      fh2.script_put_line(fh, '                         ,inverted         => FALSE');
      fh2.script_put_line(fh, '                         ,principal_name   => ''' || buff.principal || '''');
      fh2.script_put_line(fh, '                         ,principal_type   => xs_acl.ptype_db');
      fh2.script_put_line(fh, '                         ,start_date       => NULL');
      fh2.script_put_line(fh, '                         ,end_date         => NULL));');
      fh2.script_put_line(fh, 'end;');
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_host_acls;

------------------------------------------------------------
-- Create Wallet Access Control Lists
procedure grb_wallet_acls
is
   --
   -- Oracle Database Security Guide Release 21
   -- F31285-17, April 2024
   -- Chapter 8 Managing Fine-Grained Access in PL/SQL Packages and Types
   -- 8.5 Configuring Access Control for External Network Services
   -- https://docs.oracle.com/en/database/oracle/oracle-database/21/dbseg/managing-fine-grained-access-in-pl-sql-packages-and-types.html#GUID-561E9D60-1414-4066-8214-8BBB6091956B
   --
   -- In this specification, **PRIVILEGE** must be one of the following when you
   --   enter wallet privileges using xs$ace_type (note the use of underscores
   --   in these privilege names):
   --   -) use_client_certificates
   --   -) use_passwords
   -- Be aware that for wallets, you must specify either the
   --   use_client_certificates or use_passwords privileges.
   --
   ELMNT        CONSTANT varchar2(100) := 'WALLET_ACL';
   fh           fh2.sf_ptr_type;  -- object script file handle
   old_file     varchar2(1000) := 'This is not a real file name !@#$%^';
   ----------------------------------------
begin
   --dbms_output.put_line('ELMNT: ' || ELMNT || ', g_build_type: ' || g_build_type ||
   --                     ', g_schema_name: ' || g_schema_name || ', ' || ELMNT);
   for buff in (select replace(replace(wacl_name,'$','_'),'%','_') || '.' || file_ext1
                                                                    FILE_NAME
                      ,wallet_path
                      ,object_name_regexp
                      ,grantee                                      PRINCIPAL
                      ,privilege
                      ,build_type_selector
                 from  priv_obj_wacl_view
                 where build_type         = g_build_type
                  and  principal_type     = 'DATABASE'       -- xs_acl.ptype_db
                  and  grant_type         = 'GRANT'
                  and  inverted_principal = 'NO'
                  and  privilege         is not null
                 group by replace(replace(wacl_name,'$','_'),'%','_') || '.' || file_ext1
                      ,wallet_path
                      ,object_name_regexp
                      ,grantee
                      ,privilege
                      ,build_type_selector
                 order by replace(replace(wacl_name,'$','_'),'%','_') || '.' || file_ext1
                      ,wallet_path
                      ,object_name_regexp
                      ,grantee
                      ,privilege
                      ,build_type_selector)
   loop
      if old_file != buff.file_name
      then
         old_file := buff.file_name;
         if fh2.script_is_open(fh)
         then
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         fh := fh2.script_open(in_filename     => replace(replace(buff.file_name,'/','_'),'\','_')
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Wallet ACL/ACE');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '-- Wallet ACLs with the following:');
         fh2.script_put_line(fh, '--    PRINCIPAL_TYPE      = ''DATABASE'' (xs_acl.ptype_db)');
         fh2.script_put_line(fh, '--    GRANT_TYPE          = ''GRANT''');
         fh2.script_put_line(fh, '--    INVERTED_PRINICIPAL = ''NO''');
         fh2.script_put_line(fh, '--    PRIVILEGE          is not null');
         fh2.script_put_line(fh, '-- Start Dates and End Dates are ignored (set to NULL).');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_type_selector || '" Wallet ACL');
      if buff.object_name_regexp is not null
      then
         fh2.script_put_line(fh, '--   (OBJECT_NAME_REGEXP: ' || buff.object_name_regexp || ')');
      end if;
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'begin');
      fh2.script_put_line(fh, '   DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE');
      fh2.script_put_line(fh, '      (wallet_path => ''' || buff.wallet_path || '''');
      fh2.script_put_line(fh, '      ,ace         => xs$ace_type');
      fh2.script_put_line(fh, '                         (privilege_list   => xs$name_list(''' || buff.privilege || ''')');
      fh2.script_put_line(fh, '                         ,granted          => TRUE');
      fh2.script_put_line(fh, '                         ,inverted         => FALSE');
      fh2.script_put_line(fh, '                         ,principal_name   => ''' || buff.principal || '''');
      fh2.script_put_line(fh, '                         ,principal_type   => xs_acl.ptype_db');
      fh2.script_put_line(fh, '                         ,start_date       => NULL');
      fh2.script_put_line(fh, '                         ,end_date         => NULL));');
      fh2.script_put_line(fh, 'end;');
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_wallet_acls;

------------------------------------------------------------
-- Common Create Procedure.  Only used for:
--   -) FUNCTION
--   -) PACKAGE_BODY
--   -) PACKAGE_SPEC
--   -) PROCEDURE
--   -) SCHEDULER_JOB
--   -) SCHEDULER_PROGRAM
--   -) SCHEDULER_SCHEDULE
--   -) SEQUENCE
--   -) TYPE_BODY
--   -) TYPE_SPEC
procedure grb_common
      (in_ELMNT      in varchar2
      ,in_type_name  in varchar2)
is
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buff in (select obj.object_name                      OBJECT_NAME
                      ,replace(replace(obj.object_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                            FILE_NAME
                      ,obj.build_timing
                      ,obj.object_type
                 from  obj_install_object_tab  obj
                 where obj.build_type   = g_build_type
                  and  obj.object_owner = g_schema_name
                  and  obj.element_name = in_ELMNT
                  and  (   obj.element_name != 'SCHEDULER_JOB'
                           -- Skip MV Scheduler Jobs, create with Materialized Views
                        or (    obj.object_name not like   'MV\_RF$J\_%' escape '\'
                            AND obj.object_name not like 'DBMS\_JOB$\_%' escape '\'
                       )   )
                  and  (   obj.element_name != 'SEQUENCE'
                        or (    -- Skip Queue Sequences, create with Advanced Queues
                                not exists (select 'x' from dba_queue_tables qt
                                             where qt.owner = g_schema_name
                                              and  regexp_like(obj.object_name,common_util.ADV_QUEUE_PREFIX_REGEXP ||
                                                                               qt.queue_table                       ||
                                                                               common_util.ADV_QUEUE_SUFFIX_REGEXP
                                           )                  )
                                -- Identity Sequences: Auto-created with Tables
                            and obj.object_name not in (select dti.sequence_name from dba_tab_identity_cols dti
                                                         where dti.owner = obj.object_owner
                                                       )
                                -- Ignore Spatial Data Object Supplemental Sequences
                            and not regexp_like(obj.object_name, common_util.SDO_TABLE_REGEXP)
                       )   )
                  and  (   obj.element_name not in ('TYPE_BODY', 'TYPE_SPEC')
                        or (    -- Skip Pipelined Type Objects, create with pipelined package/function
                                obj.object_name not like common_util.SYS_PIPELINE_PATTERN escape '\'
                                -- Unknown type specifications, table of numbers, no dependencies
                            and obj.object_name not like common_util.SYS_TYPE_REGEXP escape '\'
                       )   )
                 order by object_name)
   loop
      fh := fh2.script_open(in_filename     => buff.file_name
                           ,in_elmnt        => in_ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buff.OBJECT_NAME ||' ' || in_type_name);
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buff.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- Note: This is a "' || buff.build_timing || '" ' || buff.object_type);
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buff.OBJECT_NAME);
      fh2.put_big_line(fh, g_schema_name || '.' || buff.OBJECT_NAME || ' ' || in_type_name
                      ,COMMON_UTIL.escape_at_sign
                         (dbms_metadata.get_ddl
                            (object_type => case in_ELMNT
                                               -- https://logbuffer.wordpress.com/2014/03/13/oracle-getting-the-ddl-for-scheduler-jobs
                                               when 'SCHEDULER_JOB'      then 'PROCOBJ'
                                               when 'SCHEDULER_PROGRAM'  then 'PROCOBJ'
                                               when 'SCHEDULER_SCHEDULE' then 'PROCOBJ'
                                                                         else in_ELMNT
                                            end
                            ,name        => buff.OBJECT_NAME
                            ,schema      => g_schema_name) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
      if buff.object_type not in ('PACKAGE BODY', 'TYPE BODY')
      then
         fh2.script_put_line(fh, '');
         grb_object_grants(fh, buff.OBJECT_NAME, buff.object_type);
         grb_object_synonyms(fh, buff.OBJECT_NAME, buff.object_type, common_util.MAXIMUM_SQL_LENGTH);
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_common;

------------------------------------------------------------
-- Create Comprehensive Data Loader
procedure grb_comp_data_loader
is
   ELMNT       CONSTANT varchar2(100) := 'DATA_LOAD';
   F_DATE      CONSTANT varchar2(100) := 'DD-MON-YYYY HH24:MI:SS';
   F_TSTTZ     CONSTANT varchar2(100) := 'DD-MON-YYYY HH24:MI:SS.FF TZH:TZM';
   F_TST       CONSTANT varchar2(100) := 'DD-MON-YYYY HH24:MI:SS.FF';
   F_IDTOS     CONSTANT varchar2(100) := 'DD HH24:MI:SS.FF';
   fh          fh2.sf_ptr_type;  -- object script file handle
   lc          varchar2(100);  -- Lead characters
   sql_txt     varchar2(32767);
   desc_tab    dbms_sql.desc_tab3;
   dyn_curs    integer;
   dyn_stat    integer;
   num_cols    number := 0;
   col_err     number;
   col_len     integer;
   junk        integer;
   --
   --  SYS.DBMS_SQL Package Specification, Named Datatype CONSTANTS
   --
   --  User_Defined_Type is Data Type ID 109. Requires col_type_name
   --    and col_type_name_len from DBMS_SQL.DESC_REC3 Record Type
   --
   --  Ref_Type is Data Type ID 111. Requires a declared "object type".
   --
   vc2_buff          varchar2(32767);                    -- Data Type ID   1
   char_buff         char(32767);                        -- Data Type ID  96
   --
   num_buff          number;                             -- Data Type ID   2
   --bfloat_buff       binary_double;                      -- Data Type ID 101
   --float_buff        binary_float;                       -- Data Type ID 100
   --
   date_buff         date;                               -- Data Type ID  12
   tstmp_buff        timestamp(9);                       -- Data Type ID 180
   tstmptz_buff      timestamp(9) with time zone;        -- Data Type ID 181
   tstmpltz_buff     timestamp(9) with local time zone;  -- Data Type ID 231
   intvlds_buff      interval day(9) to second(9);       -- Data Type ID 183
   --intvlym_buff      interval year to month;             -- Data Type ID 182
   --
   clob_buff         clob;                               -- Data Type ID 112
   xml_buff          xmltype;                            -- Data Type ID 109, Also for SDO Types and User Types
   blob_buff         blob;                               -- Data Type ID 113
   --bfile_buff        bfile;                              -- Data Type ID 114
$IF DBMS_DB_VERSION.VERSION > 19
$THEN
   json_buff         json;                               -- Data Type ID 119;
$END
   --long_buff         long;                               -- Data Type ID   8
   --lraw_buff         long raw;                           -- Data Type ID  24
   --
   --mlslbl_buff       mlslabel;                           -- Data Type ID 106
   raw_buff          raw(32767);                         -- Data Type ID  23
   --rowid_buff        rowid;                              -- Data Type ID  11
   --urowid_buff       urowid;                             -- Data Type ID 208
   --
   procedure show_col_err
         (in_table_name  in  varchar2
         ,in_col_type    in  varchar2
         ,in_i           in  number)
   is
   begin
      -- 1405 is zero length value retrieved?
      if nvl(col_err,0) not in (0, 1405)
      then
         dbms_output.put_line('COL_ERR is not 0 or 5 in' ||
                             ' BUILD_TYPE ' || g_build_type          ||
                                   ', table ' || g_schema_name           ||
                                          '.' || in_table_name           ||
                                         ', ' || in_col_type             ||
                                   ' column ' || desc_tab(in_i).col_name ||
                                  ', length ' || col_len                 ||
                                         ': ' || col_err                 );
      end if;
   end show_col_err;
   --
   procedure utf_put_clob
   is
      ptr     integer := 1;
      loc     integer;
   begin
      loop
         -- Find a linefeed
         loc := instr(clob_buff, LF, ptr);
         exit when loc = 0;
         if substr(clob_buff, loc-1, 1) = CRTN
         then
            fh2.script_put(fh, substr(clob_buff, ptr, loc-ptr));
         else
            fh2.script_put(fh, substr(clob_buff, ptr, loc-ptr+1));
         end if;
         ptr := loc+1;
      end loop;
      -- Need Double Quote at end of clob_buff.
      fh2.script_put(fh, substr(clob_buff, ptr));
   end utf_put_clob;
   --
   procedure disable_ras_policy (in_table in varchar2) is
      SQL_TXT   constant varchar2(1000) := 'begin GRAB_RAS.DISABLE_POLICY(:1, :2); end;';
   begin
      if NOT installed_types_aa.EXISTS('grbras') then return; end if;
      execute immediate SQL_TXT using in g_schema_name, in_table;
   exception when others then
      if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_RAS.DISABLE_POLICY'' must be declared')
      then
         raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                          SQL_TXT                  || CHR(10) ||
                                          '  :1 ' || g_schema_name || CHR(10) ||
                                          '  :2 ' || in_table      || CHR(10) ||
                                          SQLERRM                  || CHR(10) ||
                                         dbms_utility.format_error_backtrace );
      end if;
   end disable_ras_policy;
   --
   procedure enable_ras_policy (in_table in varchar2) is
      SQL_TXT   constant varchar2(1000) := 'begin GRAB_RAS.ENABLE_POLICY(:1, :2); end;';
   begin
      if NOT installed_types_aa.EXISTS('grbras') then return; end if;
      execute immediate SQL_TXT using in g_schema_name, in_table;
   exception when others then
      if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_RAS.ENABLE_POLICY'' must be declared')
      then
         raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                          SQL_TXT                  || CHR(10) ||
                                          '  :1 ' || g_schema_name || CHR(10) ||
                                          '  :2 ' || in_table      || CHR(10) ||
                                          SQLERRM                  || CHR(10) ||
                                         dbms_utility.format_error_backtrace );
      end if;
   end enable_ras_policy;
   --
begin
   --
   for tabs in
      (select table_name                                                        TABLE_NAME
             ,replace(replace(table_name,'$','_'),'%','_') || '.' || file_ext1  FILE_NAME
             ,replace(replace(table_name,'$','_'),'%','_') || '.' || file_ext2  CTL_FILE
             ,replace(replace(table_name,'$','_'),'%','_') || '.' || file_ext3  DAT_FILE
             ,replace(replace(table_name,'$','_'),'%','_') || '.log'            LOG_FILE
             ,before_select_sql
             ,columns_removed
             ,where_clause
             ,order_by_columns
             ,after_order_by_sql
             ,build_timing
        from  obj_install_data_load_tab  sdvw
        where build_type    = g_build_type
         and  table_owner   = g_schema_name
         and  element_name = ELMNT
        order by table_name)
   loop
      --
      -- DBMS_SQL Open, Parse, Describe
      if tabs.before_select_sql is not null
      then
         sql_txt := tabs.before_select_sql || LF;
      else
         sql_txt := '';
      end if;
      --
      sql_txt := sql_txt || 'select ';
      for cols in (select dc.column_name from dba_tab_columns  dc
                    where dc.owner      = g_schema_name
                     and  dc.table_name = tabs.table_name
                     and (                                   tabs.columns_removed is null
                          OR NOT regexp_like(dc.column_name, tabs.columns_removed)    )
                    order by dc.column_id)
      loop
         sql_txt := sql_txt || '"' || cols.column_name || '",';
      end loop;
      sql_txt := substr(sql_txt, 1, length(sql_txt)-1);
      sql_txt := sql_txt || ' from "' || g_schema_name   || '"' ||
                                 '."' || tabs.table_name || '"' ;
      --
      if tabs.where_clause is not null
      then
         sql_txt := sql_txt || LF || 'where ' || tabs.where_clause;
      end if;
      -- ORDER_BY_COLUMNS is required
      sql_txt := sql_txt || LF || 'order by ' || tabs.order_by_columns;
      --
      if tabs.after_order_by_sql is not null
      then
         sql_txt := sql_txt || LF || tabs.after_order_by_sql;
      end if;
      --
      dyn_curs := dbms_sql.open_cursor;
      begin
         dbms_sql.parse(c             => dyn_curs
                       ,statement     => sql_txt
                       ,language_flag => dbms_sql.native );
      exception when others then
         raise_application_error(-20000, 'DBMS_SQL Parse Error: ' || SQLERRM || CHR(10) ||
                                         sql_txt || ';' ||  CHR(10) || CHR(10) );
      end;
      dbms_sql.describe_columns3(c        => dyn_curs
                                ,col_cnt  => num_cols
                                ,desc_t   => desc_tab );
      ----------------------------
      -- Setup the Control File --
      ----------------------------
      fh := fh2.script_open(in_filename     => tabs.ctl_file
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_LOADER_LENGTH);
      fh2.script_put_line(fh, 'OPTIONS (SKIP=1)');
      fh2.script_put_line(fh, 'LOAD DATA');
      fh2.script_put_line(fh, 'APPEND INTO TABLE "' || g_schema_name || '"."' || tabs.table_name || '"');
      fh2.script_put_line(fh, 'FIELDS CSV WITH EMBEDDED');
      fh2.script_put_line(fh, 'TRAILING NULLCOLS');
      --
      -- Add Column Spec and Bind Variable to Dynamic Cursor
      lc := '   (';
      for i in 1 .. num_cols
      loop
         grb_cldr_array_lvl := 0;
         case
         when desc_tab(i).col_type = DBMS_SQL.VARCHAR2_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                              ' CHAR(' || desc_tab(i).col_max_len       || ')');
            dbms_sql.define_column(c            => dyn_curs
                                  ,position     => i
                                  ,column       => vc2_buff
                                  ,column_size  => desc_tab(i).col_max_len);
            --
         when desc_tab(i).col_type = DBMS_SQL.CHAR_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                              ' CHAR(' || desc_tab(i).col_max_len       || ')');
            dbms_sql.define_column_char(c            => dyn_curs
                                       ,position     => i
                                       ,column       => char_buff
                                       ,column_size  => desc_tab(i).col_max_len);
            --
         when desc_tab(i).col_type = DBMS_SQL.NUMBER_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                                    ' FLOAT EXTERNAL' );
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => num_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.DATE_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                            ' DATE ''' || F_DATE                        || '''');
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => date_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                       ' TIMESTAMP ''' || F_TST                         || '''');
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => tstmp_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_WITH_TZ_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
    ' TIMESTAMP WITH TIME ZONE ''' || F_TSTTZ                       || '''');
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => tstmptz_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_WITH_LOCAL_TZ_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
' TIMESTAMP WITH LOCAL TIME ZONE ''' || F_TST                         || '''');
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => tstmpltz_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.INTERVAL_DAY_TO_SECOND_TYPE
         then
           fh2.script_put_line (fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
         ' INTERVAL DAY TO SECOND' ); -- Don't use F_IDTOS
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => intvlds_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.BLOB_TYPE
         then
            fh2.script_put_line(fh, '      -- BLOB data must be decoded from Base64 after loading');
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                  ' CHAR(1572864)' );  -- 1048576 * 1.5
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => blob_buff);
            --
$IF DBMS_DB_VERSION.VERSION > 19
$THEN
         when desc_tab(i).col_type = DBMS_SQL.JSON_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                  ' CHAR(1048576)' );
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => json_buff);
$END
            --
         when desc_tab(i).col_type = DBMS_SQL.CLOB_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                  ' CHAR(1048576)' );
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => clob_buff);
            --
         when     desc_tab(i).col_type      = DBMS_SQL.USER_DEFINED_TYPE
              and desc_tab(i).col_type_name = 'XMLTYPE'
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                  ' CHAR(1048576)' );
            dbms_sql.define_column(c         => dyn_curs
                                  ,position  => i
                                  ,column    => xml_buff);
            --
         when desc_tab(i).col_type = DBMS_SQL.RAW_TYPE
         then
            fh2.script_put_line(fh, lc || common_util.old_rpad(desc_tab(i).col_name,30) ||
                    ' CHAR(32767)' );
            dbms_sql.define_column_raw(c            => dyn_curs
                                      ,position     => i
                                      ,column       => raw_buff
                                      ,column_size  => desc_tab(i).col_max_len);
            --
         when desc_tab(i).col_type_name in ('SDO_ELEM_INFO_ARRAY', 'SDO_GEOMETRY', 'SDO_ORDINATE_ARRAY', 'SDO_POINT_TYPE', 'ST_GEOMETRY')
         then
            if installed_types_aa.EXISTS('grbsdo')
            then
               sql_txt := 'begin GRAB_SDO.GRB_CLDR_DEFINE(' || dyn_curs || ', ' || i || ', :1, :2, :3); end;';
               begin
                  execute immediate sql_txt using in out lc, in out fh, in out desc_tab;
               exception when others then
                  if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_SDO.GRB_CLDR_DEFINE'' must be declared')
                  then
                     raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                      SQL_TXT                  || CHR(10) ||
                                                      SQLERRM                  || CHR(10) ||
                                                      dbms_utility.format_error_backtrace );
                  end if;
               end;
            end if;
            --
         else
            raise_application_error(-20000, 'Unknown DBMS_SQL DESC_TAB3 col_type ' || desc_tab(i).col_type ||
                                          ', col_type_name ' || desc_tab(i).col_type_name ||
                                           ' for column ' || desc_tab(i).col_name ||
                                           ' in table ' || g_schema_name || '.' || tabs.table_name);
            --
         end case;
         lc := '   ,';
      end loop;
      --
      fh2.script_put_line(fh, '   )');
      fh2.script_close(fh);
      -------------------------
      -- Setup the Data File --
      -------------------------
      fh := fh2.script_open(in_filename     => tabs.dat_file
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_LOADER_LENGTH);
      disable_ras_policy(tabs.table_name);
      --
      -- Write the column header
      lc := '';
      for i in 1 .. num_cols
      loop
         -- List of column names
         fh2.script_put(fh, lc || '"' || desc_tab(i).col_name || '"');
         lc := ',';
      end loop;
      fh2.script_new_line(fh);
      --
      -- Fetch the Records
      -- The return from execute is undefined for queries
      junk := dbms_sql.execute(dyn_curs);
      while dbms_sql.fetch_rows(dyn_curs) > 0
      loop
         --
         -- Add the data
         lc := '';
         for i in 1 .. num_cols
         loop
            grb_cldr_array_lvl := 0;
            case
            when desc_tab(i).col_type = DBMS_SQL.VARCHAR2_TYPE
            then
               dbms_sql.column_value(c              => dyn_curs
                                    ,position       => i
                                    ,value          => vc2_buff
                                    ,column_error   => col_err
                                    ,actual_length  => col_len);
               -- VARCHAR2, CHAR, and CLOB use the same format
               show_col_err(tabs.table_name, 'VARCHAR2', i);
               fh2.script_put(fh, lc);
               if vc2_buff is not null
               then
                  clob_buff := '"' || replace(vc2_buff,'"','""')  || '"';
                  utf_put_clob;
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.CHAR_TYPE
            then
               dbms_sql.column_value_char(c              => dyn_curs
                                         ,position       => i
                                         ,value          => char_buff
                                         ,column_error   => col_err
                                         ,actual_length  => col_len);
               -- VARCHAR2, CHAR, and CLOB use the same fh2.script_put format
               show_col_err(tabs.table_name, 'CHAR', i);
               fh2.script_put(fh, lc);
               if char_buff is not null
               then
                  clob_buff := '"' || replace(substr(char_buff, 1, col_len)
                                             ,'"','""')           || '"';
                  utf_put_clob;
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.CLOB_TYPE
            then
               dbms_sql.column_value(c         => dyn_curs
                                    ,position  => i
                                    ,value     => clob_buff);
               -- VARCHAR2, CHAR, and CLOB use the same fh2.script_put format
               fh2.script_put(fh, lc);
               if clob_buff is not null
               then
                  clob_buff := '"' || replace(clob_buff,'"','""') || '"';
                  utf_put_clob;
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.NUMBER_TYPE
            then
               dbms_sql.column_value(c              => dyn_curs
                                    ,position       => i
                                    ,value          => num_buff
                                    ,column_error   => col_err
                                    ,actual_length  => col_len);
               show_col_err(tabs.table_name, 'NUMBER', i);
               fh2.script_put(fh, lc || to_char(num_buff));
               --
            when desc_tab(i).col_type = DBMS_SQL.DATE_TYPE
            then
               dbms_sql.column_value(c              => dyn_curs
                                    ,position       => i
                                    ,value          => date_buff
                                    ,column_error   => col_err
                                    ,actual_length  => col_len);
               show_col_err(tabs.table_name, 'DATE', i);
               fh2.script_put(fh, lc);
               if date_buff is not null
               then
                  fh2.script_put(fh, '"' || to_char(date_buff, F_DATE) || '"');
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_TYPE
            then
               dbms_sql.column_value(c         => dyn_curs
                                    ,position  => i
                                    ,value     => tstmp_buff);
               fh2.script_put(fh, lc);
               if tstmp_buff is not null
               then
                  fh2.script_put(fh, '"' || to_char(tstmp_buff,  F_TST) || '"');
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_WITH_TZ_TYPE
            then
               dbms_sql.column_value(c         => dyn_curs
                                    ,position  => i
                                    ,value     => tstmptz_buff);
               fh2.script_put(fh, lc);
               if tstmptz_buff is not null
               then
                  fh2.script_put(fh, '"' || to_char(tstmptz_buff,  F_TSTTZ) || '"');
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.TIMESTAMP_WITH_LOCAL_TZ_TYPE
            then
               dbms_sql.column_value(c          => dyn_curs
                                     ,position  => i
                                     ,value     => tstmpltz_buff);
               fh2.script_put(fh, lc);
               if tstmpltz_buff is not null
               then
                  fh2.script_put(fh, '"' || to_char(tstmpltz_buff,  F_TST) || '"');
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.INTERVAL_DAY_TO_SECOND_TYPE
            then
               dbms_sql.column_value(c          => dyn_curs
                                     ,position  => i
                                     ,value     => intvlds_buff);
               fh2.script_put(fh, lc);
               if intvlds_buff is not null
               then
                  fh2.script_put(fh, '"' || to_char(intvlds_buff,  F_IDTOS) || '"');
               end if;
               --
            when     desc_tab(i).col_type      = DBMS_SQL.USER_DEFINED_TYPE
                 and desc_tab(i).col_type_name = 'XMLTYPE'
            then
               dbms_sql.column_value(c         => dyn_curs
                                    ,position  => i
                                    ,value     => xml_buff);
               fh2.script_put(fh, lc);
               if xml_buff is not null
               then
                  if nvl(DBMS_LOB.GETLENGTH(xmltype.getClobVal(xml_buff)),0) <= 0
                  then
                     clob_buff := '';
                  else
                     -- This avoids a ORA-22275 "invalid LOB locator specified"
                     --DBMS_LOB.CREATETEMPORARY(lob_loc => clob_buff
                     --                        ,cache   => TRUE
                     --                        ,dur     => DBMS_LOB.CALL);
                     -- ORA-03001 from SUBSTR on output from getclobval from a binary XML (Doc ID 2016996.1)
                     --   The LOB returned by getClobVal() is an abstract CSX LOB
                     DBMS_LOB.COPY (dest_lob    => clob_buff
                                   ,src_lob     => xmltype.getClobVal(xml_buff)
                                   ,amount      => 2147483647   -- 2Gb - 1
                                   ,dest_offset => 1
                                   ,src_offset  => 1);
                     clob_buff := '"' || replace(clob_buff, '"', '""') || '"';
                  end if;
                  utf_put_clob;
               end if;
               --
            when desc_tab(i).col_type = DBMS_SQL.BLOB_TYPE
            then
               dbms_sql.column_value(c          => dyn_curs
                                     ,position  => i
                                     ,value     => blob_buff);
               fh2.script_put(fh, lc);
               if blob_buff is not null
               then
                  -- Note: b64_encode inserts Line Feeds in the data
                  clob_buff := '"' || COMMON_UTIL.b64_encode(blob_buff, TRUE) || '"';
                  utf_put_clob;
               end if;
               --
$IF DBMS_DB_VERSION.VERSION > 19
$THEN
            when desc_tab(i).col_type = DBMS_SQL.JSON_TYPE
            then
               dbms_sql.column_value(c         => dyn_curs
                                    ,position  => i
                                    ,value     => json_buff);
               -- VARCHAR2, CHAR, and CLOB use the same fh2.script_put format
               fh2.script_put(fh, lc);
               if json_buff is not null
               then
                  clob_buff := '"' || replace(json_serialize(json_buff returning clob pretty ascii)
                                             ,'"','""') || '"';
                  utf_put_clob;
               end if;
$END
               --
            when desc_tab(i).col_type = DBMS_SQL.RAW_TYPE
            then
               dbms_sql.column_value_raw(c              => dyn_curs
                                        ,position       => i
                                        ,value          => raw_buff
                                        ,column_error   => col_err
                                        ,actual_length  => col_len);
               show_col_err(tabs.table_name, 'RAW', i);
               fh2.script_put(fh, lc);
               if raw_buff is not null
               then
                  -- Note: b64_encode inserts Line Feeds in the data
                  clob_buff := '"' || COMMON_UTIL.b64_encode(raw_buff, TRUE) || '"';
                  utf_put_clob;
               end if;
               --
            when desc_tab(i).col_type_name in ('SDO_ELEM_INFO_ARRAY', 'SDO_GEOMETRY', 'SDO_ORDINATE_ARRAY', 'SDO_POINT_TYPE', 'ST_GEOMETRY')
            then
               if installed_types_aa.EXISTS('grbsdo')
               then
                  sql_txt := 'begin GRAB_SDO.GRB_CLDR_VALUE(' || dyn_curs || ', ' || i || ', :1, :2, :3); end;';
                  begin
                     execute immediate sql_txt using in out lc, in out fh, in out desc_tab;
                  exception when others then
                     if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_SDO.GRB_CLDR_VALUE'' must be declared')
                     then
                        raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                         SQL_TXT                  || CHR(10) ||
                                                         SQLERRM                  || CHR(10) ||
                                                         dbms_utility.format_error_backtrace );
                     end if;
                 end;
               end if;
               --
            else
               raise_application_error(-20000, 'Unknown DBMS_SQL DESC_TAB3 col_type ' || desc_tab(i).col_type ||
                                            ', col_type_name ' || desc_tab(i).col_type_name ||
                                             ' for column ' || desc_tab(i).col_name ||
                                             ' in table ' || g_schema_name || '.' || tabs.table_name);
               --
            end case;
            lc := ',';  -- Add comma after the first column
         end loop;
         --
         fh2.script_new_line(fh);
         --
      end loop;
      --
      enable_ras_policy(tabs.table_name);
      fh2.script_close(fh);
      -------------------------------
      -- Setup the SQL Script File --
      -------------------------------
      fh := fh2.script_open(in_filename     => tabs.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Comprehensive Data Loader script for ' || g_schema_name   ||
                                                                      '.' || tabs.table_name || ' data');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '-- Command Line Parameters:');
      fh2.script_put_line(fh, '--   1 - SYSTEM/password@TNSALIAS');
      fh2.script_put_line(fh, '--       i.e. pass the username and password for the SYSTEM user');
      fh2.script_put_line(fh, '--            and the TNSALIAS for the connection to the database.');
      fh2.script_put_line(fh, '--       The Data Load installation requires this connection information.');
      fh2.script_put_line(fh, '--');
      if tabs.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- Note: This is a "' || tabs.build_timing || '" Comprehensive Data Loader');
      end if;
      --
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'prompt');
      fh2.script_put_line(fh, 'prompt Disable Triggers and Foreign Keys');
      fh2.script_put_line(fh, 'declare');
      fh2.script_put_line(fh, '   procedure run_sql (in_sql in varchar2) is begin');
      fh2.script_put_line(fh, '      dbms_output.put_line(in_sql || '';'');');
      fh2.script_put_line(fh, '      execute immediate in_sql;');
      fh2.script_put_line(fh, '   exception when others then');
      fh2.script_put_line(fh, '      dbms_output.put_line(''-- '' || SQLERRM || CHR(10));');
      fh2.script_put_line(fh, '   end run_sql;');
      fh2.script_put_line(fh, 'begin');
      fh2.script_put_line(fh, '   for buff in (select owner, trigger_name');
      fh2.script_put_line(fh, '                 from  dba_triggers');
      fh2.script_put_line(fh, '                 where table_owner = ''' || g_schema_name || '''');
      fh2.script_put_line(fh, '                  and  table_name = ''' || tabs.table_name || '''');
      fh2.script_put_line(fh, '                 order by owner, trigger_name)');
      fh2.script_put_line(fh, '   loop');
      fh2.script_put_line(fh, '      run_sql(''alter trigger "'' || buff.owner        || ''"'' ||');
      fh2.script_put_line(fh, '                           ''."'' || buff.trigger_name || ''" DISABLE'');');
      fh2.script_put_line(fh, '   end loop;');
      fh2.script_put_line(fh, '   for buff in (select constraint_name');
      fh2.script_put_line(fh, '                 from  dba_constraints');
      fh2.script_put_line(fh, '                 where constraint_type = ''R''');
      fh2.script_put_line(fh, '                  and  owner = ''' || g_schema_name || '''');
      fh2.script_put_line(fh, '                  and  table_name = ''' || tabs.table_name || '''');
      fh2.script_put_line(fh, '                 order by constraint_name)');
      fh2.script_put_line(fh, '   loop');
      fh2.script_put_line(fh, '      run_sql(''alter table "' || g_schema_name || '"."' || tabs.table_name || '"'' ||');
      fh2.script_put_line(fh, '              '' DISABLE constraint "'' || buff.constraint_name || ''"'');');
      fh2.script_put_line(fh, '   end loop;');
      fh2.script_put_line(fh, '   for buff in (select owner, index_name');
      fh2.script_put_line(fh, '                 from  dba_indexes');
      fh2.script_put_line(fh, '                 where index_type = ''DOMAIN''');
      fh2.script_put_line(fh, '                  and  table_owner = ''' || g_schema_name || '''');
      fh2.script_put_line(fh, '                  and  table_name = ''' || tabs.table_name || '''');
      fh2.script_put_line(fh, '                 order by owner, index_name)');
      fh2.script_put_line(fh, '   loop');
      fh2.script_put_line(fh, '      run_sql(''alter index "'' || buff.owner || ''"."'' || buff.index_name || ''"'' ||');
      fh2.script_put_line(fh, '              '' DISABLE'');');
      fh2.script_put_line(fh, '   end loop;');
      fh2.script_put_line(fh, 'end;');
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- Additional file extensions');
      fh2.script_put_line(fh, '--   .bad - Bad Records');
      fh2.script_put_line(fh, '--   .dsc - Discard Records');
      fh2.script_put_line(fh, '--   .log - Log File');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'prompt');
      fh2.script_put_line(fh, 'prompt sqlldr_control=' || g_schema_name || '/' || tabs.ctl_file);
      fh2.script_put_line(fh, 'host sqlldr ''&1.'' control=' || g_schema_name || '/' || tabs.ctl_file ||
                                                    ' data=' || g_schema_name || '/' || tabs.dat_file ||
                                                     ' log=' || g_schema_name || '/' || tabs.log_file ||
                                                    ' silent=HEADER,FEEDBACK' );
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'begin');
      fh2.script_put_line(fh, '   if ''&_RC.'' != ''0'' then');
      fh2.script_put_line(fh, '      raise_application_error(-20000, ''Control file "' || g_schema_name || '/' || tabs.ctl_file ||
                                                                    '" returned error: &_RC.'');' );
      fh2.script_put_line(fh, '   end if;');
      fh2.script_put_line(fh, 'end;');
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
      --
      for i in 1 .. num_cols
      loop
         if desc_tab(i).col_type in (DBMS_SQL.BLOB_TYPE, DBMS_SQL.RAW_TYPE)
         then
            fh2.script_put_line(fh, 'declare');
            fh2.script_put_line(fh, '   l_blob          blob;');
            fh2.script_put_line(fh, '   the_blob        blob;');
            fh2.script_put_line(fh, '   procedure b64_decode');
            fh2.script_put_line(fh, '         (in_blob  in BLOB)');
            fh2.script_put_line(fh, '   is');
            fh2.script_put_line(fh, '      BASE64_ENCODE_HEADER      constant varchar2(30) := ''' || common_util.BASE64_ENCODE_HEADER || ''';');
            fh2.script_put_line(fh, '      SPLIT_LEN              constant pls_integer  := 32764;    -- Must be divisible by 4');
            fh2.script_put_line(fh, '      header_txt    varchar2(128);');
            fh2.script_put_line(fh, '      len_blob      pls_integer;');
            fh2.script_put_line(fh, '      ptr           pls_integer;');
            fh2.script_put_line(fh, '   begin');
            fh2.script_put_line(fh, '      dbms_lob.trim(l_blob, 0);');
            fh2.script_put_line(fh, '      dbms_lob.trim(the_blob, 0);');
            fh2.script_put_line(fh, '      ----------------------------------------');
            fh2.script_put_line(fh, '      -- Check incoming BLOB sizes (and return if needed)');
            fh2.script_put_line(fh, '      if in_blob is null then return; end if;');
            fh2.script_put_line(fh, '      len_blob := length(in_blob);');
            fh2.script_put_line(fh, '      if len_blob = 0 then return; end if;');
            fh2.script_put_line(fh, '      ----------------------------------------');
            fh2.script_put_line(fh, '      -- Check for BASE64_ENCODE_HEADER in in_BLOB');
            fh2.script_put_line(fh, '      header_txt := utl_raw.cast_to_varchar2(dbms_lob.substr(in_blob');
            fh2.script_put_line(fh, '                                                            ,length(BASE64_ENCODE_HEADER)');
            fh2.script_put_line(fh, '                                                            ,1)                       );');
            fh2.script_put_line(fh, '      if header_txt != BASE64_ENCODE_HEADER');
            fh2.script_put_line(fh, '      then');
            fh2.script_put_line(fh, '         raise_application_error(-20000, ''BASE64_ENCODE_HEADER missing from data: '' || header_txt);');
            fh2.script_put_line(fh, '      end if;');
            fh2.script_put_line(fh, '      ----------------------------------------');
            fh2.script_put_line(fh, '      -- Create "L_BLOB" after removing BASE64_ENCODE_HEADER, Carriage Returns, and Line Feeds');
            fh2.script_put_line(fh, '      ptr := 1 + length(BASE64_ENCODE_HEADER);  -- Skip over the header');
            fh2.script_put_line(fh, '      while ptr <= len_blob');
            fh2.script_put_line(fh, '      loop');
            fh2.script_put_line(fh, '         dbms_lob.append(l_blob');
            fh2.script_put_line(fh, '                        ,utl_raw.translate(dbms_lob.substr(in_blob');
            fh2.script_put_line(fh, '                                                          ,SPLIT_LEN');
            fh2.script_put_line(fh, '                                                          ,ptr)');
            fh2.script_put_line(fh, '                                          ,hextoraw(''000D0A'')       -- NULL, Carriage Return, Line Feed');
            fh2.script_put_line(fh, '                                          ,hextoraw(''00'')   )   );  -- NULL');
            fh2.script_put_line(fh, '         ptr := ptr + SPLIT_LEN;');
            fh2.script_put_line(fh, '      end loop;');
            fh2.script_put_line(fh, '      len_blob := length(l_blob);');
            fh2.script_put_line(fh, '      ----------------------------------------');
            fh2.script_put_line(fh, '      --  Create "THE_BLOB" after Base64 Decoding');
            fh2.script_put_line(fh, '      ptr := 1;');
            fh2.script_put_line(fh, '      while ptr <= len_blob');
            fh2.script_put_line(fh, '      loop');
            fh2.script_put_line(fh, '         dbms_lob.append(the_blob');
            fh2.script_put_line(fh, '                        ,UTL_ENCODE.BASE64_DECODE(dbms_lob.substr(l_blob');
            fh2.script_put_line(fh, '                                                                 ,SPLIT_LEN');
            fh2.script_put_line(fh, '                                                                 ,ptr)   )   );');
            fh2.script_put_line(fh, '         ptr := ptr + SPLIT_LEN;');
            fh2.script_put_line(fh, '      end loop;');
            fh2.script_put_line(fh, '   end b64_decode;');
            fh2.script_put_line(fh, 'begin');
            fh2.script_put_line(fh, '   dbms_lob.createtemporary(l_blob, true);');
            fh2.script_put_line(fh, '   dbms_lob.createtemporary(the_blob, true);');
            fh2.script_put_line(fh, '   for buff in (select ROWID RID, "' || desc_tab(i).col_name || '"');
            fh2.script_put_line(fh, '                 from  "' || g_schema_name || '"."' || tabs.table_name || '"');
            fh2.script_put_line(fh, '                 for update of "' || desc_tab(i).col_name || '")');
            fh2.script_put_line(fh, '   loop');
            fh2.script_put_line(fh, '      b64_decode(buff."' || desc_tab(i).col_name || '");');
            fh2.script_put_line(fh, '      -- This overwrites the Base64 Encoded String with the original binary data');
            fh2.script_put_line(fh, '      update "' || g_schema_name || '"."' || tabs.table_name || '"');
            fh2.script_put_line(fh, '        set  "' || desc_tab(i).col_name || '" = the_blob');
            fh2.script_put_line(fh, '       where rowid = buff.rid;');
            fh2.script_put_line(fh, '   end loop;');
            fh2.script_put_line(fh, '   dbms_lob.freetemporary(l_blob);');
            fh2.script_put_line(fh, '   dbms_lob.freetemporary(the_blob);');
            fh2.script_put_line(fh, 'end;');
            fh2.script_put_line(fh, '/');
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, 'commit;');
            fh2.script_put_line(fh, '');
         end if;
      end loop;
      --
      fh2.script_close(fh);
      --
      dbms_sql.close_cursor(dyn_curs);
      --
   end loop;
   --
end grb_comp_data_loader;

------------------------------------------------------------
-- Create Database Link
procedure grb_database_links
is
   ELMNT      CONSTANT varchar2(100) := 'DB_LINK';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in (select obj.object_name                      DB_LINK_NAME
                      ,replace(replace(obj.object_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                            FILE_NAME
                      ,obj.object_owner                     USERNAME
                      ,lnk.host
                      ,obj.build_timing
                 from  obj_install_object_tab  obj
                       join dba_db_links  lnk
                            on  lnk.owner   = obj.object_owner
                            and lnk.db_link = obj.object_name
                 where obj.build_type    = g_build_type
                  and  obj.object_owner  = g_schema_name
                  and  obj.element_name   = ELMNT
                 order by obj.object_name)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buf1.db_link_name ||' Database Link');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '-- Public Database Links can be captured in OBJECT_CONF');
      fh2.script_put_line(fh, '--   -) USERNAME:     PUBLIC');
      fh2.script_put_line(fh, '--   -) ELEMENT_NAME: DB_LINK');
      fh2.script_put_line(fh, '--   Sripts will be created in SYSTEM folder.');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- Note: This is a "' || buf1.build_timing || '" Database Link');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'begin');
      fh2.script_put_line(fh, '  for buff in (select db_link from dba_db_links');
      fh2.script_put_line(fh, '                where owner   = ''' || g_schema_name || '''');
      fh2.script_put_line(fh, '                 and  db_link like ''' || buf1.db_link_name || '%'')');
      fh2.script_put_line(fh, '  loop');
      fh2.script_put_line(fh, '     execute immediate ''drop database link '' || buff.db_link;');
      fh2.script_put_line(fh, '  end loop;');
      fh2.script_put_line(fh, 'end;');
      fh2.script_put_line(fh, '/');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- DBMS_METADATA will not create clear text passwords');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name || '.' || buf1.db_link_name);
      fh2.put_big_line(fh, g_schema_name || '.' || buf1.db_link_name || ' DB Link'
                      ,dbms_metadata.get_ddl(object_type => 'DB_LINK'
                                            ,name        => buf1.db_link_name
                                            ,schema      => g_schema_name)
                      ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- No grants on Database Links');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Synonyms - Non-unique Database Link name causes problems');
      fh2.script_put_line(fh, '--  because DBA_SYNONYMS does not display database link owner.');
      for buf2 in (select target_owner                 OWNER
                         ,synonym_name
                         ,build_type_selector
                    from  obj_install_synonym_tab
                    where build_type    = g_build_type
                     and  synonym_owner = g_schema_name
                     and  db_link       = buf1.db_link_name
                     and  element_name   = 'SYNONYM'
                    order by target_owner
                         ,synonym_name)
      loop
         fh2.script_put_line(fh, '');
         dbms_output.put_line('-- ' || buf2.build_type_selector || ' found.' || LF ||
                              '--   buf1.FILE_NAME = '    || buf1.file_name    || LF ||
                              '--   buf1.DB_LINK_NAME = ' || buf1.db_link_name || LF ||
                              '--   buf2.SYNONYM_NAME = ' || buf2.synonym_name || LF ||
                              '--   g_schema_name = '     || g_schema_name     || LF ||
                              '--   g_build_type = '    || g_build_type    );
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buf2.owner ||
                                                '.' || buf2.synonym_name);
         fh2.put_big_line(fh, buf2.owner || '.' || buf2.synonym_name || ' Synonym'
                         ,dbms_metadata.get_ddl(object_type => 'SYNONYM'
                                               ,name        => buf2.synonym_name
                                               ,schema      => buf2.owner)
                         ,common_util.MAXIMUM_SQL_LENGTH);
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_database_links;

------------------------------------------------------------
-- Create Database Trigger
--   There are no PUBLIC Database Triggers
--   https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/CREATE-TRIGGER-statement.html
procedure grb_database_triggers
is
   ELMNT      CONSTANT varchar2(100) := 'DATABASE_TRIGGER';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buff in (select object_name              TRIGGER_NAME
                      ,file_ext1
                      ,build_timing
                 from  obj_install_object_tab
                 where build_type    = g_build_type
                  and  object_owner  = g_schema_name
                  and  element_name   = ELMNT
                 order by trigger_name
                      ,file_ext1
                      ,build_timing)
   loop
      if NOT fh2.script_is_open(fh)
      then
         fh := fh2.script_open(in_filename     => replace(replace(g_schema_name,'$','_'),'%','_') || '.' || buff.file_ext1
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Database Triggers for ' || g_build_type);
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_timing || '" Trigger');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name      ||
                                             '.' || buff.trigger_name  );
      fh2.put_big_line(fh, g_schema_name || '.' || buff.trigger_name || ' Trigger'
                      ,COMMON_UTIL.escape_at_sign
                         (dbms_metadata.get_ddl
                            (object_type => 'TRIGGER'
                            ,name        => buff.trigger_name
                            ,schema      => g_schema_name) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_database_triggers;

------------------------------------------------------------
-- Create Database Directory
procedure grb_directories
is
   TYPE dir_aa_type is table of varchar2(1)
        index by dba_directories.directory_path%TYPE;
   dir_aa     dir_aa_type;
   dbuff      dba_directories.directory_path%TYPE;
   --  "create directory" should only be run by SYSTEM
   ELMNT      CONSTANT varchar2(100) := 'DIRECTORY';
   fh         fh2.sf_ptr_type;  -- object script file handle
   old_dir    dba_directories.directory_name%TYPE;
   sql_txt    varchar2(32767);
begin
   for buf1 in(select directory_name
                     ,grantee                   GRANTEE
                     ,privilege
                     ,max(grantable)            GRANTABLE
                     ,directory_path
                     ,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext1
                                                FILE_NAME
                     --,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext2
                     --                           BASH_NAME
                     --,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext3
                     --                           BATCH_NAME
                     ,build_timing
                from  priv_obj_dir_view
                where build_type       = g_build_type
                 and  directory_owner  = 'SYS'
                 and  element_name      = ELMNT
                group by directory_name
                     ,grantee
                     ,privilege
                     ,directory_path
                     ,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext1
                     --,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext2
                     --,replace(replace(directory_name,'$','_'),'%','_') || '.' || file_ext3
                     ,build_timing
                order by directory_name
                     ,grantee
                     ,privilege)
   loop
      if buf1.directory_name != nvl(old_dir,'###BOGUS###')
      then
         if old_dir is not null
         then
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         old_dir := buf1.directory_name;
         fh := fh2.script_open(in_filename     => buf1.file_name
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create ' || buf1.directory_name ||' Database Directory');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--   Duplicate CREATE DIRECTORY scripts will be created');
         fh2.script_put_line(fh, '--      in different build types because directories are');
         fh2.script_put_line(fh, '--      created based on permissions, not owners.');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '');
         -- If this is run by a DBA other than SYS, DBMS_METADATA
         --    will only return directories granted with GRANT option
         sql_txt := 'create or replace directory "' || buf1.directory_name || '"' || LF ||
                                         '   as ''' || buf1.directory_path || '''';
         fh2.put_big_line(fh, buf1.directory_name || ' Directory', sql_txt || ';', common_util.MAXIMUM_SQL_LENGTH);
         dir_aa(buf1.directory_path) := 'X';
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--  Grants');
         fh2.script_put_line(fh, '');
         for buf2 in (select directory_name
                            ,grantee                  GRANTEE
                            ,privilege
                       from  priv_obj_dir_view
                       where build_type      = 'pub'
                        --and  build_timing  = 'CURRENT'  All Public Directories are CURRENT
                        and  directory_owner = 'SYS'
                        and  element_name     = ELMNT
                       group by directory_name
                            ,grantee
                            ,privilege
                       order by directory_name
                            ,grantee
                            ,privilege)
         loop
            if buf2.directory_name = buf1.directory_name
            then
               fh2.script_put_line(fh, 'grant ' || buf2.privilege ||
                                       ' on directory "'  || buf1.directory_name ||
                                       '" to "' || buf2.grantee || '";');
            end if;
         end loop;
      end if;
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '-- Note: This is a "' || buf1.build_timing || '" Directory Grant');
      end if;
      -- Oracle Database 12c Release 1 Database SQL Language Reference
      -- "on_object_clause"
      -- Users, directory schema objects, editions, data mining models, Java
      --   source and resource schema objects, and SQL translation profiles
      --   are identified separately because they reside in separate namespaces.
      -- If this is run by a DBA other than SYS, DBMS_METADATA
      --    will only return directories granted with GRANT option
      sql_txt := 'grant ' || buf1.privilege ||
                  ' on directory "'  || buf1.directory_name ||
                  '" to "' || buf1.grantee || '"';
      -- Missing "with hierarchy option" ...
      if buf1.grantable = 'YES'
      then
         sql_txt := sql_txt || ' with grant option';
      end if;
      fh2.script_put_line(fh, sql_txt || ';');
      fh2.script_put_line(fh, '');
   end loop;
   if old_dir is not null
   then
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
      --dbms_output.put_line('buf1.bash_name = ' || buf1.bash_name);
      fh := fh2.script_open(in_filename     =>  'create_directories.sh'
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_BASH_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '#');
      fh2.script_put_line(fh, '#  Create Directories for Linux');
      fh2.script_put_line(fh, '#');
      fh2.script_put_line(fh, '');
      dbuff := dir_aa.FIRST;
      loop
         fh2.script_put_line(fh, 'mkdir -p '  || replace(dbuff,'\','/'));
         exit when dbuff = dir_aa.LAST;
         dbuff := dir_aa.NEXT(dbuff);
      end loop;
      fh2.script_put_line(fh, '');
      dbuff := dir_aa.FIRST;
      loop
         fh2.script_put_line(fh, 'chmod 777 ' || replace(dbuff,'\','/'));
         exit when dbuff = dir_aa.LAST;
         dbuff := dir_aa.NEXT(dbuff);
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_close(fh);
      --dbms_output.put_line('buf1.bash_name = ' || buf1.batch_name);
      fh := fh2.script_open(in_filename     => 'create_directories.bat'
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_CMD_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'REM');
      fh2.script_put_line(fh, 'REM  Create Directories for Windows');
      fh2.script_put_line(fh, 'REM');
      fh2.script_put_line(fh, '');
      dbuff := dir_aa.FIRST;
      loop
         fh2.script_put_line(fh, 'md '  || replace(dbuff,'/','\'));
         exit when dbuff = dir_aa.LAST;
         dbuff := dir_aa.NEXT(dbuff);
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'REM set db_owner=oracle');
      fh2.script_put_line(fh, '');
      dbuff := dir_aa.FIRST;
      loop
         fh2.script_put_line(fh, 'REM icacls '|| replace(dbuff,'/','\') || ' /grant %db_owner%:F /T');
         exit when dbuff = dir_aa.LAST;
         dbuff := dir_aa.NEXT(dbuff);
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_close(fh);
   end if;
end grb_directories;

------------------------------------------------------------
-- Create Foreign Keys
procedure grb_foreign_keys
      (in_elmnt  in varchar2)
is
   fh         fh2.sf_ptr_type;  -- object script file handle
   old_tab    varchar2(1000);
   fname      varchar2(1000);
begin
   old_tab := 'This is not a Table Name.';
   for buff in (select fk.base_table_name                   TABLE_NAME
                      ,replace(replace(fk.base_table_name,'$','_'),'%','_') || '.' || fk.file_ext1
                                                            FILE_NAME
                      ,fk.base_table_type
                      ,fk.foreign_key_name
                      ,fk.build_type_selector
                 from  obj_install_fkey_tab  fk
                 where fk.base_table_owner = g_schema_name  --Doesn't work with Views
                  and  fk.element_name      = in_elmnt
                  and  fk.build_type       = g_build_type
                 order by fk.base_table_name
                      ,fk.foreign_key_name  )
   loop
      if buff.table_name != old_tab
      then
         if fh2.script_is_open(fh)
         then
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         old_tab := buff.table_name;
         fh := fh2.script_open(in_filename     => buff.file_name
                              ,in_elmnt        => in_elmnt
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Foreign Keys for ' || g_schema_name   ||
                                                            '.' || buff.table_name ||
                                                            ' ' || buff.base_table_type);
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_type_selector || '" Foreign Key');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name        ||
                                             '.' || buff.foreign_key_name );
      fh2.put_big_line(fh, g_schema_name || '.' || buff.table_name || ' Ref Constraint'
                      ,dbms_metadata.get_ddl(object_type  => 'REF_CONSTRAINT'
                                            ,name         => buff.foreign_key_name
                                            ,schema       => g_schema_name)
                      ,common_util.MAXIMUM_SQL_LENGTH);
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_foreign_keys;

------------------------------------------------------------
-- Create Index Scripts
procedure grb_indexes
      (in_elmnt  in VARCHAR2)
is
   fh                fh2.sf_ptr_type;  -- object script file handle
   old_own           varchar2(1000);
   old_tab           varchar2(1000);
   fname             varchar2(1000);
   sql_txt           varchar2(1000);
begin
   old_own := 'This is not an Owner Name.';
   old_tab := 'This is not a Table name.';
   for buff in (select ind.table_owner
                      ,ind.table_name
                      ,replace(replace(ind.table_name,'$','_'),'%','_') || '.' || ind.file_ext1
                                                          FILE_NAME
                      ,ind.table_type
                      ,ind.index_owner
                      ,ind.index_name
                      ,ind.file_ext1                      INDEX_EXT
                      ,ind.index_type
                      ,ind.ityp_owner
                      ,ind.ityp_name
                      ,ind.build_type_selector
                 from  obj_install_index_tab  ind
                 where ind.build_type     = g_build_type
                  and  ind.index_owner    = g_schema_name
                  and  ind.element_name    = in_elmnt
                  and  ind.index_type    != 'LOB'    -- LOB Indexes are auto-created
                  and  (ind.table_owner, ind.table_name) not in (
                       select xt.owner, xt.table_name
                        from  dba_xml_tables  xt)      -- XMLTable Indexes are auto-created
                  and  not exists (
                       -- Primary Key and Unique Key Indexes are auto-created
                       select 'x' from dba_constraints cons
                        where cons.constraint_type in ('P','U')
                         and  cons.owner       = ind.table_owner
                         and  cons.table_name  = ind.table_name
                         and  cons.index_owner = ind.index_owner
                         and  cons.index_name  = ind.index_name)
                  and  NOT regexp_like(ind.index_name, common_util.ORACLE_TEXT_TABLE_REGEXP)
                  and  ind.index_name not like common_util.RECYCLE_BIN_PATTERN escape '\'
                  and  ind.index_name != common_util.MVIEW_AUTO_INDEX_PREFIX || ind.table_name
                 order by ind.table_owner
                      ,ind.table_name
                      ,ind.index_owner
                      ,ind.index_name)
   loop
      if    buff.table_owner != old_own
         or buff.table_name  != old_tab
      then
         if fh2.script_is_open(fh)
         then
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         old_own := buff.table_owner;
         old_tab := buff.table_name;
         if buff.table_owner = g_schema_name
         then
            fname := buff.file_name;
         else
            fname := buff.table_owner || '.' || buff.file_name;
         end if;
         fh := fh2.script_open(in_filename     => fname --buff.file_name
                              ,in_elmnt        => in_elmnt
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Indexes for ' || buff.table_owner ||
                                                       '.' || buff.table_name  ||
                                                       ' ' || buff.table_type  );
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_type_selector || '" Index');
      fh2.script_put_line(fh, '');
      if     buff.index_type = 'DOMAIN'
         AND buff.ityp_owner = 'MDSYS'
         AND installed_types_aa.EXISTS('grbsdo')
      then
         fh2.script_put_line(fh, '-- The MDSYS Domain Index "' || buff.index_owner ||
                                                         '"."' || buff.index_name  || CHR(10) ||
                                 '--   installation script is located in the "root" folder because' || CHR(10) ||
                                 '--   it must be executed using the "' || buff.index_owner || '" database login.');
         fh2.script_put_line(fh, '');
         --
         sql_txt := 'begin GRAB_SDO.GRB_IND(:1, :2, :3, :4, :5, :6, :7, :8); end;';
         begin
            execute immediate sql_txt using buff.table_owner, buff.table_name, buff.table_type,
                                            buff.index_owner, buff.index_name, buff.index_ext,
                                            buff.ityp_owner,  buff.ityp_name;
         exception when others then
            if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_SDO.GRB_IND'' must be declared')
            then
               raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                SQL_TXT                  || CHR(10) ||
                                                SQLERRM                  || CHR(10) ||
                                                dbms_utility.format_error_backtrace );
            end if;
         end;
      else
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buff.index_owner ||
                                                '.' || buff.index_name  );
         fh2.put_big_line(fh, g_schema_name || '.' || buff.table_name || ' ' || buff.table_type
                         ,dbms_metadata.get_ddl(object_type => 'INDEX'
                                               ,name        => buff.index_name
                                               ,schema      => buff.index_owner)
                         ,common_util.MAXIMUM_SQL_LENGTH);
      end if;
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_indexes;

------------------------------------------------------------
-- Create Master Installation Script
procedure grb_install_master
is
   fh         fh2.sf_ptr_type;  -- object script file handle
   fname      varchar2(1000) := 'install.sql';
   l_loc      varchar2(256)  := 'grb_install_master';
begin
   --
   fh := fh2.script_open(in_filename     => fname
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Master Installation Script');
   fh2.script_put_line(fh, '--    All scripts created by "https://ODBCapture.org", Version ' || get_version);
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Must be run as SYS');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '-- Command Line Parameters:');
   fh2.script_put_line(fh, '--   1 - TOP_PDB_SYSTEM: SYSTEM/password@TNSALIAS');
   fh2.script_put_line(fh, '--       i.e. pass the username and password for the SYSTEM user');
   fh2.script_put_line(fh, '--            and the TNSALIAS for the connection to the pluggable database.');
   fh2.script_put_line(fh, '--       The Data Load installation requires this connection information.');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--  NOTE: If running in a Linux based Docker Container from a Windows FileSystem Mount, run this first:');
   fh2.script_put_line(fh, '--    dos2unix -f -o ../install/*/*.csv ../install/*/*/*.csv');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'define TOP_PDB_SYSTEM="&1."');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt Setup Abort on Error');
   fh2.script_put_line(fh, 'WHENEVER SQLERROR EXIT SQL.SQLCODE');
   fh2.script_put_line(fh, 'WHENEVER OSERROR EXIT');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'set serveroutput on size unlimited format wrapped');
   fh2.script_put_line(fh, 'select ''user: '' || u.username ||');
   fh2.script_put_line(fh, '       '', db: '' || d.name ||');
   fh2.script_put_line(fh, '       '', con: '' || sys_context(''USERENV'', ''CON_NAME'') ||');
   fh2.script_put_line(fh, '       '', tstmp: '' || systimestamp   CONNECTION');
   fh2.script_put_line(fh, ' from  v$database d');
   fh2.script_put_line(fh, ' cross join user_users u;');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt Identify this Module in V$SESSION');
   fh2.script_put_line(fh, 'set appinfo "' || g_build_type || ' Installation"');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, 'prompt **************************');
   fh2.script_put_line(fh, 'prompt *  Run SYS Installation  *');
   fh2.script_put_line(fh, 'prompt **************************');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, '@install_sys.sql');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt Setup Continue on Error');
   fh2.script_put_line(fh, 'WHENEVER SQLERROR CONTINUE');
   fh2.script_put_line(fh, 'WHENEVER OSERROR CONTINUE');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, 'prompt *****************************');
   fh2.script_put_line(fh, 'prompt *  Run SYSTEM Installation  *');
   fh2.script_put_line(fh, 'prompt *****************************');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'connect &TOP_PDB_SYSTEM.');
   fh2.script_put_line(fh, 'set serveroutput on size unlimited format wrapped');
   fh2.script_put_line(fh, 'select ''user: '' || u.username ||');
   fh2.script_put_line(fh, '       '', db: '' || d.name ||');
   fh2.script_put_line(fh, '       '', con: '' || sys_context(''USERENV'', ''CON_NAME'') ||');
   fh2.script_put_line(fh, '       '', tstmp: '' || systimestamp   CONNECTION');
   fh2.script_put_line(fh, ' from  v$database d');
   fh2.script_put_line(fh, ' cross join user_users u;');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '@install_system.sql');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, 'prompt *************************');
   fh2.script_put_line(fh, 'prompt *  Install Application  *');
   fh2.script_put_line(fh, 'prompt *************************');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, '@install_' || g_build_type || '.sql "&TOP_PDB_SYSTEM."');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'set appinfo "Null"');
   fh2.script_put_line(fh, 'set appinfo off');
   fh2.script_put_line(fh, 'prompt');
   fh2.script_put_line(fh, 'prompt "' || g_build_type || '" Installation is Done.');
   fh2.script_put_line(fh, '');
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'dbi.sql'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.dbi_sql(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'installation_finalize.sql'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.installation_finalize_sql(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'installation_prepare.sql'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.installation_prepare_sql(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'odbcapture_installation_logs.cldr'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.odbcapture_installation_logs_cldr(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'odbcapture_installation_logs.csv'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.odbcapture_installation_logs_csv(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'odbcapture_installation_logs.ctl'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.odbcapture_installation_logs_ctl(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'report_status.sql'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.report_status_sql(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'list_invalids.csv'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.list_invalids_csv(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   fh := fh2.script_open(in_filename     => 'set_user_authentication.sql'
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   fh2.put_big_line(in_fh      => fh
                   ,in_loc     => l_loc
                   ,in_txt     => root_scripts.set_user_authentication_sql(g_build_type)
                   ,in_max_len => common_util.MAXIMUM_SQL_LENGTH);
   fh2.script_close(fh);
   --
   grb_ras_acls;               -- Moved from "gen_schemas"
   --
end grb_install_master;

------------------------------------------------------------
-- Create Schema (Non SYS/SYSTEM) Installation Script
procedure grb_install_schemas
is
   fh             fh2.sf_ptr_type;  -- object script file handle
   fname          varchar2(1000) := 'install_' || replace(replace(g_build_type,'$','_'),'%','_') || '.sql';
   file_id        pls_integer;
begin
   fh := fh2.script_open(in_filename     => fname
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   --
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  ' || g_build_type || ' Installation Script');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Must be run as a SYSTEM User (DBA)');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '-- Command Line Parameters:');
   fh2.script_put_line(fh, '--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS');
   fh2.script_put_line(fh, '--       i.e. pass the username and password for the SYSTEM user');
   fh2.script_put_line(fh, '--            and the TNSALIAS for the connection to the database.');
   fh2.script_put_line(fh, '--       The Data Load installation requires this connection information.');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool install_' || g_build_type || '.log');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'define INSTALL_SYSTEM_CONNECT="&1."');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '-- For Oracle Change Data Capture (CDC) packages');
   fh2.script_put_line(fh, 'set sqlprefix "~"');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '-- Escape character: "^P", CHR(16), DLE');
   fh2.script_put_line(fh, 'set escape OFF');
   fh2.script_put_line(fh, 'set escape "' || CHR(16) || '"');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, '--  Prepare for Install');
   fh2.script_put_line(fh, '@dbi.sql "./installation_prepare.sql" "" "&INSTALL_SYSTEM_CONNECT."');
   fh2.script_put_line(fh, '');
   --
   for buff in (select nvl(object_type, element_name)    OBJECT_TYPE
                      ,element_seq, file_ext2, file_ext3
                 from  element_conf
                 where element_seq > 0
                 order by element_seq)
   loop
      if fh2.sf_aa(g_build_type).EXISTS(buff.element_seq)
      then
         fh2.script_put_line(fh, '----------------------------------------');
         fh2.script_put_line(fh, '-- ' || buff.object_type || ' Install');
         fh2.script_put_line(fh, '');
         file_id := fh2.sf_aa(g_build_type)(buff.element_seq).FIRST;
         loop
            -- RegExp: "([.]ctl|[.]csv)$" Any string ending with ".ctl" or ".csv"
            if not regexp_like(fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename
                              , '([.]' || buff.file_ext2 ||
                                '|[.]' || buff.file_ext3 || ')$', 'i')
            then
               fh2.script_put_line(fh,
                  '@dbi.sql "' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).schema_name ||
                           '/' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename    ||
                         '" "' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).schema_name ||
                         '" "&INSTALL_SYSTEM_CONNECT."'                                          );
            end if;
            exit when file_id = fh2.sf_aa(g_build_type)(buff.element_seq).LAST;
            file_id := fh2.sf_aa(g_build_type)(buff.element_seq).NEXT(file_id);
         end loop;
         fh2.script_put_line(fh, '');
      end if;
   end loop;
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, '-- Finalize Installation (Includes SPOOL OFF)');
   fh2.script_put_line(fh, '@dbi.sql "./installation_finalize.sql" "" "&INSTALL_SYSTEM_CONNECT."');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool off');
   fh2.script_put_line(fh, '');
   --
   fh2.script_close(fh);
end grb_install_schemas;

------------------------------------------------------------
-- Create SYS Installation Script
procedure grb_install_sys
is
   fh            fh2.sf_ptr_type;  -- object script file handle
   fname         varchar2(1000) := 'install_sys.sql';
   file_id       pls_integer;
begin
   fh := fh2.script_open(in_filename     => fname
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   --
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  SYS Installation Script');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Must be run as SYS');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool install_sys.log');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'set blockterminator off');
   fh2.script_put_line(fh, 'set sqlblanklines on');
   fh2.script_put_line(fh, '');
   --
   for buff in (select nvl(object_type, element_name)    OBJECT_TYPE
                      ,element_seq, file_ext2, file_ext3
                 from  element_conf
                 where element_seq between -199 and -100
                 order by element_seq)
   loop
      if fh2.sf_aa(g_build_type).EXISTS(buff.element_seq)
      then
         fh2.script_put_line(fh, '----------------------------------------');
         fh2.script_put_line(fh, '-- ' || buff.object_type || ' Install');
         fh2.script_put_line(fh, '');
         file_id := fh2.sf_aa(g_build_type)(buff.element_seq).FIRST;
         loop
            -- RegExp: "([.]ctl|[.]csv)$" Any string ending with ".ctl" or ".csv"
            if not regexp_like(fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename
                              , '([.]' || buff.file_ext2 ||
                                '|[.]' || buff.file_ext3 || ')$', 'i')
            then
               fh2.script_put_line(fh,
                  '@dbi.sql "' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).schema_name ||
                           '/' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename    || '" "" ""' );
            end if;
            exit when file_id = fh2.sf_aa(g_build_type)(buff.element_seq).LAST;
            file_id := fh2.sf_aa(g_build_type)(buff.element_seq).NEXT(file_id);
         end loop;
         fh2.script_put_line(fh, '');
      end if;
   end loop;
   --
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'set sqlblanklines off');
   fh2.script_put_line(fh, 'set blockterminator on');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool off');
   fh2.script_put_line(fh, '');
   --
   fh2.script_close(fh);
end grb_install_sys;

------------------------------------------------------------
-- Create SYSTEM Installation Script
procedure grb_install_system
is
   fh            fh2.sf_ptr_type;  -- object script file handle
   fname         varchar2(1000) := 'install_system.sql';
   file_id       pls_integer;
begin
   fh := fh2.script_open(in_filename     => fname
                        ,in_elmnt        => 'INSTALL_SCRIPT'
                        ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   --
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  SYSTEM Installation Script');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Must be run as SYSTEM');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool install_system.log');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'set blockterminator off');
   fh2.script_put_line(fh, 'set sqlblanklines on');
   fh2.script_put_line(fh, '');
   --
   for buff in (select nvl(object_type, element_name)    OBJECT_TYPE
                      ,element_seq, file_ext2, file_ext3
                 from  element_conf
                 where element_seq between -99 and 0
                 order by element_seq)
   loop
      if fh2.sf_aa(g_build_type).EXISTS(buff.element_seq)
      then
         fh2.script_put_line(fh, '----------------------------------------');
         fh2.script_put_line(fh, '-- ' || buff.object_type || ' Install');
         fh2.script_put_line(fh, '');
         file_id := fh2.sf_aa(g_build_type)(buff.element_seq).FIRST;
         loop
            -- RegExp: "([.]ctl|[.]csv)$" Any string ending with ".ctl" or ".csv"
            if not regexp_like(fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename
                              , '([.]' || buff.file_ext2 ||
                                '|[.]' || buff.file_ext3 || ')$', 'i')
            then
               fh2.script_put_line(fh,
                  '@dbi.sql "' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).schema_name ||
                           '/' || fh2.sf_aa(g_build_type)(buff.element_seq)(file_id).filename    || '" "" ""' );
            end if;
            exit when file_id = fh2.sf_aa(g_build_type)(buff.element_seq).LAST;
            file_id := fh2.sf_aa(g_build_type)(buff.element_seq).NEXT(file_id);
         end loop;
         fh2.script_put_line(fh, '');
      end if;
   end loop;
   --
   fh2.script_put_line(fh, '----------------------------------------');
   fh2.script_put_line(fh, 'set sqlblanklines off');
   fh2.script_put_line(fh, 'set blockterminator on');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'spool off');
   fh2.script_put_line(fh, '');
   --
   fh2.script_close(fh);
end grb_install_system;

------------------------------------------------------------
-- Create Materialized View Scripts
procedure grb_materialized_views
is
   PELMNT     varchar2(100) := '';
   ELMNT      varchar2(100) := 'MVIEW';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in (with qmain as (
                select object_name                  MVIEW_NAME
                      ,replace(replace(object_name,'$','_'),'%','_') || '.' || file_ext1
                                                    FILE_NAME
                      ,build_timing
                 from  obj_install_object_tab
                 where build_type    = g_build_type
                  and  object_owner  = g_schema_name
                  and  element_name   = ELMNT
                 order by object_name
                ), qdep as (  -- Dependencies
                select object_name
                      ,referenced_name
                 from  dba_dependencies_tab
                 where object_owner     = g_schema_name
                  and  object_type      = 'MATERIALIZED VIEW'
                  and  referenced_owner = g_schema_name
                  and  referenced_type  = 'MATERIALIZED VIEW'
                  and  dependency_type  = 'REF'
                ), qroot as (  -- Root nodes have no dependencies
                select 0           LVL
                      ,obj.object_name
                 from  dba_objects_tab  obj
                 where obj.object_owner = g_schema_name
                  and  obj.object_type  = 'MATERIALIZED VIEW'
                  and  obj.object_name not in (select qdep.object_name from qdep)
                ), qlvl as (   -- Levels for all nodes
                select level                 LVL
                      ,qdep.object_name      OBJECT_NAME
                 from  qdep
                 connect by prior qdep.referenced_name = qdep.object_name
                 start with qdep.referenced_name in (select qroot.object_name from qroot)
                ), q_all as (  -- Combine root/dependent nodes
                select lvl, object_name from qroot
                union all
                select max(lvl) lvl, object_name from qlvl
                 group by object_name
                )  -- Main query
                select qmain.mview_name
                      ,ltrim(to_char(nvl(q_all.lvl,-1)+1,'09')) || '_' || qmain.file_name
                                                   FILE_NAME
                      ,qmain.build_timing
                 from  qmain
                  left join q_all
                       on (q_all.object_name = qmain.mview_name)
                order by 1, 2)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buf1.mview_name || ' Materialized View');
      fh2.script_put_line(fh, '--');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- NOTE: This is a "' || buf1.build_timing || '" Materialized View');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buf1.mview_name);
      fh2.put_big_line(fh, g_schema_name || '.' || buf1.mview_name || ' Materialized View'
                      ,COMMON_UTIL.split_sql_length
                         (COMMON_UTIL.escape_at_sign
                            (dbms_metadata.get_ddl
                               (object_type => 'MATERIALIZED_VIEW'
                               ,name        => buf1.mview_name
                               ,schema      => g_schema_name) ) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Comments');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buf1.mview_name);
      BEGIN
         fh2.put_big_line(fh, g_schema_name || '.' || buf1.mview_name || ' Materialized View'
                         ,dbms_metadata.get_dependent_ddl(object_type        => 'COMMENT'
                                                         ,base_object_name   => buf1.mview_name
                                                         ,base_object_schema => g_schema_name)
                         ,common_util.MAXIMUM_SQL_LENGTH);
      EXCEPTION
         WHEN DBMS_METADATA.object_not_found2
         THEN
            null;
      END;
      fh2.script_put_line(fh, '');
      -- Materialized Views are listed as Tables in DBA_TAB_PRIVS
      grb_object_grants(fh, buf1.mview_name, 'TABLE');
      grb_object_synonyms(fh, buf1.mview_name, 'MATERIALIZED VIEW', common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_materialized_views;

------------------------------------------------------------
-- Create PL/SQL Java Source
procedure grb_plsql_java
is
   SQL_TXT   constant varchar2(1000) := 'begin GRAB_JAVA.GRB_PJAVA; end;';
begin
   if NOT installed_types_aa.EXISTS('grbjava') then return; end if;
   execute immediate SQL_TXT;
exception when others then
   if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_JAVA.GRB_PJAVA'' must be declared')
   then
      raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                       SQL_TXT                  || CHR(10) ||
                                       SQLERRM                  || CHR(10) ||
                                       dbms_utility.format_error_backtrace );
   end if;
end grb_plsql_java;

------------------------------------------------------------
-- Create Roles and SYS Grants
procedure grb_roles
is
   ELMNT     CONSTANT varchar2(100) := 'ROLE';
   fh        fh2.sf_ptr_type;  -- object script file handle
   sql_txt   varchar2(32767);
begin
   for buf1 in
      (select user_or_role                 ROLENAME
             ,replace(replace(user_or_role,'$','_'),'%','_') || '.' || file_ext1
                                           FILE_NAME
        from  uor_install_view
        where uor_type = 'ROLE'
         and  build_type    = g_build_type
         and  oracle_provided = 'N'
        order by user_or_role)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      dbms_output.put_line('buf1.file_name = ' || buf1.file_name);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || buf1.rolename || ' Role');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'create role ' || buf1.rolename || ';');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Current Grant of YS Objects (but not directories)');
      fh2.script_put_line(fh, '');
      for buf2 in (select object_owner              OWNER
                         ,object_name               TABLE_NAME
                         ,privilege
                         ,max(grantable)            GRANTABLE
                    from  priv_sysobj_privileges_view
                    where grantee      = buf1.rolename
                     and  build_type   = g_build_type
                     and  build_timing = 'CURRENT'
                     and  object_type != 'DIRECTORY' -- All directories are owned by SYS
                          -- Keep LCR$ Logical Change Record
                          -- Keep AQ$ Queue Tables and Views
                          -- SYS_PLSQL Pipelined Type Objects are recreated automatically
                     and  object_name not like common_util.SYS_PIPELINE_PATTERN escape '\'
                          -- Skip QT*_BUFFER Queue Views here. Grant Views with Advanced Queue
                          --   https://blogs.oracle.com/db/entry/oracle_support_master_note_for_troubleshooting_advanced_queuing_and_oracle_streams_propagation_issue
                          --   "Note that when queue table is created, a view called QT<nnn>_BUFFER is created in the SYS schema, and the queue table owner is given
                          --    SELECT privileges on it. The <nnn> corresponds to the object_id of the associated queue table"
                     and  object_name not like common_util.ADV_QUEUE_VIEW_PATTERN escape '\'
                    group by object_owner
                         ,object_name
                         ,grantee
                         ,privilege
                    order by object_owner
                         ,object_name
                         ,grantee
                         ,privilege)
      loop
         -- No appropriate DBMS_METADATA.  Manually create the SQL.
         sql_txt := 'grant ' || buf2.privilege ||
                     ' on "' || buf2.owner || '"."' || buf2.table_name || '"' ||
                     ' to "' || buf1.rolename || '"';
         -- Missing "with hierarchy option" ...
         -- Does not work for ROLES ...
         --if buf2.grantable = 'YES'
         --then
         --   sql_txt := sql_txt || ' with grant option';
         --end if;
         fh2.put_big_line(fh, buf2.owner || '.' || buf2.table_name ||
                         ' Grant', sql_txt || ';'
                         ,common_util.MAXIMUM_SQL_LENGTH);
      END LOOP;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_roles;

------------------------------------------------------------
-- Create Table Scripts
procedure grb_tables
is
   PELMNT     varchar2(100) := '';
   ELMNT      varchar2(100) := 'TABLE';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in (select obj.object_name                      TABLE_NAME
                      ,replace(replace(obj.object_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                            FILE_NAME
                      ,obj.build_timing
                      ,xt.table_name                        XML_TABLE_NAME
                 from  obj_install_object_tab  obj
                  left join dba_xml_tables  xt
                            on  xt.owner      = obj.object_owner
                            and xt.table_name = obj.object_name
                 where obj.build_type    = g_build_type
                  and  obj.object_owner  = g_schema_name
                  and  obj.element_name   = ELMNT
                       -- Skip Oracle Text Supplemental Tables
                  and  NOT regexp_like(obj.object_name, common_util.ORACLE_TEXT_TABLE_REGEXP)
                       -- Skip Spatial Data Object Supplemental Tables
                  and  NOT regexp_like(obj.object_name, common_util.SDO_TABLE_REGEXP)
                       -- Skip Indexed Organized Overflow Tables
                       -- Skip Indexed Organized Mapping Tables
                  and  not exists (select 'x' from dba_tables tab
                                    where tab.owner      = g_schema_name
                                     and  tab.table_name = obj.object_name
                                     and  tab.iot_type  in ('IOT_OVERFLOW','IOT_MAPPING') )
                       -- Skip Materialized View Tables (not the view itself)
                  and  not exists (select 'x' from dba_mviews mv
                                    where mv.owner      = g_schema_name
                                     and  mv.mview_name = obj.object_name)
                       -- Skip Queue Tables, create with Advanced Queues
                  and  not exists (select 'x' from dba_queue_tables qt
                                    where qt.owner = g_schema_name
                                     and  (   obj.object_name = qt.queue_table
                                           or regexp_like(obj.object_name,common_util.ADV_QUEUE_PREFIX_REGEXP ||
                                                                          qt.queue_table                      ||
                                                                          common_util.ADV_QUEUE_SUFFIX_REGEXP  )  )  )
       order by obj.object_name )
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buf1.table_name || ' Table');
      fh2.script_put_line(fh, '--');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- NOTE: This is a "' || buf1.build_timing || '" Table');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
--      if buf1.table_type = 'XMLTABLE'
--      then
--         --  DBMS_METADATA incorrectly creates XMLTables with the
--         --  "ALLOW NONSCHEMA DISALLOW ANYSCHEMA" clause, but without the
--         --  "XMLTYPE STORE AS BINARY XML" clause, resulting in an ORA-00922
--         fh2.script_put_line(fh, 'CREATE TABLE "' || g_schema_name   ||
--                                            '"."' || buf1.table_name || '" OF XMLTYPE;');
--      else
        fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name   ||
                                               '.' || buf1.table_name );
         fh2.put_big_line(fh, g_schema_name || '.' || buf1.table_name || ' Table'
                         ,dbms_metadata.get_ddl(object_type => 'TABLE'
                                               ,name        => buf1.table_name
                                               ,schema      => g_schema_name)
                         ,common_util.MAXIMUM_SQL_LENGTH);
--      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Comments');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                             '.' || buf1.table_name);
      BEGIN
         fh2.put_big_line(fh, g_schema_name || '.' || buf1.table_name || ' Table'
                         ,dbms_metadata.get_dependent_ddl(object_type        => 'COMMENT'
                                                         ,base_object_name   => buf1.table_name
                                                         ,base_object_schema => g_schema_name)
                         ,common_util.MAXIMUM_SQL_LENGTH);
      EXCEPTION
         WHEN DBMS_METADATA.object_not_found2
         THEN
            null;
      END;
      fh2.script_put_line(fh, '');
      grb_object_grants(fh, buf1.table_name, 'TABLE');
      grb_object_synonyms(fh, buf1.table_name, 'TABLE', common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_tables;

------------------------------------------------------------
-- Create Trigger Scripts
procedure grb_triggers
      (in_elmnt   in varchar2)
is
   fh         fh2.sf_ptr_type;  -- object script file handle
   old_own    varchar2(1000);
   old_tab    varchar2(1000);
   fname      varchar2(1000);
begin
   old_own := 'This is not an Owner Name.';
   old_tab := 'This is not a Table name.';
   for buff in (select target_name                 TABLE_NAME
                      ,target_owner                TABLE_OWNER
                      ,replace(replace(target_name,'$','_'),'%','_') || '.' || file_ext1
                                                   FILE_NAME
                      ,target_type
                      ,trigger_name
                      ,build_type_selector
                 from  obj_install_trigger_tab
                 where trigger_owner = g_schema_name
                  and  element_name   = in_elmnt
                  and  build_type    = g_build_type
                 order by target_owner
                      ,target_name
                      ,trigger_name  )
   loop
      if    buff.table_owner != old_own
         or buff.table_name  != old_tab
      then
         if fh2.script_is_open(fh)
         then
            fh2.script_put_line(fh, '');
            fh2.script_put_line(fh, 'set define on');
            fh2.script_close(fh);
         end if;
         old_own := buff.table_owner;
         old_tab := buff.table_name;
         if buff.table_owner = g_schema_name
         then
            fname := buff.file_name;
         else
            fname := buff.table_owner || '.' || buff.file_name;
         end if;
         fh := fh2.script_open(in_filename     => fname    -- buff.file_name
                              ,in_elmnt        => in_elmnt
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Triggers for ' || buff.table_owner ||
                                                        '.' || buff.table_name  ||
                                                        ' ' || buff.target_type );
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_type_selector || '" Trigger');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name      ||
                                             '.' || buff.trigger_name  );
      fh2.put_big_line(fh, g_schema_name || '.' || buff.trigger_name || ' Trigger'
                      ,COMMON_UTIL.escape_at_sign
                         (dbms_metadata.get_ddl
                            (object_type => 'TRIGGER'
                            ,name        => buff.trigger_name
                            ,schema      => g_schema_name) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_triggers;

------------------------------------------------------------
-- Create Users and SYS Grants
procedure grb_users
is
   ELMNT     CONSTANT varchar2(100) := 'USER';
   fh        fh2.sf_ptr_type;  -- object script file handle
   sql_txt   varchar2(32767);
begin
   for buf1 in (select sc.username
                      ,replace(replace(sc.username,'$','_'),'%','_') || '.' || ec.file_ext1
                                                      FILE_NAME
                      ,sc.profile
                      ,sc.temporary_tspace
                      ,sc.default_tspace
                      ,sc.ts_quota
                 from  schema_conf  sc
                       join element_conf  ec
                            on  ec.element_name = ELMNT
                 where sc.build_type      = g_build_type
                  and  sc.oracle_provided = 'N'
                 order by sc.username)
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || buf1.username || ' Schema');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'create user "' || buf1.username || '"');
      fh2.script_put_line(fh, '   no authentication');
      fh2.script_put_line(fh, '   profile ' || nvl(buf1.profile, 'DEFAULT'));
      fh2.script_put_line(fh, '   temporary tablespace ' || nvl(buf1.temporary_tspace, 'TEMP'));
      if buf1.default_tspace is not null
      then
         fh2.script_put_line(fh, '   default tablespace ' || buf1.default_tspace);
         fh2.script_put_line(fh, '   quota ' || nvl(buf1.ts_quota, 'UNLIMITED') ||
                                      ' on ' || buf1.default_tspace);
         for buf2 in (select tspace_name, ts_quota
                       from  tspace_conf
                       where username = buf1.username)
         loop
            fh2.script_put_line(fh, '   quota ' || nvl(buf2.ts_quota, 'UNLIMITED') ||
                                         ' on ' || buf2.tspace_name);
         end loop;
         fh2.script_put_line(fh, '   ;');
      else
         fh2.script_put_line(fh, '   ;');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Current Grant of SYS Objects (but not directories)');
      fh2.script_put_line(fh, '');
      for buf2 in (select object_owner
                         ,object_name
                         ,object_type
                         ,privilege
                         ,max(grantable)            GRANTABLE
                    from  priv_sysobj_privileges_view
                    where grantee      = buf1.username
                     and  build_type   = g_build_type
                     and  build_timing = 'CURRENT'
                     and  object_type != 'DIRECTORY' -- All directories are owned by SYS
                          -- Keep LCR$ Logical Change Record
                          -- Keep AQ$ Queue Tables and Views
                          -- SYS_PLSQL Pipelined Type Objects are recreated automatically
                     and  object_name not like common_util.SYS_PIPELINE_PATTERN escape '\'
                          -- Skip QT*_BUFFER Queue Views here. Grant Views with Advanced Queue
                          --   https://blogs.oracle.com/db/entry/oracle_support_master_note_for_troubleshooting_advanced_queuing_and_oracle_streams_propagation_issue
                          --   "Note that when queue table is created, a view called QT<nnn>_BUFFER is created in the SYS schema, and the queue table owner is given
                          --    SELECT privileges on it. The <nnn> corresponds to the object_id of the associated queue table"
                     and  object_name not like common_util.ADV_QUEUE_VIEW_PATTERN escape '\'
                    group by object_owner
                         ,object_name
                         ,object_type
                         ,privilege
                    order by object_owner
                         ,object_name
                         ,object_type
                         ,privilege)
      loop
         -- No appropriate DBMS_METADATA.  Manually create the SQL.
         --
         --  These "types" don't require a grant quailifier:
         --    -) FUNCTION
         --    -) INDEXTYPE
         --    -) LIBRARY
         --    -) MATERIALIZED VIEW
         --    -) OPERATOR
         --    -) PACKAGE
         --    -) PROCEDURE
         --    -) SEQUENCE
         --    -) TABLE
         --    -) TYPE
         --    -) VIEW
         --
         --  Other forms (and "types") include:
         --    -) ON DIRECTORY (DIRECTORY)         - Handled in "grb_directories"
         --    -) ON USER (USER)                   - Handled HERE and in "grb_object_grants"
         --    -) ON EDITION (EDITION)             - Handled HERE and in "grb_object_grants"
         --    -) ON JAVA SOURCE (JAVA CLASS)      - Handled HERE and in "grb_object_grants" and "grb_plsql_java"
         --    -) ON JAVA RESOURCE (JAVA RESOURCE) - Handled HERE and in "grb_object_grants"
         --    -) ON MINING MODEL (MLE LANGUAGE?)  - Not Handled
         --    -) ON SQL TRANSLATION PROFILE (???) - Not Handled
         --
         sql_txt := 'grant ' || buf2.privilege ||
                      ' on ' || case buf2.object_type when 'JAVA CLASS'    then 'JAVA SOURCE "'   || buf2.object_owner || '"."'
                                                      when 'JAVA SOURCE'   then 'JAVA SOURCE "'   || buf2.object_owner || '"."'
                                                      when 'JAVA RESOURCE' then 'JAVA RESOURCE "' || buf2.object_owner || '"."'
                                                      when 'EDITION'       then 'EDITION "'
                                                      when 'USER'          then 'USER "'
                                                                           else '"'               || buf2.object_owner || '"."'
                                end                                                               || buf2.object_name  ||
                    '" to "' || buf1.username || '"';
         -- Missing "with hierarchy option"...
         if buf2.grantable = 'YES'
         then
            sql_txt := sql_txt || ' with grant option';
         end if;
         fh2.put_big_line(fh, buf2.object_owner || '"."' || buf2.object_name ||
                         ' Grant', sql_txt || ';'
                         ,common_util.MAXIMUM_SQL_LENGTH);
      END LOOP;
      --
      if installed_types_aa.EXISTS('grbjava')
      then
         sql_txt := 'begin GRAB_JAVA.GRB_SYSGRNT(:1, ''' || buf1.username  ||
                                               ''', ''' || buf1.file_name ||
                                               ''', ''' || ELMNT          ||
                                               ''', ''CURRENT''); end;';
         begin
            execute immediate sql_txt using in out fh;
         exception when others then
            if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_JAVA.GRB_SYSGRNT'' must be declared')
            then
               raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                SQL_TXT                  || CHR(10) ||
                                                SQLERRM                  || CHR(10) ||
                                                dbms_utility.format_error_backtrace );
            end if;
         end;
      end if;
      --
      if installed_types_aa.EXISTS('grbras')
      then
         sql_txt := 'begin GRAB_RAS.GRB_USR(:1, ''' || buf1.username || '''); end;';
         begin
            execute immediate sql_txt using in out fh;
         exception when others then
            if NOT regexp_like (SQLERRM, 'PLS-00201: identifier ''GRAB_RAS.GRB_USR'' must be declared')
            then
               raise_application_error(-20000, 'Execute Immediate ERROR' || CHR(10) ||
                                                SQL_TXT                  || CHR(10) ||
                                                SQLERRM                  || CHR(10) ||
                                                dbms_utility.format_error_backtrace );
            end if;
         end;
      end if;
      --
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_users;

------------------------------------------------------------
-- Create Schema Trigger
--   There are no PUBLIC Schema Triggers
--   https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/CREATE-TRIGGER-statement.html
procedure grb_user_triggers
is
   ELMNT      CONSTANT varchar2(100) := 'SCHEMA_TRIGGER';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buff in (select object_name              TRIGGER_NAME
                      ,file_ext1
                      ,build_timing
                 from  obj_install_object_tab
                 where build_type    = g_build_type
                  and  object_owner  = g_schema_name
                  and  element_name   = ELMNT
                 order by trigger_name
                      ,file_ext1
                      ,build_timing)
   loop
      if NOT fh2.script_is_open(fh)
      then
         fh := fh2.script_open(in_filename     => replace(replace(g_schema_name,'$','_'),'%','_') || '.' || buff.file_ext1
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '--  Create Schema Triggers for ' || g_build_type);
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  NOTE: This is a "' || buff.build_timing || '" Trigger');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name      ||
                                             '.' || buff.trigger_name  );
      fh2.put_big_line(fh, g_schema_name || '.' || buff.trigger_name || ' Trigger'
                      ,COMMON_UTIL.escape_at_sign
                         (dbms_metadata.get_ddl
                            (object_type => 'TRIGGER'
                            ,name        => buff.trigger_name
                            ,schema      => g_schema_name) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
   end loop;
   if fh2.script_is_open(fh)
   then
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end if;
end grb_user_triggers;


------------------------------------------------------------
-- Create View Scripts
procedure grb_views
is
   PELMNT     varchar2(100) := '';
   ELMNT      varchar2(100) := 'VIEW';
   fh         fh2.sf_ptr_type;  -- object script file handle
begin
   for buf1 in (select obj.object_name                      VIEW_NAME
                      ,replace(replace(obj.object_name,'$','_'),'%','_') || '.' || obj.file_ext1
                                                            FILE_NAME
                      ,obj.build_timing
                 from  obj_install_object_tab  obj
                  left join dba_xml_tables  xt
                            on  xt.owner      = obj.object_owner
                            and xt.table_name = obj.object_name
                 where obj.build_type    = g_build_type
                  and  obj.object_owner  = g_schema_name
                  and  obj.element_name   = ELMNT
                       -- Skip Queue Table Views, create with Advanced Queue
                  and  not exists (select 'x' from dba_queue_tables qt
                                    where qt.owner = g_schema_name
                                     and  (   obj.object_name = qt.queue_table
                                           or regexp_like(obj.object_name,common_util.ADV_QUEUE_PREFIX_REGEXP ||
                                                                          qt.queue_table                      ||
                                                                          common_util.ADV_QUEUE_SUFFIX_REGEXP  )  )  )
       order by obj.object_name )
   loop
      fh := fh2.script_open(in_filename     => buf1.file_name
                           ,in_elmnt        => ELMNT
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Create ' || g_schema_name || '.' || buf1.view_name || ' view');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define off');
      fh2.script_put_line(fh, '');
      if buf1.build_timing != 'CURRENT'
      then
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '-- Note: This is a "' || buf1.build_timing || '" View');
      end if;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--');
      fh2.script_put_line(fh, '--  Cannot grant permisions on a view with an error');
      fh2.script_put_line(fh, '--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987');
      fh2.script_put_line(fh, 'create view "' || g_schema_name || '"."' || buf1.view_name || '"');
      fh2.script_put_line(fh, '  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;');
      grb_object_grants(fh, buf1.view_name, 'VIEW');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                               '.' || buf1.view_name);
      fh2.put_big_line(fh, g_schema_name || '.' || buf1.view_name || ' View'
                      ,COMMON_UTIL.split_sql_length
                         (COMMON_UTIL.escape_at_sign
                            (dbms_metadata.get_ddl
                               (object_type => 'VIEW'
                               ,name        => buf1.view_name
                               ,schema      => g_schema_name) ) )
                      ,common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--  Comments');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--DBMS_METADATA:' || g_schema_name ||
                                           '.' || buf1.view_name);
      BEGIN
         fh2.put_big_line(fh, g_schema_name || '.' || buf1.view_name || ' View'
                         ,dbms_metadata.get_dependent_ddl(object_type        => 'COMMENT'
                                                         ,base_object_name   => buf1.view_name
                                                         ,base_object_schema => g_schema_name)
                         ,common_util.MAXIMUM_SQL_LENGTH);
      EXCEPTION
         WHEN DBMS_METADATA.object_not_found2
         THEN
            null;
      END;
      fh2.script_put_line(fh, '');
      grb_object_grants(fh, buf1.view_name, 'VIEW');
      grb_object_synonyms(fh, buf1.view_name, 'VIEW', common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
   end loop;
end grb_views;


------------------------------------------------------------
---   Setup and Main Control  ---
------------------------------------------------------------


------------------------------------------------------------
-- Set Installed Types
procedure set_installed_types
is
   -- ORA-00942: table or view does not exist
   table_does_not_exist  EXCEPTION;
   PRAGMA EXCEPTION_INIT(table_does_not_exist, -942);
   TYPE rcurs_type is ref cursor;
   rcurs     rcurs_type;
   btype     build_conf.build_type%TYPE;
begin
   -- Load INSTALLED_TYPES Array
   installed_types_aa.DELETE;
   open rcurs for 'select distinct build_type from odbcapture_installation_logs';
   loop
      fetch rcurs into btype;
      exit when rcurs%NOTFOUND;
      installed_types_aa(btype) := 'Y';
   end loop;
   if NOT installed_types_aa.EXISTS('grbsrc')
   then
      raise_application_error(-20000, 'Unable to find "grbsrc" in odbcapture_installation_log');
   end if;
   dbms_output.put_line($$PLSQL_UNIT || '.set_installed_types: ' || installed_types_aa.COUNT || ' Build Types in ODBCAPTURE_INSTALLATION_LOG');
exception when table_does_not_exist then
   null;
end set_installed_types;


------------------------------------------------------------
-- Initialize this Package
procedure initialize
      (in_build_type  in varchar2)
is
   -- Set the Installation Type
   procedure set_build_type
   is
      l_notes   build_conf.notes%type;
   begin
      if in_build_type in ('sys','pub')
      then
         raise_application_error (-20000, 'Build Type of "sys" or "pub" is not allowed: ' || in_build_type);
      end if;
      begin
         select notes
          into  l_notes
          from  BUILD_CONF
          where build_type = in_build_type;
      exception when NO_DATA_FOUND then
         raise_application_error (-20000, 'Invalid Build Type: ' || in_build_type);
      end;
      g_build_type  := in_build_type;
      dbms_output.put_line('g_build_type = ' || g_build_type || ', ' || l_notes);
   end set_build_type;
   --
begin
   -- Reset
   fh2.script_close_all;
   g_build_type   := null;
   g_schema_name    := null;
   -- Set Globals
   set_build_type;
   if fh2.sf_aa.EXISTS(g_build_type) then fh2.sf_aa(g_build_type).DELETE; end if;
   --  Checks and Settings
   COMMON_UTIL.check_windows_filenames(g_build_type);
   COMMON_UTIL.dbms_metadata_settings;
end initialize;


------------------------------------------------------------
-- Set the Schema Name
procedure set_schema_name
      (in_schema_name  in varchar2)
is
begin
   g_schema_name := in_schema_name;
   dbms_output.put_line('g_schema_name = ' || g_schema_name);
end set_schema_name;


------------------------------------------------------------
-- Generate SYS/SYSTEM Installation Scripts
procedure gen_installs
is
begin
   ------------------------------------------------------------
   set_schema_name('SYS');
   grb_future_sys_grants;     -- "FUTURE" SYS Object Grants
   grb_database_triggers;
   grb_host_acls;
   grb_wallet_acls;
   grb_roles;
   grb_users;
   ------------------------------------------------------------
   set_schema_name('SYSTEM');
   grb_future_grants;       -- Includes "FUTURE" Grants
   grb_directories;
   grb_user_triggers;
   ------------------------------------------------------------
   set_schema_name('PUBLIC');
   grb_future_synonyms;
   grb_database_links;
   ------------------------------------------------------------
   set_schema_name('');
   grb_install_master;
   grb_install_sys;
   grb_install_system;
end gen_installs;


------------------------------------------------------------
-- Generate NON SYS/SYSTEM Installation Scripts
procedure gen_schemas
is
   -- Loop through all scripts
   procedure all_schema_scripts is
   begin
      grb_future_synonyms;
      grb_advanced_queues;
      grb_aq_tables;
      grb_application_context;
      grb_comp_data_loader;
      grb_common('FUNCTION'          ,'Function'    );
      grb_common('PACKAGE_BODY'      ,'Package Body');
      grb_common('PACKAGE_SPEC'      ,'Package'     );
      grb_common('PROCEDURE'         ,'Procedure'   );
      grb_common('SCHEDULER_JOB'     ,'Job'         );
      grb_common('SCHEDULER_PROGRAM' ,'Program'     );
      grb_common('SCHEDULER_SCHEDULE','Schedule'    );
      grb_common('SEQUENCE'          ,'Sequence'    );
      grb_common('TYPE_BODY'         ,'Type Body'   );
      grb_common('TYPE_SPEC'         ,'Type'        );
      grb_database_links;
      grb_foreign_keys('MVIEW_FOREIGN_KEY');
      grb_foreign_keys('TABLE_FOREIGN_KEY');
      grb_foreign_keys('VIEW_FOREIGN_KEY');
      grb_indexes('MVIEW_INDEX');
      grb_indexes('TABLE_INDEX');
      grb_materialized_views;
      grb_plsql_java;
      grb_tables;
      grb_triggers('MVIEW_TRIGGER');
      grb_triggers('TABLE_TRIGGER');
      grb_triggers('VIEW_TRIGGER');
      grb_views;
   end all_schema_scripts;
begin
   for sch in (select obj.object_owner
                from  schema_objects_tab  obj
                      join schema_conf  sl
                          on  sl.username        = obj.object_owner
                          and sl.oracle_provided = 'N'
                where obj.build_type    = g_build_type
                 and  obj.object_owner != 'PUBLIC'
                group by obj.object_owner
                order by obj.object_owner)
   loop
      set_schema_name(sch.object_owner);
      all_schema_scripts;
   end loop;
   set_schema_name('');
   grb_install_schemas;
end gen_schemas;


------------------------------------------------------------
---   PUBLIC API  ---
------------------------------------------------------------


------------------------------------------------------------
-- Generate All Installation Scripts into the sf_aa array
procedure all_scripts
      (in_build_type   in varchar2)
is
begin
   dbms_output.put_line('Running ' || $$PLSQL_UNIT || '.all_scripts'  ||
                              '(in_build_type "' || in_build_type || '")' );
   initialize(in_build_type);
   gen_installs;
   gen_schemas;
   fh2.script_close_all;
end all_scripts;


------------------------------------------------------------
-- Get Version
function get_version
   return varchar2
is
begin
   return 'V2.1';
end get_version;


end grab_scripts;
/

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ROOT_SCRIPTS.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.ROOT_SCRIPTS Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.ROOT_SCRIPTS

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."ROOT_SCRIPTS" 
as

   utl_dir varchar2(50) := '../grb_linked_install_scripts';


function get_schema_list
      (in_build_type  in varchar2)
   return varchar2
is
   schema_list  varchar2(1000);
begin
   for sch in (select obj.object_owner
                from  schema_objects_tab  obj
                where obj.build_type = in_build_type
                 and  obj.object_owner != 'PUBLIC'
                group by obj.object_owner
                order by obj.object_owner)
   loop
      schema_list := schema_list || '''' || sch.object_owner || ''',';
   end loop;
   -- Remove the "comma" at the end of schema_list, if any
   schema_list := regexp_replace(schema_list,',$','');
   return schema_list;
end get_schema_list;


--------------------------------------------------------------------------------
-- Database Script Install Wrapper
function dbi_sql
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := q'{
-- Database Installation Assist
--   Wrapper for Database Installation Scripts
--
--   Parameters
--   1) Script Name
--   2) Schema Name
--   3) System Connect String

prompt === DBI Started: &1.

define DBI_SCRIPT_NAME="&1."
define DBI_SCHEMA_NAME="&2."
define DBI_SYSTEM_CONNECT="&3."

variable dbi_beg_dtm varchar2(40)
variable dbi_beg_secs number

set feedback off
begin
   -- Initialize Timer
   :dbi_beg_dtm  := to_char(systimestamp,'YYYY-MM-DD') || 'T' ||
                    to_char(systimestamp,'HH24:MI:SS');
   :dbi_beg_secs := dbms_utility.get_time;
   -- Set Current Schema
   if length('&DBI_SCHEMA_NAME.') > 0
   then
      execute immediate 'alter session set current_schema = "&DBI_SCHEMA_NAME."';
   end if;
end;
}';
   -- Can't have string declaration with a "/" on a line by itself
   ret_txt := ret_txt || '/' || CHR(10) || q'{
set feedback on
set blockterminator off
set sqlblanklines on

}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || q'{@"&DBI_SCRIPT_NAME." "&DBI_SYSTEM_CONNECT."
set serveroutput on size unlimited format wrapped

set sqlblanklines off
set blockterminator on
set feedback off
begin
   -- Reset Current Schema
   if length('&DBI_SCHEMA_NAME.') > 0
   then
      execute immediate 'alter session set current_schema = "' || USER || '"';
   end if;
   -- Show Timer Results
   dbms_output.put_line('=== DBI Completed at ' || to_char(systimestamp,'YYYY-MM-DD') || 'T' ||
                                                   to_char(systimestamp,'HH24:MI:SS') ||
      ' for a duration of '   || trim( (dbms_utility.get_time - :dbi_beg_secs) / 100 ) ||
      ' seconds (started at ' || :dbi_beg_dtm || ')');
end;
}';
   -- Can't have string declaration with a "/" on a line by itself
   ret_txt := ret_txt || '/' || CHR(10) || CHR(10) || 'set feedback on';
   return ret_txt;
end dbi_sql;


--------------------------------------------------------------------------------
-- Installation Finalization Script
function installation_finalize_sql
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt      varchar2(32767);
begin
   ret_txt := q'{
--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                          q'{/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/compile_all.sql" "' || get_schema_list(in_build_type) ||
                          q'{"

prompt
prompt alter_foreign_keys_ENABLE
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/alter_foreign_keys.sql" "ENABLE" "' || get_schema_list(in_build_type) ||
                          q'{"

prompt
prompt alter_triggers_ENABLE
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/alter_triggers.sql" "ENABLE" "' || get_schema_list(in_build_type) ||
                          q'{"

prompt
prompt update_id_sequences
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/update_id_sequences.sql" "' || get_schema_list(in_build_type) ||
                          q'{"

--prompt
--prompt alter_queues_ENABLE
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '--@"' || utl_dir ||
                         '/alter_queues.sql" "ENABLE" "' || get_schema_list(in_build_type) ||
                          q'{"

--prompt
--prompt alter_scheduler_jobs_ENABLE
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '--@"' || utl_dir ||
                         '/alter_scheduler_jobs.sql" "ENABLE" "' || get_schema_list(in_build_type) ||
                          q'{"

prompt
prompt Switch Spooling Off
spool off

}';
   return ret_txt;
end installation_finalize_sql;


--------------------------------------------------------------------------------
-- Installation Preparation Script
function installation_prepare_sql
      (in_build_type  in varchar2)
   return varchar2
is
   TYPE btype_nt_type is table of build_conf.build_type%TYPE;
   btype_nt    btype_nt_type;
   ret_txt     varchar2(32767);
begin
   select to_build_type
    bulk collect into btype_nt
    from  build_type_timing
    where from_build_type = in_build_type
     and  build_timing = 'CURRENT'
     and  to_build_type not in (in_build_type, 'sys','pub')
    order by to_build_type;
   ret_txt := q'{
--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
}';
   ret_txt := ret_txt || '   dbms_output.put_line(''Prerequisite BUILD_TYPEs for "' ||
                                                    in_build_type || '"'');' || CHR(10);
   for i in 1 .. btype_nt.COUNT
   loop
      ret_txt := ret_txt || '   do_it(''' || btype_nt(i) || ''');' || CHR(10);
   end loop;
   ret_txt := ret_txt || 'end;' || CHR(10) || '/' || CHR(10);
   return ret_txt;
end installation_prepare_sql;


--------------------------------------------------------------------------------
-- ODBCAPTURE Installation Logs Comprehensive Data Loader
function odbcapture_installation_logs_cldr
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := q'{
--
--  Comprehensive Data Loader script for odbcapture_installation_logs data
--
--  Must be run as SYSTEM
--
--  Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Confirm/Create odbcapture_installation_logs Table
declare
   jnk  number := 0;
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   begin
      execute immediate 'insert into odbcapture_installation_logs(load_dtm, build_type, file_name)' ||
                        ' values(sysdate, ''Test'', ''Test'')';
      rollback;
      jnk := 1;
   exception when others then
      if SQLCODE != -942    -- Table or view does not exist
      then
         dbms_output.put_line('odbcapture_installation_logs table: ' || SQLERRM);
      end if;
      jnk := -1;
   end;
   if jnk = -1
   then
      run_sql('create table odbcapture_installation_logs' || CHR(10) ||
         ' (load_dtm date' || CHR(10) ||
         ' ,build_type varchar2(10)' || CHR(10) ||
         ' ,file_name varchar2(512)' || CHR(10) ||
         ' ,contents clob)');
      run_sql('comment on column odbcapture_installation_logs.load_dtm is ''Date/Time the installation log file was loaded.''');
      run_sql('comment on column odbcapture_installation_logs.build_type is ''Type of Build (from BUILD_CONF).''');
      run_sql('comment on column odbcapture_installation_logs.file_name is ''Name of installation log file.''');
      run_sql('comment on column odbcapture_installation_logs.contents is ''Contents/Text of the installation log file.''');
      run_sql('comment on table odbcapture_installation_logs is ''ODBCAPTURE installation log files.''');
      run_sql('grant select on odbcapture_installation_logs to public');
      run_sql('create public synonym odbcapture_installation_logs for odbcapture_installation_logs');
   end if;
end;
}';
   -- Can't have string declaration with a "/" on a line by itself
   ret_txt := ret_txt || '/' || CHR(10) || q'{

-- NOTE: Additional file extensions for SQL*Loader include
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=./odbcapture_installation_logs.ctl
host sqlldr '&1.' control=odbcapture_installation_logs.ctl data=odbcapture_installation_logs.csv log=odbcapture_installation_logs.log silent=HEADER,FEEDBACK

begin
   if '&_RC.' != '0' then
      raise_application_error(-20000, 'Control file "odbcapture_installation_logs.ctl" returned error: &_RC.');
   end if;
end;
}';
   -- Can't have string declaration with a "/" on a line by itself
   ret_txt := ret_txt || '/' || CHR(10);
   return ret_txt;
end odbcapture_installation_logs_cldr;


--------------------------------------------------------------------------------
-- ODBCAPTURE Installation Logs Comma Separated Values File
function odbcapture_installation_logs_csv
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := '"' || in_build_type || '","install_sys.log"'    || CHR(10) ||
              '"' || in_build_type || '","install_system.log"' || CHR(10) ||
              '"' || in_build_type || '","install_'            ||
                     in_build_type || '.log"';
   for buff in (select table_owner
                      ,table_name
                 from  obj_install_data_load_tab
                 where element_name = 'DATA_LOAD'
                  and  build_type   = in_build_type
                 order by table_owner
                      ,table_name)
   loop
      ret_txt := ret_txt || CHR(10) || '"' || in_build_type   ||
                                     '","' || replace(replace(buff.table_owner,'$','_'),'%','_') ||
                                       '/' || replace(replace(buff.table_name,'$','_'),'%','_')  || '.log"';
   end loop;
   return ret_txt;
end odbcapture_installation_logs_csv;


--------------------------------------------------------------------------------
-- ODBCAPTURE Installation Logs Control File
function odbcapture_installation_logs_ctl
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := q'{LOAD DATA
APPEND INTO TABLE "ODBCAPTURE_INSTALLATION_LOGS"
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
   (LOAD_DTM          SYSDATE
   ,BUILD_TYPE        char(10)
   ,FILE_NAME         char(512)
   ,CONTENTS          LOBFILE(FILE_NAME) TERMINATED BY EOF
   )}';
   return ret_txt;
end odbcapture_installation_logs_ctl;


--------------------------------------------------------------------------------
-- Report Status
function report_status_sql
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := q'{
--
--  Report Status Script
--
--  Must be run as SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--
-- Note: odbcapture_installation_logs table will be created
--   to load installation logs (if not already available).
--

----------------------------------------
prompt
prompt Load Installation Files
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || q'{@"odbcapture_installation_logs.cldr" "&1."}' ||
                         q'{

----------------------------------------
-- Setup for Reports
set linesize 2499
set trimspool on
set echo off
set verify off
set termout on
set serveroutput on size unlimited format wrapped

----------------------------------------
prompt
prompt Reporting Summary of Build Type Log Errors
}';
   -- Can't have string declaration with a "/" on a line by itself
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/summarize_install_log.sql" "' || in_build_type ||
                          q'{"

----------------------------------------
prompt
prompt Reporting Invalid Objects
set feedback off
set termout off
spool list_invalids.csv
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/list_invalids.sql" "' || get_schema_list(in_build_type) ||
                          q'{"
spool off
set termout on
set feedback on

----------------------------------------
prompt
prompt Reporting JUnit XML Database Build Status
set feedback off
set termout off
spool db_build_junit_report.xml
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/db_build_junit_report.sql" "' || get_schema_list(in_build_type) ||
                          q'{"
spool off
set termout on
set feedback on

----------------------------------------
prompt
prompt Reorting JUnit XML Installation Log
set feedback off
set termout off
spool log_files_junit_report.xml
}';
   -- Can't start a line with an "@"
   ret_txt := ret_txt || '@"' || utl_dir ||
                         '/log_files_junit_report.sql" "' || in_build_type ||
                          q'{"
spool off
set termout on
set feedback on

----------------------------------------
-- Done with Reports
set linesize 80
set verify on}';
   return ret_txt;
end report_status_sql;


--------------------------------------------------------------------------------
-- Set User Authentication
function list_invalids_csv
      (in_build_type  in varchar2)
   return varchar2
is
begin
   return '"OWNER","OBJECT_NAME","OBJECT_TYPE","STATUS"';
end list_invalids_csv;


--------------------------------------------------------------------------------
-- Set User Authentication
function set_user_authentication_sql
      (in_build_type  in varchar2)
   return varchar2
is
   ret_txt  varchar2(32767);
begin
   ret_txt := q'{
--
-- Set "}' || in_build_type || q'{" USER AUTHENTICATION
--
-- Command Line Parameters:
--   1 - Password Key
--

}';
   for sch in (select sl.username
                     ,trim(to_char(ora_hash(username,99),'09'))   HASH_VALUE
                from  schema_conf  sl
                where sl.build_type = in_build_type
                 and  sl.oracle_provided = 'N'
                order by sl.username)
   loop
      ret_txt := ret_txt || 'alter user "' || sch.username   ||
                       '" identified by "' || sch.hash_value || '&1.";' ;
   end loop;
   return ret_txt;
end set_user_authentication_sql;


end root_scripts;
/

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ZIP_UTIL_PKG.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.ZIP_UTIL_PKG Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.ZIP_UTIL_PKG

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."ZIP_UTIL_PKG" 
is

  /*

  Purpose:      Package handles zipping and unzipping of files

  Remarks:      by Anton Scheffer, see http://forums.oracle.com/forums/thread.jspa?messageID=9289744#9289744

                for unzipping, see http://technology.amis.nl/blog/8090/parsing-a-microsoft-word-docx-and-unzip-zipfiles-with-plsql
                for zipping, see http://forums.oracle.com/forums/thread.jspa?threadID=1115748&tstart=0

  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     09.01.2011  Created
  MBR     21.05.2012  Fixed a bug related to use of dbms_lob.substr in get_file (use dbms_lob.copy instead)

  */

  function raw2num(
    p_value in raw
  )
    return number
  is
  begin                                               -- note: FFFFFFFF => -1
    return utl_raw.cast_to_binary_integer( p_value
                                         , utl_raw.little_endian
                                         );
  end;
--
  function file2blob(
    p_dir in varchar2
  , p_file_name in varchar2
  )
    return blob
  is
    file_lob bfile;
    file_blob blob;
  begin
    file_lob := bfilename( p_dir
                         , p_file_name
                         );
    dbms_lob.open( file_lob
                 , dbms_lob.file_readonly
                 );
    dbms_lob.createtemporary( file_blob
                            , true
                            );
    dbms_lob.loadfromfile( file_blob
                         , file_lob
                         , dbms_lob.lobmaxsize
                         );
    dbms_lob.close( file_lob );
    return file_blob;
  exception
    when others
    then
      if dbms_lob.isopen( file_lob ) = 1
      then
        dbms_lob.close( file_lob );
      end if;
      if dbms_lob.istemporary( file_blob ) = 1
      then
        dbms_lob.freetemporary( file_blob );
      end if;
      raise;
  end;
--
  function raw2varchar2(
    p_raw in raw
  , p_encoding in varchar2
  )
    return varchar2
  is
  begin
    return nvl
            ( utl_i18n.raw_to_char( p_raw
                                  , p_encoding
                                  )
            , utl_i18n.raw_to_char
                            ( p_raw
                            , utl_i18n.map_charset( p_encoding
                                                  , utl_i18n.generic_context
                                                  , utl_i18n.iana_to_oracle
                                                  )
                            )
            );
  end;
  function get_file_list(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return t_file_list
  is
  begin
    return get_file_list( file2blob( p_dir
                                   , p_zip_file
                                   )
                        , p_encoding
                        );
  end;
--
  function get_file_list(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null
  )
    return t_file_list
  is
    t_ind integer;
    t_hd_ind integer;
    t_rv t_file_list;
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when dbms_lob.substr( p_zipped_blob
                               , 4
                               , t_ind
                               ) = hextoraw( '504B0506' )
            or t_ind < 1;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return null;
    end if;
--
    t_hd_ind := raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_ind + 16
                                        ) ) + 1;
    t_rv := t_file_list( );
    t_rv.extend( raw2num( dbms_lob.substr( p_zipped_blob
                                         , 2
                                         , t_ind + 10
                                         ) ) );
    for i in 1 .. raw2num( dbms_lob.substr( p_zipped_blob
                                          , 2
                                          , t_ind + 8
                                          ) )
    loop
      t_rv( i ) :=
        raw2varchar2
             ( dbms_lob.substr( p_zipped_blob
                              , raw2num( dbms_lob.substr( p_zipped_blob
                                                        , 2
                                                        , t_hd_ind + 28
                                                        ) )
                              , t_hd_ind + 46
                              )
             , p_encoding
             );
      t_hd_ind :=
          t_hd_ind
        + 46
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 28
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 30
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 32
                                  ) );
    end loop;
--
    return t_rv;
  end;
--
  function get_file(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob
  is
  begin
    return get_file( file2blob( p_dir
                              , p_zip_file
                              )
                   , p_file_name
                   , p_encoding
                   );
  end;
--
  function get_file(
    p_zipped_blob in blob
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob
  is
    t_tmp blob;
    t_ind integer;
    t_hd_ind integer;
    t_fl_ind integer;
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when dbms_lob.substr( p_zipped_blob
                               , 4
                               , t_ind
                               ) = hextoraw( '504B0506' )
            or t_ind < 1;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return null;
    end if;
--
    t_hd_ind := raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_ind + 16
                                        ) ) + 1;
    for i in 1 .. raw2num( dbms_lob.substr( p_zipped_blob
                                          , 2
                                          , t_ind + 8
                                          ) )
    loop
      if p_file_name =
           raw2varchar2
             ( dbms_lob.substr( p_zipped_blob
                              , raw2num( dbms_lob.substr( p_zipped_blob
                                                        , 2
                                                        , t_hd_ind + 28
                                                        ) )
                              , t_hd_ind + 46
                              )
             , p_encoding
             )
      then
        if dbms_lob.substr( p_zipped_blob
                          , 2
                          , t_hd_ind + 10
                          ) = hextoraw( '0800' )                -- deflate
        then
          t_fl_ind :=
                raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_hd_ind + 42
                                        ) );
          t_tmp := hextoraw( '1F8B0800000000000003' );          -- gzip header
          dbms_lob.copy( t_tmp
                       , p_zipped_blob
                       , raw2num( dbms_lob.substr( p_zipped_blob
                                                 , 4
                                                 , t_fl_ind + 19
                                                 ) )
                       , 11
                       ,   t_fl_ind
                         + 31
                         + raw2num( dbms_lob.substr( p_zipped_blob
                                                   , 2
                                                   , t_fl_ind + 27
                                                   ) )
                         + raw2num( dbms_lob.substr( p_zipped_blob
                                                   , 2
                                                   , t_fl_ind + 29
                                                   ) )
                       );
          dbms_lob.append( t_tmp
                         , dbms_lob.substr( p_zipped_blob
                                          , 4
                                          , t_fl_ind + 15
                                          )
                         );
          dbms_lob.append( t_tmp
                         , dbms_lob.substr( p_zipped_blob, 4, t_fl_ind + 23 )
                         );
          return utl_compress.lz_uncompress( t_tmp );
        end if;
--
        if dbms_lob.substr( p_zipped_blob
                          , 2
                          , t_hd_ind + 10
                          ) =
                      hextoraw( '0000' )
                                        -- The file is stored (no compression)
        then
          t_fl_ind :=
                raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_hd_ind + 42
                                        ) );

          dbms_lob.createtemporary(t_tmp, cache => true);

          dbms_lob.copy(dest_lob => t_tmp,
                        src_lob => p_zipped_blob,
                        amount => raw2num( dbms_lob.substr( p_zipped_blob, 4, t_fl_ind + 19)),
                        dest_offset => 1,
                        src_offset => t_fl_ind + 31 + raw2num(dbms_lob.substr(p_zipped_blob, 2, t_fl_ind + 27)) + raw2num(dbms_lob.substr( p_zipped_blob, 2, t_fl_ind + 29))
                       );

          return t_tmp;

        end if;

      end if;
      t_hd_ind :=
          t_hd_ind
        + 46
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 28
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 30
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 32
                                  ) );
    end loop;
--
    return null;
  end;
--
  function little_endian(
    p_big in number
  , p_bytes in pls_integer := 4
  )
    return raw
  is
  begin
    return utl_raw.substr
                  ( utl_raw.cast_from_binary_integer( p_big
                                                    , utl_raw.little_endian
                                                    )
                  , 1
                  , p_bytes
                  );
  end;
--
  procedure add_file(
    p_zipped_blob in out nocopy blob
  , p_name in varchar2
  , p_content in blob
  )
  is
    t_now date;
    t_blob blob;
    t_clen integer;
  begin
    t_now := sysdate;
    t_blob := utl_compress.lz_compress( p_content );
    t_clen := dbms_lob.getlength( t_blob );
    if p_zipped_blob is null
    then
      dbms_lob.createtemporary( p_zipped_blob
                              , true
                              );
    end if;
    dbms_lob.append
      ( p_zipped_blob
      , utl_raw.concat
          ( hextoraw( '504B0304' )              -- Local file header signature
          , hextoraw( '1400' )                  -- version 2.0
          , hextoraw( '0000' )                  -- no General purpose bits
          , hextoraw( '0800' )                  -- deflate
          , little_endian
              (   to_number( to_char( t_now
                                    , 'ss'
                                    ) ) / 2
                + to_number( to_char( t_now
                                    , 'mi'
                                    ) ) * 32
                + to_number( to_char( t_now
                                    , 'hh24'
                                    ) ) * 2048
              , 2
              )                                 -- File last modification time
          , little_endian
              (   to_number( to_char( t_now
                                    , 'dd'
                                    ) )
                + to_number( to_char( t_now
                                    , 'mm'
                                    ) ) * 32
                + ( to_number( to_char( t_now
                                      , 'yyyy'
                                      ) ) - 1980 ) * 512
              , 2
              )                                 -- File last modification date
          , dbms_lob.substr( t_blob
                           , 4
                           , t_clen - 7
                           )                                         -- CRC-32
          , little_endian( t_clen - 18 )                    -- compressed size
          , little_endian( dbms_lob.getlength( p_content ) )
                                                          -- uncompressed size
          , little_endian( length( p_name )
                         , 2
                         )                                 -- File name length
          , hextoraw( '0000' )                           -- Extra field length
          , utl_raw.cast_to_raw( p_name )                         -- File name
          )
      );
    dbms_lob.copy( p_zipped_blob
                 , t_blob
                 , t_clen - 18
                 , dbms_lob.getlength( p_zipped_blob ) + 1
                 , 11
                 );                                      -- compressed content
    dbms_lob.freetemporary( t_blob );
  end;
--
  procedure finish_zip(
    p_zipped_blob in out nocopy blob
  )
  is
    t_cnt pls_integer := 0;
    t_offs integer;
    t_offs_dir_header integer;
    t_offs_end_header integer;
    t_comment raw( 32767 )
                 := utl_raw.cast_to_raw( 'Implementation by Anton Scheffer' );
  begin
    t_offs_dir_header := dbms_lob.getlength( p_zipped_blob );
    t_offs := dbms_lob.instr( p_zipped_blob
                            , hextoraw( '504B0304' )
                            , 1
                            );
    while t_offs > 0
    loop
      t_cnt := t_cnt + 1;
      dbms_lob.append
        ( p_zipped_blob
        , utl_raw.concat
            ( hextoraw( '504B0102' )
                                    -- Central directory file header signature
            , hextoraw( '1400' )                                -- version 2.0
            , dbms_lob.substr( p_zipped_blob
                             , 26
                             , t_offs + 4
                             )
            , hextoraw( '0000' )                        -- File comment length
            , hextoraw( '0000' )              -- Disk number where file starts
            , hextoraw( '0100' )                   -- Internal file attributes
            , hextoraw( '2000B681' )               -- External file attributes
            , little_endian( t_offs - 1 )
                                       -- Relative offset of local file header
            , dbms_lob.substr
                ( p_zipped_blob
                , utl_raw.cast_to_binary_integer
                                           ( dbms_lob.substr( p_zipped_blob
                                                            , 2
                                                            , t_offs + 26
                                                            )
                                           , utl_raw.little_endian
                                           )
                , t_offs + 30
                )                                                 -- File name
            )
        );
      t_offs :=
          dbms_lob.instr( p_zipped_blob
                        , hextoraw( '504B0304' )
                        , t_offs + 32
                        );
    end loop;
    t_offs_end_header := dbms_lob.getlength( p_zipped_blob );
    dbms_lob.append
      ( p_zipped_blob
      , utl_raw.concat
          ( hextoraw( '504B0506' )       -- End of central directory signature
          , hextoraw( '0000' )                          -- Number of this disk
          , hextoraw( '0000' )          -- Disk where central directory starts
          , little_endian
                   ( t_cnt
                   , 2
                   )       -- Number of central directory records on this disk
          , little_endian( t_cnt
                         , 2
                         )        -- Total number of central directory records
          , little_endian( t_offs_end_header - t_offs_dir_header )
                                                  -- Size of central directory
          , little_endian
                    ( t_offs_dir_header )
                                       -- Relative offset of local file header
          , little_endian
                ( nvl( utl_raw.length( t_comment )
                     , 0
                     )
                , 2
                )                                   -- ZIP file comment length
          , t_comment
          )
      );
  end;
--
  procedure save_zip(
    p_zipped_blob in blob
  , p_dir in varchar2
  , p_filename in varchar2
  )
  is
    t_fh utl_file.file_type;
    t_len pls_integer := 32767;
  begin
    t_fh := utl_file.fopen( p_dir
                          , p_filename
                          , 'wb'
                          );
    for i in 0 .. trunc(  ( dbms_lob.getlength( p_zipped_blob ) - 1 ) / t_len )
    loop
      utl_file.put_raw( t_fh
                      , dbms_lob.substr( p_zipped_blob
                                       , t_len
                                       , i * t_len + 1
                                       )
                      );
    end loop;
    utl_file.fclose( t_fh );
  end;
--

end zip_util_pkg;
/

set define on

----------------------------------------
-- TABLE_FOREIGN_KEY Install


prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/BUILD_PATH.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.BUILD_PATH TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_FK1

  ALTER TABLE "ODBCAPTURE"."BUILD_PATH" ADD CONSTRAINT "BUILD_PATH_FK1" FOREIGN KEY ("PARENT_BUILD_SEQ")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ") ENABLE;

--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.BUILD_PATH_FK2

  ALTER TABLE "ODBCAPTURE"."BUILD_PATH" ADD CONSTRAINT "BUILD_PATH_FK2" FOREIGN KEY ("BUILD_SEQ")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ") ENABLE;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/DLOAD_CONF.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.DLOAD_CONF TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.DLOAD_CONF_FK1

  ALTER TABLE "ODBCAPTURE"."DLOAD_CONF" ADD CONSTRAINT "DLOAD_CONF_FK1" FOREIGN KEY ("USERNAME")
	  REFERENCES "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME") ENABLE;

--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.DLOAD_CONF_FK2

  ALTER TABLE "ODBCAPTURE"."DLOAD_CONF" ADD CONSTRAINT "DLOAD_CONF_FK2" FOREIGN KEY ("BUILD_TYPE")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_TYPE") ENABLE;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/OBJECT_CONF.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.OBJECT_CONF TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.OBJECT_CONF_FK1

  ALTER TABLE "ODBCAPTURE"."OBJECT_CONF" ADD CONSTRAINT "OBJECT_CONF_FK1" FOREIGN KEY ("USERNAME")
	  REFERENCES "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME") ENABLE;

--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.OBJECT_CONF_FK2

  ALTER TABLE "ODBCAPTURE"."OBJECT_CONF" ADD CONSTRAINT "OBJECT_CONF_FK2" FOREIGN KEY ("ELEMENT_NAME")
	  REFERENCES "ODBCAPTURE"."ELEMENT_CONF" ("ELEMENT_NAME") ENABLE;

--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.OBJECT_CONF_FK3

  ALTER TABLE "ODBCAPTURE"."OBJECT_CONF" ADD CONSTRAINT "OBJECT_CONF_FK3" FOREIGN KEY ("BUILD_TYPE")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_TYPE") ENABLE;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/ROLE_CONF.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.ROLE_CONF TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.ROLE_CONF_FK1

  ALTER TABLE "ODBCAPTURE"."ROLE_CONF" ADD CONSTRAINT "ROLE_CONF_FK1" FOREIGN KEY ("BUILD_TYPE")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_TYPE") ENABLE;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/SCHEMA_CONF.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.SCHEMA_CONF TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.SCHEMA_CONF_FK1

  ALTER TABLE "ODBCAPTURE"."SCHEMA_CONF" ADD CONSTRAINT "SCHEMA_CONF_FK1" FOREIGN KEY ("BUILD_TYPE")
	  REFERENCES "ODBCAPTURE"."BUILD_CONF" ("BUILD_TYPE") ENABLE;

set define on

prompt ============================================================
prompt Running: grbsrc ODBCAPTURE/TSPACE_CONF.tfk
prompt ============================================================

--
--  Create Foreign Keys for ODBCAPTURE.TSPACE_CONF TABLE
--

set define off


--  NOTE: This is a "BASE TABLE" Foreign Key

--DBMS_METADATA:ODBCAPTURE.TSPACE_CONF_FK1

  ALTER TABLE "ODBCAPTURE"."TSPACE_CONF" ADD CONSTRAINT "TSPACE_CONF_FK1" FOREIGN KEY ("USERNAME")
	  REFERENCES "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME") ENABLE;

set define on

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbsrc ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbsrc', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
-- SYS_GRANT Install


prompt ============================================================
prompt Running: grbras SYS/ODBCAPTURE_usr.sgrnt
prompt ============================================================


--
--  Future Grant SYS Objects (but not directories)
--

set define off



--  "SYS" Object Grants

grant SELECT on "SYS"."DBA_XS_ACES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XS_ACLS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XS_ACL_PARAMETERS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XS_APPLIED_POLICIES" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XS_PRINCIPALS" to "ODBCAPTURE";
grant SELECT on "SYS"."DBA_XS_ROLE_GRANTS" to "ODBCAPTURE";


set define on


----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbras Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbras ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbras"');
   do_it('grbsrc');
end;
/


----------------------------------------
-- PACKAGE Install


prompt ============================================================
prompt Running: grbras ODBCAPTURE/GRAB_RAS.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_RAS Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_RAS

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."GRAB_RAS" 
   authid current_user
as

   procedure grb_usr
      (fh          in out NOCOPY  fh2.sf_ptr_type
      ,in_grantee  in             varchar2);

   procedure disable_policy
      (in_schema  in  varchar2
      ,in_object  in  varchar2);

   procedure enable_policy
      (in_schema  in  varchar2
      ,in_object  in  varchar2);

   procedure grb_racl;

end grab_ras;
/


--  Grants


--  Synonyms


set define on

----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbras ODBCAPTURE/EXPORTING_RAS_DATA.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.EXPORTING_RAS_DATA Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.EXPORTING_RAS_DATA

  CREATE TABLE "ODBCAPTURE"."EXPORTING_RAS_DATA" 
   (	"SCHEMA" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"OBJECT" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"POLICY_OWNER" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	"POLICY" VARCHAR2(128 BYTE) NOT NULL ENABLE, 
	 CONSTRAINT "EXPORTING_RAS_DATA_PK" PRIMARY KEY ("SCHEMA", "OBJECT", "POLICY_OWNER", "POLICY") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS ;

--  Comments

--DBMS_METADATA:ODBCAPTURE.EXPORTING_RAS_DATA

   COMMENT ON COLUMN "ODBCAPTURE"."EXPORTING_RAS_DATA"."SCHEMA" IS 'Owner of object containing data being exported';
   COMMENT ON COLUMN "ODBCAPTURE"."EXPORTING_RAS_DATA"."OBJECT" IS 'Object containing data being exported';
   COMMENT ON COLUMN "ODBCAPTURE"."EXPORTING_RAS_DATA"."POLICY_OWNER" IS 'Owner of temporarily disabled RAS Policy';
   COMMENT ON COLUMN "ODBCAPTURE"."EXPORTING_RAS_DATA"."POLICY" IS 'Temporarily disabled RAS Policy';
   COMMENT ON TABLE "ODBCAPTURE"."EXPORTING_RAS_DATA"  IS 'RAS Policies temporarily disabled during data exports';


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbras ODBCAPTURE/ROLE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.ROLE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."ROLE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/ROLE_CONF.ctl

prompt Translating ../grbras/ODBCAPTURE/ROLE_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XS_CACHE_ADMIN','grbras','Y','The mid-tier cache. It is required for caching the security policy at the mid-tier level for the checkAcl (authorization) method of the XSAccessController class. Grant this role to the application connection user or the Real Application Security dispatcher.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XS_CONNECT','grbras','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XS_NAMESPACE_ADMIN','grbras','Y','In Oracle Database Real Application Security, enables the grantee to manage and manipulate the namespace and attribute for a session. Grant this role to the Real Application Security session user.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XS_RESOURCE','grbras','Y',NULL);

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('XS_SESSION_ADMIN','grbras','Y','In Oracle Database Real Application Security, enables the grantee to manage the life cycle of a session, including the ability to create, attach, detach, and destroy the session. Grant this role to the application connection user or Real Application Security dispatcher.');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/ROLE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbras ODBCAPTURE/SCHEMA_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.SCHEMA_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."SCHEMA_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/SCHEMA_CONF.ctl

prompt Translating ../grbras/ODBCAPTURE/SCHEMA_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('XS$NULL','grbras','Y',NULL,NULL,NULL,NULL,'RAS - Real Application Security NULL Login');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/SCHEMA_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- VIEW Install


prompt ============================================================
prompt Running: grbras ODBCAPTURE/PRIV_OBJ_RACL_VIEW.vw
prompt ============================================================

--
--  Create ODBCAPTURE.PRIV_OBJ_RACL_VIEW view
--

set define off


--
--  Cannot grant permisions on a view with an error
--  https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:43253832697675#2653213300346351987
create view "ODBCAPTURE"."PRIV_OBJ_RACL_VIEW"
  as   select * from TEMP_PUBLICLY_UPDATEABLE_TABLE;

--  Grants



--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_RACL_VIEW

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ODBCAPTURE"."PRIV_OBJ_RACL_VIEW" ("BUILD_TYPE", "BUILD_TIMING", "BUILD_TYPE_SELECTOR", "OBJECT_NAME_REGEXP", "RACL_BUILD_TYPE", "OWNER_BUILD_TYPE", "OWNER", "OWNER_UOR_TYPE", "ELEMENT_NAME", "FILE_EXT1", "FILE_EXT2", "FILE_EXT3") AS 
  select case t.build_timing
          when 'FUTURE' then ol.build_type
                        else uor.build_type
       end                              BUILD_TYPE
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end                              BUILD_TIMING
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end                              BUILD_TYPE_SELECTOR
      ,ol.object_name_regexp
      ,ol.build_type                    RACL_BUILD_TYPE
      ,uor.build_type                   OWNER_BUILD_TYPE
      ,uor.user_or_role                 OWNER
      ,uor.uor_type                     OWNER_UOR_TYPE
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3
 from  uor_install_view  uor
       join element_conf  ec
            on  ec.element_name = 'RAS_ACL'
  left join object_conf  ol
            on  ol.username     = uor.user_or_role
            and ol.build_type  != uor.build_type
            and ol.element_name = ec.element_name
          --  and ol.object_name_regexp is not null  Don't Care About the Filter Contents
  left join build_type_timing  t
            -- Ensure the Grantee is available when the RACL is installed
            on  t.from_build_type = ol.build_type
            and t.to_build_type   = uor.build_type
 where uor.user_or_role in (select distinct a.owner from dba_xs_acls a)
  and  uor.oracle_provided = 'N'    -- Exclude Oracle Provided Grantees
 group by case t.build_timing
          when 'FUTURE' then ol.build_type
                        else uor.build_type
       end
      ,case t.build_timing
          when 'FUTURE' then 'FUTURE'
                        else 'CURRENT'
       end
      ,case t.build_timing
          when 'FUTURE' then 'OBJECT_NAME_REGEXP'
                        else 'GRANTEE'
       end
      ,ol.object_name_regexp
      ,ol.build_type
      ,uor.build_type
      ,uor.user_or_role
      ,uor.uor_type
      ,ec.element_name
      ,ec.file_ext1
      ,ec.file_ext2
      ,ec.file_ext3;

--  Comments

--DBMS_METADATA:ODBCAPTURE.PRIV_OBJ_RACL_VIEW


--  Grants


--  Synonyms


set define on

----------------------------------------
-- PACKAGE BODY Install


prompt ============================================================
prompt Running: grbras ODBCAPTURE/GRAB_RAS.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_RAS Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_RAS

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."GRAB_RAS" 
as


------------------------------------------------------------
-- Grant Real Application Security (RAS) Administrative Permissions
--
--  Note1: This created source code may or may not be running in the Oracle Cloud
--  Note2: RAS may or may not be installed in the database running this source code.
--
procedure grb_usr
      (fh          in out NOCOPY  fh2.sf_ptr_type
      ,in_grantee  in             varchar2)
as
   first_pass  boolean := TRUE;
begin
   for buff in (select privilege
                 from  dba_xs_aces
                 where acl       = 'SYSTEMACL'
                  and  principal = in_grantee
                 order by privilege)
   loop
      if first_pass
      then
         first_pass := FALSE;
         fh2.script_put_line(fh, q'{}');
         fh2.script_put_line(fh, q'{-- Real Application Security System Grants}');
         fh2.script_put_line(fh, q'{}');
      end if;
      fh2.script_put_line(fh, q'{}');
      fh2.script_put_line(fh, q'{prompt XS Admin Grant "}' || buff.privilege || q'{" to "}' || in_grantee || q'{"}');
      fh2.script_put_line(fh, q'{begin}');
      fh2.script_put_line(fh, q'{   execute immediate 'begin' ||}');
      fh2.script_put_line(fh, q'{                     '  xs_admin_util.grant_system_privilege(''}' ||
                                                            buff.privilege || q'{'', ''}' || in_grantee || q'{''); ' ||}');
      fh2.script_put_line(fh, q'{                     'end;';}');
      fh2.script_put_line(fh, q'{exception when others then}');
      fh2.script_put_line(fh, q'{   if    SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'}');
      fh2.script_put_line(fh, q'{     AND SQLERRM not like '%ORA-01031: insufficient privileges%'}');
      fh2.script_put_line(fh, q'{   then}');
      fh2.script_put_line(fh, q'{      raise;}');
      fh2.script_put_line(fh, q'{   end if;}');
      fh2.script_put_line(fh, q'{end;}');
      fh2.script_put_line(fh, q'{/}');
      fh2.script_put_line(fh, q'{}');
      fh2.script_put_line(fh, q'{prompt XS Admin Cloud Grant "}' || buff.privilege || q'{" to "}' || in_grantee || q'{"}');
      fh2.script_put_line(fh, q'{begin}');
      fh2.script_put_line(fh, q'{   execute immediate 'begin' ||}');
      fh2.script_put_line(fh, q'{                     '  xs_admin_cloud_util.grant_system_privilege(''}' ||
                                                            buff.privilege || q'{'', ''}' || in_grantee || q'{''); ' ||}');
      fh2.script_put_line(fh, q'{                     'end;';}');
      fh2.script_put_line(fh, q'{exception when others then}');
      fh2.script_put_line(fh, q'{   if SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_CLOUD_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'}');
      fh2.script_put_line(fh, q'{   then}');
      fh2.script_put_line(fh, q'{      raise;}');
      fh2.script_put_line(fh, q'{   end if;}');
      fh2.script_put_line(fh, q'{end;}');
      fh2.script_put_line(fh, q'{/}');
      fh2.script_put_line(fh, q'{}');
   end loop;
end grb_usr;


------------------------------------------------------------
-- Disable Real Application Security (RAS) Enforcement
procedure disable_policy
      (in_schema  in  varchar2
      ,in_object  in  varchar2)
is
begin
   for buff in (select t.policy_owner, t.policy
                 from  dba_xs_applied_policies t
                 where t.schema = in_schema
                  and  t.object = in_object
                  and  t.status = 'ENABLED'
                 order by t.policy_owner, t.policy)
   loop
      begin
         insert into exporting_ras_data
               (   schema,    object,      policy_owner,      policy)
            values
               (in_schema, in_object, buff.policy_owner, buff.policy);
         commit;
      exception when DUP_VAL_ON_INDEX then
         null;  -- Ignore this exception
      end;
      xs_data_security.disable_object_policy
         (schema => in_schema
         ,object => in_object
         ,policy => '"' || buff.policy_owner || '"."' ||
                           buff.policy       || '"'   );
   end loop;
end disable_policy;


------------------------------------------------------------
-- Enable Real Application Security (RAS) Enforcement
procedure enable_policy
      (in_schema  in  varchar2
      ,in_object  in  varchar2)
is
begin
   for buff in (select t.policy_owner, t.policy
                 from  exporting_ras_data t
                 where t.schema = in_schema
                  and  t.object = in_object
                 order by t.policy_owner, t.policy)
   loop
      xs_data_security.enable_object_policy
         (schema => in_schema
         ,object => in_object
         ,policy => '"' || buff.policy_owner || '"."' ||
                           buff.policy       || '"'   );
      delete from exporting_ras_data t
       where t.schema       = in_schema
        and  t.object       = in_object
        and  t.policy_owner = buff.policy_owner
        and  t.policy       = buff.policy;
      commit;
   end loop;
end enable_policy;


------------------------------------------------------------
-- Create Real Application Security (RAS) Access Control Lists
procedure grb_racl
as
   ELMNT           CONSTANT varchar2(100) := 'RAS_ACL';
   fh              fh2.sf_ptr_type;  -- object script file handle
   l_DDL_handle    NUMBER;
   l_XForm_handle  NUMBER;
   old_file        varchar2(1000) := 'This is not a real file name !@#$%^';
   ----------------------------------------
   procedure l_close_file as
      l_file_name  varchar2(1000) :=
                   fh2.sf_aa(fh.bld_type)(fh.bld_ord)(fh.file_id).filename;
   begin
      --
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
      --
      fh := fh2.script_open(in_filename     => 'odbcapture_installation_logs.csv'
                           ,in_elmnt        => 'INSTALL_SCRIPT'
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      fh2.script_put_line(fh, '"' || grab_scripts.g_build_type ||
                            '","' || l_file_name || '.log"' );
      fh2.script_close(fh);
      --
   end l_close_file;
   ----------------------------------------
begin
   --ELMNT: RAS_ACL, g_build_type: grbtst, g_schema_name: SYS, RAS_ACL
   --dbms_output.put_line('ELMNT: ' || ELMNT || ', g_build_type: ' || grab_scripts.g_build_type ||
   --                     ', g_schema_name: ' || grab_scripts.g_schema_name || ', ' || ELMNT);
   for buf1 in (select 'RAS_Admin_' ||owner || '.' || file_ext1    FILE_NAME
                      ,owner
                      ,build_type_selector
                 from  priv_obj_racl_view
                 where build_type = grab_scripts.g_build_type
                 -- and  owner        = grab_scripts.g_schema_name  (All Schema)
                 order by owner
                      ,build_type_selector)
   loop
      if old_file != buf1.file_name
      then
         old_file := buf1.file_name;
         if fh2.script_is_open(fh)
         then
            l_close_file;
         end if;
         fh := fh2.script_open(in_filename     => buf1.file_name
                              ,in_elmnt        => ELMNT
                              ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '-- Create RAS ACLs for RAS Administrator ' || buf1.owner);
         fh2.script_put_line(fh, '--  NOTE: This is a "' || buf1.build_type_selector || '" RAS ACL');
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '-- To disable RAS ACLs for data loading/unloading, use:');
         for buf2 in (select t.schema, t.policy, t.object
                       from  dba_xs_applied_policies t
                       where t.policy_owner = buf1.owner
                       order by t.policy_owner, t.policy, t.object)
         loop
            fh2.script_put_line(fh, '--begin');
            fh2.script_put_line(fh, '--   xs_data_security.disable_object_policy'          );
            fh2.script_put_line(fh, '--      (policy  => ''"' || buf1.owner  ||
                                                        '"."' || buf2.policy || '"''');
            fh2.script_put_line(fh, '--      ,schema  => '''  || buf2.schema ||  '''');
            fh2.script_put_line(fh, '--      ,object  => '''  || buf2.object ||  '''');
            fh2.script_put_line(fh, '--      );' );
            fh2.script_put_line(fh, '--end;');
            fh2.script_put_line(fh, '--/');
         end loop;
         fh2.script_put_line(fh, '--');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, 'set define off');
         fh2.script_put_line(fh, '');
         fh2.script_put_line(fh, '');
      end if;
      fh2.script_put_line(fh, '-- RAS Defined Roles');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.name from dba_xs_principals t
                    where t.type = 'ROLE'
                     and  t.name not like 'XS%'
                    order by t.name)
      loop
         fh2.script_put_line(fh, 'prompt ' || buf2.name || '.XS_ROLE');
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buf2.name || '.XS_ROLE');
         fh2.put_big_line(fh, buf1.owner || '.' || buf2.name || ' XS_ROLE'
                             ,DBMS_METADATA.get_ddl(object_type => 'XS_ROLE'
                                                   ,name        => buf2.name)
                             ,common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- RAS Defined Users');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.name from dba_xs_principals t
                    where t.type = 'USER'
                     and  t.name not like 'XS%'
                    order by t.name)
      loop
         fh2.script_put_line(fh, 'prompt ' || buf2.name || '.XS_USER');
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buf2.name || '.XS_USER');
         -- Need to catch this failure:
         -- ORA-31603: object "GRB_TEST_USER_01" of type XS_USER not found in schema "ODBCAPTURE"
         begin
            fh2.put_big_line(fh, buf1.owner || '.' || buf2.name || ' XS_USER'
                                ,DBMS_METADATA.get_ddl(object_type => 'XS_USER'
                                                      ,name        => buf2.name)
                                ,common_util.MAXIMUM_SQL_LENGTH);
         exception when others then
            if SQLCODE = -31603
            then
               dbms_output.put_line(SQLERRM || CHR(10) ||
                                    dbms_utility.format_error_backtrace ||
                                    dbms_utility.format_call_stack);
            else
               raise;
            end if;
         end;
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- Database Role Grants to RAS Principals');
      fh2.script_put_line(fh, '-- DBMS_METADATA: "XS_ROLE_GRANT" doesn''t do this');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.granted_role, t.grantee from dba_xs_role_grants t
                    where t.granted_role_type = 'DATABASE'
                     and  t.granted_role not like 'XS%'
                    order by t.granted_role, t.grantee)
      loop
         fh2.script_put_line(fh, 'prompt grant "' || buf2.granted_role ||
                                         '" to "' || buf2.grantee || '";');
         fh2.script_put_line(fh, 'grant "' || buf2.granted_role ||
                                           '" to "' || buf2.grantee || '";');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '-- RAS Role Grants to RAS Principals');
      fh2.script_put_line(fh, '-- Note: DBMS_METADATA XS_ROLE_GRANT won''t work with multiple users per role');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.grantee, t.granted_role from dba_xs_role_grants t
                    where t.grantee in (select distinct t2.principal from dba_xs_aces t2
                                         where t2.owner = buf1.owner)
                    order by t.grantee, t.granted_role)
      loop
         --fh2.script_put_line(fh, '-- DBMS_METADATA: ' || buf2.granted_role || '.XS_ROLE_GRANT');
         --fh2.put_big_line(fh, buf1.owner || '.' || buf2.granted_role || ' XS_ROLE_GRANT'
         --                         ,dbms_metadata.get_ddl(object_type => 'XS_ROLE_GRANT'
         --                                               ,name        => buf2.granted_role)
         --                         ,common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, 'prompt principal grant "' || buf2.granted_role ||
                                                   '" to "' || buf2.grantee || '";');
         fh2.script_put_line(fh, 'BEGIN');
         fh2.script_put_line(fh, '  xs_principal.grant_roles(grantee => ''"' || buf2.grantee || '"'', ');
         fh2.script_put_line(fh, '     role => ''"' || buf2.granted_role || '"'');');
         fh2.script_put_line(fh, 'END;');
         fh2.script_put_line(fh, '/');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '--------------------------------------');
      fh2.script_put_line(fh, '-- RAS ACLs Owned by RAS Administrator');
      fh2.script_put_line(fh, '--------------------------------------');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.name from dba_xs_acls t
                    where t.owner = buf1.owner
                    order by t.name)
      loop
         fh2.script_put_line(fh, 'prompt ' || buf2.name || '.XS_ACL');
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buf2.name || '.XS_ACL');
         fh2.put_big_line(fh, buf1.owner || '.' || buf2.name || ' XS_ACL'
                             ,DBMS_METADATA.get_ddl(object_type => 'XS_ACL'
                                                   ,name        => buf2.name
                                                   ,schema      => buf1.owner)
                             ,common_util.MAXIMUM_SQL_LENGTH);
         for buf3 in (select distinct t.acl from dba_xs_acl_parameters t
                       where t.acl       = buf2.name
                        and  t.acl_owner = buf1.owner
                       order by t.acl)
         loop
            fh2.script_put_line(fh, 'prompt ' || buf3.acl || '.XS_ACL_PARAM');
            fh2.script_put_line(fh, '--DBMS_METADATA:' || buf3.acl || '.XS_ACL_PARAM');
            fh2.put_big_line(fh, buf1.owner || '.' || buf3.acl || ' XS_ACL_PARAM'
                                ,DBMS_METADATA.get_ddl(object_type => 'XS_ACL_PARAM'
                                                      ,name        => buf3.ACL
                                                      ,schema      => buf1.owner)
                                ,common_util.MAXIMUM_SQL_LENGTH);
         end loop;
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '----------------------------------------------------');
      fh2.script_put_line(fh, '-- Policies for RAS Admininistrator (includes REALM)');
      fh2.script_put_line(fh, '----------------------------------------------------');
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, '');
      for buf2 in (select t.policy from dba_xs_applied_policies t
                    where t.POLICY_OWNER = buf1.owner
                    order by t.policy)
      loop
         fh2.script_put_line(fh, 'prompt ' || buf2.policy || '.XS_DATA_SECURITY');
         fh2.script_put_line(fh, '--DBMS_METADATA:' || buf2.policy || '.XS_DATA_SECURITY');
         fh2.script_put_line(fh, '--  For UNKNOWN reasons: Need to change from this:');
         fh2.script_put_line(fh, '--    dbms_xds.enable_xds(');
         fh2.script_put_line(fh, '--       object_schema => ''ODBCAPTURE'',');
         fh2.script_put_line(fh, '--       object_name => ''GRBTST_$NAME'',');
         fh2.script_put_line(fh, '--       policy_name => ''"ODBCTEST"."GRB_TEST_POLICY_01"'');');
         fh2.script_put_line(fh, '--  To this for use with Autonomous Database Service in Oracle Cloud:');
         fh2.script_put_line(fh, '--    xs_data_security.apply_object_policy(');
         fh2.script_put_line(fh, '--       schema => ''ODBCAPTURE'',');
         fh2.script_put_line(fh, '--       object => ''GRBTST_$NAME'',');
         fh2.script_put_line(fh, '--       policy => ''"ODBCTEST"."GRB_TEST_POLICY_01"'');');
         fh2.put_big_line(fh, buf1.owner || '.' || buf2.policy || ' XS_DATA_SECURITY'
                                  ,replace
                                      (replace
                                         (replace
                                            (replace
                                               (DBMS_METADATA.get_ddl(object_type => 'XS_DATA_SECURITY'
                                                                     ,name        => buf2.policy
                                                                     ,schema      => buf1.owner )
                                               ,' dbms_xds.enable_xds('
                                               ,' xs_data_security.apply_object_policy(' )
                                            ,' object_schema => '
                                            ,' schema => ' )
                                         ,' object_name => '
                                         ,' object => ' )
                                      ,' policy_name => '
                                      ,' policy => ' )
                                  ,common_util.MAXIMUM_SQL_LENGTH);
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, '');
   end loop;
   if fh2.script_is_open(fh)
   then
      l_close_file;
   end if;
end grb_racl;


end grab_ras;
/

set define on

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbras ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbras', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbsdo Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbsdo ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbsdo"');
   do_it('grbsrc');
end;
/


----------------------------------------
-- PACKAGE Install


prompt ============================================================
prompt Running: grbsdo ODBCAPTURE/GRAB_SDO.pkssql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_SDO Package
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_SDO

  CREATE OR REPLACE EDITIONABLE PACKAGE "ODBCAPTURE"."GRAB_SDO" AUTHID DEFINER
as

   sdo_elem_info_buff   sdo_elem_info_array;
   sdo_geometry_buff    sdo_geometry;
   sdo_ordinate_buff    sdo_ordinate_array;
   sdo_point_buff       sdo_point_type;
   st_geometry_buff     st_geometry;

   function sql_sdo_dim_element
      (in_de  in  sdo_dim_element)
   return varchar2;

   function sql_sdo_dim_array
      (in_da      in  sdo_dim_array
      ,in_spaces  in  varchar2 default '')
   return varchar2;

   function ctl_sdo_point_type
      (in_spaces  in  varchar2 default '   ')
   return varchar2;
   function dat_sdo_point_type
      (in_pt  in  sdo_point_type)
   return varchar2;

   function ctl_sdo_elem_info_array
   return varchar2;
   function dat_sdo_elem_info_array
      (in_eia  in  sdo_elem_info_array)
   return varchar2;

   function ctl_sdo_ordinate_array
   return varchar2;
   function dat_sdo_ordinate_array
      (in_oa  in  sdo_ordinate_array)
   return varchar2;

   function ctl_sdo_geometry
      (in_spaces  in  varchar2 default '   ')
   return varchar2;
   function dat_sdo_geometry
      (in_geo  in  sdo_geometry)
   return varchar2;

   function ctl_st_geometry
      (in_spaces  in  varchar2 default '   ')
   return varchar2;
   function dat_st_geometry
      (in_geo  in  st_geometry)
   return varchar2;

   procedure grb_ind
      (in_table_owner  in varchar2
      ,in_table_name   in varchar2
      ,in_table_type   in varchar2
      ,in_index_owner  in varchar2
      ,in_index_name   in varchar2
      ,in_index_ext    in varchar2
      ,in_ityp_owner   in varchar2
      ,in_ityp_name    in varchar2);

   procedure grb_cldr_define
      (in_dyn_curs  in            integer
      ,in_position  in            integer
      ,io_lc        in out nocopy varchar2
      ,io_fh        in out nocopy fh2.sf_ptr_type
      ,io_desc_tab3 in out nocopy dbms_sql.desc_tab3);

   procedure grb_cldr_value
      (in_dyn_curs  in            integer
      ,in_position  in            integer
      ,io_lc        in out nocopy varchar2
      ,io_fh        in out nocopy fh2.sf_ptr_type
      ,io_desc_tab3 in out nocopy dbms_sql.desc_tab3);

end grab_sdo;
/


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbsdo ODBCAPTURE/ROLE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.ROLE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."ROLE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/ROLE_CONF.ctl

prompt Translating ../grbsdo/ODBCAPTURE/ROLE_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('CSW_USR_ROLE','grbsdo','Y','Provides user privileges to manage the Catalog Services for the Web (CSW) component of Oracle Spatial.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SPATIAL_CSW_ADMIN','grbsdo','Y','Provides administrative privileges to manage the Catalog Services for the Web (CSW) component of Oracle Spatial.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('SPATIAL_WFS_ADMIN','grbsdo','Y','Provides administrative privileges to manage the Web Feature Service (WFS) component of Oracle Spatial.');

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('WFS_USR_ROLE','grbsdo','Y','Provides user privileges for the Web Feature Service (WFS) component of Oracle Spatial.');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/ROLE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbsdo ODBCAPTURE/SCHEMA_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.SCHEMA_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."SCHEMA_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/SCHEMA_CONF.ctl

prompt Translating ../grbsdo/ODBCAPTURE/SCHEMA_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('MDDATA','grbsdo','Y',NULL,NULL,NULL,NULL,'SDO,LCTR - Spatial - Oracle Locator (MDSYS, MDDATA)');

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('MDSYS','grbsdo','Y',NULL,NULL,NULL,NULL,'SDO,LCTR - Spatial - Oracle Locator (MDSYS, MDDATA)');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/SCHEMA_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- PACKAGE BODY Install


prompt ============================================================
prompt Running: grbsdo ODBCAPTURE/GRAB_SDO.pkbsql
prompt ============================================================

--
--  Create ODBCAPTURE.GRAB_SDO Package Body
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRAB_SDO

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "ODBCAPTURE"."GRAB_SDO" as


------------------------------------------------------------
-- Report the SQL Script Values of the SDO DIM Element
function sql_sdo_dim_element
      (in_de  in  sdo_dim_element)
   return varchar2
as
begin
   return 'sdo_dim_element(''' ||             in_de.sdo_dimname            ||
                        ''', ' || nvl(to_char(in_de.sdo_lb       ),'NULL') ||
                          ', ' || nvl(to_char(in_de.sdo_ub       ),'NULL') ||
                          ', ' || nvl(to_char(in_de.sdo_tolerance),'NULL') ||
                           ')' ;
end sql_sdo_dim_element;


------------------------------------------------------------
-- Report the SQL Script Values of the SDO DIM Array
function sql_sdo_dim_array
      (in_da      in  sdo_dim_array
      ,in_spaces  in  varchar2 default '')
   return varchar2
as
   ret_txt  varchar2(32767);
begin
   if in_da.EXISTS(1)
   then
      ret_txt := 'sdo_dim_array(' || grab_sdo.sql_sdo_dim_element(in_da(1));
      for i in 2 .. in_da.COUNT
      loop
         ret_txt := ret_txt || CHR(10) || in_spaces ||
                    '             ,' || grab_sdo.sql_sdo_dim_element(in_da(i));
      end loop;
      ret_txt := ret_txt || CHR(10) || in_spaces ||
                 '             )';
   end if;
   return ret_txt;
end sql_sdo_dim_array;


------------------------------------------------------------
-- Report the Control File Specification of the SDO POINT
function ctl_sdo_point_type
      (in_spaces  in  varchar2 default '   ')
   return varchar2
as
begin
    return 'COLUMN OBJECT TREAT AS SDO_POINT_TYPE'      || CHR(10) || in_spaces ||
           '   (X   FLOAT EXTERNAL TERMINATED BY '';''' || CHR(10) || in_spaces ||
           '   ,Y   FLOAT EXTERNAL TERMINATED BY '';''' || CHR(10) || in_spaces ||
           '   ,Z   FLOAT EXTERNAL TERMINATED BY '';''' || CHR(10) || in_spaces ||
           '   )';
end ctl_sdo_point_type;


------------------------------------------------------------
-- Report the Data Contents of the SDO POINT
function dat_sdo_point_type
      (in_pt  in  sdo_point_type)
   return varchar2
as
begin
    return to_char(in_pt.x) || ';' ||
           to_char(in_pt.y) || ';' ||
           to_char(in_pt.z) || ';' ;
end dat_sdo_point_type;


------------------------------------------------------------
-- Report the Control File Specification of the SDO_ELEM_INFO_ARRAY
function ctl_sdo_elem_info_array
   return varchar2
as
   delim  varchar2(1);
begin
   grab_scripts.grb_cldr_array_lvl := grab_scripts.grb_cldr_array_lvl + 1;
   delim                           := grab_scripts.grb_cldr_delim_nt(grab_scripts.grb_cldr_array_lvl);
   return 'VARRAY TERMINATED BY ''' || delim || ''' (SDO_ELEM_INFO_ARRAY  FLOAT EXTERNAL TERMINATED BY '';'')';
end ctl_sdo_elem_info_array;


------------------------------------------------------------
-- Report the Data Contents of the SDO_ELEM_INFO_ARRAY
function dat_sdo_elem_info_array
      (in_eia  in  sdo_elem_info_array)
   return varchar2
as
   delim     varchar2(1);
   ret_txt   varchar2(32767);
begin
   grab_scripts.grb_cldr_array_lvl := grab_scripts.grb_cldr_array_lvl + 1;
   delim                           := grab_scripts.grb_cldr_delim_nt(grab_scripts.grb_cldr_array_lvl);
   if in_eia.EXISTS(1)
   then
      ret_txt := to_char(in_eia(1));
      for i in 2 .. in_eia.COUNT
      loop
         ret_txt := ret_txt || ';' || to_char(in_eia(i));
      end loop;
   else
      ret_txt := '';
   end if;
   return ret_txt || delim;
end dat_sdo_elem_info_array;


------------------------------------------------------------
-- Report the Control File Specification of the SDO_ORDINATE_ARRAY
function ctl_sdo_ordinate_array
   return varchar2
as
   delim  varchar2(1);
begin
   grab_scripts.grb_cldr_array_lvl := grab_scripts.grb_cldr_array_lvl + 1;
   delim                           := grab_scripts.grb_cldr_delim_nt(grab_scripts.grb_cldr_array_lvl);
   return 'VARRAY TERMINATED BY ''' || delim || ''' (SDO_ORDINATE_ARRAY  FLOAT EXTERNAL TERMINATED BY '';'')';
end ctl_sdo_ordinate_array;


------------------------------------------------------------
-- Report the Data Contents of the SDO_ORDINATE_ARRAY
function dat_sdo_ordinate_array
      (in_oa  in  sdo_ordinate_array)
   return varchar2
as
   delim     varchar2(1);
   ret_txt   varchar2(32767);
begin
   grab_scripts.grb_cldr_array_lvl := grab_scripts.grb_cldr_array_lvl + 1;
   delim                           := grab_scripts.grb_cldr_delim_nt(grab_scripts.grb_cldr_array_lvl);
   if in_oa.EXISTS(1)
   then
      ret_txt := to_char(in_oa(1));
      for i in 2 .. in_oa.COUNT
      loop
         ret_txt := ret_txt || ';' || to_char(in_oa(i));
      end loop;
   else
      ret_txt := '';
   end if;
   return ret_txt || delim;
end dat_sdo_ordinate_array;


------------------------------------------------------------
-- Report the Control File Specification of the SDO_GEOMETRY
function ctl_sdo_geometry
      (in_spaces  in  varchar2 default '   ')
   return varchar2
as
begin
   return 'COLUMN OBJECT TREAT AS SDO_GEOMETRY'                                 || CHR(10) || in_spaces ||
          '   (SDO_GTYPE     FLOAT EXTERNAL TERMINATED BY '';'''                || CHR(10) || in_spaces ||
          '   ,SDO_SRID      FLOAT EXTERNAL TERMINATED BY '';'''                || CHR(10) || in_spaces ||
          '   ,SDO_POINT     ' || grab_sdo.ctl_sdo_point_type(in_spaces||'   ') || CHR(10) || in_spaces ||
          '   ,SDO_ELEM_INFO ' || grab_sdo.ctl_sdo_elem_info_array              || CHR(10) || in_spaces ||
          '   ,SDO_ORDINATES ' || grab_sdo.ctl_sdo_ordinate_array               || CHR(10) || in_spaces ||
          '   )';
end ctl_sdo_geometry;


------------------------------------------------------------
-- Report the Data Contents of the SDO_GEOMETRY
function dat_sdo_geometry
      (in_geo  in  sdo_geometry)
   return varchar2
as
begin
   return to_char(in_geo.sdo_gtype)                              || ';' ||
          to_char(in_geo.sdo_srid)                               || ';' ||
          grab_sdo.dat_sdo_point_type(in_geo.sdo_point)          ||
          grab_sdo.dat_sdo_elem_info_array(in_geo.sdo_elem_info) ||
          grab_sdo.dat_sdo_ordinate_array(in_geo.sdo_ordinates)  ;
end dat_sdo_geometry;


------------------------------------------------------------
-- Report the Control File Specification of the SDO_GEOMETRY
function ctl_st_geometry
      (in_spaces  in  varchar2 default '   ')
   return varchar2
as
begin
   return 'COLUMN OBJECT TREAT AS ST_GEOMETRY'                         || CHR(10) || in_spaces ||
          '   (GEOM   ' || grab_sdo.ctl_sdo_geometry(in_spaces||'   ') || CHR(10) || in_spaces ||
          '   )';
end ctl_st_geometry;


------------------------------------------------------------
-- Report the Data Contents of the SDO_GEOMETRY
function dat_st_geometry
      (in_geo  in  st_geometry)
   return varchar2
as
begin
   return grab_sdo.dat_sdo_geometry(in_geo.geom);
end dat_st_geometry;


------------------------------------------------------------
-- Report the Data Contents of the SDO_GEOMETRY
procedure grb_ind
      (in_table_owner  in varchar2
      ,in_table_name   in varchar2
      ,in_table_type   in varchar2
      ,in_index_owner  in varchar2
      ,in_index_name   in varchar2
      ,in_index_ext    in varchar2
      ,in_ityp_owner   in varchar2
      ,in_ityp_name    in varchar2)
is
   fh                fh2.sf_ptr_type;  -- Domain Index file handler
   old_schema_name   varchar2(1000) := grab_scripts.g_schema_name;
   ----------------------------------------
   procedure l_close_file as
      l_file_name  varchar2(1000) :=
                   fh2.sf_aa(fh.bld_type)(fh.bld_ord)(fh.file_id).filename;
   begin
      --
      fh2.script_put_line(fh, '');
      fh2.script_put_line(fh, 'set define on');
      fh2.script_close(fh);
      --
      grab_scripts.g_schema_name  := '';
      fh := fh2.script_open(in_filename     => 'odbcapture_installation_logs.csv'
                           ,in_elmnt        => 'INSTALL_SCRIPT'
                           ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
      grab_scripts.g_schema_name  := old_schema_name;
      --
      fh2.script_put_line(fh, '"' || grab_scripts.g_build_type ||
                            '","' || l_file_name || '.log"' );
      fh2.script_close(fh);
      --
   end l_close_file;
begin
   dbms_output.put_line(in_table_owner || ', ' ||
                        in_table_name  || ', ' ||
                        in_table_type  || ', ' ||
                        in_index_owner || ', ' ||
                        in_index_name  || ', ' ||
                        in_index_ext   );
   --
   grab_scripts.g_schema_name  := '';
   fh := fh2.script_open(in_filename     => replace(replace(in_index_name ,'$','_'),'%','_')
                                                   || '.' || in_index_ext
                               ,in_elmnt        => 'INSTALL_SCRIPT'
                               ,in_max_linesize => common_util.MAXIMUM_SQL_LENGTH);
   grab_scripts.g_schema_name  := old_schema_name;
   --
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '--  Create Indexes for ' || in_table_owner ||
                                                        '.' || in_table_name  ||
                                                        ' ' || in_table_type  );
   fh2.script_put_line(fh, '--');
   fh2.script_put_line(fh, '');
   fh2.script_put_line(fh, 'set define off');
   fh2.script_put_line(fh, '');
   for buf1 in (select column_name from dba_ind_columns
                 where table_owner = grab_scripts.g_schema_name
                  and  table_name  = in_table_name
                  and  index_owner = in_index_owner
                  and  index_name  = in_index_name
                 order by column_position )
   loop
      for buf2 in (select diminfo, srid
                    from  MDSYS.all_sdo_geom_metadata
                    where owner       = grab_scripts.g_schema_name
                     and  table_name  = in_table_name
                     and  column_name = buf1.column_name)
      loop
         fh2.script_put_line(fh, '----------------------------------------');
         fh2.script_put_line(fh, 'prompt');
         fh2.script_put_line(fh, 'prompt MUST be run as ' || grab_scripts.g_schema_name);
         fh2.script_put_line(fh, 'insert into MDSYS.user_sdo_geom_metadata');
         fh2.script_put_line(fh, '      (table_name');
         fh2.script_put_line(fh, '      ,column_name');
         fh2.script_put_line(fh, '      ,diminfo');
         fh2.script_put_line(fh, '      ,srid)');
         fh2.script_put_line(fh, '   values');
         fh2.script_put_line(fh, '      (''' || in_table_name  || '''');
         fh2.script_put_line(fh, '      ,''' || buf1.column_name || '''');
         fh2.script_put_line(fh, '      ,' || grab_sdo.sql_sdo_dim_array(buf2.diminfo, '       '));
         fh2.script_put_line(fh, '      ,' || nvl(to_char(buf2.srid),'NULL'));
         fh2.script_put_line(fh, '      );');
         fh2.script_put_line(fh, '');
      end loop;
      fh2.script_put_line(fh, 'CREATE INDEX "' || in_index_owner || '"."' || in_index_name || '"' || CHR(10) ||
                                     '   ON "' || in_table_owner || '"."' || in_table_name || '" ("' || buf1.column_name || '")' || CHR(10) ||
                                     '   INDEXTYPE IS "' || in_ityp_owner || '"."' || in_ityp_name || '";');
      fh2.script_put_line(fh, '');
   end loop;
   --
   --fh2.script_put_line(fh, '--DBMS_METADATA:' || in_index_owner ||
   --                                              '.' || in_index_name);
   --fh2.put_big_line(fh, grab_scripts.g_schema_name || '.' || in_table_name || ' ' || in_table_type
   --                ,dbms_metadata.get_ddl(object_type => 'INDEX'
   --                                      ,name        => in_index_name
   --                                      ,schema      => in_index_owner)
   --                ,common_util.MAXIMUM_SQL_LENGTH);
   --
   l_close_file;
end grb_ind;


------------------------------------------------------------
-- Define Dynamic SQL Column
procedure grb_cldr_define
      (in_dyn_curs  in            integer
      ,in_position  in            integer
      ,io_lc        in out nocopy varchar2
      ,io_fh        in out nocopy fh2.sf_ptr_type
      ,io_desc_tab3 in out nocopy dbms_sql.desc_tab3)
is
begin
   case
      when io_desc_tab3(in_position).col_type_name = 'SDO_ELEM_INFO_ARRAY'
      then
         fh2.script_put_line(io_fh, io_lc || common_util.old_rpad(io_desc_tab3(in_position).col_name,30) ||
                 ' ' || ctl_sdo_elem_info_array );
         dbms_sql.define_column(c         => in_dyn_curs
                               ,position  => in_position
                               ,column    => sdo_elem_info_buff);
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_GEOMETRY'
      then
         fh2.script_put_line(io_fh, io_lc || common_util.old_rpad(io_desc_tab3(in_position).col_name,30) ||
                 ' ' || ctl_sdo_geometry );
         dbms_sql.define_column(c         => in_dyn_curs
                               ,position  => in_position
                               ,column    => sdo_geometry_buff);
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_ORDINATE_ARRAY'
      then
         fh2.script_put_line(io_fh, io_lc || common_util.old_rpad(io_desc_tab3(in_position).col_name,30) ||
                 ' ' || ctl_sdo_ordinate_array );
         dbms_sql.define_column(c         => in_dyn_curs
                               ,position  => in_position
                               ,column    => sdo_ordinate_buff);
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_POINT_TYPE'
      then
         fh2.script_put_line(io_fh, io_lc || common_util.old_rpad(io_desc_tab3(in_position).col_name,30) ||
                 ' ' || ctl_sdo_point_type );
         dbms_sql.define_column(c         => in_dyn_curs
                               ,position  => in_position
                               ,column    => sdo_point_buff);
         --
      when io_desc_tab3(in_position).col_type_name = 'ST_GEOMETRY'
      then
         fh2.script_put_line(io_fh, io_lc || common_util.old_rpad(io_desc_tab3(in_position).col_name,30) ||
                 ' ' || ctl_st_geometry );
         dbms_sql.define_column(c         => in_dyn_curs
                               ,position  => in_position
                               ,column    => st_geometry_buff);
         --
      else
         raise_application_error(-20000, 'Bad Column Type "' || io_desc_tab3(in_position).col_type ||
                                                     '" in io_desc_tab3(' || in_position || ').col_type');
   end case;
end grb_cldr_define;


------------------------------------------------------------
-- Value from Dynamic SQL Column
procedure grb_cldr_value
      (in_dyn_curs  in            integer
      ,in_position  in            integer
      ,io_lc        in out nocopy varchar2
      ,io_fh        in out nocopy fh2.sf_ptr_type
      ,io_desc_tab3 in out nocopy dbms_sql.desc_tab3)
is
begin
   case
      when io_desc_tab3(in_position).col_type_name = 'SDO_ELEM_INFO_ARRAY'
      then
         dbms_sql.column_value(c         => in_dyn_curs
                              ,position  => in_position
                              ,value     => sdo_elem_info_buff);
         fh2.script_put(io_fh, io_lc || grab_sdo.dat_sdo_elem_info_array(sdo_elem_info_buff));
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_GEOMETRY'
      then
         dbms_sql.column_value(c         => in_dyn_curs
                              ,position  => in_position
                              ,value     => sdo_geometry_buff);
         fh2.script_put(io_fh, io_lc || grab_sdo.dat_sdo_geometry(sdo_geometry_buff));
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_ORDINATE_ARRAY'
      then
         dbms_sql.column_value(c         => in_dyn_curs
                              ,position  => in_position
                              ,value     => sdo_ordinate_buff);
         fh2.script_put(io_fh, io_lc || grab_sdo.dat_sdo_ordinate_array(sdo_ordinate_buff));
         --
      when io_desc_tab3(in_position).col_type_name = 'SDO_POINT_TYPE'
      then
         dbms_sql.column_value(c         => in_dyn_curs
                              ,position  => in_position
                              ,value     => sdo_point_buff);
         fh2.script_put(io_fh, io_lc || grab_sdo.dat_sdo_point_type(sdo_point_buff));
         --
      when io_desc_tab3(in_position).col_type_name = 'ST_GEOMETRY'
      then
         dbms_sql.column_value(c         => in_dyn_curs
                              ,position  => in_position
                              ,value     => st_geometry_buff);
         fh2.script_put(io_fh, io_lc || grab_sdo.dat_st_geometry(st_geometry_buff));
         --
      else
         raise_application_error(-20000, 'Bad Column Type "' || io_desc_tab3(in_position).col_type ||
                                                     '" in io_desc_tab3(' || in_position || ').col_type');
   end case;
end grb_cldr_value;


end grab_sdo;
/

set define on

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbsdo ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbsdo', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbdat Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbdat ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbdat"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
end;
/


----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbdat ODBCAPTURE/DLOAD_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.DLOAD_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."DLOAD_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/DLOAD_CONF.ctl

prompt Translating ../grbdat/ODBCAPTURE/DLOAD_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','BUILD_CONF','grbsrc','BUILD_SEQ',NULL,NULL,'build_seq <= -41',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','BUILD_PATH','grbsrc','PARENT_BUILD_SEQ, BUILD_SEQ',NULL,NULL,'build_seq <= -41',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','DLOAD_CONF','grbdat','USERNAME, TABLE_NAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbsrc'',''grbjava'',''grbras'',''grbsdo'',''grbendp'',''grbdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ELEMENT_CONF','grbsrc','ELEMENT_SEQ',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','METADATA_TRANSFORM_PARAMS','grbsrc','NAME',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','OBJECT_CONF','grbdat','USERNAME, ELEMENT_NAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbsrc'',''grbjava'',''grbras'',''grbsdo'',''grbendp'',''grbdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ROLE_CONF','grbjava','ROLENAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbjava'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ROLE_CONF','grbras','ROLENAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbras'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ROLE_CONF','grbsdo','ROLENAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbsdo'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ROLE_CONF','grbsrc','ROLENAME, BUILD_TYPE',NULL,NULL,'build_type in (''sys'',''pub'',''grbsrc'',''grbendp'',''grpdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','SCHEMA_CONF','grbjava','USERNAME',NULL,NULL,'build_type in (''grbjava'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','SCHEMA_CONF','grbras','USERNAME',NULL,NULL,'build_type in (''grbras'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','SCHEMA_CONF','grbsdo','USERNAME',NULL,NULL,'build_type in (''grbsdo'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','SCHEMA_CONF','grbsrc','USERNAME',NULL,NULL,'build_type in (''sys'',''pub'',''grbsrc'',''grbendp'',''grpdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','TSPACE_CONF','grbsrc','USERNAME, TSPACE_NAME',NULL,NULL,'username in (select username from schema_conf where build_type in (''grbsrc''))',NULL,NULL);


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/DLOAD_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbdat ODBCAPTURE/OBJECT_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.OBJECT_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."OBJECT_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/OBJECT_CONF.ctl

prompt Translating ../grbdat/ODBCAPTURE/OBJECT_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','DIRECTORY','grbendp','^GRAB_SCRIPTS_DIR$','Do Not Capture. GRAB_SCRIPTS.write_scripts creates this directory when needed');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','GRANT','grbjava','JAVA','Any Oracle Provided Grant with JAVA in the Name (Oracle Provided Objects, System Priveleges, and Queue SysPrivs)');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','JAVA_SOURCE','grbjava','.*','All Java Source');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_BODY','grbjava','GRAB_JAVA','Any Package Body with GRAB_JAVA in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_BODY','grbras','GRAB_RAS','Any Package Body with GRAB_RAS in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_BODY','grbsdo','GRAB_SDO','Any Package Body with GRAB_SDO in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_SPEC','grbjava','GRAB_JAVA','Any Package Specification with GRAB_JAVA in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_SPEC','grbras','GRAB_RAS','Any Package Specification with GRAB_RAS in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','PACKAGE_SPEC','grbsdo','GRAB_SDO','Any Package Specification with GRAB_SDO in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','ROLE','grbjava','JAVA','Any Oracle Provided Role Grant with JAVA in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','SYS_GRANT','grbjava','JAVA','Any SYS Grants on objects with "JAVA" in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','SYS_GRANT','grbras','^DBA_XS_','Any SYS Grants on objects with "DBA_XS_" (Real Application Security Views)');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','TABLE','grbendp','^ODBCAPTURE_INSTALLATION_LOGS$','Do Not Capture. ODBCapture should never own the ODBCAPTURE_INSTALLATION_LOGS table.');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','TABLE','grbras','EXPORTING_RAS_DATA','Only Valid with Real Application Security');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','VIEW','grbjava','JAVA','Any View with JAVA in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','VIEW','grbras','PRIV_OBJ_RACL_VIEW','Only Valid with Real Application Security');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/OBJECT_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbdat ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbdat', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
-- ROLE Install


prompt ============================================================
prompt Running: grbtst SYS/GRB_TEST_ROLE.role
prompt ============================================================

--
--  Create GRB_TEST_ROLE Role
--

set define off


create role GRB_TEST_ROLE;


--  Current Grant of YS Objects (but not directories)


set define on

----------------------------------------
-- USER Install


prompt ============================================================
prompt Running: grbtst SYS/ODBCTEST.user
prompt ============================================================

--
--  Create ODBCTEST Schema
--

set define off

create user "ODBCTEST"
   no authentication
   profile DEFAULT
   temporary tablespace TEMP
   default tablespace USERS
   quota 512M on USERS
   ;

--  Current Grant of SYS Objects (but not directories)


-- Real Application Security System Grants


prompt XS Admin Grant "ADMIN_ANY_SEC_POLICY" to "ODBCTEST"
begin
   execute immediate 'begin' ||
                     '  xs_admin_util.grant_system_privilege(''ADMIN_ANY_SEC_POLICY'', ''ODBCTEST''); ' ||
                     'end;';
exception when others then
   if    SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
     AND SQLERRM not like '%ORA-01031: insufficient privileges%'
   then
      raise;
   end if;
end;
/

prompt XS Admin Cloud Grant "ADMIN_ANY_SEC_POLICY" to "ODBCTEST"
begin
   execute immediate 'begin' ||
                     '  xs_admin_cloud_util.grant_system_privilege(''ADMIN_ANY_SEC_POLICY'', ''ODBCTEST''); ' ||
                     'end;';
exception when others then
   if SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_CLOUD_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
   then
      raise;
   end if;
end;
/


prompt XS Admin Grant "PROVISION" to "ODBCTEST"
begin
   execute immediate 'begin' ||
                     '  xs_admin_util.grant_system_privilege(''PROVISION'', ''ODBCTEST''); ' ||
                     'end;';
exception when others then
   if    SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
     AND SQLERRM not like '%ORA-01031: insufficient privileges%'
   then
      raise;
   end if;
end;
/

prompt XS Admin Cloud Grant "PROVISION" to "ODBCTEST"
begin
   execute immediate 'begin' ||
                     '  xs_admin_cloud_util.grant_system_privilege(''PROVISION'', ''ODBCTEST''); ' ||
                     'end;';
exception when others then
   if SQLERRM not like '%PLS-00201: identifier ''XS_ADMIN_CLOUD_UTIL.GRANT_SYSTEM_PRIVILEGE'' must be declared%'
   then
      raise;
   end if;
end;
/


set define on

----------------------------------------
-- HOST_ACL Install


prompt ============================================================
prompt Running: grbtst SYS/host1.hacl
prompt ============================================================

--
--  Create Host ACL/ACE
--
-- Host ACLs with the following:
--    PRINCIPAL_TYPE      = 'DATABASE' (xs_acl.ptype_db)
--    GRANT_TYPE          = 'GRANT'
--    INVERTED_PRINICIPAL = 'NO'
--    PRIVILEGE          is not null
-- Start Dates and End Dates are ignored (set to NULL).
--

set define off


--
--  Create Host ACL/ACE for host1 from port 1100 to 1101 
--  NOTE: This is a "GRANTEE" Host ACL
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
      (host        => 'host1'
      ,lower_port  => 1100
      ,upper_port  => 1101
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('CONNECT')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'ODBCTEST'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/

set define on

prompt ============================================================
prompt Running: grbtst SYS/host2.hacl
prompt ============================================================

--
--  Create Host ACL/ACE
--
-- Host ACLs with the following:
--    PRINCIPAL_TYPE      = 'DATABASE' (xs_acl.ptype_db)
--    GRANT_TYPE          = 'GRANT'
--    INVERTED_PRINICIPAL = 'NO'
--    PRIVILEGE          is not null
-- Start Dates and End Dates are ignored (set to NULL).
--

set define off


--
--  Create Host ACL/ACE for host2 from port NULL to NULL 
--  NOTE: This is a "GRANTEE" Host ACL
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
      (host        => 'host2'
      ,lower_port  => NULL
      ,upper_port  => NULL
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('CONNECT')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'ODBCTEST'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/


--
--  Create Host ACL/ACE for host2 from port NULL to NULL 
--  NOTE: This is a "GRANTEE" Host ACL
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
      (host        => 'host2'
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('RESOLVE')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'ODBCTEST'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/

set define on

prompt ============================================================
prompt Running: grbtst SYS/odbctest_host.hacl
prompt ============================================================

--
--  Create Host ACL/ACE
--
-- Host ACLs with the following:
--    PRINCIPAL_TYPE      = 'DATABASE' (xs_acl.ptype_db)
--    GRANT_TYPE          = 'GRANT'
--    INVERTED_PRINICIPAL = 'NO'
--    PRIVILEGE          is not null
-- Start Dates and End Dates are ignored (set to NULL).
--

set define off


--
--  Create Host ACL/ACE for odbctest_host from port 1234 to 5678 
--  NOTE: This is a "OBJECT_NAME_REGEXP" Host ACL
--   (OBJECT_NAME_REGEXP: ^odbctest)
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
      (host        => 'odbctest_host'
      ,lower_port  => 1234
      ,upper_port  => 5678
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('CONNECT')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'PUBLIC'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/

set define on

----------------------------------------
-- WALLET_ACL Install


prompt ============================================================
prompt Running: grbtst SYS/_opt_install_files_oracle_wallet.wacl
prompt ============================================================

--
--  Create Wallet ACL/ACE
--
-- Wallet ACLs with the following:
--    PRINCIPAL_TYPE      = 'DATABASE' (xs_acl.ptype_db)
--    GRANT_TYPE          = 'GRANT'
--    INVERTED_PRINICIPAL = 'NO'
--    PRIVILEGE          is not null
-- Start Dates and End Dates are ignored (set to NULL).
--

set define off


--
--  NOTE: This is a "GRANTEE" Wallet ACL
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE
      (wallet_path => 'file:/opt/install_files/oracle_wallet'
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('USE_PASSWORDS')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'ODBCTEST'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/

set define on

prompt ============================================================
prompt Running: grbtst SYS/_var_opt_install_files_oracle_wallet.wacl
prompt ============================================================

--
--  Create Wallet ACL/ACE
--
-- Wallet ACLs with the following:
--    PRINCIPAL_TYPE      = 'DATABASE' (xs_acl.ptype_db)
--    GRANT_TYPE          = 'GRANT'
--    INVERTED_PRINICIPAL = 'NO'
--    PRIVILEGE          is not null
-- Start Dates and End Dates are ignored (set to NULL).
--

set define off


--
--  NOTE: This is a "GRANTEE" Wallet ACL
--

begin
   DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE
      (wallet_path => 'file:/var\opt\install_files/oracle_wallet'
      ,ace         => xs$ace_type
                         (privilege_list   => xs$name_list('USE_PASSWORDS')
                         ,granted          => TRUE
                         ,inverted         => FALSE
                         ,principal_name   => 'ODBCTEST'
                         ,principal_type   => xs_acl.ptype_db
                         ,start_date       => NULL
                         ,end_date         => NULL));
end;
/

set define on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
-- GRANT Install


prompt ============================================================
prompt Running: grbtst SYSTEM/ODBCTEST_usr.grnt
prompt ============================================================


--
--  Create ODBCTEST Grants
--

set define off



--  Database System Privileges

grant CREATE PROCEDURE to "ODBCTEST";
grant CREATE SEQUENCE to "ODBCTEST";
grant CREATE SESSION to "ODBCTEST";
grant CREATE TABLE to "ODBCTEST";


--  "sys" BUILD_TYPE Role Grants
--  "GRANTEE" (delayed) Role Grants
--  Note: "OBJECT" Schema Object Grants are given during Role creation

grant "GRB_TEST_ROLE" to "ODBCTEST" with admin option;


set define on


----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbtst Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbtst ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbtst"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
end;
/


----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbtst ODBCAPTURE/GRBTST__NAME.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.GRBTST_$NAME Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRBTST_$NAME

  CREATE TABLE "ODBCAPTURE"."GRBTST_$NAME" 
   (	"C1" VARCHAR2(20 BYTE), 
	"ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.GRBTST_$NAME


--  Grants
grant DELETE on "ODBCAPTURE"."GRBTST_$NAME" to "GRB_TEST_ROLE";
grant INSERT on "ODBCAPTURE"."GRBTST_$NAME" to "GRB_TEST_ROLE";
grant SELECT on "ODBCAPTURE"."GRBTST_$NAME" to "GRB_TEST_ROLE";
grant UPDATE on "ODBCAPTURE"."GRBTST_$NAME" to "GRB_TEST_ROLE";


--  Synonyms


set define on

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/GRBTST_IMAGE.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.GRBTST_IMAGE Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRBTST_IMAGE

  CREATE TABLE "ODBCAPTURE"."GRBTST_IMAGE" 
   (	"ID" NUMBER(5,0), 
	"IMAGE" BLOB
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCAPTURE.GRBTST_IMAGE


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbtst ODBCAPTURE/BUILD_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.BUILD_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."BUILD_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/BUILD_CONF.ctl

prompt Translating ../grbtst/ODBCAPTURE/BUILD_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-40,'grbtst','ODBCapture and ODBCTest Testing Objects');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-38,'grbtjva','ODBCTest Java Testing');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-35,'grbtjsn','ODBCapture JSON Data Type Testing');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-33,'grbtsdo','ODBCTest Spatial Data Option Testing');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-30,'grbtctx','ODBCTest Testing of Oracle Text');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-10,'grbtend','ODBCapture and ODBCTest Testing Objects Endpoint and Non-Generated Objects');

insert into "ODBCAPTURE"."BUILD_CONF" ("BUILD_SEQ","BUILD_TYPE","NOTES")
  values (-8,'grbtdat','ODBCapture and ODBCTest Testing Self-Capture Configuration Data');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/BUILD_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/BUILD_PATH.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.BUILD_PATH data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."BUILD_PATH"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'BUILD_PATH'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/BUILD_PATH.ctl

prompt Translating ../grbtst/ODBCAPTURE/BUILD_PATH.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-50,-40);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-40,-38);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-40,-35);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-40,-33);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-40,-30);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-38,-10);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-35,-10);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-33,-10);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-30,-10);

insert into "ODBCAPTURE"."BUILD_PATH" ("PARENT_BUILD_SEQ","BUILD_SEQ")
  values (-10,-8);


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/BUILD_PATH.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/GRBTST__NAME.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.GRBTST_$NAME data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_$NAME'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_$NAME'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."GRBTST_$NAME"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_$NAME'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/GRBTST__NAME.ctl

prompt Translating ../grbtst/ODBCAPTURE/GRBTST__NAME.csv to 'INSERT INTO'

-- Manually Fixed by DDieterich
insert into "ODBCAPTURE"."GRBTST_$NAME" ("C1","ID")
  values ('5',5);

-- Manually Fixed by DDieterich
insert into "ODBCAPTURE"."GRBTST_$NAME" ("C1","ID")
  values ('15',15);


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/GRBTST__NAME.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/GRBTST_IMAGE.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.GRBTST_IMAGE data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_IMAGE'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_IMAGE'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."GRBTST_IMAGE"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_IMAGE'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/GRBTST_IMAGE.ctl

prompt Translating ../grbtst/ODBCAPTURE/GRBTST_IMAGE.csv to 'INSERT INTO'

-- Need to Use "DBMS_LOB.CONVERTTOBLOB" on IMAGE data
insert into "ODBCAPTURE"."GRBTST_IMAGE" ("ID","IMAGE")
  values (1,'(Base64 with Linefeeds)
iVBORw0KGgoAAAANSUhEUgAAAY0AAAFTCAMAAADyTaC8AAAAA3NCSVQICAjb4U/g
AAABtlBMVEUAAAD7+O1/sn8AAP9QUFCurq6ZMzOGhoaZAJkAZgCpUlLq1ZXUqSfM
mQAnJydpaf/Vqqp+fn5YWP9CRT9wemLDh4frzevevFhja1jMzMypKanX1/+JCIkn
fScnJ/+OnHnjueOlpaWxv53Jeclre2PX19f379cHBwebrIM9iz1Ym1i8eXnt9O19
iWyVv5V1dXU9PT3v39+Ojo7dq93mzc3lzH/v7++3xKTMmZmVlf+rq/+zQLOxZGTX
59f79furzasHagecOTnV3coREf9YWFjB2sFqamoRERHz5sFLT0Xt7f/UlNQ9Pf9p
pWnf39/Bwf/PoBF/f//dvLz39/eGk3Ln5+fu3atocFsHB/+kG6RfZlX8+fnYsT2e
np6ltY66UrqgQUERcBFQVUnz4fPhw2nnwuf48fGSoXy9yKu+vr5bYlLNnAf9/Pdj
Y2PJ07v39/+VlZX57/lER0ARABHn6+HMf8xsdV+tMq28WLyRBJHXnNf15/VMUEfD
zrTx2/Hqy+rt8OhYXk+rupVJTURTWUzP2MPPhs/////b4tL39+/lveWwOrDgsuC/
YL/Zodm2SLbb4dGnI6eFtRMPAAAACXBIWXMAAAsSAAALEgHS3X78AAAAFnRFWHRD
cmVhdGlvbiBUaW1lADAxLzIzLzA3TruF+QAAAB90RVh0U29mdHdhcmUATWFjcm9t
ZWRpYSBGaXJld29ya3MgOLVo0ngAABW6SURBVHic7Z0LWxvXmYAFqhRGloRFTKFW
pXabR8hg4kpZI2MWFQgCeTHUgGJCjWtD7OBwSY2bi7Ob7iZptzlbb9rs/uM915kz
oxlJI43Qh/heP5bmcmbmzPfqXGbQ0YQIAodQrzOAaKANSKANSKANSKANSKANSKAN
SKANSKANSECxkRm0pjcMo+yZcGEqM7lC38sbGX2b/gCgjRWjRoinj8Vb5QWD6pjc
KK8cZM4nc+cGKBu1MvVABlmMG5QOWnikhbLR/YydK5BsbBgZY4qG2DAyGfriXQ8p
G4NYNroDtbGySN+NaWfZMAS6G2OBvW4sTp5zJrsOIBuTk+Vy+WCweU0lm4vp8uTU
+WTu3ABkI7OYoSw4bZQFNSvpgTlJS1JfAcjG5IaYdNjICBbUvN6RatjWX0AA2Vhg
n/SyajcWPBIeyNqJtSO3sE/VHWSf6kC14nTatU9VFm16mRwYmcXFPquowNgQlK2a
Z7pZJVQr91k1RaDZuOygDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUiA
tTHU6wz0gotmo78lgbXxzD77z3IebfQER9jvv/7YbXGfcVFskB9+/He3xf3FhbFB
/vOrvz9DGz3iWf2i+6+/QRu9wS3sb/7nPtroCUOu/B/a6AldKRvQXYK10ZV2A220
SVf6VGijTbpyvYE22qQr1+Joo026cp8KbbRJV+7hoo02QRuQQBuQcLneYKCNnoBl
AxJoAxJoAxKfhVwZcl/cIvrWQ0NDz7z+9+qkwdroftkIea3oHWgjgN0GBtoIYLeB
AdbGZ/bZ2v/+4c6TGzduDN3oBL71kzvv/43tEm20ji0+n39ii2dnNpiQz0lANuZG
susP+EQ2u9XuTkzA2tAy9u2d+nh2ZuPGk781thFOt5jN3bvpuTDVcTf8IL283uE5
XwQb77vF80tfFr584bBx4/2WbKSVlIZyhrPUCisg4ZeBnTQwzIz9h8un+9rxsS8b
x8fXHDbuNLSRDYfDW2Rtd3l5d40GeX13ObzmnVVq42WYTSzPBXXS0FAZs8vg8Xz3
0bFvG8eP3rXZeNJC2dilDcHWLp2h7+uqFgoL9DYiPEfS3EbHLQd0G+874jp044Nx
Gtvv/nTND//6X3Sb8Q/0Vqe5jTUeYVoo2MyDsGdOl2lFdTlsfOv8lP/8w2PGR28f
++HtP/G3D3/ux4aIMJ2yZghrSjhWC5FdJpfFxp06G+M8ru2UDVo6XGz89D575Tbu
/9Q8unfZyArMFoKVDJHMR0+s8UkDhGfs87oWgNZUj3hkW20yOHyLR6411bOv/kGE
jX98Zd0tDLNom+0GDXJ2xD2by3L5On2f867N/Jw0RHjGPnGxEUwrbtVUr373htt4
87tX1tGHw1mtTxXO7i675zIt2vQ0ebm7nA0/COSkIcIyVquPq4hnGz3cF9bWdhvk
m6/YF0rZq8Yar3TE9UY4nW7Qv1WkO62mCHAb/+1l48aLTq/+9Fb8l9d/M/Sb67/0
zErHzUHLgLbxB08bbeJug3z/dOjp995Z2er0ErtlQNuo61F1yQb5/noDGecIGBvu
o2e6wr81TdGrIICx4YRlrPGnu+2yMf7CWTagADBLApuN8Rct2rASetu4xm8hgjx1
gFkS6DauyVuwTW1oCT1tvKAXHy/Qhj90GyJ+LdjQEnra+JIm+hJt+EOzIePX3Iae
0MvGL/hdkl+gDV9YNlT8mtqwJfSyIe46jqMNX1g2xD30D5vbsCX0sPGBvMf+AchT
B5glgWnDjF8zG/aEHjbYDcc//vH4+FEN4qkDzJLAtDEu4zfezIY9obuNF+9SPvqI
vjyEeOoAsyRQNqz4Oe/COnAk9CgbDH4DGOSpA8ySwHb1Z91Ab1A27AnRRpCgDUig
DUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUg0seHx
RR0PG/YRA2jDNw1teI6m8VhuHy+ONnzTwEaDkWaeNvSRZmjDN542Go4X/8tfWhgv
jjZ842GjyXjxt92X28eLow3feNloPF68Udkwx4ujDd9411SNxot7txvaeHG04Rts
xSERdA9X+6Yi2vBN46s/r/HiePXXHfDOCCTQBiTQBiTQBiTQBiTQBiTQBiTQBiTQ
BiTQBiTQBiTQBiTQBiTQBiTQBiTQBiS6YwN/9aU9lI2Af/VlXH7NZxx/EckPZtlQ
8XvUrGzYE3rYYD9i9d13+GthPjFtmPFrZsOe0MOG+QNvIE8dYJYEVruhfomwmQ17
Qi8b+CuT7WDZCPZXJvEXWNtB61MF+gus/Ktu+OvEPtFsyF93bm5DT+htA3+52z/6
9Uagv9xN25cbaMMntqu/QH/VXgDy1CFkKYgnZvhN6ElPIwHBhs6/qAlb2XD9dLdB
f5WN2GwAhywW2et2jOFY9eb60PU3VsYaxDPIp2jBoTMbfN6fosPtKE8/u18sCi8m
X7/z9OOhj5++87XKmKeNzp+h/KQ/bBT3+JQIpG7jUIWWpdgrum3OGI1JG85yQX74
8YtXZIi8+uLHH0hDG0E8ffFOP9iILcWi2zTyS/v7S4dkNhqNxvgLXSXWxOb3Y9Gr
8/tLS9478bDxmj3+kLWi37wmDWwE8wzlv/aDjXla4UcJWaIBnV3Sy8ZNGtxidE+m
oCVj6arYpBgVWIVF2qDL5uuPYPZpPGwE9Qzlb/vBBgtktHgYZTPRQ81G9DZ92b/K
Z4pR0qg1EWtYdbZfr6OpjWCeofyJ71M/F9qyURQ2irqNopiqt1EUOHbCuR2tO0Iz
G8E8Q/lXe75P/Vxox8ahn7JxGBMc2nfCKbZjI4BW/JM9/6d+Lvi3wdoL1W7M3yTy
xWw3Wq2prqot7dhsPHG30dEzlP9856/ftnPq54JPG9H9fVokVJ+KVjW01eYvZp+q
mY0Ya9LpuqUo3aJ+tc2GC3L9w9/7yvfvHzr23uAIvcRvltSFhGwI9sTFBSv5h56X
GF57OnRZ2qKNNuk3G93mHG181tGuugIIG0PPXP6FXPFY3CK2rXt7u9YVEDZ8EGDZ
QBsdgzYgEaCNZx3tqitcYhtYNjoGbUACbUCiYxs/vFYz2G50TKc2vv7xm2B21RUu
m413vghoV13hktl48/RVQLvqCpfMxvWPrRlsNzqmQxtwvlboyiWzoZcNtNEx2G70
D7Y+FbYbPQavNyBhuxZHGz0G71NBAv++AQksG5BAG5BAG5DAdgMSWDYggTYggTaQ
1kEbkEAbkEAbkEAbkOhzG6cz1vRMvHn6nVM5cW+nK/lpQp/bGNAMKBsTCa/UEzOJ
CTG1k2hBXfD0uQ3BxAB7pTYG2IS3jXhc2hg4eYw2AiX+fCwxwyI/kNjcZB/1mc3N
eOIxIQnKhMdGYsVp4l4r1Vrw9LEN6uKU2TiZEbXUzMkpjfOAVjZmEgJrI2Fjc6el
RiZ4+tgGa8Bp5AdYsLkNFmAabu+aStqIj7XW5AdP/9uY8LZxOiGwNuI2EvF4/CQR
HzjvHF8GGw3Kxk5cYG3EbTBBY5teTUs36X8b5OQ5Od3UbAwkTj03Mpt3rKmCxbQx
QGudx5oNsnni8cFPWN0ttNFFxp7rcxO9qIVa4RLYuPJ4ZqxB5QSJS2Dj9MrMlV7n
oUUugY0LBNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqA
BNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqAxLnbiKRS
qUj94py1LFVz3zLnshklmSK5pmdhpojkGq11OXQo550jRi3V7Ng+OHcbyWQqlazW
LY6sWilK7ltqSWw79GVj1aE0ldTXuhya2fDIEd+2lGx2bB/4t1Hy+TBpx5kk2Wcp
f8Ymc2JVzu3jSkpiZc2xspSrWZMluUMRzfr91GTiUs7hy9qrsqEdR9sPXRqy7zWn
slWT2zq2yTUoRs3xa6NGaxpfG9B6yZZBboO9RELJfJVGKl9Nhs7YmSX5s3T5pzFV
pQsLNGGFJlLxYCefzIvlhE+y7ZUNup9qvkT3SshRqEZK9P9qKBmq0BRVulHIOnwu
VKnm82I2xw9pLqGHotmqhuQnSB2d5SiZCiVVnsWe1bbmsUmykGfn0j7+bNSO3kr5
tpF660jzwUSwUNXYKSfPSIHVPyX1OctHxLnnRQIWW6LZOKvSdznL9snKmLSRp/tN
5elWNVKhiyN5cpRnG5dIJanXRSx1TpVOs2zIJfQ9dER3LfJrHp3liEa/pPIcoQch
EauWk8emNuRG7eJr25+9R2P760//yQ+f/ppu897PzH3Qj3QyT8/4LJ/L5WigCtWc
GRVSrRD5SRTvXJVug8VKEVlNhlLKRomfCI1WNUJCkSpZXSWFAj1CNUVnnTaILKJE
bzfYEmajYlatBZkbM0dmnldt25rHZrto3oY1wMe2vz1LMVZ/kvLDTz7lb2e/VeGo
5FbZQWnBp9DTKoRCSVk2KlVCbDZ4zPSaajUUyksh1WqKxVrGVwSBJl2tHBVIqFY9
4t6TyQjfvnUbpWqIV28qjW5D5VlurLY1j32uNt7jcW2nbNDSYdpIiajzSkdQqhb4
mbHCThqWDUqtIrJsRtBRNo7ylQipnNFZ+QnmdU/rNghrd0Q1llRHN8uGzDOEskFr
qrd4ZH0dgG/xllZTsc1p+GusAqkdEdbjXOU2IrLx1GywCvpMs8EaoCORZd725FPO
doNuxtvxJBH7o32gQoF9qq3D22ycsU10G0xE9cxcl9NtmHlm6SPWtma7ca42gmrF
6WEr9JRovynC+i2sP+LoU0kbrGZKaTbkNhy2oVVTmf0a3pQS1qCwng/rHpVC1XzB
y0aNrrTZyNNuk+q5VvPVgm7DPL7orZnbmn2q87VBD9xGD9fjak520mvu1xsmNVsW
tcQlx35d9iMXNbwIyDl2U9IWONeZe5RXMub6JufQKv5NPvR59ffQ9xE0qqupvPsl
eF8C/K7hUSoVzKfuYgDcxiUDbUACbUACbUACbUACbUACbUACbUACbUACbUACbUAC
bUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUDC24Y1
ILiDQbgeo4rbp2xoMxnD8EwoKEaDPLjfZ8f7xtuGNSC4g0G4HqOKdcJpPzvUbWxk
SK3c2IfTBp9vW5G/Z8e3gauNhmOGS7aV7JvzcnRvzvbFfNuX7T2+2bx2l5g20mty
IZ998MAl+fQtZWO6zF4zg2r+1rRL8tu3eeAPi3xur7hHHDaKh0SuYjNsNZndc9nR
jv35vQP82Y32Z8dfcXvEb00PSP3gAxdcbNSNGWYDRMwxw7bhvgWWsiBH91b5eOBc
6CjPBl9Vq2x8ERuEEqrkqyEXHw+yYWojGw6Ht8hcOLubpcvC67vLYeolvbs750i+
kjGUjcxixlggg4ZhsP9GmdwyMiuO5NtLS0UW+Pn9pX06OxqNRUcJiVKK/IVsR2NL
MZZilKbYXopFr9JkN6M3D+37OZ1JxE+1Z8eTzZM4eyK5/dnxVxLxe87zUwOkeUxl
PKxBVq64rKwbM8xtyDHD9uG+fESuHN3LCglNkAslj3Ji7JWywUb68dFeITl6iTG3
uyzizcrGS/aSHaEzW4Ssr7PF6fXw1ksrUwuLBwvsndnYmBTvVtmg6w8WF6zUe7PR
eV4kijTsZOkqDT2diW5rZWOPrYndlCnmiUhCS8dS7La1o4GxxBh/jKb57PixuCgP
zmfH72ye7NjCqAZIiyjKeJBIw1rfzYZzzDC3Icd+OYc0WqO0ameVJE3A5/m4RNNG
zvazA5wH4RHVXDARd5f5MjHD3hkvh5kbzooxVRZTLPrGYLlcpiVCt0GnpgxVPmaj
o7LG4YEfjZH5UfY+r9m4ykrM7aiYic1qrcl2bEnVV/ET9RRN8xnAiXvSRt3zsSfG
Enr5UAOkiR6PJrgVHOeYYZuNnIeNWqhwllM2cm42ajkB23Itu6sizQRssVoqLW2k
pY255V3VekxnFgfFFLdxkKFMO2wMLmZU63GbVj1iiod4NsbDzd4tG3SGT9XZ2KO1
ldrnTOKxfMCvZWPCy8bMie0B8WqANNHj0QT3asw+ZrilspGqigTeZSOSFIhtX46E
R3jD7V42Xm6Fs3pnqzZlTLFgcxuyDGg2pulqvQ9RjEVnzVablomWy8ZtuqEeiZ0T
UQE1KxtmlWZS0LqTHZSNujHDug3WblTcbKjhvEJVfpXUqg1qKs5WmLYUJDyntxvy
fS488tKZfNCYEtGfOqBzt4SNaYNJmDIGnanpR3xbhphOqHbjMEod8Rer3SCajaWl
beeOJuK0dbBssHZjLOF8djxt4lX6VdlyqwHSJfYLPioe/tuNujHDug26LL/q2m5U
89WKaaOUDyULzWyI3uxwOKv1qeg7KydrrsnLqk9lZBYXhQ1ysHhQJmXX5IcsxLSz
xCoe2acitP9UFC9mn4poNopu+zk91WzQ9vzkecL57HjtgeUhda0sB0jzEecqHv77
VE3HDEeqroud44ArLQ5mXeM1UlpWW2l3EXZqZesCo+yuwkReVYjrDTpbVC/m9YZv
djb1Ofuz4/Xx4vY4thAPv/epcsnUqv7TKx6cFVKVUBs/1eTvwrwXTMRnnifqri0s
UhW3pS3Gw/ddw0iq0e/KKWpnqbZ+p2mrrrUAx87MzGmD1RHX6LQYD7yHCwm0AQm0
AYme2UgPZ7N3+cR61ry2KG9kMrfYxK3JzKTWV9rm/aHRGGXUXLijqu979htEF5ie
2VgfTj9YHqb92/Dd9MiuXDi5UV452KBWMgvlQUPpKM5GeY80drNYNHulEzMJ2bPc
SXTjDz89oac1FbsHMkKNkGXt9vmKuvOUUdfXsZi0od+ziMeljYGTx2gjCJgNfmdw
eMRaaNowrKrKxYa4EKYXyol7XfmjaE/oqQ11Z0rcw5VkptjrdMbQ/n4kbUSjUavZ
kDY2d7rzJ+qe0EsbI+xmrdPGlCwa5YVF6+6HsLHHbiZdNRdyG/GxLn1hoCf00MYw
+5Or08aGYTpgf+KTRM27eaMxcyG3kYjH4yeJuNufpS8gvbMxssvvD/Ju7rr609OU
ViAGM+akZWPWYWOCMrZpu293gemZjZFl8c7+0LQWljdu+V8uKCusAV+8ZSbmNviX
P7S/P6geLtZUnRPm0DKR3c2af/82OINkwVjMGBsqaVR8yeOQ/a3CbMUT4ssaDLQR
IGtplxu35bLLvdDDotvXnfoIADYQE7QBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBif8HPdLWAOwjtc0AAAAASUVORK5CYII=
');

-- Need to Use "DBMS_LOB.CONVERTTOBLOB" on IMAGE data
insert into "ODBCAPTURE"."GRBTST_IMAGE" ("ID","IMAGE")
  values (2,'(Base64 with Linefeeds)
iVBORw0KGgoAAAANSUhEUgAAAY0AAAFTCAMAAADyTaC8AAAAA3NCSVQICAjb4U/g
AAABtlBMVEUAAAD7+O1/sn8AAP9QUFCurq6ZMzOGhoaZAJkAZgCpUlLq1ZXUqSfM
mQAnJydpaf/Vqqp+fn5YWP9CRT9wemLDh4frzevevFhja1jMzMypKanX1/+JCIkn
fScnJ/+OnHnjueOlpaWxv53Jeclre2PX19f379cHBwebrIM9iz1Ym1i8eXnt9O19
iWyVv5V1dXU9PT3v39+Ojo7dq93mzc3lzH/v7++3xKTMmZmVlf+rq/+zQLOxZGTX
59f79furzasHagecOTnV3coREf9YWFjB2sFqamoRERHz5sFLT0Xt7f/UlNQ9Pf9p
pWnf39/Bwf/PoBF/f//dvLz39/eGk3Ln5+fu3atocFsHB/+kG6RfZlX8+fnYsT2e
np6ltY66UrqgQUERcBFQVUnz4fPhw2nnwuf48fGSoXy9yKu+vr5bYlLNnAf9/Pdj
Y2PJ07v39/+VlZX57/lER0ARABHn6+HMf8xsdV+tMq28WLyRBJHXnNf15/VMUEfD
zrTx2/Hqy+rt8OhYXk+rupVJTURTWUzP2MPPhs/////b4tL39+/lveWwOrDgsuC/
YL/Zodm2SLbb4dGnI6eFtRMPAAAACXBIWXMAAAsSAAALEgHS3X78AAAAFnRFWHRD
cmVhdGlvbiBUaW1lADAxLzIzLzA3TruF+QAAAB90RVh0U29mdHdhcmUATWFjcm9t
ZWRpYSBGaXJld29ya3MgOLVo0ngAABW6SURBVHic7Z0LWxvXmYAFqhRGloRFTKFW
pXabR8hg4kpZI2MWFQgCeTHUgGJCjWtD7OBwSY2bi7Ob7iZptzlbb9rs/uM915kz
oxlJI43Qh/heP5bmcmbmzPfqXGbQ0YQIAodQrzOAaKANSKANSKANSKANSKANSKAN
SKANSKANSECxkRm0pjcMo+yZcGEqM7lC38sbGX2b/gCgjRWjRoinj8Vb5QWD6pjc
KK8cZM4nc+cGKBu1MvVABlmMG5QOWnikhbLR/YydK5BsbBgZY4qG2DAyGfriXQ8p
G4NYNroDtbGySN+NaWfZMAS6G2OBvW4sTp5zJrsOIBuTk+Vy+WCweU0lm4vp8uTU
+WTu3ABkI7OYoSw4bZQFNSvpgTlJS1JfAcjG5IaYdNjICBbUvN6RatjWX0AA2Vhg
n/SyajcWPBIeyNqJtSO3sE/VHWSf6kC14nTatU9VFm16mRwYmcXFPquowNgQlK2a
Z7pZJVQr91k1RaDZuOygDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUiA
tTHU6wz0gotmo78lgbXxzD77z3IebfQER9jvv/7YbXGfcVFskB9+/He3xf3FhbFB
/vOrvz9DGz3iWf2i+6+/QRu9wS3sb/7nPtroCUOu/B/a6AldKRvQXYK10ZV2A220
SVf6VGijTbpyvYE22qQr1+Joo026cp8KbbRJV+7hoo02QRuQQBuQcLneYKCNnoBl
AxJoAxJoAxKfhVwZcl/cIvrWQ0NDz7z+9+qkwdroftkIea3oHWgjgN0GBtoIYLeB
AdbGZ/bZ2v/+4c6TGzduDN3oBL71kzvv/43tEm20ji0+n39ii2dnNpiQz0lANuZG
susP+EQ2u9XuTkzA2tAy9u2d+nh2ZuPGk781thFOt5jN3bvpuTDVcTf8IL283uE5
XwQb77vF80tfFr584bBx4/2WbKSVlIZyhrPUCisg4ZeBnTQwzIz9h8un+9rxsS8b
x8fXHDbuNLSRDYfDW2Rtd3l5d40GeX13ObzmnVVq42WYTSzPBXXS0FAZs8vg8Xz3
0bFvG8eP3rXZeNJC2dilDcHWLp2h7+uqFgoL9DYiPEfS3EbHLQd0G+874jp044Nx
Gtvv/nTND//6X3Sb8Q/0Vqe5jTUeYVoo2MyDsGdOl2lFdTlsfOv8lP/8w2PGR28f
++HtP/G3D3/ux4aIMJ2yZghrSjhWC5FdJpfFxp06G+M8ru2UDVo6XGz89D575Tbu
/9Q8unfZyArMFoKVDJHMR0+s8UkDhGfs87oWgNZUj3hkW20yOHyLR6411bOv/kGE
jX98Zd0tDLNom+0GDXJ2xD2by3L5On2f867N/Jw0RHjGPnGxEUwrbtVUr373htt4
87tX1tGHw1mtTxXO7i675zIt2vQ0ebm7nA0/COSkIcIyVquPq4hnGz3cF9bWdhvk
m6/YF0rZq8Yar3TE9UY4nW7Qv1WkO62mCHAb/+1l48aLTq/+9Fb8l9d/M/Sb67/0
zErHzUHLgLbxB08bbeJug3z/dOjp995Z2er0ErtlQNuo61F1yQb5/noDGecIGBvu
o2e6wr81TdGrIICx4YRlrPGnu+2yMf7CWTagADBLApuN8Rct2rASetu4xm8hgjx1
gFkS6DauyVuwTW1oCT1tvKAXHy/Qhj90GyJ+LdjQEnra+JIm+hJt+EOzIePX3Iae
0MvGL/hdkl+gDV9YNlT8mtqwJfSyIe46jqMNX1g2xD30D5vbsCX0sPGBvMf+AchT
B5glgWnDjF8zG/aEHjbYDcc//vH4+FEN4qkDzJLAtDEu4zfezIY9obuNF+9SPvqI
vjyEeOoAsyRQNqz4Oe/COnAk9CgbDH4DGOSpA8ySwHb1Z91Ab1A27AnRRpCgDUig
DUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUigDUg0seHx
RR0PG/YRA2jDNw1teI6m8VhuHy+ONnzTwEaDkWaeNvSRZmjDN542Go4X/8tfWhgv
jjZ842GjyXjxt92X28eLow3feNloPF68Udkwx4ujDd9411SNxot7txvaeHG04Rts
xSERdA9X+6Yi2vBN46s/r/HiePXXHfDOCCTQBiTQBiTQBiTQBiTQBiTQBiTQBiTQ
BiTQBiTQBiTQBiTQBiTQBiTQBiTQBiS6YwN/9aU9lI2Af/VlXH7NZxx/EckPZtlQ
8XvUrGzYE3rYYD9i9d13+GthPjFtmPFrZsOe0MOG+QNvIE8dYJYEVruhfomwmQ17
Qi8b+CuT7WDZCPZXJvEXWNtB61MF+gus/Ktu+OvEPtFsyF93bm5DT+htA3+52z/6
9Uagv9xN25cbaMMntqu/QH/VXgDy1CFkKYgnZvhN6ElPIwHBhs6/qAlb2XD9dLdB
f5WN2GwAhywW2et2jOFY9eb60PU3VsYaxDPIp2jBoTMbfN6fosPtKE8/u18sCi8m
X7/z9OOhj5++87XKmKeNzp+h/KQ/bBT3+JQIpG7jUIWWpdgrum3OGI1JG85yQX74
8YtXZIi8+uLHH0hDG0E8ffFOP9iILcWi2zTyS/v7S4dkNhqNxvgLXSXWxOb3Y9Gr
8/tLS9478bDxmj3+kLWi37wmDWwE8wzlv/aDjXla4UcJWaIBnV3Sy8ZNGtxidE+m
oCVj6arYpBgVWIVF2qDL5uuPYPZpPGwE9Qzlb/vBBgtktHgYZTPRQ81G9DZ92b/K
Z4pR0qg1EWtYdbZfr6OpjWCeofyJ71M/F9qyURQ2irqNopiqt1EUOHbCuR2tO0Iz
G8E8Q/lXe75P/Vxox8ahn7JxGBMc2nfCKbZjI4BW/JM9/6d+Lvi3wdoL1W7M3yTy
xWw3Wq2prqot7dhsPHG30dEzlP9856/ftnPq54JPG9H9fVokVJ+KVjW01eYvZp+q
mY0Ya9LpuqUo3aJ+tc2GC3L9w9/7yvfvHzr23uAIvcRvltSFhGwI9sTFBSv5h56X
GF57OnRZ2qKNNuk3G93mHG181tGuugIIG0PPXP6FXPFY3CK2rXt7u9YVEDZ8EGDZ
QBsdgzYgEaCNZx3tqitcYhtYNjoGbUACbUCiYxs/vFYz2G50TKc2vv7xm2B21RUu
m413vghoV13hktl48/RVQLvqCpfMxvWPrRlsNzqmQxtwvlboyiWzoZcNtNEx2G70
D7Y+FbYbPQavNyBhuxZHGz0G71NBAv++AQksG5BAG5BAG5DAdgMSWDYggTYggTaQ
1kEbkEAbkEAbkEAbkOhzG6cz1vRMvHn6nVM5cW+nK/lpQp/bGNAMKBsTCa/UEzOJ
CTG1k2hBXfD0uQ3BxAB7pTYG2IS3jXhc2hg4eYw2AiX+fCwxwyI/kNjcZB/1mc3N
eOIxIQnKhMdGYsVp4l4r1Vrw9LEN6uKU2TiZEbXUzMkpjfOAVjZmEgJrI2Fjc6el
RiZ4+tgGa8Bp5AdYsLkNFmAabu+aStqIj7XW5AdP/9uY8LZxOiGwNuI2EvF4/CQR
HzjvHF8GGw3Kxk5cYG3EbTBBY5teTUs36X8b5OQ5Od3UbAwkTj03Mpt3rKmCxbQx
QGudx5oNsnni8cFPWN0ttNFFxp7rcxO9qIVa4RLYuPJ4ZqxB5QSJS2Dj9MrMlV7n
oUUugY0LBNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqA
BNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqABNqAxLnbiKRS
qUj94py1LFVz3zLnshklmSK5pmdhpojkGq11OXQo550jRi3V7Ng+OHcbyWQqlazW
LY6sWilK7ltqSWw79GVj1aE0ldTXuhya2fDIEd+2lGx2bB/4t1Hy+TBpx5kk2Wcp
f8Ymc2JVzu3jSkpiZc2xspSrWZMluUMRzfr91GTiUs7hy9qrsqEdR9sPXRqy7zWn
slWT2zq2yTUoRs3xa6NGaxpfG9B6yZZBboO9RELJfJVGKl9Nhs7YmSX5s3T5pzFV
pQsLNGGFJlLxYCefzIvlhE+y7ZUNup9qvkT3SshRqEZK9P9qKBmq0BRVulHIOnwu
VKnm82I2xw9pLqGHotmqhuQnSB2d5SiZCiVVnsWe1bbmsUmykGfn0j7+bNSO3kr5
tpF660jzwUSwUNXYKSfPSIHVPyX1OctHxLnnRQIWW6LZOKvSdznL9snKmLSRp/tN
5elWNVKhiyN5cpRnG5dIJanXRSx1TpVOs2zIJfQ9dER3LfJrHp3liEa/pPIcoQch
EauWk8emNuRG7eJr25+9R2P760//yQ+f/ppu897PzH3Qj3QyT8/4LJ/L5WigCtWc
GRVSrRD5SRTvXJVug8VKEVlNhlLKRomfCI1WNUJCkSpZXSWFAj1CNUVnnTaILKJE
bzfYEmajYlatBZkbM0dmnldt25rHZrto3oY1wMe2vz1LMVZ/kvLDTz7lb2e/VeGo
5FbZQWnBp9DTKoRCSVk2KlVCbDZ4zPSaajUUyksh1WqKxVrGVwSBJl2tHBVIqFY9
4t6TyQjfvnUbpWqIV28qjW5D5VlurLY1j32uNt7jcW2nbNDSYdpIiajzSkdQqhb4
mbHCThqWDUqtIrJsRtBRNo7ylQipnNFZ+QnmdU/rNghrd0Q1llRHN8uGzDOEskFr
qrd4ZH0dgG/xllZTsc1p+GusAqkdEdbjXOU2IrLx1GywCvpMs8EaoCORZd725FPO
doNuxtvxJBH7o32gQoF9qq3D22ycsU10G0xE9cxcl9NtmHlm6SPWtma7ca42gmrF
6WEr9JRovynC+i2sP+LoU0kbrGZKaTbkNhy2oVVTmf0a3pQS1qCwng/rHpVC1XzB
y0aNrrTZyNNuk+q5VvPVgm7DPL7orZnbmn2q87VBD9xGD9fjak520mvu1xsmNVsW
tcQlx35d9iMXNbwIyDl2U9IWONeZe5RXMub6JufQKv5NPvR59ffQ9xE0qqupvPsl
eF8C/K7hUSoVzKfuYgDcxiUDbUACbUACbUACbUACbUACbUACbUACbUACbUACbUAC
bUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUACbUDC24Y1
ILiDQbgeo4rbp2xoMxnD8EwoKEaDPLjfZ8f7xtuGNSC4g0G4HqOKdcJpPzvUbWxk
SK3c2IfTBp9vW5G/Z8e3gauNhmOGS7aV7JvzcnRvzvbFfNuX7T2+2bx2l5g20mty
IZ998MAl+fQtZWO6zF4zg2r+1rRL8tu3eeAPi3xur7hHHDaKh0SuYjNsNZndc9nR
jv35vQP82Y32Z8dfcXvEb00PSP3gAxdcbNSNGWYDRMwxw7bhvgWWsiBH91b5eOBc
6CjPBl9Vq2x8ERuEEqrkqyEXHw+yYWojGw6Ht8hcOLubpcvC67vLYeolvbs750i+
kjGUjcxixlggg4ZhsP9GmdwyMiuO5NtLS0UW+Pn9pX06OxqNRUcJiVKK/IVsR2NL
MZZilKbYXopFr9JkN6M3D+37OZ1JxE+1Z8eTzZM4eyK5/dnxVxLxe87zUwOkeUxl
PKxBVq64rKwbM8xtyDHD9uG+fESuHN3LCglNkAslj3Ji7JWywUb68dFeITl6iTG3
uyzizcrGS/aSHaEzW4Ssr7PF6fXw1ksrUwuLBwvsndnYmBTvVtmg6w8WF6zUe7PR
eV4kijTsZOkqDT2diW5rZWOPrYndlCnmiUhCS8dS7La1o4GxxBh/jKb57PixuCgP
zmfH72ye7NjCqAZIiyjKeJBIw1rfzYZzzDC3Icd+OYc0WqO0ameVJE3A5/m4RNNG
zvazA5wH4RHVXDARd5f5MjHD3hkvh5kbzooxVRZTLPrGYLlcpiVCt0GnpgxVPmaj
o7LG4YEfjZH5UfY+r9m4ykrM7aiYic1qrcl2bEnVV/ET9RRN8xnAiXvSRt3zsSfG
Enr5UAOkiR6PJrgVHOeYYZuNnIeNWqhwllM2cm42ajkB23Itu6sizQRssVoqLW2k
pY255V3VekxnFgfFFLdxkKFMO2wMLmZU63GbVj1iiod4NsbDzd4tG3SGT9XZ2KO1
ldrnTOKxfMCvZWPCy8bMie0B8WqANNHj0QT3asw+ZrilspGqigTeZSOSFIhtX46E
R3jD7V42Xm6Fs3pnqzZlTLFgcxuyDGg2pulqvQ9RjEVnzVablomWy8ZtuqEeiZ0T
UQE1KxtmlWZS0LqTHZSNujHDug3WblTcbKjhvEJVfpXUqg1qKs5WmLYUJDyntxvy
fS488tKZfNCYEtGfOqBzt4SNaYNJmDIGnanpR3xbhphOqHbjMEod8Rer3SCajaWl
beeOJuK0dbBssHZjLOF8djxt4lX6VdlyqwHSJfYLPioe/tuNujHDug26LL/q2m5U
89WKaaOUDyULzWyI3uxwOKv1qeg7KydrrsnLqk9lZBYXhQ1ysHhQJmXX5IcsxLSz
xCoe2acitP9UFC9mn4poNopu+zk91WzQ9vzkecL57HjtgeUhda0sB0jzEecqHv77
VE3HDEeqroud44ArLQ5mXeM1UlpWW2l3EXZqZesCo+yuwkReVYjrDTpbVC/m9YZv
djb1Ofuz4/Xx4vY4thAPv/epcsnUqv7TKx6cFVKVUBs/1eTvwrwXTMRnnifqri0s
UhW3pS3Gw/ddw0iq0e/KKWpnqbZ+p2mrrrUAx87MzGmD1RHX6LQYD7yHCwm0AQm0
AYme2UgPZ7N3+cR61ry2KG9kMrfYxK3JzKTWV9rm/aHRGGXUXLijqu979htEF5ie
2VgfTj9YHqb92/Dd9MiuXDi5UV452KBWMgvlQUPpKM5GeY80drNYNHulEzMJ2bPc
SXTjDz89oac1FbsHMkKNkGXt9vmKuvOUUdfXsZi0od+ziMeljYGTx2gjCJgNfmdw
eMRaaNowrKrKxYa4EKYXyol7XfmjaE/oqQ11Z0rcw5VkptjrdMbQ/n4kbUSjUavZ
kDY2d7rzJ+qe0EsbI+xmrdPGlCwa5YVF6+6HsLHHbiZdNRdyG/GxLn1hoCf00MYw
+5Or08aGYTpgf+KTRM27eaMxcyG3kYjH4yeJuNufpS8gvbMxssvvD/Ju7rr609OU
ViAGM+akZWPWYWOCMrZpu293gemZjZFl8c7+0LQWljdu+V8uKCusAV+8ZSbmNviX
P7S/P6geLtZUnRPm0DKR3c2af/82OINkwVjMGBsqaVR8yeOQ/a3CbMUT4ssaDLQR
IGtplxu35bLLvdDDotvXnfoIADYQE7QBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQBCbQB
CbQBCbQBCbQBCbQBCbQBif8HPdLWAOwjtc0AAAAASUVORK5CYII=
');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/GRBTST_IMAGE.ctl" returned error: 0');
   end if;
end;
/

declare
   l_blob          blob;
   the_blob        blob;
   procedure b64_decode
         (in_blob  in BLOB)
   is
      BASE64_ENCODE_HEADER      constant varchar2(30) := '(Base64 with Linefeeds)';
      SPLIT_LEN              constant pls_integer  := 32764;    -- Must be divisible by 4
      header_txt    varchar2(128);
      len_blob      pls_integer;
      ptr           pls_integer;
   begin
      dbms_lob.trim(l_blob, 0);
      dbms_lob.trim(the_blob, 0);
      ----------------------------------------
      -- Check incoming BLOB sizes (and return if needed)
      if in_blob is null then return; end if;
      len_blob := length(in_blob);
      if len_blob = 0 then return; end if;
      ----------------------------------------
      -- Check for BASE64_ENCODE_HEADER in in_BLOB
      header_txt := utl_raw.cast_to_varchar2(dbms_lob.substr(in_blob
                                                            ,length(BASE64_ENCODE_HEADER)
                                                            ,1)                       );
      if header_txt != BASE64_ENCODE_HEADER
      then
         raise_application_error(-20000, 'BASE64_ENCODE_HEADER missing from data: ' || header_txt);
      end if;
      ----------------------------------------
      -- Create "L_BLOB" after removing BASE64_ENCODE_HEADER, Carriage Returns, and Line Feeds
      ptr := 1 + length(BASE64_ENCODE_HEADER);  -- Skip over the header
      while ptr <= len_blob
      loop
         dbms_lob.append(l_blob
                        ,utl_raw.translate(dbms_lob.substr(in_blob
                                                          ,SPLIT_LEN
                                                          ,ptr)
                                          ,hextoraw('000D0A')       -- NULL, Carriage Return, Line Feed
                                          ,hextoraw('00')   )   );  -- NULL
         ptr := ptr + SPLIT_LEN;
      end loop;
      len_blob := length(l_blob);
      ----------------------------------------
      --  Create "THE_BLOB" after Base64 Decoding
      ptr := 1;
      while ptr <= len_blob
      loop
         dbms_lob.append(the_blob
                        ,UTL_ENCODE.BASE64_DECODE(dbms_lob.substr(l_blob
                                                                 ,SPLIT_LEN
                                                                 ,ptr)   )   );
         ptr := ptr + SPLIT_LEN;
      end loop;
   end b64_decode;
begin
   dbms_lob.createtemporary(l_blob, true);
   dbms_lob.createtemporary(the_blob, true);
   for buff in (select ROWID RID, "IMAGE"
                 from  "ODBCAPTURE"."GRBTST_IMAGE"
                 for update of "IMAGE")
   loop
      b64_decode(buff."IMAGE");
      -- This overwrites the Base64 Encoded String with the original binary data
      update "ODBCAPTURE"."GRBTST_IMAGE"
        set  "IMAGE" = the_blob
       where rowid = buff.rid;
   end loop;
   dbms_lob.freetemporary(l_blob);
   dbms_lob.freetemporary(the_blob);
end;
/

commit;

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/ROLE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.ROLE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."ROLE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'ROLE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/ROLE_CONF.ctl

prompt Translating ../grbtst/ODBCAPTURE/ROLE_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."ROLE_CONF" ("ROLENAME","BUILD_TYPE","ORACLE_PROVIDED","NOTES")
  values ('GRB_TEST_ROLE','grbtst','N','ODBCapture Testing');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/ROLE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/SCHEMA_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.SCHEMA_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."SCHEMA_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'SCHEMA_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/SCHEMA_CONF.ctl

prompt Translating ../grbtst/ODBCAPTURE/SCHEMA_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."SCHEMA_CONF" ("USERNAME","BUILD_TYPE","ORACLE_PROVIDED","PROFILE","TEMPORARY_TSPACE","DEFAULT_TSPACE","TS_QUOTA","NOTES")
  values ('ODBCTEST','grbtst','N',NULL,NULL,'USERS','512M','Test Account');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/SCHEMA_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtst ODBCAPTURE/TSPACE_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.TSPACE_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."TSPACE_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'TSPACE_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/TSPACE_CONF.ctl

prompt Translating ../grbtst/ODBCAPTURE/TSPACE_CONF.csv to 'INSERT INTO'


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/TSPACE_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbtst ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE','ODBCTEST'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE','ODBCTEST'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE','ODBCTEST'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE','ODBCTEST'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE','ODBCTEST'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE','ODBCTEST'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbtst', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbtjsn Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbtjsn ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbtjsn"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
   do_it('grbtst');
end;
/


----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbtjsn ODBCAPTURE/GRBTST_JSON.tbl
prompt ============================================================

--
--  Create ODBCAPTURE.GRBTST_JSON Table
--

set define off


--DBMS_METADATA:ODBCAPTURE.GRBTST_JSON

  CREATE TABLE "ODBCAPTURE"."GRBTST_JSON" 
   (	"ID" NUMBER(5,0), 
	"JSON_DATA" JSON
   ) SEGMENT CREATION IMMEDIATE  LOGGING;
ALTER TABLE "ODBCAPTURE"."GRBTST_JSON" ADD CONSTRAINT "GRBTST_JSON_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCAPTURE.GRBTST_JSON


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbtjsn ODBCAPTURE/GRBTST_JSON.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.GRBTST_JSON data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_JSON'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_JSON'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."GRBTST_JSON"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'GRBTST_JSON'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/GRBTST_JSON.ctl

prompt Translating ../grbtjsn/ODBCAPTURE/GRBTST_JSON.csv to 'INSERT INTO'

-- Manually Fixed by DDieterich
insert into "ODBCAPTURE"."GRBTST_JSON" ("ID","JSON_DATA")
  values (1,'[
  100,
  500,
  300,
  200,
  400
]');

-- Manually Fixed by DDieterich
insert into "ODBCAPTURE"."GRBTST_JSON" ("ID","JSON_DATA")
  values (2,'{
  "color" : "red",
  "value" : "#f00"
}');

-- Manually Fixed by DDieterich
insert into "ODBCAPTURE"."GRBTST_JSON" ("ID","JSON_DATA")
  values (3,'{
  "id" : "0001",
  "type" : "donut",
  "name" : "Cake",
  "ppu" : 0.55,
  "batters" :
  {
    "batter" :
    [
      {
        "id" : "1001",
        "type" : "Regular"
      },
      {
        "id" : "1002",
        "type" : "Chocolate"
      },
      {
        "id" : "1003",
        "type" : "Blueberry"
      },
      {
        "id" : "1004",
        "type" : "Devil''s Food"
      }
    ]
  },
  "topping" :
  [
    {
      "id" : "5001",
      "type" : "None"
    },
    {
      "id" : "5002",
      "type" : "Glazed"
    },
    {
      "id" : "5005",
      "type" : "Sugar"
    },
    {
      "id" : "5007",
      "type" : "Powdered Sugar"
    },
    {
      "id" : "5006",
      "type" : "Chocolate with Sprinkles"
    },
    {
      "id" : "5003",
      "type" : "Chocolate"
    },
    {
      "id" : "5004",
      "type" : "Maple"
    }
  ]
}');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/GRBTST_JSON.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbtjsn ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbtjsn', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbtsdo Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbtsdo ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbtsdo"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
   do_it('grbtst');
end;
/


----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbtsdo ODBCTEST/SDO_COLA_MARKETS.tbl
prompt ============================================================

--
--  Create ODBCTEST.SDO_COLA_MARKETS Table
--

set define off


--DBMS_METADATA:ODBCTEST.SDO_COLA_MARKETS

  CREATE TABLE "ODBCTEST"."SDO_COLA_MARKETS" 
   (	"MKT_ID" NUMBER, 
	"NAME" VARCHAR2(32 BYTE), 
	"SHAPE" "ST_GEOMETRY"
   ) SEGMENT CREATION IMMEDIATE  LOGGING
 VARRAY "SHAPE"."GEOM"."SDO_ELEM_INFO" STORE AS SECUREFILE LOB 
 VARRAY "SHAPE"."GEOM"."SDO_ORDINATES" STORE AS SECUREFILE LOB ;
ALTER TABLE "ODBCTEST"."SDO_COLA_MARKETS" ADD PRIMARY KEY ("MKT_ID")
  USING INDEX  ENABLE;

--  Comments

--DBMS_METADATA:ODBCTEST.SDO_COLA_MARKETS


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbtsdo ODBCTEST/SDO_COLA_MARKETS.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCTEST.SDO_COLA_MARKETS data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCTEST'
                  and  table_name = 'SDO_COLA_MARKETS'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCTEST'
                  and  table_name = 'SDO_COLA_MARKETS'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCTEST"."SDO_COLA_MARKETS"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCTEST'
                  and  table_name = 'SDO_COLA_MARKETS'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCTEST/SDO_COLA_MARKETS.ctl

prompt Translating ../grbtsdo/ODBCTEST/SDO_COLA_MARKETS.csv to 'INSERT INTO'

-- 2003;;;;;1;1003;31;1;5;7
insert into "ODBCTEST"."SDO_COLA_MARKETS" (MKT_ID, NAME, SHAPE)
   values (1, 'cola_a', ST_GEOMETRY(SDO_GEOMETRY(2003, NULL,
          SDO_POINT_TYPE(NULL, NULL, NULL),
          SDO_ELEM_INFO_ARRAY(1, 1003, 3),
          SDO_ORDINATE_ARRAY(1, 1, 5, 7) ) ) );

-- 2003;;;;;1;1003;15;1;8;1;8;6;5;7;5;1
insert into "ODBCTEST"."SDO_COLA_MARKETS" (MKT_ID, NAME, SHAPE)
   values (2, 'cola_b', ST_GEOMETRY(SDO_GEOMETRY(2003, NULL,
          SDO_POINT_TYPE(NULL, NULL, NULL),
          SDO_ELEM_INFO_ARRAY(1, 1003, 1),
          SDO_ORDINATE_ARRAY(5, 1, 8, 1, 8, 6, 5, 7, 5, 1) ) ) );

-- 2003;;;;;1;1003;13;3;6;3;6;5;4;5;3;3
insert into "ODBCTEST"."SDO_COLA_MARKETS" (MKT_ID, NAME, SHAPE)
   values (3, 'cola_c', ST_GEOMETRY(SDO_GEOMETRY(2003, NULL,
          SDO_POINT_TYPE(NULL, NULL, NULL),
          SDO_ELEM_INFO_ARRAY(1, 1003, 1),
          SDO_ORDINATE_ARRAY(3, 3, 6, 3, 6, 5, 4, 5, 3, 3) ) ) );

-- 2003;;;;;1;1003;48;7;10;9;8;11
insert into "ODBCTEST"."SDO_COLA_MARKETS" (MKT_ID, NAME, SHAPE)
   values (4, 'cola_d', ST_GEOMETRY(SDO_GEOMETRY(2003, NULL,
          SDO_POINT_TYPE(NULL, NULL, NULL),
          SDO_ELEM_INFO_ARRAY(1, 1003, 4),
          SDO_ORDINATE_ARRAY(8, 7, 10, 9, 8, 11) ) ) );


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCTEST/SDO_COLA_MARKETS.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- INDEX Install


prompt ============================================================
prompt Running: grbtsdo ODBCTEST/SDO_COLA_MARKETS.tidx
prompt ============================================================

--
--  Create Indexes for ODBCTEST.SDO_COLA_MARKETS TABLE
--

set define off


--  NOTE: This is a "TARGET" Index

-- The MDSYS Domain Index "ODBCTEST"."COLA_SPATIAL_IDX
--   installation script is located in the "root" folder because
--   it must be executed using the "ODBCTEST" database login.


set define on

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbtsdo ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCTEST'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCTEST'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCTEST'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbtsdo', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbtctx Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbtctx ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbtctx"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
   do_it('grbtst');
end;
/


----------------------------------------
-- TABLE Install


prompt ============================================================
prompt Running: grbtctx ODBCTEST/CUST_CTX_TEST.tbl
prompt ============================================================

--
--  Create ODBCTEST.CUST_CTX_TEST Table
--

set define off


--DBMS_METADATA:ODBCTEST.CUST_CTX_TEST

  CREATE TABLE "ODBCTEST"."CUST_CTX_TEST" 
   (	"CUST_ID" NUMBER, 
	"CUST_NAME" VARCHAR2(80 BYTE), 
	"CREATE_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE  LOGGING;

--  Comments

--DBMS_METADATA:ODBCTEST.CUST_CTX_TEST


--  Grants


--  Synonyms


set define on

----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbtctx ODBCTEST/CUST_CTX_TEST.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCTEST.CUST_CTX_TEST data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCTEST'
                  and  table_name = 'CUST_CTX_TEST'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCTEST'
                  and  table_name = 'CUST_CTX_TEST'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCTEST"."CUST_CTX_TEST"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCTEST'
                  and  table_name = 'CUST_CTX_TEST'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCTEST/CUST_CTX_TEST.ctl

prompt Translating ../grbtctx/ODBCTEST/CUST_CTX_TEST.csv to 'INSERT INTO'

insert into "ODBCTEST"."CUST_CTX_TEST" ("CUST_ID","CUST_NAME","CREATE_DATE")
  values (1,'The Acme Manufacturing Company, Inc.','14-MAY-2024 16:40:54');

insert into "ODBCTEST"."CUST_CTX_TEST" ("CUST_ID","CUST_NAME","CREATE_DATE")
  values (2,'Coyote Trap Construction GMBH','14-MAY-2024 16:40:58');

insert into "ODBCTEST"."CUST_CTX_TEST" ("CUST_ID","CUST_NAME","CREATE_DATE")
  values (3,'Trapezium and Trappist Developments','14-MAY-2024 16:41:28');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCTEST/CUST_CTX_TEST.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- INDEX Install


prompt ============================================================
prompt Running: grbtctx ODBCTEST/CUST_CTX_TEST.tidx
prompt ============================================================

--
--  Create Indexes for ODBCTEST.CUST_CTX_TEST TABLE
--

set define off


--  NOTE: This is a "INDEX" Index

--DBMS_METADATA:ODBCTEST.CUST_CTX_TEST_IND

  CREATE INDEX "ODBCTEST"."CUST_CTX_TEST_IND" ON "ODBCTEST"."CUST_CTX_TEST" ("CUST_NAME") 
   INDEXTYPE IS "CTXSYS"."CONTEXT_V2" ;

set define on

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbtctx ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCTEST'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCTEST'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCTEST'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCTEST'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbtctx', 'OCI_APEX_install.sql');
commit;

--
--  SYS Installation Script
--
--  Must be run as SYS
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  SYSTEM Installation Script
--
--  Must be run as SYSTEM
--


set blockterminator off
set sqlblanklines on

----------------------------------------
set sqlblanklines off
set blockterminator on



--
--  grbtdat Installation Script
--
--  Must be run as a SYSTEM User (DBA)
--
-- Command Line Parameters:
--   1 - INSTALL_SYSTEM_CONNECT: SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--



-- For Oracle Change Data Capture (CDC) packages

-- Escape character: "^P", CHR(16), DLE
set escape OFF
set escape ""

----------------------------------------
--  Prepare for Install

prompt ============================================================
prompt Running: grbtdat ./installation_prepare.sql
prompt ============================================================

--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbtdat"');
   do_it('grbendp');
   do_it('grbjava');
   do_it('grbras');
   do_it('grbsdo');
   do_it('grbsrc');
   do_it('grbtctx');
   do_it('grbtend');
   do_it('grbtjsn');
   do_it('grbtjva');
   do_it('grbtsdo');
   do_it('grbtst');
end;
/


----------------------------------------
-- DATA_LOAD Install


prompt ============================================================
prompt Running: grbtdat ODBCAPTURE/DLOAD_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.DLOAD_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."DLOAD_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'DLOAD_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/DLOAD_CONF.ctl

prompt Translating ../grbtdat/ODBCAPTURE/DLOAD_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','BUILD_CONF','grbtst','BUILD_SEQ',NULL,NULL,'build_seq between -40 and -1',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','BUILD_PATH','grbtst','PARENT_BUILD_SEQ, BUILD_SEQ',NULL,NULL,'build_seq between -40 and -1',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','DLOAD_CONF','grbtdat','USERNAME, TABLE_NAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbtst'',''grbtctx'',''grbtjva'',''grbtjsn'',''grbtsdo'',''grbtend'',''grbtdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','GRBTST_$NAME','grbtst','ID',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','GRBTST_IMAGE','grbtst','ID',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','GRBTST_JSON','grbtjsn','ID',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','OBJECT_CONF','grbtdat','USERNAME, ELEMENT_NAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbtst'',''grbtctx'',''grbtjva'',''grbtjsn'',''grbtsdo'',''grbtend'',''grbtdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','ROLE_CONF','grbtst','ROLENAME, BUILD_TYPE',NULL,NULL,'build_type in (''grbtst'',''grbtend'',''grbtdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','SCHEMA_CONF','grbtst','USERNAME',NULL,NULL,'build_type in (''grbtst'',''grbtend'',''grbtdat'')',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCAPTURE','TSPACE_CONF','grbtst','USERNAME, TSPACE_NAME',NULL,NULL,'username in (select username from schema_conf where build_type in (''grbtst''))',NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCTEST','CUST_CTX_TEST','grbtctx','CUST_ID',NULL,NULL,NULL,NULL,NULL);

insert into "ODBCAPTURE"."DLOAD_CONF" ("USERNAME","TABLE_NAME","BUILD_TYPE","ORDER_BY_COLUMNS","BEFORE_SELECT_SQL","COLUMNS_REMOVED","WHERE_CLAUSE","AFTER_ORDER_BY_SQL","NOTES")
  values ('ODBCTEST','SDO_COLA_MARKETS','grbtsdo','MKT_ID',NULL,NULL,NULL,NULL,NULL);


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/DLOAD_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

prompt ============================================================
prompt Running: grbtdat ODBCAPTURE/OBJECT_CONF.cldr
prompt ============================================================

--
--  Comprehensive Data Loader script for ODBCAPTURE.OBJECT_CONF data
--
-- Command Line Parameters:
--   1 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Data Load installation requires this connection information.
--

prompt
prompt Disable Triggers and Foreign Keys
declare
   procedure run_sql (in_sql in varchar2) is begin
      dbms_output.put_line(in_sql || ';');
      execute immediate in_sql;
   exception when others then
      dbms_output.put_line('-- ' || SQLERRM || CHR(10));
   end run_sql;
begin
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by owner, trigger_name)
   loop
      run_sql('alter trigger "' || buff.owner        || '"' ||
                           '."' || buff.trigger_name || '" DISABLE');
   end loop;
   for buff in (select constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by constraint_name)
   loop
      run_sql('alter table "ODBCAPTURE"."OBJECT_CONF"' ||
              ' DISABLE constraint "' || buff.constraint_name || '"');
   end loop;
   for buff in (select owner, index_name
                 from  dba_indexes
                 where index_type = 'DOMAIN'
                  and  table_owner = 'ODBCAPTURE'
                  and  table_name = 'OBJECT_CONF'
                 order by owner, index_name)
   loop
      run_sql('alter index "' || buff.owner || '"."' || buff.index_name || '"' ||
              ' DISABLE');
   end loop;
end;
/

-- Additional file extensions
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

prompt
prompt sqlldr_control=ODBCAPTURE/OBJECT_CONF.ctl

prompt Translating ../grbtdat/ODBCAPTURE/OBJECT_CONF.csv to 'INSERT INTO'

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','TABLE','grbtjsn','GRBTST_JSON','ODBCapture JSON Datatype Testing');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCAPTURE','TABLE','grbtst','^(GRBTST_IMAGE|GRBTST_[$]NAME)$','ODBCatpure Test Tables');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','GRANT','grbtjva','[Jj][Aa][Vv][Aa]','Any permission with JAVA in the name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','JAVA_SOURCE','grbtjva','^DirUtil$','Any Java Source called "DirUtil"');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','PACKAGE_BODY','grbtjva','^DIR_UTIL$','Any Package Body called "DIRUTIL"');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','PACKAGE_SPEC','grbtjva','^DIR_UTIL$','Any Package Specification called DIRUTIL');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','ROLE','grbtjva','JAVA','Any Oracle Provided Role Grant with JAVA in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','SEQUENCE','grbtend','^MDRS_','Any Sequences Starting with MDRT_');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','SEQUENCE','grbtsdo','^MDRS_','Any Sequence Starting with MDRS_');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','SYS_GRANT','grbtjva','[Jj][Aa][Vv][Aa]','Any permission with JAVA in the name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','TABLE','grbtctx','CUST_CTX_TEST','Any Table with CUST_CTX_TEST in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','TABLE','grbtend','^MDRT_','Any Tables Starting with MDRT_');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','TABLE','grbtsdo','^(SDO_|MDRT_)','Any Table Name Starting with SDO_ or MDRT_');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','TABLE_INDEX','grbtctx','CUST_CTX_TEST','Any Index with CUST_CTX_TEST in the Name');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('ODBCTEST','TABLE_INDEX','grbtsdo','^SDO_','Any Table Index Starting with SDO_');

insert into "ODBCAPTURE"."OBJECT_CONF" ("USERNAME","ELEMENT_NAME","BUILD_TYPE","OBJECT_NAME_REGEXP","NOTES")
  values ('PUBLIC','HOST_ACL','grbtst','^odbctest','Any Public Host ACLs with a Hostname starting with "ODBCTEST"');


begin
   if '0' != '0' then
      raise_application_error(-20000, 'Control file "ODBCAPTURE/OBJECT_CONF.ctl" returned error: 0');
   end if;
end;
/

commit;

----------------------------------------
-- Finalize Installation (Includes SPOOL OFF)

prompt ============================================================
prompt Running: grbtdat ./installation_finalize.sql
prompt ============================================================

--
--  Finalize Installation
--

prompt
prompt Drop Temp Publicly Updateable Table
drop public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE;
drop table TEMP_PUBLICLY_UPDATEABLE_TABLE purge;

prompt
prompt fix_invalid_public_synonyms
--@"../grb_linked_install_scripts/fix_invalid_public_synonyms.sql"

prompt
prompt compile_all
--@"../grb_linked_install_scripts/compile_all.sql" "'ODBCAPTURE'"

prompt
prompt alter_foreign_keys_ENABLE
--@"../grb_linked_install_scripts/alter_foreign_keys.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt alter_triggers_ENABLE
--@"../grb_linked_install_scripts/alter_triggers.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt update_id_sequences
--@"../grb_linked_install_scripts/update_id_sequences.sql" "'ODBCAPTURE'"

--prompt
--prompt alter_queues_ENABLE
--@"../grb_linked_install_scripts/alter_queues.sql" "ENABLE" "'ODBCAPTURE'"

--prompt
--prompt alter_scheduler_jobs_ENABLE
--@"../grb_linked_install_scripts/alter_scheduler_jobs.sql" "ENABLE" "'ODBCAPTURE'"

prompt
prompt Switch Spooling Off




prompt Update ODBCAPTURE_INSTALLATION_LOGS
insert into odbcapture_installation_logs(load_dtm, build_type, file_name)
  values(sysdate, 'grbtdat', 'OCI_APEX_install.sql');
commit;

--
--  Re-create Invalid Public Synonyms
--

----------------------------------------
prompt
prompt Re-create Invalid Public Synonyms
set serveroutput on size unlimited format wrapped

Declare
   sql_txt varchar(2000);
Begin
 for buff in (with q1 as (
              select owner, object_name, editionable
               from  dba_objects
               where status != 'VALID'
              )
              select syn.synonym_name, syn.table_owner, syn.table_name,
                     case q1.editionable when 'Y'  then ' EDITIONABLE'
                                         when NULL then ''
                                                   else ' NONEDITIONABLE'
                     end                  EDITIONABLE
                from dba_synonyms  syn
                     join q1
                          on  q1.owner       = syn.owner
                          and q1.object_name = syn.synonym_name
                     join dba_users  usr
                          on  usr.username = syn.table_owner
                          and (   usr.oracle_maintained is null
                               OR usr.oracle_maintained != 'Y')
               where syn.owner = 'PUBLIC' )
  loop
    begin
      sql_txt := 'CREATE OR REPLACE' || buff.EDITIONABLE || ' PUBLIC SYNONYM "' ||
                  buff.synonym_name || '" for "' || buff.table_owner || '"."' ||
                  buff.table_name ||'"';
      dbms_output.put_line(sql_txt);
      execute immediate sql_txt;
    exception
      when others then
        dbms_output.put_line('ERROR:' || CHR(10) || SQLERRM || CHR(10));
        dbms_output.put_line('----------------------------------------');
    end;
  end loop;
end;
/


--
--  Compile All "grbtst" Build Type Objects
--   1 - Schema List
--

declare
   sql_txt  varchar2(1000);
begin
   dbms_output.put_line('Compile All started');
   for buff in (select owner, object_name
                 from  sys.dba_objects
                 where owner      in ('ODBCAPTURE','ODBCTEST')
                  and  object_type = 'JAVA SOURCE'
                 order by owner, object_name )
   loop
      sql_txt := 'alter java source "' || buff.owner       ||
                                 '"."' || buff.object_name || '" compile';
      dbms_output.put_line(sql_txt || ';');
      begin
         execute immediate sql_txt;
      exception when others then
         dbms_output.put_line('-- ' || SQLERRM || CHR(10));
      end;
   end loop;
   for buff in (select username from dba_users
                 where username in ('ODBCAPTURE','ODBCTEST')
                 order by username )
   loop
      begin
         DBMS_UTILITY.compile_schema(schema      => buff.username
                                    ,compile_all => FALSE);
         dbms_output.put_line(buff.username  || ' Compiled.');
      exception when others then
         dbms_output.put_line('Error Compiling Schema ' || buff.username);
         dbms_output.put_line(SQLERRM || CHR(10));
      end;
   end loop;
   dbms_output.put_line('Compile All is done.');
end;
/

--
--  Alter Foreign Keys
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--   2 - Schema List
--

declare
   sql_txt  varchar2(1000);
   procedure missing_parent_sql
         (in_owner       sys.dba_constraints.owner%TYPE
         ,in_constraint  sys.dba_constraints.constraint_name%TYPE)
   is
      TYPE fk_rec_type is record
         (child_owner    sys.dba_constraints.owner%TYPE
         ,child_table    sys.dba_constraints.table_name%TYPE
         ,child_column   sys.dba_cons_columns.column_name%TYPE
         ,parent_owner   sys.dba_constraints.owner%TYPE
         ,parent_table   sys.dba_constraints.table_name%TYPE
         ,parent_column  sys.dba_cons_columns.column_name%TYPE);
      TYPE fk_nt_type is table of fk_rec_type;
      fk_nt  fk_nt_type;
   begin
      select ctab.owner child_owner,  ctab.table_name child_table,  ccol.column_name child_column,
             ptab.owner parent_owner, ptab.table_name parent_table, pcol.column_name parent_column
       bulk  collect into fk_nt
       from  sys.dba_constraints  ctab
             join sys.dba_cons_columns  ccol
                  on  ccol.owner = ctab.owner and ccol.constraint_name = ctab.constraint_name
             join sys.dba_constraints  ptab
                  on  ptab.owner = ctab.r_owner and ptab.constraint_name = ctab.r_constraint_name
             join sys.dba_cons_columns  pcol
                  on  pcol.owner = ptab.owner and pcol.constraint_name = ptab.constraint_name
                  and pcol.position = ccol.position
       where ctab.owner = in_owner and ctab.constraint_name = in_constraint
       order by ccol.position;
      if SQL%NOTFOUND then return; end if;
      dbms_output.put_line('-- ORA-20000: Query to find missing parent keys:');
      -- ORA-20000:  select "CHILD_KEY" from from "CHILD_OWNER"."CHILD_TABLE" group by "CHILD_KEY"
      sql_txt := '-- ORA-20000:  select "' || fk_nt(1).child_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).child_column;
      end loop;
      sql_txt := sql_txt || '" from "' || fk_nt(1).child_owner || '"."' || fk_nt(1).child_table ||
                        '" group by "' || fk_nt(1).child_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).child_column;
      end loop;
      dbms_output.put_line (sql_txt || '"');
      -- ORA-20000: MINUS select "PARENT_KEY" from "PARENT_OWNER"."PARENT_TABLE";
      sql_txt := '-- ORA-20000:  MINUS select "' || fk_nt(1).parent_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).parent_column;
      end loop;
      sql_txt := sql_txt || '" from "' || fk_nt(1).parent_owner || '"."' || fk_nt(1).parent_table || '";';
      dbms_output.put_line (sql_txt);
   end missing_parent_sql;
begin
   dbms_output.put_line('Alter Foreign Keys started.');
   dbms_output.put_line(q'{  ENABLE 'ODBCAPTURE','ODBCTEST'}');
   for buff in (select owner, table_name, constraint_name
                 from  dba_constraints
                 where constraint_type = 'R'
                  and  owner in ('ODBCAPTURE','ODBCTEST')
                 order by owner, table_name, constraint_name)
   loop
      sql_txt := 'alter table "' || buff.owner || '"."' || buff.table_name ||
                    '" ENABLE constraint "' || buff.constraint_name || '"';
      dbms_output.put_line(sql_txt || ';');
      begin
         execute immediate sql_txt;
      exception when others then
         dbms_output.put_line('-- *');
         dbms_output.put_line('-- ERROR at line :');
         dbms_output.put_line('-- ' || SQLERRM);
         missing_parent_sql(buff.owner, buff.constraint_name);
      end;
   end loop;
   dbms_output.put_line('Alter Foreign Keys is done.');
end;
/

--
--  Alter Type Triggers
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--   2 - Schema List
--

declare
   sql_txt  varchar2(1000);
begin
   dbms_output.put_line('Alter Triggers started.');
   dbms_output.put_line(q'{  ENABLE 'ODBCAPTURE','ODBCTEST'}');
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner in ('ODBCAPTURE','ODBCTEST')
                 order by owner, trigger_name)
   loop
      sql_txt := 'alter trigger "' || buff.owner        || '"."' ||
                                      buff.trigger_name || '" ENABLE';
      dbms_output.put_line(sql_txt || ';');
      begin
         execute immediate sql_txt;
      exception when others then
         dbms_output.put_line('-- ' || SQLERRM || CHR(10));
      end;
   end loop;
   dbms_output.put_line('Alter Triggers is done.');
end;
/

--
-- Update "grbtst" IDENTITY SEQUENCES
--   1 - Schema List
--

declare
   UNDEFINED_SEQUENCE  EXCEPTION;  -- sequence not yet defined in this session
   PRAGMA EXCEPTION_INIT (UNDEFINED_SEQUENCE, -8002);
   l_last_seq   number;
   l_max_val    number;
   sql_txt      varchar2(4000);
begin
   dbms_output.put_line('Update ID Sequences started');
   for buff in (
      select tic.owner
            ,tic.table_name
            ,tic.column_name
            ,tic.sequence_name
       from  dba_tab_identity_cols  tic
       where tic.owner in ('ODBCAPTURE','ODBCTEST')
      order by tic.owner
            ,tic.table_name
            ,tic.column_name
            ,tic.sequence_name )
   loop
      -- Find the Current Sequence Value
      sql_txt := 'select ' || buff.owner || '.' || buff.sequence_name ||
                 '.currval from dual';
      begin
         execute immediate sql_txt into l_last_seq;
      exception when UNDEFINED_SEQUENCE
      then
         -- Find the Last Number for the Sequence
         select ds.last_number into l_last_seq
          from  dba_sequences  ds
          where ds.sequence_owner = buff.owner
           and  ds.sequence_name  = buff.sequence_name;
      end;
      -- Find the maximum IDENTITY column value
      sql_txt := 'select max(' || buff.column_name || ')' ||
                 ' from ' || buff.owner || '.' || buff.table_name;
      execute immediate sql_txt into l_max_val;
      -- Display values found
      dbms_output.put_line(buff.owner || '.' || buff.sequence_name || ' Last Sequence: ' || l_last_seq ||
                   ', ' || buff.owner || '.' || buff.table_name || ' max(' || buff.column_name || ') = ' || l_max_val);
      if l_last_seq < l_max_val
      then
         -- Increment the sequence as necessary
         sql_txt := 'begin' ||
                    ' while ' || buff.owner || '.' || buff.sequence_name || '.nextval < ' || l_max_val ||
                    ' loop null; end loop;' ||
                    'end;';
         dbms_output.put_line(sql_txt);
         execute immediate sql_txt;-- using l_last_seq;
      end if;
   end loop;
   dbms_output.put_line('Identity Sequence Updates is done.');
end;
/
