create or replace package body hook
as


----------------------
--  Private Procedures
----------------------


------------------------------------------------------------
procedure run_hooks
      (in_hook_name  in varchar2)
is
begin
   for i in 1 .. run_aa(in_hook_name).COUNT
   loop
      execute immediate run_aa(in_hook_name)(i);
   end loop;
end run_hooks;


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure before_test_all
is
begin
   if before_test_all_active
   then
      run_hooks('before_test_all');
   end if;
end before_test_all;

------------------------------------------------------------
procedure before_test_run
is
begin
   if before_test_run_active
   then
      run_hooks('before_test_run');
   end if;
end before_test_run;

------------------------------------------------------------
procedure execute_test_runner
is
begin
   if execute_test_runner_active
   then
      run_hooks('execute_test_runner');
   end if;
end execute_test_runner;

------------------------------------------------------------
procedure after_assertion
is
begin
   --
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   if t_run_assert_hook
   then
$END  ------%WTPLSQL_end_ignore_lines%------
   --
   if after_assertion_active
   then
      run_hooks('after_assertion');
   end if;
   --
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   end if;
$END  ------%WTPLSQL_end_ignore_lines%------
   --
end after_assertion;

------------------------------------------------------------
procedure after_test_run
is
begin
   if after_test_run_active
   then
      run_hooks('after_test_run');
   end if;
end after_test_run;

------------------------------------------------------------
procedure after_test_all
is
begin
   if after_test_all_active
   then
      run_hooks('after_test_all');
   end if;
end after_test_all;

------------------------------------------------------------
procedure ad_hoc_report
is
begin
   if ad_hoc_report_active
   then
      run_hooks('ad_hoc_report');
   end if;
end ad_hoc_report;

------------------------------------------------------------
procedure init
is
begin
   before_test_all_active     := FALSE;
   before_test_run_active     := FALSE;
   execute_test_runner_active := FALSE;
   after_assertion_active     := FALSE;
   after_test_run_active      := FALSE;
   after_test_all_active      := FALSE;
   ad_hoc_report_active       := FALSE;
   for buff in (
      select hook_name
       from  hooks
       group by hook_name )
   loop
      select run_string bulk collect into run_nt
       from  hooks
       where hook_name = buff.hook_name
       order by hooks.seq;
      if SQL%FOUND
      then
         run_aa(buff.hook_name) := run_nt;
         case buff.hook_name
            when 'before_test_all'     then before_test_all_active     := TRUE;
            when 'before_test_run'     then before_test_run_active     := TRUE;
            when 'execute_test_runner' then execute_test_runner_active := TRUE;
            when 'after_assertion'     then after_assertion_active     := TRUE;
            when 'after_test_run'      then after_test_run_active      := TRUE;
            when 'after_test_all'      then after_test_all_active      := TRUE;
            when 'ad_hoc_report'       then ad_hoc_report_active       := TRUE;
            else raise_application_error(-20012, 'Unknown HOOK_NAME Case' || buff.hook_name);
          end case;
      end if;
   end loop;
end init;


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN

   procedure test_hook
      (in_msg  in  varchar2)
   is
   begin
      t_test_hook_msg := in_msg;
   end test_hook;

   procedure test_setup
   is
   begin
      --
      t_hooks_nt := hooks_nt_type('before_test_all'     
                                 ,'before_test_run'     
                                 ,'execute_test_runner' 
                                 ,'after_assertion'     
                                 ,'after_test_run'      
                                 ,'after_test_all'      
                                 ,'ad_hoc_report');
      --
      select * bulk collect into t_save_nt from hooks;
      delete from hooks;
      --
      t_hooks_rec.seq         := 1;
      t_hooks_rec.description := 'WTPSQL Self Test';
      for i in 1 .. t_hooks_nt.COUNT
      loop
         t_hooks_rec.hook_name  := t_hooks_nt(i);
         t_hooks_rec.run_string := 'begin hook.test_hook(''' ||
                                    t_hooks_nt(i) || '''); end;';
         insert into hooks values t_hooks_rec;
      end loop;
      --
      commit;
      t_run_assert_hook := FALSE;
      init;
      --
   end test_setup;

   procedure test_teardown
   is
   begin
      delete from hooks;
      forall i in 1 .. t_save_nt.COUNT
         insert into hooks values t_save_nt(i);
      commit;
      init;
      t_run_assert_hook := TRUE;
   end test_teardown;

   procedure WTPLSQL_RUN
   is
      num_recs  number;
   begin
      wtplsql.g_DBOUT := 'HOOK:PACKAGE BODY';
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Setup';
      select count(*) into num_recs from hooks;
      wt_assert.isnotnull
         (msg_in           => 'Number of records before setup'
         ,check_this_in    => num_recs);
      test_setup;
      wt_assert.eqqueryvalue
         (msg_in           => 'Confirm number of test records'
         ,check_query_in   => 'select count(*) from hooks'
         ,against_value_in => t_hooks_nt.COUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'All Hooks On';
      t_test_hook_msg := '';
      for i in 1 .. t_hooks_nt.COUNT
      loop
         hook.t_run_assert_hook := TRUE;
         execute immediate 'begin hook.' || t_hooks_nt(i) || '; end;';
         hook.t_run_assert_hook := FALSE;
         wt_assert.eq
            (msg_in          => t_hooks_nt(i) || ' is active'
            ,check_this_in   => t_test_hook_msg
            ,against_this_in => t_hooks_nt(i));
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'All Hooks Off';
      delete from hooks;
      commit;
      init;
      wt_assert.eqqueryvalue
         (msg_in           => 'Confirm number of test records 2'
         ,check_query_in   => 'select count(*) from hooks'
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      t_test_hook_msg := '';
      for i in 1 .. t_hooks_nt.COUNT
      loop
         execute immediate 'begin hook.' || t_hooks_nt(i) || '; end;';
         wt_assert.isnull
            (msg_in          => t_hooks_nt(i) || ' is not active'
            ,check_this_in   => t_test_hook_msg);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      test_teardown;
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of records after teardown'
         ,check_query_in   => 'select count(*) from hooks'
         ,against_value_in => num_recs);
      hook.t_run_assert_hook := TRUE;
   end;

$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


------------------------------------------------------------
begin
   init;
end hook;
