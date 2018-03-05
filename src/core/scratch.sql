
alter system set PLSQL_CCFLAGS = 
    'WTPLSQL_ENABLE:TRUE, WTPLSQL_SELFTEST:TRUE'
    scope=BOTH;

select p.value PLSQL_CCFLAGS
 from  dual  d
  left join v$parameter  p
            on  p.name in 'plsql_ccflags';

-- This works
declare
   dual_rowid   ROWID;
   test_tstamp  timestamp := systimestamp - 1/24;
begin
   wt_assert.g_testcase := 'Basic Testing';
   wt_assert.eq('Varchar Test', 'THIS', 'THIS');
   wt_assert.eq('Number Test', 1, 2);
   wt_assert.eq('Date Test', sysdate, sysdate + 1/24);
   wt_assert.eq('Boolean Test', FALSE, FALSE);
   wt_assert.reset_globals;
   wt_assert.eq('Timestamp Test', systimestamp, systimestamp);
   wt_assert.eq('Interval Test', systimestamp - test_tstamp, systimestamp - test_tstamp);
   select ROWID into dual_rowid from dual;
   wt_assert.eq('ROWID Test', dual_rowid, dual_rowid);
end;
/

select assert.get_NLS_DATE_FORMAT from dual;

select * from plsql_profiler_data;
select * from plsql_profiler_units;
select * from plsql_profiler_runs;

select * from wt_test_runs;
select * from wt_results;
select * from wt_dbout_profiles;

execute wtplsql.delete_records;

   select *
    from  all_arguments
    where owner         = USER
     and  object_name   = 'WTPLSQL_RUN'
     and  package_name  = 'WT_ASSERT'
     and  argument_name is null
     and  position      = 1
     and  sequence      = 0;

declare
   procedure run_test (in_package_name in varchar2)
   is
   begin
      wtplsql.test_run(in_package_name);
      wt_text_report.dbms_out(in_runner_name    => in_package_name
                           --  ,in_hide_details   => TRUE
                             ,in_summary_first  => TRUE
                             ,in_show_pass      => TRUE
                             ,in_show_aux       => TRUE
                             );
   end run_test;
begin
   --run_test('WTPLSQL');
   run_test('WT_ASSERT');
end;
/

select * from wt_dbout_profiles where test_run_id = 26 order by line;
