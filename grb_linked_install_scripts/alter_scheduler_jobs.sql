
--
--  Alter Scheduler Jobs
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--   2 - Schema List
--

declare
   sql_txt  varchar2(1000);
begin
   dbms_output.put_line('Alter Scheduler Jobs started.');
   dbms_output.put_line(q'{  &1. &2.}');
   for buff in (select owner, job_name
                 from  dba_scheduler_jobs
                 where owner in (&2.)
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
   dbms_output.put_line('Alter Scheduler Jobs is done.');
end;
/
