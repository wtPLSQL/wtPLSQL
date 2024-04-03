
----------------------------------------
-- Show the Services for this PDB
select name from v$services;
prompt Using the following service at localhost:1521
execute dbms_output.put_line(SYS_CONTEXT('USERENV','SERVICE_NAME'));
select name from v$services;

----------------------------------------
-- Ensure Hooks are Initialized
execute hook.init;

----------------------------------------
-- Recreate Database Links and Run Tests
declare
   procedure run_sql (in_sql in varchar2) is
      -- ORA-02024: database link not found
      no_db_link exception;
      pragma exception_init(no_db_link, -02024);
   begin
      dbms_output.put_line(in_sql);
      execute immediate in_sql;
      dbms_output.put_line(CHR(10));
   exception
      when no_db_link then
         null;  -- Ignore this errror;
      when others then
         dbms_output.put_line(SQLERRM || CHR(10));
   end run_sql;
begin
   -- Test every Schema Owner in the Database
   for buff in (select proc.owner             TEST_OWNER
                 from  dba_procedures  proc
                 where proc.procedure_name = 'WTPLSQL_RUN'
                  and  proc.object_type    = 'PACKAGE'
              group by proc.owner
              order by proc.owner )
   loop
      run_sql('drop database link "' || buff.TEST_OWNER || '"');
      run_sql('create database link "' || buff.TEST_OWNER  ||
                      '" connect to "' || buff.TEST_OWNER  ||
                   '" identified by "' || buff.TEST_OWNER  ||
         '" using ''//localhost:1521/' || SYS_CONTEXT('USERENV','SERVICE_NAME') || '''');
      run_sql('begin wtplsql.test_all@' || buff.TEST_OWNER || '; end;');
   end loop;
end;
/

----------------------------------------
-- Setup for Reports
connect &PDB_SYSTEM.
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
select 'db: ' || name ||
       ', con: ' || sys_context('USERENV', 'CON_NAME') ||
       ', tstmp: ' || systimestamp
 from  v$database;
set linesize 2499
set trimspool on
set echo off
set verify off
set feedback off

spool off

----------------------------------------
set termout on
prompt Reporting Unit Test Results...
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);
set linesize 2499
set trimspool on
set echo off
set verify off
set feedback off
set termout off

spool JUnit_Report_All.xml

begin
   wtp.junit_report_all;
end;
/

spool off
set termout on

----------------------------------------
-- Done with Reports
set linesize 80
set verify on
set feedback on
