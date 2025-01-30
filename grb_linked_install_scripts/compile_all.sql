
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
                 where owner      in (&1.)
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
                 where username in (&1.)
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
