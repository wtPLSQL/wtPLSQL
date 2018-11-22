create or replace package body wtplsql
as

   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      TYPE test_all_aa_type is table of varchar2(400) index by varchar2(400);
      test_all_aa       test_all_aa_type;
      wtplsql_skip_test boolean := FALSE;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------


----------------------
--  Private Procedures
----------------------


------------------------------------------------------------
-- This procedure is separated for internal WTPLSQL testing
procedure check_runner
is
   l_package_check        number;
begin
   -- These RAISEs can be captured because the Test Runs Record is set.
   --  Check for NULL Runner Name
   if core_data.g_run_rec.runner_name is null
   then
      raise_application_error (-20001, 'RUNNER_NAME is null');
   end if;
   --  Check for Valid Runner Name
   select count(*) into l_package_check
    from  user_procedures
    where procedure_name = C_RUNNER_ENTRY_POINT
     and  object_name    = core_data.g_run_rec.runner_name
     and  object_type    = 'PACKAGE';
   if l_package_check != 1
   then
      raise_application_error (-20002, 'RUNNER_NAME Procedure "' ||
                                     core_data.g_run_rec.runner_name ||
                                     '.' || C_RUNNER_ENTRY_POINT ||
                                                '" is not valid' );
   end if;
end check_runner;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_check_runner
   is
      l_save_test_run_rec   core_data.run_rec_type;
      l_msg_in   varchar2(4000);
      l_err_in   varchar2(4000);
      --------------------------------------  WTPLSQL Testing --
      procedure l_test_sqlerrm is begin
         -- Restore the core_data.g_run_rec
         core_data.g_run_rec := l_save_test_run_rec;
         wt_assert.eq
                  (msg_in          => l_msg_in
                  ,check_this_in   => SQLERRM
                  ,against_this_in => l_err_in);
      end l_test_sqlerrm;
   begin
      -- Save CORE_DATA data
      l_save_test_run_rec := core_data.g_run_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'CHECK_RUNNER Happy Path 1';
      wt_assert.eq
               (msg_in          => 'Confirm RUNNER_OWNER'
               ,check_this_in   => core_data.g_run_rec.runner_owner
               ,against_this_in => USER);
      core_data.g_run_rec.runner_name := 'WTPLSQL';
      l_msg_in := 'Valid RUNNER_NAME';
      l_err_in := 'ORA-0000: normal, successful completion';
      begin
         check_runner;
         l_test_sqlerrm;
      exception when others then
         l_test_sqlerrm;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'CHECK_RUNNER Sad Path 1';
      core_data.g_run_rec.runner_name := '';
      l_msg_in := 'Null RUNNER_NAME';
      l_err_in := 'ORA-20001: RUNNER_NAME is null';
      begin
         check_runner;
         l_test_sqlerrm;
      exception when others then
         -- This test is expected to throw an error
         l_test_sqlerrm;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'CHECK_RUNNER Sad Path 2';
      core_data.g_run_rec.runner_name := 'BOGUS';
      l_msg_in := 'Invalid RUNNER_NAME';
      l_err_in := 'ORA-20002: RUNNER_NAME Procedure "BOGUS.' ||
                  C_RUNNER_ENTRY_POINT || '" is not valid';
      begin
         check_runner;
         l_test_sqlerrm;
      exception when others then
         l_test_sqlerrm;
      end;
   end t_check_runner;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure find_dbout
is
   --
   -- https://docs.oracle.com/cd/E11882_01/server.112/e41084/sql_elements008.htm#SQLRF51129
   -- Within a namespace, no two objects can have the same name.  The following
   --   schema objects share one namespace:
   --  -) Packages
   --  -) Private synonyms
   --  -) Sequences
   --  -) Stand-alone procedures
   --  -) Stand-alone stored functions
   --  -) User-defined operators
   --  -) User-defined types
   --  -) Tables
   --  -) Views
   -- Each of the following schema objects has its own namespace:
   --  -) Clusters
   --  -) Constraints
   --  -) Database triggers
   --  -) Dimensions
   --  -) Indexes
   --  -) Materialized views (When you create a materialized view, the database
   --     creates an internal table of the same name. This table has the same
   --     namespace as the other tables in the schema. Therefore, a schema
   --     cannot contain a table and a materialized view of the same name.)
   --  -) Private database links
   -- Because tables and sequences are in the same namespace, a table and a
   --   sequence in the same schema cannot have the same name. However, tables
   --   and indexes are in different namespaces. Therefore, a table and an index
   --   in the same schema can have the same name.
   -- Each schema in the database has its own namespaces for the objects it
   --   contains. This means, for example, that two tables in different schemas
   --   are in different namespaces and can have the same name.
   -- Results are unknown if a Database Object Under Test has the same name in
   --   different namespaces.
   --
   l_dot_pos   number;
   l_cln_pos   number;
