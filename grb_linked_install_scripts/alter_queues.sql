
--
--  Alter Queues
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--   2 - Schema List
--

declare
   sql_txt  varchar2(1000);
begin
   dbms_output.put_line('Alter Queues started');
   dbms_output.put_line(q'{  &1. &2.}');
   for buff in (select owner, name
                 from  dba_queues
                 where owner in (&2.)
                  and  queue_type != 'EXCEPTION_QUEUE'
                 order by owner, name)
   loop
      sql_txt := 'begin DBMS_AQADM.' ||
                 case '&1.' when 'ENABLE' then 'START_QUEUE'
                                          else 'STOP_QUEUE'
                 end ||
                 '(QUEUE_NAME => ''' || buff.owner || '.' || buff.name ||
                 ''', ENQUEUE => TRUE, DEQUEUE => TRUE); end;';
      dbms_output.put_line(sql_txt || ';');
      begin
         execute immediate sql_txt;
      exception when others then
         dbms_output.put_line('-- ' || SQLERRM || CHR(10));
      end;
   end loop;
   dbms_output.put_line('Alter Queues is done.');
end;
/
