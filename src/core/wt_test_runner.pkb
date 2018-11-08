create or replace package body wt_test_runner
as



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
   l_id := wt_test_runners_seq.nextval;
   insert into wt_test_runners (id, owner, name)
      values (l_id, in_owner, in_name);
   commit;
   return l_id;
end get_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_get_id
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      null;
   end t_get_id;
   procedure t_insert_test_runner
   is
      C_OWNER    CONSTANT varchar2(50) := 'WT_TEST_RUNNER_OWNER_FOR_TESTING';
      C_NAME     CONSTANT varchar2(50) := 'WT_TEST_RUNNER_NAME_FOR_TESTING';
      l_id       number;
      num_recs   number;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'INSERT_TEST_RUNNER Happy Path 1';
      delete from wt_test_runners
       where owner = C_OWNER
        and  name  = C_NAME;
      wt_assert.eqqueryvalue
         (msg_in             => 'Number of Starting Records'
         ,check_query_in     => 'select count(name) from wt_test_runners' ||
                                ' where owner = ' || C_OWNER ||
                                ' and name = ' || C_NAME
         ,against_value_in   => 0);
   end t_insert_test_runner;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_id
      (in_id  in number)
is
begin
   delete from wt_test_runners
    where id = in_id;
end delete_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_id
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      null;
   end t_delete_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN  --% WTPLSQL SET DBOUT "WT_TEST_RUNNER:PACKAGE BODY" %--
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_get_id;
      t_delete_id;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_test_runner;
