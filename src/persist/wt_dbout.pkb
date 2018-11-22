create or replace package body wt_dbout
   authid definer
as


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_id
      (in_owner  in varchar2
      ,in_name   in varchar2
      ,in_type   in varchar2)
   return number
is
   l_id  number;
begin
   select id into rec.id from wt_testcases
    where owner = in_owner
     and  name  = in_name
     and  type  = in_type;
   return l_id;
exception
   when NO_DATA_FOUND
   then
      return l_id;
end get_id;

------------------------------------------------------------
function dim_id
      (in_owner  in varchar2
      ,in_name   in varchar2
      ,in_type   in varchar2)
   return number
is
   rec  wt_dbouts%ROWTYPE;
begin
   rec.id := get_id (in_owner, in_name, in_type);
   if rec.id is null
   then
      rec.id    := wt_dbouts_seq.nextval;
      rec.owner := in_owner;
      rec.name  := in_name;
      rec.type  := in_type;
      insert into wt_dbouts values rec;
   end if;
   return rec.id;
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
procedure delete_records
is
begin
   with q1 as (
   select id
    from  wt_dbouts
   MINUS
   select dbout_id ID
    from  wt_test_runs
    group by dbout_id
   )
   delete from wt_dbouts
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


end wt_dbout;
