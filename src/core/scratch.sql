
-- This works
declare
   dual_rowid   ROWID;
   test_tstamp  timestamp := systimestamp - 1/24;
begin
   assert.reset_globals;
   assert.g_testcase := 'Basic Testing';
   assert.eq('Varchar Test', 'THIS', 'THIS');
   assert.eq('Number Test', 1, 2);
   assert.eq('Date Test', sysdate, sysdate + 1/24);
   assert.eq('Boolean Test', FALSE, FALSE);
   assert.reset_globals;
   assert.eq('Timestamp Test', systimestamp, systimestamp);
   assert.eq('Interval Test', systimestamp - test_tstamp, systimestamp - test_tstamp);
   select ROWID into dual_rowid from dual;
   assert.eq('ROWID Test', dual_rowid, dual_rowid);
end;
/

select assert.get_NLS_DATE_FORMAT from dual;

select * from test_runs;
select * from results;
select * from dbout_profiles;

execute wtplsql.test_run('WTPLSQL');
execute text_report.dbms_out(wtplsql.g_test_runs_rec.id);

begin
   for buff in (select id from test_runs)
   loop
      text_report.dbms_out(buff.id);
   end loop;
end;
/
