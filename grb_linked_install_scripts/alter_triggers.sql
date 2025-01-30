
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
   dbms_output.put_line(q'{  &1. &2.}');
   for buff in (select owner, trigger_name
                 from  dba_triggers
                 where table_owner in (&2.)
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
   dbms_output.put_line('Alter Triggers is done.');
end;
/
