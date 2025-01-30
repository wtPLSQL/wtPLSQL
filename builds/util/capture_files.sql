
--
-- Capture Source Code Files
--
--  Must be run as ODBCAPTURE
--
--  Command Line Parameters:
--    -) 1: FILE_NAME    - Zip File Name Root
--

define FILE_NAME="&1."

-- Setup SQL*Plus
set trimout on
set trimspool on
set pagesize 0
set linesize 5000
set long 100000000
set longchunksize 32767
whenever sqlerror exit sql.sqlcode rollback
set serveroutput on size unlimited format word_wrapped

-- Setup for Source Code Capture
execute FH2.clear_buffers;
execute COMMON_UTIL.update_view_tabs;

-- Capture Source Code
BEGIN
   for buff in (select build_type
                 from  odbcapture_installation_logs
                 group by build_type
                 order by max(load_dtm))
   loop
      GRAB_SCRIPTS.all_scripts(buff.build_type);
   end loop;
end;
/

-- Generate/Save Zip File
delete from zip_files where file_name = '&FILE_NAME..zip';
execute FH2.write_scripts('&FILE_NAME..zip');
commit;

-- https://ogobrecht.com/posts/2020-01-01-download-blobs-with-sqlplus/
-- Download BLOBs with SQL*Plus
set verify off
--set heading off
variable contents clob
BEGIN
  select COMMON_UTIL.b64_encode(file_blob)
   into  :contents
   from  zip_files
   where file_name = '&FILE_NAME..zip';
END;
/
set feedback off
set termout off
spool "&FILE_NAME..zip.b64"
print contents
spool off
