
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
-- Setup for Reports
set linesize 2499
set trimspool on
set echo off
set verify off
set termout on
set serveroutput on size unlimited format wrapped

----------------------------------------
prompt
prompt Reporting Summary of Install Type Log Errors
declare
   TYPE err_aa_type is table of pls_integer index by varchar2(4000);
   err_aa      err_aa_type;
   line_txt    varchar2(4000);
   so_far      pls_integer;
   end_pos     pls_integer;
   procedure add_line is
   begin
      if regexp_like(line_txt, '(ORA-|SQL-|SP2-|PLS-|PL2-|TNS-|(object|mmap) failed)')
      then
         begin
            err_aa(line_txt) := err_aa(line_txt) + 1;
         exception when NO_DATA_FOUND then
            err_aa(line_txt) := 1;
         end;
      end if;
   end add_line;
begin
   for buff in (select file_name, load_dtm, contents
                 from  odbcapture_installation_logs
                 where install_type = 'grbsrc'
                  and  load_dtm > trunc(sysdate,'DD') - 2
                 order by file_name, load_dtm)
   loop
      dbms_output.put_line('Processing file ' || buff.file_name ||
                                 ' (' || to_char(buff.load_dtm,'YYYY-MM-DD HH24:MI:SS') || ')');
      err_aa.DELETE;
      so_far := 0;
      loop
         end_pos := instr(buff.contents, chr(10), so_far + 1);
         exit when end_pos = 0;
         line_txt := substr(buff.contents, so_far + 1, end_pos - so_far - 1);
         add_line;
         so_far := end_pos;
      end loop;
      line_txt := substr(buff.contents, so_far + 1, 4000);
      add_line;
      if err_aa.COUNT = 0 then continue; end if;
      line_txt := err_aa.FIRST;
      loop
         dbms_output.put_line(line_txt);
         dbms_output.put_line('  ' || err_aa(line_txt) || ' lines: ' || line_txt);
         exit when line_txt = err_aa.LAST;
         line_txt := err_aa.NEXT(line_txt);
      end loop;
   end loop;
end;
/

----------------------------------------
prompt
prompt Reporting Invalid Objects
set feedback off
set termout off
spool list_invalids.csv
@"list_invalids.sql" ""
spool off
set termout on
set feedback on

----------------------------------------
prompt
prompt Reporting JUnit XML Database Build Status
set feedback off
set termout off
spool db_build_junit_report.xml
@"db_build_junit_report.sql" ""
spool off
set termout on
set feedback on

----------------------------------------
prompt
prompt Reorting JUnit XML Installation Log
set feedback off
set termout off
spool log_files_junit_report.xml
@"log_files_junit_report.sql" ""
spool off
set termout on
set feedback on

----------------------------------------
-- Done with Reports
set linesize 80
set verify on

