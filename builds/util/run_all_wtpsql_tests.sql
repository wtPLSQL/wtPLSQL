
-- Recreate Database Links

declare
   sql_txt varchar2(4000);
   procedure run_sql is begin
      dbms_output.put_line(sql_txt);
      execute immediate sql_txt;
   end run_sql;
begin
   --
   for buff in (select db_link from user_db_links)
   loop
      sql_txt := 'drop database link "' || buff.db_link || '"';
      run_sql;
   end loop;
   --
   for buff in (
      select proc.owner             TEST_OWNER
       from  dba_procedures  proc
       where proc.procedure_name = 'WTPLSQL_RUN'
        and  proc.object_type    = 'PACKAGE'
       group by proc.owner
       order by proc.owner )
   loop
      sql_txt := 'create database link "' || buff.TEST_OWNER  || '"' ||
                          ' connect to "' || buff.TEST_OWNER  || '"' ||
                       ' identified by "' || buff.TEST_OWNER  || '"' ||
          '   using ''//localhost:1521/' || SYS_CONTEXT('USERENV','SERVICE_NAME') || '''';
      run_sql;
   end loop;
end;
/

-- Run All Tests

begin
   for buff in (
      select username, db_link from user_db_links
       order by username, db_link )
   loop
      dbms_output.put_line('Running Tests for ' || buff.db_link);
      begin
        -- execute immediate 'begin wtplsql.test_all@' || buff.username ||
         execute immediate 'begin wtplsql.test_all@' || buff.db_link ||
                                            '; end;' ;
      exception when others
      then
         dbms_output.put_line(CHR(10) || SQLERRM || CHR(10));
      end;
      commit;
   end loop;
end;
/
