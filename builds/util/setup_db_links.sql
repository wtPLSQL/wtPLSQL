
--
--  Setup Datbase Linkgs for Unit Testing
--
--  Run as WTP Schema/User
--

set serveroutput on size unlimited format wrapped

----------------------------------------
prompt
prompt Recreate Database Links
declare
   procedure run_sql (in_sql in varchar2) is
      -- ORA-02024: database link not found
      no_db_link exception;
      pragma exception_init(no_db_link, -02024);
   begin
      dbms_output.put_line(in_sql);
      execute immediate in_sql;
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
      run_sql('alter session set current_schema = "' || buff.TEST_OWNER || '"');
      run_sql('drop database link "' || buff.TEST_OWNER || '"');
      run_sql('create database link "' || buff.TEST_OWNER  ||
                      '" connect to "' || buff.TEST_OWNER  ||
                   '" identified by "' || buff.TEST_OWNER  ||
               '" using ''//localhost:1521/' || SYS_CONTEXT('USERENV','SERVICE_NAME') || '''');
   end loop;
   run_sql('alter session set current_schema = "' || USER || '"');
end;
/

exit
