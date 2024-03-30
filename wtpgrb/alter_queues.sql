
--
--  Alter "wtpgrb" Install Type Queues
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--

declare
   procedure do_it (in_schema in varchar2) is
      sql_txt  varchar2(1000);
   begin
      for buff in (select owner, name from dba_queues
                    where owner = in_schema and queue_type != 'EXCEPTION_QUEUE'
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
      dbms_output.put_line('-- ' || in_schema || ' Alter Queues is done.');
   end do_it;
begin
   dbms_output.put_line('Alter Queues for wtpgrb Install Type');
   do_it('ODBCAPTURE');
end;
/
