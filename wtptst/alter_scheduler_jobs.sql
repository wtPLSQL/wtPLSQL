
--
--  Alter "wtptst" Install Type Scheduler Jobs
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--

declare
   procedure do_it (in_schema in varchar2) is
      sql_txt  varchar2(1000);
   begin
      for buff in (select owner, job_name from dba_scheduler_jobs
                    where owner = in_schema
                    order by owner, job_name)
      loop
         sql_txt := 'begin DBMS_SCHEDULER.&1.(NAME => ''' ||
               buff.owner || '.' || buff.job_name || '''); end;';
         dbms_output.put_line(sql_txt || ';');
         begin
            execute immediate sql_txt;
         exception when others then
            dbms_output.put_line('-- ' || SQLERRM || CHR(10));
         end;
      end loop;
      dbms_output.put_line('-- ' || in_schema || ' Alter Scheduler Jobs is done.');
   end do_it;
begin
   dbms_output.put_line('Alter Scheduler Jobs for wtptst Install Type');
   do_it('WTP');
end;
/