begin
   if g_DBOUT is null
   then
      return;
   end if;
   l_dot_pos := instr(g_DBOUT,'.');
   l_cln_pos := instr(g_DBOUT,':');
   begin
      with q_main as (
      select obj.owner
            ,obj.object_name
            ,obj.object_type
       from  dba_objects  obj
       where obj.owner = core_data.g_run_rec.runner_owner
        and  (   ( -- No separators were given, assume USER is the owner.
                   -- No object type was given. This could throw TOO_MANY_ROWS.
                      l_dot_pos       = 0
                  and l_cln_pos       = 0
                  and obj.object_name = g_DBOUT  )
              OR ( -- No object owner was given, assume USER is the owner.
                      l_dot_pos       = 0
                  and l_cln_pos      != 0
                  and obj.object_name = substr(g_DBOUT, 1, l_cln_pos-1)
                  and obj.object_type = substr(g_DBOUT, l_cln_pos+1, 512) ) )
      UNION ALL
      select obj.owner
            ,obj.object_name
            ,obj.object_type
       from  dba_objects  obj
       where ( -- No object type was given. This could throw TOO_MANY_ROWS.
                  l_dot_pos      != 0
              and l_cln_pos       = 0
              and obj.owner       = substr(g_DBOUT, 1, l_dot_pos-1)
              and obj.object_name = substr(g_DBOUT, l_dot_pos+1, 512) )
         OR  ( -- All separators were given
                  l_dot_pos      != 0
              and l_cln_pos      != 0
              and obj.owner       = substr(g_DBOUT, 1, l_dot_pos-1)
              and obj.object_name = substr(g_DBOUT, l_dot_pos+1, l_cln_pos-l_dot_pos-1)
              and obj.object_type = substr(g_DBOUT, l_cln_pos+1, 512) )
      )
      select owner
            ,object_name
            ,object_type
       into  core_data.g_run_rec.dbout_owner
            ,core_data.g_run_rec.dbout_name
            ,core_data.g_run_rec.dbout_type
       from  q_main;
   exception
      when NO_DATA_FOUND
      then
         core_data.run_error('Unable to find database object "' ||
                                               g_DBOUT  || '".' );
         return;
      when TOO_MANY_ROWS
      then
         -- The SELECT INTO will load some values into these variables
         --   when TOO_MANY_ROWS are selected.
         core_data.g_run_rec.dbout_owner   := '';
         core_data.g_run_rec.dbout_name    := '';
         core_data.g_run_rec.dbout_type    := '';
         core_data.run_error('Found too many database objects "' ||
                                                 g_DBOUT || '".' );
         return;
   end;
   --
