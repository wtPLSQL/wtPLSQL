create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   test_runs%ROWTYPE;


----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
procedure init_test_run
      (in_package_name  in  varchar2)
is
   test_runs_rec_NULL   test_runs%ROWTYPE;
   package_check        number;
begin
   -- Reset the Test Runs Record before checking anything
   g_test_runs_rec              := test_runs_rec_NULL;
   g_test_runs_rec.id           := test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_owner := USER;
   g_test_runs_rec.runner_name  := in_package_name;
   -- These RAISEs can be captured because the Test Runs Record is set.
   --  Check for NULL Runner Name
   if g_test_runs_rec.runner_name is null
   then
      raise_application_error  (-20000, 'RUNNER_NAME is null');
   end if;
   --  Check for Valid Runner Name
   select count(*) into package_check
    from  user_arguments
    where object_name   = 'WTPLSQL_RUN'
     and  package_name  = g_test_runs_rec.runner_name
     and  argument_name is null
     and  position      = 1
     and  sequence      = 0;
   if package_check != 1
   then
      raise_application_error (-20000, 'RUNNER_NAME is not valid');
   end if;
   --
end init_test_run;

------------------------------------------------------------
procedure insert_test_run
is
begin
   g_test_runs_rec.end_dtm := systimestamp;
   insert into test_runs values g_test_runs_rec;
exception
   when DUP_VAL_ON_INDEX
   then
      -- This record must have already been inserted
      null;
end insert_test_run;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
begin

   init_test_run(in_package_name);

   result.initialize(g_test_runs_rec.id);

   profiler.initialize(g_test_runs_rec.id);
   g_test_runs_rec.dbout_owner := profiler.g_rec.dbout_owner;
   g_test_runs_rec.dbout_name  := profiler.g_rec.dbout_name;
   g_test_runs_rec.dbout_type  := profiler.g_rec.dbout_type;

   begin
      execute immediate 'BEGIN ' || in_package_name || '.WTPLSQL_RUN; END;';
   exception
      when OTHERS
      then
         g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                                 dbms_utility.format_error_backtrace
                                                ,1,4000);
   end;

   profiler.pause;

   ROLLBACK;

   insert_test_run;

   profiler.finalize;

   result.finalize;

   COMMIT;

exception
   when OTHERS
   then
      g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace ||
                                              CHR(10) || g_test_runs_rec.error_message
                                             ,1,4000);
      insert_test_run;
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
procedure testcase1
is
begin
   assert.g_testcase := 'TESTCASE_1';
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
      (msg_in             => 'TEST_RUNS Record Not Exists'
      ,check_query_in     => 'select count(*) from TEST_RUNS' ||
                            ' where id = ''' || g_test_runs_rec.id || ''''
      ,against_value_in   => 0);
--   insert_test_run;
--   assert.eqqueryvalue
--      (msg_in             => 'TEST_RUNS Record Exists'
--      ,check_query_in     => 'select count(*) from TEST_RUNS' ||
--                            ' where id = ''' || g_test_runs_rec.id || ''''
--      ,against_value_in   => 1);
--   delete from TEST_RUNS where id = g_test_runs_rec.id;
--   assert.eq (msg_in          => 'Test Runs Delete'
--             ,check_this_in   => SQL%ROWCOUNT
--             ,against_this_in => 1);
--   assert.eqqueryvalue
--      (msg_in             => 'TEST_RUNS Record Not Exists'
--      ,check_query_in     => 'select count(*) from TEST_RUNS' ||
--                            ' where id = ''' || g_test_runs_rec.id || ''''
--      ,against_value_in   => 0);
end testcase1;

----------------------------------------
procedure WTPLSQL_RUN
is
begin
   testcase1;
end;

$END
--=======================================================--


end wtplsql;
