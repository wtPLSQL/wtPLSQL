
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
   procedure report_test (in_package_name in varchar2)
   is
   begin
      wtplsql.test_run(in_package_name);
      wt_text_report.dbms_out(in_runner_name    => in_package_name
                           --  ,in_hide_details   => TRUE
                           --  ,in_summary_last   => TRUE
                           --  ,in_show_pass      => TRUE
                           --  ,in_show_aux       => TRUE
                             );
   end report_test;
begin
   report_test('WTPLSQL');
   report_test('WT_RESULT');
   report_test('WT_ASSERT');
   report_test('WT_PROFILER');
end;
/

select * from user_errors
 --where attribute = 'ERROR'
 order by name, type, sequence, line, position, text;

 where name = 'WT_PROFILE_TEST';

select * from dual
 where regexp_like('package body wt_result', '(FUNCTION|PROCEDURE|PACKAGE|TYPE|TRIGGER)', 'i');


select * from wt_dbout_profiles where test_run_id = 26 order by line;

select * from wt_test_data;

create or replace procedure wt_profile_test
is
  l_junk number;
begin
   --% WTPLSQL SET DBOUT "WT_PROFILER" %--'
   l_junk := 1;
end wt_profile_test;
/

begin
      execute immediate
         'create or replace procedure wt_profile_test'     || CHR(10) ||
         'is'                                              || CHR(10) ||
         '  l_junk number;'                                || CHR(10) ||
         'begin'                                           || CHR(10) ||
         '   --% WTPLSQL SET DBOUT "WT_PROFILE_TEST" %--'  || CHR(10) ||
         '   l_junk := 1;'                                 || CHR(10) ||
         'end wt_profile_test;'                            ;
end;
/