end find_dbout;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_find_dbout
   is
      l_save_test_run_rec   core_data.run_rec_type;
      procedure clear_run_rec is begin
         core_data.g_run_rec.dbout_owner   := '';
         core_data.g_run_rec.dbout_name    := '';
         core_data.g_run_rec.dbout_type    := '';
         core_data.g_run_rec.error_message := '';
      end clear_run_rec;
   begin
      -- Save CORE_DATA data
      l_save_test_run_rec := core_data.g_run_rec;
      --------------------------------------  WTPLSQL Testing --
      -- These tests assume this package does not set a DBOUT
      wt_assert.g_testcase := 'Find DBOUT Happy Path 1';
      clear_run_rec;
      g_DBOUT := '';
      find_dbout;
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 2';
      clear_run_rec;
      g_DBOUT := 'SYS.DUAL';
      find_dbout;
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner,
         against_this_in =>  'SYS');
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name,
         against_this_in =>  'DUAL');
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type,
         against_this_in =>  'TABLE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 3';
      clear_run_rec;
      g_DBOUT := 'WTPLSQL:PACKAGE BODY';
      find_dbout;
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner,
         against_this_in =>  USER);
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name,
         against_this_in =>  'WTPLSQL');
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type,
         against_this_in =>  'PACKAGE BODY');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 4';
      clear_run_rec;
      g_DBOUT := 'WT_EXECUTE_TEST_RUNNER';
      find_dbout;
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner,
         against_this_in =>  USER);
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name,
         against_this_in =>  'WT_EXECUTE_TEST_RUNNER');
      wt_assert.eq(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type,
         against_this_in =>  'PROCEDURE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 1';
      clear_run_rec;
      g_DBOUT := 'someone.bogus:thingy';
      find_dbout;
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type);
      wt_assert.isnotnull(
         msg_in          => 'core_data.g_run_rec.error_message',
         check_this_in   =>  core_data.g_run_rec.error_message);
      wt_assert.eqqueryvalue (
         msg_in           => 'core_data.g_run_rec.error_message',
         check_query_in   => 'select 1 from dual where ''' ||
                              core_data.g_run_rec.error_message ||
                              ''' like ''%Unable to find database object "' ||
                              g_DBOUT || '".%''',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 2';
      clear_run_rec;
      g_DBOUT := 'WTPLSQL';
      find_dbout;
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_owner',
         check_this_in   =>  core_data.g_run_rec.dbout_owner);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_name',
         check_this_in   =>  core_data.g_run_rec.dbout_name);
      wt_assert.isnull(
         msg_in          => 'core_data.g_run_rec.dbout_type',
         check_this_in   =>  core_data.g_run_rec.dbout_type);
      wt_assert.eqqueryvalue (
         msg_in           => 'core_data.g_run_rec.error_message',
         check_query_in   => 'select 1 from dual where ''' ||
                              core_data.g_run_rec.error_message ||
                              ''' like ''%Found too many database objects "' ||
                              g_DBOUT || '".%''',
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      -- Restore CORE_DATA data
      core_data.g_run_rec := l_save_test_run_rec;
      -- Reset package data
      g_DBOUT := '';
   end t_find_dbout;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function get_runner_entry_point
   return varchar2
is
begin
   return C_RUNNER_ENTRY_POINT;
end get_runner_entry_point;

------------------------------------------------------------
function show_version
   return varchar2
is
   ret_str  wt_version.text%TYPE;
begin
   select max(t1.text) into ret_str
    from  wt_version  t1
    where t1.install_dtm = (select max(t2.install_dtm)
                             from  wt_version  t2);
   return ret_str;
exception when NO_DATA_FOUND
then
   return '';
end show_version;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_show_version
   is
      existing_version   wt_version.text%TYPE;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Show Version Happy Path';
      existing_version := show_version;
      wt_assert.isnotnull (
         msg_in        => 'Test Existing Version',
         check_this_in => existing_version);
      --------------------------------------  WTPLSQL Testing --
      insert into wt_version (install_dtm, action, text)
         values (to_date('31-DEC-4000','DD-MON-YYYY'), 'TESTING', 'TESTING');
      wt_assert.eq (
         msg_in          => 'Test New Version',
         check_this_in   => show_version,
         against_this_in => 'TESTING');
      --------------------------------------  WTPLSQL Testing --
      rollback;
      wt_assert.eq (
         msg_in          => 'Return to Existing Version',
         check_this_in   => show_version,
         against_this_in => existing_version);
   end t_show_version;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
   pragma AUTONOMOUS_TRANSACTION;  -- Required if called as Remote Procedure Call (RPC)
   l_error_stack          varchar2(32000);
   procedure concat_err_message
         (in_err_msg  in varchar2)
   is
   begin
      if core_data.g_run_rec.error_message is not null
      then
         core_data.g_run_rec.error_message := substr(in_err_msg || CHR(10)||
                                                 core_data.g_run_rec.error_message
                                                ,1,4000);
      else
         core_data.g_run_rec.error_message := in_err_msg;
      end if;
   end concat_err_message;
begin
   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      -- This will avoid running the TEST_RUN procedure for some self-tests
      if wtplsql_skip_test
      then
         test_all_aa(in_package_name) := 'X';
         return;
      end if;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
   -- Start a new Transaction
   COMMIT;
   -- Initialize
   core_data.init1(in_package_name);
   g_DBOUT := '';
   wt_assert.reset_globals;
   -- Reset the Test Runs Record before checking anything
   check_runner;
   hook.before_test_run;
   core_data.init2;
   -- Call the Test Runner
   begin
      hook.execute_test_runner;
   exception
      when OTHERS
      then
         l_error_stack := dbms_utility.format_error_stack     ||
                          dbms_utility.format_error_backtrace ;
         concat_err_message(l_error_stack);
   end;
   -- Finalize
   rollback;    -- Discard any pending transactions.
   core_data.finalize;
   find_dbout;
   hook.after_test_run;
   -- Required if called as Remote Procedure Call (RPC)
   COMMIT;
end test_run;


--==============================================================--
-- No Unit Test for TEST_RUN.
--   Too complicated because testing occurs while the TEST_RUN
--   procedure is executing.  This also prevents 100% profiling.
--==============================================================--


------------------------------------------------------------
procedure test_all
is
   TYPE runners_nt_type is table of varchar2(128);
   l_runners_nt      runners_nt_type;
begin
   hook.before_test_all;
   select object_name
     bulk collect into l_runners_nt
    from  user_procedures  t1
    where procedure_name = C_RUNNER_ENTRY_POINT
     and  object_type    = 'PACKAGE'
    group by object_name
    order by object_name;
   for i in 1 .. l_runners_nt.COUNT
   loop
      test_run(l_runners_nt(i));
   end loop;
   hook.after_test_all;
end test_all;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_test_all
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'TEST_ALL Happy Path';
      test_all_aa.DELETE;
      wtplsql_skip_test := TRUE;
      -- TEST_ALL will populate the test_all_aa array
      wtplsql.test_all;
      wtplsql_skip_test := FALSE;
      -- This package should be in the test_all_aa array
      --------------------------------------  WTPLSQL Testing --
      wt_assert.this (
         msg_in        => 'test_all_aa.EXISTS(''WTPLSQL'')',
         check_this_in => test_all_aa.EXISTS('WTPLSQL'));
   end t_test_all;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      t_check_runner;
      t_find_dbout;
      t_show_version;
      t_test_all;
   end;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wtplsql;
