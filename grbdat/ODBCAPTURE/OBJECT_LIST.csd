
--
--  Consolidated Seed Data script for DEVDBA.OBJECT_LIST data
--
-- Command Line Parameters:
--   1 - Script Directory
--       i.e. pass the directory name for this script.
--       Use "." if running from current directory.
--   2 - SYSTEM/password@TNSALIAS
--       i.e. pass the username and password for the SYSTEM user
--            and the TNSALIAS for the connection to the database.
--       The Seed Data installation requires this connection information.
--

define OBJ_PATH = "&1."

-- NOTE: Additional file extensions for SQL*Loader include
--   .bad - Bad Records
--   .dsc - Discard Records
--   .log - Log File

set verify off
set feedback off

prompt
prompt sqlldr_control=&&OBJ_PATH./OBJECT_LIST.ctl
host sqlldr '&2.' control=&&OBJ_PATH./OBJECT_LIST.ctl data=&&OBJ_PATH./OBJECT_LIST.csv log=&&OBJ_PATH./OBJECT_LIST.log silent=HEADER,FEEDBACK

begin
   if '&_RC.' != '0' then
      raise_application_error(-20000, 'Control file "&&OBJ_PATH./OBJECT_LIST.ctl" returned error: &_RC.');
   end if;
end;
/

set feedback on
set verify on

