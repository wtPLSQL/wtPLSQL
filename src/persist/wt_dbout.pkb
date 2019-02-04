create or replace package body wt_dbout
as

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   C_OWNER    CONSTANT varchar2(50) := 'WT_DBOUT_OWNER_FOR_TESTING_1234ABCD';
   C_NAME     CONSTANT varchar2(50) := 'WT_DBOUT_NAME_FOR_TESTING_1234ABCD';
   C_TYPE     CONSTANT varchar2(50) := 'DBOUT_TYPE_1234ABCD';
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
   select id into l_id from wt_dbouts
    where owner = in_owner
     and  name  = in_name
     and  type  = in_type;
   return l_id;
exception
   when NO_DATA_FOUND
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
      delete from wt_dbouts
       where owner = C_OWNER
        and  name  = C_NAME
        and  type  = C_TYPE;
      wt_assert.isnotnull
         (msg_in          => 'Number of Rows deleted'  
         ,check_this_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_dbouts' || 
                              ' where owner = ''' || C_OWNER ||
                              ''' and name  = ''' || C_NAME  ||
                              ''' and type  = ''' || C_TYPE  || ''''
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 1';
      wt_assert.isnull
         (msg_in            => 'Check for Null return'
         ,check_this_in     => get_id(C_OWNER, C_NAME, C_TYPE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Happy Path 2';
      insert into wt_dbouts (id, owner, name, type)
         values (wt_dbouts_seq.nextval, C_OWNER, C_NAME, C_TYPE)
         returning id into l_id;
      wt_assert.eq
         (msg_in           => 'Check ID return'
         ,check_this_in    => get_id(C_OWNER, C_NAME, C_TYPE)
         ,against_this_in  => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_get_id Teardown';
      delete from wt_dbouts
       where owner = C_OWNER
        and  name  = C_NAME
        and  type  = C_TYPE;
      wt_assert.eq
         (msg_in           => 'Number of Rows deleted'
         ,check_this_in    => SQL%ROWCOUNT
         ,against_this_in  => 1);
      commit;
   end t_get_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
function dim_id
      (in_owner  in varchar2
      ,in_name   in varchar2
      ,in_type   in varchar2)
   return number
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   rec  wt_dbouts%ROWTYPE;
begin
   if    in_owner is NULL
      OR in_name  is NULL
      OR in_type  is NULL
   then
      return null;
   end if;
   rec.id := get_id (in_owner, in_name, in_type);
   if rec.id is null
   then
      rec.id    := wt_dbouts_seq.nextval;
      rec.owner := in_owner;
      rec.name  := in_name;
      rec.type  := in_type;
      insert into wt_dbouts values rec;
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
      delete from wt_dbouts
       where owner = C_OWNER
        and  name  = C_NAME
        and  type  = C_TYPE;
      wt_assert.isnotnull
         (msg_in          => 'Number of Rows deleted'  
         ,check_this_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_dbouts' || 
                              ' where owner = ''' || C_OWNER ||
                              ''' and name  = ''' || C_NAME  ||
                              ''' and type  = ''' || C_TYPE  || ''''
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 1';
      l_id := dim_id(C_OWNER, C_NAME, C_TYPE);
      wt_assert.isnotnull
         (msg_in            => 'Check ID return 1'
         ,check_this_in     => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Happy Path 2';
      wt_assert.eq
         (msg_in            => 'Check ID return 2'
         ,check_this_in     => dim_id(C_OWNER, C_NAME, C_TYPE)
         ,against_this_in   => l_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Sad Path 1';
      wt_assert.isnull
         (msg_in            => 'Check NULL return'
         ,check_this_in     => dim_id(NULL, NULL, NULL));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_dim_id Teardown';
      delete from wt_dbouts
       where owner = C_OWNER
        and  name  = C_NAME
        and  type  = C_TYPE;
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
   delete from wt_dbouts
    where id in (
          select id
           from  wt_dbouts
          MINUS
          select dbout_id ID
           from  wt_test_runs
           group by dbout_id);
end delete_records;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_records
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Setup';
      delete from wt_dbouts
       where owner = C_OWNER
        and  name  = C_NAME
        and  type  = C_TYPE;
      wt_assert.isnotnull
         (msg_in          => 'Number of Rows deleted'  
         ,check_this_in   => SQL%ROWCOUNT);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_dbouts (id, owner, name, type)
         values (wt_dbouts_seq.nextval, C_OWNER, C_NAME, C_TYPE);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 1'
         ,check_query_in   => 'select count(*) from wt_dbouts' || 
                              ' where owner = ''' || C_OWNER ||
                              ''' and name  = ''' || C_NAME  ||
                              ''' and type  = ''' || C_TYPE  || ''''
         ,against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Happy Path 1';
      delete_records;
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should be 0'
         ,check_query_in   => 'select count(*) from wt_dbouts' || 
                              ' where owner = ''' || C_OWNER ||
                              ''' and name  = ''' || C_NAME  ||
                              ''' and type  = ''' || C_TYPE  || ''''
         ,against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_delete_records Happy Path 2';
      delete_records;
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of Rows should still be 0'
         ,check_query_in   => 'select count(*) from wt_dbouts' || 
                              ' where owner = ''' || C_OWNER ||
                              ''' and name  = ''' || C_NAME  ||
                              ''' and type  = ''' || C_TYPE  || ''''
         ,against_value_in => 0);
      commit;
   end t_delete_records;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wtplsql.g_DBOUT := 'WT_DBOUT:PACKAGE BODY';
      t_get_id;
      t_dim_id;
      t_delete_records;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_dbout;
