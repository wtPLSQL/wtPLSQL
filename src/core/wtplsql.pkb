create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   test_runs%ROWTYPE;


----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
procedure new_test_run
      (in_package_name  in  varchar2)
is
   test_runs_rec_NULL   test_runs%ROWTYPE;
begin
   g_test_runs_rec              := test_runs_rec_NULL;
   g_test_runs_rec.runner_name  := in_package_name;
   g_test_runs_rec.id           := test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_owner := USER;
   insert into test_runs values g_test_runs_rec;
end new_test_run;

------------------------------------------------------------
procedure update_test_run
is
begin
   g_test_runs_rec.end_dtm := systimestamp;
   update test_runs
     set  end_dtm       = g_test_runs_rec.end_dtm
         ,error_message = g_test_runs_rec.error_message
    where id = g_test_runs_rec.id;
end update_test_run;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
begin
   if in_package_name is null
   then
      raise_application_error  (-20000, 'i_package_name is null');
   end if;
   new_test_run(in_package_name);
   result.initialize(g_test_runs_rec.id);
   profiler.initialize(g_test_runs_rec.id);
   COMMIT;
   begin
      execute immediate in_package_name || '.WTPLSQL_RUN';
   exception
      when OTHERS
      then
         g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                                 dbms_utility.format_error_backtrace
                                                ,1,4000);
   end;
   profiler.pause;
   ROLLBACK;
   profiler.finalize;
   result.finalize;
   update_test_run;
   COMMIT;
exception
   when OTHERS
   then
      g_test_runs_rec.error_message := substr(g_test_runs_rec.error_message || CHR(10) ||
                                              dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace
                                             ,1,4000);
      update_test_run;
      profiler.finalize;
      result.finalize;
      COMMIT;
end test_run;

------------------------------------------------------------
procedure test_all
is
begin
   select package_name
     bulk collect into g_runners_nt
    from  user_arguments  t1
    where object_name   = 'WTPLSQL_RUN'
     and  position      = 1
     and  sequence      = 0
     and  data_type     is null
     and  not exists (
          select 'x' from user_arguments  t2
           where t2.object_name = t1.object_name
            and  (   t2.overload is null
                  OR t2.overload = t1.overload)
            and  t2.position    > t1.position
            and  t2.sequence    > t1.sequence
          );
   for i in 1 .. g_runners_nt.COUNT
   loop
      test_run(g_runners_nt(i));
   end loop;
end test_all;


--=======================================================--
--  WtPLSQL Procedures
$IF $$WTPLSQL_ENABLE
$THEN

----------------------------------------
procedure wtplsql_setup
      (in_package_name  in  varchar2)
is
begin
   new_test_run(in_package_name);
end wtplsql_setup;

----------------------------------------
procedure wtplsql_teardown
      (in_package_name  in  varchar2)
is
begin
   delete from test_runs
    where runner_name = in_package_name;
end wtplsql_teardown;

----------------------------------------
procedure testcase1
is
begin
   assert.g_testcase := 'Testcase 1: New Test Run';
   g_test_runs_rec.runner_name := 'TESTCASE_1';
   --
   g_test_runs_rec.dbout_owner    := 'X';
   g_test_runs_rec.dbout_name     := 'X';
   g_test_runs_rec.dbout_type     := 'X';
   g_test_runs_rec.profiler_runid := -1;
   g_test_runs_rec.end_dtm        := systimestamp;
   g_test_runs_rec.error_message  := 'X';
   --
   assert.eqqueryvalue
      (msg_in             => 'TEST_RUNS Record Not Exists'
      ,check_query_in     => 'select count(*) from TEST_RUNS' ||
                            ' where runner_name = ''' || g_test_runs_rec.runner_name || ''''
      ,against_value_in   => 0);
   assert.isnotnull (msg_in        =>  'g_test_runs_rec.runner_name NOT NULL'
                    ,check_this_in => g_test_runs_rec.runner_name);
   new_test_run('TESTCASE_1');  -- Pass By Reference Clears the Runner Name
   assert.isnotnull (msg_in        =>  'g_test_runs_rec.id NOT NULL'
                    ,check_this_in => g_test_runs_rec.id);
   assert.isnotnull (msg_in        =>  'g_test_runs_rec.start_dtm NOT NULL'
                    ,check_this_in => g_test_runs_rec.start_dtm);
   assert.isnotnull (msg_in        =>  'g_test_runs_rec.runner_name NOT NULL'
                    ,check_this_in => g_test_runs_rec.runner_name);
   assert.isnotnull (msg_in        =>  'g_test_runs_rec.runner_owner NOT NULL'
                    ,check_this_in => g_test_runs_rec.runner_owner);
   assert.isnull (msg_in        =>  'g_test_runs_rec.dbout_owner IS NULL'
                 ,check_this_in => g_test_runs_rec.dbout_owner);
   assert.isnull (msg_in        =>  'g_test_runs_rec.dbout_name IS NULL'
                 ,check_this_in => g_test_runs_rec.dbout_name);
   assert.isnull (msg_in        =>  'g_test_runs_rec.dbout_type IS NULL'
                 ,check_this_in => g_test_runs_rec.dbout_type);
   assert.isnull (msg_in        =>  'g_test_runs_rec.profiler_runid IS NULL'
                 ,check_this_in => g_test_runs_rec.profiler_runid);
   assert.isnull (msg_in        =>  'g_test_runs_rec.end_dtm IS NULL'
                 ,check_this_in => g_test_runs_rec.end_dtm);
   assert.isnull (msg_in        =>  'g_test_runs_rec.error_message IS NULL'
                 ,check_this_in => g_test_runs_rec.error_message);
   assert.eqqueryvalue
      (msg_in             => 'TEST_RUNS Record Exists'
      ,check_query_in     => 'select count(*) from TEST_RUNS' ||
                            ' where runner_name = ''' || g_test_runs_rec.runner_name || ''''
      ,against_value_in   => 1);
   wtplsql_teardown(g_test_runs_rec.runner_name);
end testcase1;

----------------------------------------
procedure testcase3
is
begin
   assert.g_testcase := 'Testcase 3: Invalid Package';
   p_test_runs_rec.runner_name := 'TESTCASE_3';
   assert.objnotexists(msg_in        => p_test_runs_rec.runner_name || ' NOT EXISTS'
                      ,check_this_in => p_test_runs_rec.runner_name);
   assert.raises
      (msg_in           => 'Should Raise Exception'
      ,check_call_in    => 'WTPLSQL.test_run(''' || p_test_runs_rec.runner_name || ''')'
      ,against_exc_in   => 'ORA-00900: invalid SQL statement');
end testcase3;

----------------------------------------
procedure WTPLSQL_RUN
is
begin
   wtplsql_teardown('TESTCASE_1');
   testcase1;
   testcase3;
end;

$END
--=======================================================--


end wtplsql;
