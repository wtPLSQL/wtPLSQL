create or replace package body wt_testcase
   authid definer
as


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_id
      (in_name   in varchar2)
   return number
is
   l_id  number;
begin
   select id into rec.id from wt_testcases
    where name = in_name;
   return rec.id;
exception
   when NO_DATA_FOUND
   then
      return null;
end get_id;


------------------------------------------------------------
function dim_id
      (in_name   in varchar2)
   return number
is
   rec  wt_testcases%ROWTYPE;
begin
   rec.id := get_id (in_name);
   if rec.id is null
   then
      rec.id   := wt_testcases_seq.nextval;
      rec.name := in_name;
      insert into wt_testcases values rec;
   end if;
   return rec.id;
end dim_id;


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
procedure delete_records
      (in_test_runner_id  in number)
is
begin
   with q1 as (
   select id
    from  wt_testcases
   MINUS
   select testcase_id ID
    from  wt_results
    group by testcase_id
   )
   delete from wt_testcases
    where id in (select id from q1);
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
