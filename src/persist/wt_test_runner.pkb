create or replace package body wt_test_runner
   authid definer
as


$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   C_OWNER    CONSTANT varchar2(50) := 'WT_TEST_RUNNER_OWNER_FOR_TESTING_1234ABCD';
   C_NAME     CONSTANT varchar2(50) := 'WT_TEST_RUNNER_NAME_FOR_TESTING_1234ABCD';
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_id
      (in_owner  in varchar2
      ,in_name   in varchar2)
   return number
is
   l_id  number;
begin
   select id into l_id
    from  wt_test_runners
    where owner = in_owner
     and  name  = in_name;
   return l_id;
exception when NO_DATA_FOUND then
   return NULL;
end get_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_get_id
   is
      l_id           number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Setup';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.isnotnull
         (msg_in           => 'Number of Rows deleted'  
         ,check_query_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_test_runners' || 
                              ' where owner = ' || C_OWNER ||
                              ' and name  = ' || C_NAME
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 1';
      wt_assert.isnull
         (msg_in            => 'Check for Null return'
         ,check_this_in     => get_id(C_OWNER, C_NAME));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 2';
      insert into wt_test_runners (id, owner, name)
         values (wt_test_runners_seq.nextval, C_OWNER, C_NAME)
         returning id into l_id;
      wt_assert.eq
         (msg_in           => 'Check ID return'
         ,check_this_in    => get_id(C_OWNER, C_NAME)
         ,against_this_in  => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Teardown';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.eq
         (msg_in           => 'Number of Rows deleted'
         ,check_query_in   => SQL%ROWCOUNT
         ,against_this_in  => 1);
      commit;
   end t_get_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
function dim_id
      (in_owner  in varchar2
      ,in_name   in varchar2)
   return number
is
   pragma AUTONOMOUS_TRANSACTION;
   rec  wt_test_runners%ROWTYPE;
begin
   rec.id := get_id (in_owner, in_name);
   if rec.id is null
   then
      rec.id    := wt_test_runners_seq.nextval;
      rec.owner := in_owner;
      rec.name  := in_name;
      insert into wt_dbouts values rec;
   end if;
   return rec.id;
end dim_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_dim_id
   is
      l_id           number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Setup';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.isnotnull
         (msg_in           => 'Number of Rows deleted'  
         ,check_query_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_test_runners' || 
                              ' where owner = ' || C_OWNER ||
                              ' and name  = ' || C_NAME
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 1';
      l_id := dim_id(C_OWNER, C_NAME);
      wt_assert.isnotnull
         (msg_in            => 'Check ID return 1'
         ,check_this_in     => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 2';
      wt_assert.eq
         (msg_in            => 'Check ID return 2'
         ,check_this_in     => dim_id(C_OWNER, C_NAME)
         ,against_this_in   => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Teardown';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.eq
         (msg_in           => 'Number of Rows deleted'  
         ,check_query_in   => SQL%ROWCOUNT
         ,against_this_in  => 1);
      commit;
   end t_dim_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_records
      (in_test_runner_id  in number)
is
begin
   delete from wt_test_runners
    where id = in_test_runner_id;
end delete_records;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_records
   is
      l_id   number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Setup';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.isnotnull
         (msg_in           => 'Number of Rows deleted'  
         ,check_query_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_test_runners (id, owner, name)
         values (wt_test_runners_seq.nextval, C_OWNER, C_NAME)
         returning id into l_id;
      wt_assert.isnotnull
         (msg_in           => 'Check for ID'
         ,check_this_in    => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 1'
         ,check_query_in   => 'select count(*) from wt_test_runners' || 
                              ' where owner = ' || C_OWNER ||
                              ' and name  = ' || C_NAME
         ,against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Happy Path 1';
      delete_records(l_id);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_test_runners' || 
                              ' where owner = ' || C_OWNER ||
                              ' and name  = ' || C_NAME
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Happy Path 2';
      delete_records(l_id);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should still be 0'
         ,check_query_in   => 'select count(*) from wt_test_runners' || 
                              ' where owner = ' || C_OWNER ||
                              ' and name  = ' || C_NAME
         ,against_value_in => 0);
      commit;
   end t_dim_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN  --% WTPLSQL SET DBOUT "WT_TEST_RUNNER:PACKAGE BODY" %--
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_get_id;
      t_dim_id;
      t_delete_records;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_runner;
