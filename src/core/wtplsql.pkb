create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   wt_test_runs%ROWTYPE;


   --===============--%WTPLSQL_begin_ignore_lines%--===============--
   $IF $$WTPLSQL_SELFTEST
   $THEN
      g_running_selftest  boolean := FALSE;
   $END
   --===============--%WTPLSQL_end_ignore_lines%--=================--


----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
-- This procedure is separated for internal WTPLSQL testing
procedure check_runner
is
   package_check        number;
begin
   -- These RAISEs can be captured because the Test Runs Record is set.
   --  Check for NULL Runner Name
   if g_test_runs_rec.runner_name is null
   then
      raise_application_error (-20001, 'RUNNER_NAME is null');
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
      raise_application_error (-20002, 'RUNNER_NAME is not valid');
   end if;
end check_runner;

------------------------------------------------------------
procedure init_test_run
is
   test_runs_rec_NULL   wt_test_runs%ROWTYPE;
begin
   -- Reset the Test Runs Record before checking anything
   g_test_runs_rec              := test_runs_rec_NULL;
   g_test_runs_rec.id           := wt_test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_owner := USER;
end init_test_run;

------------------------------------------------------------
procedure insert_test_run
is
begin
   g_test_runs_rec.end_dtm := systimestamp;
   insert into wt_test_runs values g_test_runs_rec;
end insert_test_run;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
begin

   init_test_run;
   g_test_runs_rec.runner_name := in_package_name;
   check_runner;

   wt_result.initialize(g_test_runs_rec.id);

   wt_profiler.initialize(in_test_run_id      => g_test_runs_rec.id,
                          in_runner_name      => g_test_runs_rec.runner_name,
                          out_dbout_owner     => g_test_runs_rec.dbout_owner,
                          out_dbout_name      => g_test_runs_rec.dbout_name,
                          out_dbout_type      => g_test_runs_rec.dbout_type,
                          out_trigger_offset  => g_test_runs_rec.trigger_offset,
                          out_profiler_runid  => g_test_runs_rec.profiler_runid);

   begin
      execute immediate 'BEGIN ' || in_package_name || '.WTPLSQL_RUN; END;';
   exception
      when OTHERS
      then
         g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                                 dbms_utility.format_error_backtrace
                                                ,1,4000);
   end;

   wt_profiler.pause;

   ROLLBACK;

   insert_test_run;

   wt_profiler.finalize;

   wt_result.finalize;

   COMMIT;

   --===============--%WTPLSQL_begin_ignore_lines%--===============--
   $IF $$WTPLSQL_SELFTEST $THEN callback_1; $END
   --===============--%WTPLSQL_end_ignore_lines%--=================--

exception
   when OTHERS
   then
      g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace ||
                                              CHR(10) || g_test_runs_rec.error_message
                                             ,1,4000);
      begin
         insert_test_run;
         exception when DUP_VAL_ON_INDEX then null;
      end;
      wt_profiler.finalize;
      wt_result.finalize;
      COMMIT;
      --===============--%WTPLSQL_begin_ignore_lines%--===============--
      $IF $$WTPLSQL_SELFTEST $THEN callback_2; $END
      --===============--%WTPLSQL_end_ignore_lines%--=================--

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

------------------------------------------------------------
procedure clear_tables
is
begin
   wt_result.clear_tables;
   wt_profiler.clear_tables;
   delete from wt_test_runs;
   COMMIT;
end clear_tables;



--===============--%WTPLSQL_begin_ignore_lines%--===============--
--  Embedded Test Procedures

$IF $$WTPLSQL_SELFTEST
$THEN

  -- Profiler Annotation: --% WTPLSQL SET DBOUT "WTPLSQL" %-- Extra Stuff

----------------------------------------
procedure testcase_0
is
   save_test_runs_rec   wt_test_runs%ROWTYPE := g_test_runs_rec;
