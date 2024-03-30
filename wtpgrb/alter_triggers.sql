
--
--  Alter "wtpgrb" Install Type Triggers
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--

declare
   procedure do_it (in_schema in varchar2) is
      sql_txt  varchar2(1000);
   begin
      for buff in (select owner, trigger_name from dba_triggers
                    where table_owner = in_schema
                    order by owner, trigger_name)
      loop
         sql_txt := 'alter trigger "' || buff.owner        || '"."' ||
                                         buff.trigger_name || '" &1.';
         dbms_output.put_line(sql_txt || ';');
         begin
            execute immediate sql_txt;
         exception when others then
            dbms_output.put_line('-- ' || SQLERRM || CHR(10));
         end;
      end loop;
      dbms_output.put_line('-- ' || in_schema || ' Alter Triggers is done.');
   end do_it;
begin
   dbms_output.put_line('Alter Triggers for wtpgrb Install Type');
   do_it('ODBCAPTURE');
end;
/
