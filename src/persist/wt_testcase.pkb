create or replace package body wt_testcase
as


$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   C_TESTCASE  CONSTANT varchar2(50) := 'WT_TESTCASE_FOR_TESTING_1234ABCD';
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_id
      (in_testcase  in varchar2)
   return number
is
   l_id  number;
begin
   select id into l_id
    from  wt_testcases
    where name = in_testcase;
   return l_id;
exception when NO_DATA_FOUND
then
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
      delete from wt_testcases
       where testcase = C_TESTCASE;
      wt_assert.isnotnull
         (msg_in          => 'Number of Rows deleted'  
         ,check_this_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_testcases' || 
                              ' where testcase = ''' || C_TESTCASE || ''''
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 1';
      wt_assert.isnull
         (msg_in            => 'Check for Null return'
         ,check_this_in     => get_id(C_TESTCASE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 2';
      insert into wt_testcases (id, testcase)
         values (wt_test_runners_seq.nextval, C_TESTCASE)
         returning id into l_id;
      wt_assert.eq
         (msg_in           => 'Check ID return'
         ,check_this_in    => get_id(C_TESTCASE)
         ,against_this_in  => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Teardown';
      delete from wt_testcases
       where testcase = C_TESTCASE;
      wt_assert.eq
         (msg_in           => 'Number of Rows deleted'
         ,check_this_in    => SQL%ROWCOUNT
         ,against_this_in  => 1);
      commit;
   end t_get_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
function dim_id
      (in_testcase  in varchar2)
   return number
is
   pragma AUTONOMOUS_TRANSACTION;
   rec  wt_testcases%ROWTYPE;
begin
   rec.id := get_id (in_testcase);
   if rec.id is null
   then
      rec.id       := wt_testcases_seq.nextval;
      rec.testcase := in_testcase;
      insert into wt_testcases values rec;
   end if;
   commit;
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
      delete from wt_testcases
       where testcase = C_TESTCASE;
      wt_assert.isnotnull
         (msg_in          => 'Number of Rows deleted'  
         ,check_this_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_testcases' || 
                              ' where testcase = ''' || C_TESTCASE || ''''
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 1';
      l_id := dim_id(C_TESTCASE);
      wt_assert.isnotnull
         (msg_in            => 'Check ID return 1'
         ,check_this_in     => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 2';
      wt_assert.eq
         (msg_in            => 'Check ID return 2'
         ,check_this_in     => dim_id(C_TESTCASE)
         ,against_this_in   => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Teardown';
      delete from wt_testcases
       where owner = C_TESTCASE;
      wt_assert.eq
         (msg_in           => 'Number of Rows deleted'  
         ,check_this_in    => SQL%ROWCOUNT
         ,against_this_in  => 1);
      commit;
   end t_dim_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_records
is
begin
   delete from wt_testcases
    where id in (
          select id from wt_testcases
          MINUS
          select distinct testcase_id ID from wt_results
          MINUS
          select distinct testcase_id ID from wt_testcase_runs);
end delete_records;


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


end wt_testcase;