begin
   wt_assert.g_testcase := 'TESTCASE_0';
   -- This Test Case runs in the EXECUTE IMMEDAITE in the TEST_RUN
   --   procedure in this package.
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.id NOT NULL'
                       ,check_this_in => g_test_runs_rec.id);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.start_dtm NOT NULL'
                       ,check_this_in => g_test_runs_rec.start_dtm);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.runner_name NOT NULL'
                       ,check_this_in => g_test_runs_rec.runner_name);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.runner_owner NOT NULL'
                       ,check_this_in => g_test_runs_rec.runner_owner);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.dbout_owner IS NOTNULL'
                       ,check_this_in => g_test_runs_rec.dbout_owner);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.dbout_name IS NOT NULL'
                       ,check_this_in => g_test_runs_rec.dbout_name);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.dbout_type IS NOT NULL'
                       ,check_this_in => g_test_runs_rec.dbout_type);
   wt_assert.isnotnull (msg_in        =>  'g_test_runs_rec.profiler_runid IS NOT NULL'
                       ,check_this_in => g_test_runs_rec.profiler_runid);
   wt_assert.isnull (msg_in        =>  'g_test_runs_rec.end_dtm IS NULL'
                    ,check_this_in => g_test_runs_rec.end_dtm);
   wt_assert.isnull (msg_in        =>  'g_test_runs_rec.error_message IS NULL'
                    ,check_this_in => g_test_runs_rec.error_message);
   wt_assert.eqqueryvalue
         (msg_in             => 'TEST_RUNS Record Not Exists'
         ,check_query_in     => 'select count(*) from WT_TEST_RUNS' ||
                                ' where id = ''' || g_test_runs_rec.id || ''''
         ,against_value_in   => 0);
end testcase_0;


----------------------------------------
procedure testcase_1
is
begin
   -- Note: This procedure runs in an exception handler.  The
   --   ERROR_STACK will have data in it.
   wt_assert.g_testcase := 'TESTCASE_1';
   -- This Test Case runs at the last step of the TEST_RUNS
   --   procedure in this package.
end testcase_1;

----------------------------------------
procedure testcase_2
is
begin
   -- Note: This procedure runs in an exception handler.  The
   --   ERROR_STACK will have data in it.
   -- Note2: "wt_result.finalize" has run, so "wt_assert"s
   --   go to DBMS_OUTPUT.
   wt_assert.g_testcase := 'TESTCASE_2';
   -- This Test Case runs at the last step of the TEST_RUNS
   --   procedure exception handler in this package.
   --g_test_runs_rec.runner_name := 'BOGUS';
   --wt_assert.raises (msg_in         => 'Check_Runner Procedure raises exception'
   --                 ,check_call_in  => 'check_runner'
   --                 ,against_exc_in => 'ORA-00000');
   --g_test_runs_rec.runner_name := save_test_runs_rec.runner_name;
end testcase_2;

----------------------------------------
--  Called from Internal Test Point
procedure callback_1
is
begin
   -- Note: This procedure runs in an exception handler.  The
   --   ERROR_STACK will have data in it.
   if NOT g_running_selftest
   then
      return;
   end if;
   testcase_2;
   -- This will cause callback_2 to be called
   raise_application_error(-20000,'WTPLSQL Callback_1 Exception Raised');
end callback_1;

----------------------------------------
--  Called from Internal Test Point
procedure callback_2
is
   err_txt  varchar2(32000);
begin
   err_txt := dbms_utility.format_error_stack     ||
              dbms_utility.format_error_backtrace;
   -- Note: This procedure runs in an exception handler.  The
   --   ERROR_STACK will have data in it.
   if NOT g_running_selftest
   then
      return;
   end if;
   testcase_2;
   -- This procedure MUST set g_running_selftest to FALSE
   g_running_selftest := FALSE;
exception
   when others then
      -- This procedure MUST set g_running_selftest to FALSE
      g_running_selftest := FALSE;
      raise_application_error(-20000, substr(dbms_utility.format_error_stack     ||
                                             dbms_utility.format_error_backtrace ||
                                             CHR(10) || err_txt, 1, 4000) );
end callback_2;

----------------------------------------
procedure WTPLSQL_RUN
is
begin
   -- This runs like a self-contained "in-circuit" test.
   --   Internal test points are activated by the
   --   g_running_selftest variable.  This grants access
   --   to specific locations within this package.
   g_running_selftest := TRUE;
   testcase_0;
   -- Callback_1 will be called at the end of TestCase_0.
   -- Callback_2 will be called at the end of the RUN_TEST
   --   procedure, after this procedure has completed.
   -- Callback_2 must set g_running_selftest to FALSE;
end;

$END

end wtplsql;
