create or replace package body hook
as

   TYPE run_nt_type is table
      of hooks%ROWTYPE;
   TYPE run_aa_type is table
      of run_nt_type
      index by varchar2(20);
   g_run_aa  run_aa_type;

----------------------
--  Private Procedures
----------------------


------------------------------------------------------------
procedure run_hooks
      (in_hook_name  in varchar2)
is
   l_error_stack          varchar2(32000);
begin
   for i in 1 .. g_run_aa(in_hook_name).COUNT
   loop
      begin
         execute immediate g_run_aa(in_hook_name)(i).run_string;
      exception
         when OTHERS
         then
            l_error_stack := 'Hook Error in "' || in_hook_name ||
                              '", SEQ ' || g_run_aa(in_hook_name)(i).seq ||
                                    '.' || CHR(10) ||
                              dbms_utility.format_error_stack ||
                              dbms_utility.format_error_backtrace;
            core_data.run_error(l_error_stack);
            wt_assert.isnull
               (msg_in        => 'Un-handled Exception in ' ||
                                  in_hook_name || ' Hook'
               ,check_this_in => l_error_stack);
      end;
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
   if g_run_assert_hook
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
   l_run_nt  run_nt_type;
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
      select * bulk collect into l_run_nt
       from  hooks
       where hook_name = buff.hook_name
       order by hooks.seq;
      if SQL%FOUND
      then
         g_run_aa(buff.hook_name) := l_run_nt;
         case buff.hook_name
            when 'before_test_all'     then before_test_all_active     := TRUE;
            when 'before_test_run'     then before_test_run_active     := TRUE;
            when 'execute_test_runner' then execute_test_runner_active := TRUE;
            when 'after_assertion'     then after_assertion_active     := TRUE;
            when 'after_test_run'      then after_test_run_active      := TRUE;
            when 'after_test_all'      then after_test_all_active      := TRUE;
            when 'ad_hoc_report'       then ad_hoc_report_active       := TRUE;
            else raise_application_error(-20003, 'Unknown HOOK_NAME Case' || buff.hook_name);
          end case;
      end if;
   end loop;
end init;


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   --------------------------------------  WTPLSQL Testing --
   procedure test_hook
      (in_msg  in  varchar2)
   is
   begin
      g_test_hook_msg := in_msg;
   end test_hook;
   --------------------------------------  WTPLSQL Testing --
   procedure WTPLSQL_RUN
   is
      TYPE  hooks_nt_type is table of hooks%ROWTYPE;
      l_hooks_ntSAVE  hooks_nt_type;
      TYPE hname_nt_type is table of hooks.hook_name%TYPE;
      l_hname_nt      hname_nt_type;
      l_hooks_rec     hooks%ROWTYPE;
      num_recs  number;
   begin
      wtplsql.g_DBOUT := 'HOOK:PACKAGE BODY';
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Setup';
      g_run_assert_hook := FALSE;
      select count(*) into num_recs from hooks;
      wt_assert.isnotnull
         (msg_in           => 'Number of records before setup'
         ,check_this_in    => num_recs);
      --------------------------------------  WTPLSQL Testing --
      l_hname_nt := hname_nt_type('before_test_all'     
                                 ,'before_test_run'     
                                 ,'execute_test_runner' 
                                 ,'after_assertion'     
                                 ,'after_test_run'      
                                 ,'after_test_all'      
                                 ,'ad_hoc_report');
      select * bulk collect into l_hooks_ntSAVE from hooks;
      delete from hooks;
      --------------------------------------  WTPLSQL Testing --
      l_hooks_rec.seq         := 1;
      l_hooks_rec.description := 'WTPSQL Self Test';
      for i in 1 .. l_hname_nt.COUNT
      loop
         l_hooks_rec.hook_name  := l_hname_nt(i);
         l_hooks_rec.run_string := 'begin hook.test_hook(''' ||
                                    l_hname_nt(i) || '''); end;';
         insert into hooks values l_hooks_rec;
      end loop;
      commit;
      --------------------------------------  WTPLSQL Testing --
      init;
      wt_assert.eqqueryvalue
         (msg_in           => 'Confirm number of test records'
         ,check_query_in   => 'select count(*) from hooks'
         ,against_value_in => l_hname_nt.COUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'All Hooks On';
      for i in 1 .. l_hname_nt.COUNT
      loop
         g_test_hook_msg := '';
         g_run_assert_hook := TRUE;
         execute immediate 'begin hook.' || l_hname_nt(i) || '; end;';
         g_run_assert_hook := FALSE;
         wt_assert.eq
            (msg_in          => l_hname_nt(i) || ' is active'
            ,check_this_in   => g_test_hook_msg
            ,against_this_in => l_hname_nt(i));
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
      for i in 1 .. l_hname_nt.COUNT
      loop
         g_test_hook_msg := '';
         execute immediate 'begin hook.' || l_hname_nt(i) || '; end;';
         wt_assert.isnull
            (msg_in          => l_hname_nt(i) || ' is not active'
            ,check_this_in   => g_test_hook_msg);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Teardown';
      delete from hooks;
      forall i in 1 .. l_hooks_ntSAVE.COUNT
         insert into hooks values l_hooks_ntSAVE(i);
      commit;
      init;
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of records after teardown'
         ,check_query_in   => 'select count(*) from hooks'
         ,against_value_in => num_recs);
      g_run_assert_hook := TRUE;
   end WTPLSQL_RUN;

$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


------------------------------------------------------------
begin
   init;
end hook;
