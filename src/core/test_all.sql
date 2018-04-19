
spool test_all

set serveroutput on size unlimited format wrapped

/*
alter system
  set PLSQL_CCFLAGS = 'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:TRUE'
  --set PLSQL_CCFLAGS = 'WTPLSQL_ENABLE:TRUE'
  scope=BOTH';
select p.value PLSQL_CCFLAGS
 from  dual  d
  left join v$parameter  p
            on  p.name in 'plsql_ccflags';
*/

begin
   --
   wtplsql.test_all;
   --
   for buff in (select runner_name
                 from  wt_test_runs
                 where runner_owner = USER
                 group by runner_name
                 order by runner_name)
   loop
      wt_text_report.dbms_out(in_runner_name    => buff.runner_name
                           --  ,in_hide_details   => TRUE
                           --  ,in_summary_last   => TRUE
                             ,in_show_pass      => TRUE
                             ,in_show_aux       => TRUE
                             );
   end loop;
   --
end;
/

spool off
