
spool test_all
set serveroutput on size unlimited format wrapped
set linesize 1000
set trimspool on

/*

alter system
  set PLSQL_CCFLAGS = 'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:TRUE'
  --set PLSQL_CCFLAGS = 'WTPLSQL_ENABLE:TRUE'
  scope=BOTH;

select p.value PLSQL_CCFLAGS
 from  dual  d
  left join v$parameter  p
            on  p.name in 'plsql_ccflags';

begin
   $IF $$WTPLSQL_SELFTEST
   $THEN
      dbms_output.put_line('WTPLSQL_SELFTEST is TRUE');
   $END
   dbms_output.put_line('Check WTPLSQL_SELFTEST is Done.');
end;
/

*/

begin
   wtplsql.test_all;
end;
/

spool off
