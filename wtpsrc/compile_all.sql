
--
--  Compile All "wtpsrc" Install Type Objects
--

declare
   procedure do_it (in_schema in varchar2) is
      sql_txt  varchar2(1000);
   begin
      for buff in (select object_name
                    from  sys.dba_objects
                    where owner       = in_schema
                     and  object_type = 'JAVA SOURCE'
                    order by object_name )
      loop
         sql_txt := 'alter java source "' || in_schema || '"."' || buff.object_name || '" compile';
         dbms_output.put_line(sql_txt || ';');
         begin
            execute immediate sql_txt;
         exception when others then
            dbms_output.put_line('-- ' || SQLERRM || CHR(10));
         end;
      end loop;
      begin
         DBMS_UTILITY.compile_schema(schema => in_schema, compile_all => FALSE);
         dbms_output.put_line('-- ' || in_schema || ' Compile All is done.');
      exception when others then
         dbms_output.put_line('Compiling Schema ' || in_schema || CHR(10) || SQLERRM);
         dbms_output.put_line('');
      end;
   end do_it;
begin
   dbms_output.put_line('Compile All for wtpsrc Install Type');
   do_it('WTP');
end;
/
