create or replace package body wt_profile
as

   TYPE ignr_aa_type is table
      of varchar2(1)
      index by PLS_INTEGER;
   g_ignr_aa   ignr_aa_type;

   g_rec  wt_dbout_runs%ROWTYPE;

   $IF $$WTPLSQL_SELFTEST $THEN  ------%WTPLSQL_begin_ignore_lines%------
      g_current_user  varchar2(30);
      g_skip_insert   boolean := FALSE;
      g_skip_add      boolean := FALSE;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------

----------------------
--  Private Procedures
----------------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN

   procedure tl_compile_db_object
         (in_ptype   in varchar2
         ,in_pname   in varchar2
         ,in_source  in varchar2)
   is
      l_sql_txt  varchar2(4000);
      l_errtxt   varchar2(32000) := '';
   begin
      --------------------------------------  WTPLSQL Testing --
      -- Wrap in_source to complete the DDL statement
      l_sql_txt := 'create or replace ' || in_ptype || ' ' ||
                   in_pname || ' is' || CHR(10) ||
                   in_source || CHR(10) ||
                   'end ' || in_pname || ';';
      wt_assert.raises
         (msg_in         => 'Compile ' || in_ptype || ' ' || in_pname
         ,check_call_in  => l_sql_txt
         ,against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      for buff in (select * from user_errors
                    where attribute = 'ERROR'
                     and  name      = in_pname
                     and  type      = in_ptype
                    order by sequence)
      loop
         l_errtxt := l_errtxt || buff.line || ', ' ||
            buff.position || ': ' || buff.text || CHR(10);
      end loop;
      wt_assert.isnull
         (msg_in        => 'Compile ' || in_ptype || ' ' || in_pname ||
                            ' Error'
         ,check_this_in => l_errtxt);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.objexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => g_current_user,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end tl_compile_db_object;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_drop_db_object
      (in_pname  in  varchar2,
       in_ptype  in  varchar2)
   is
      l_sql_txt  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'drop ' || in_ptype || ' ' || in_pname;
      wt_assert.raises
         (msg_in         => 'drop ' || in_ptype || ' ' || in_pname
         ,check_call_in  => l_sql_txt
         ,against_exc_in => '');
      wt_assert.objnotexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => g_current_user,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end tl_drop_db_object;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_count_plsql_profiler_recs
         (in_test_run_id     in number
         ,in_expected_count  in number)
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_runs (' || in_test_run_id || ')'
         ,check_query_in   => 'select count(*) from plsql_profiler_runs' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_units (' || in_test_run_id || ')'
         ,check_query_in   => 'select count(*) from plsql_profiler_units' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_data (' || in_test_run_id || ')'
         ,check_query_in   => 'select count(*) from plsql_profiler_data' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
   end tl_count_plsql_profiler_recs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_insert_plsql_profiler_recs
         (in_test_run_id     in number)
   is
      l_sql_txt    varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'insert into plsql_profiler_runs (runid)' ||
                   ' values (' || in_test_run_id || ')';
      wt_assert.raises (
         msg_in         => 'insert plsql_profiler_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'insert into plsql_profiler_units (runid, unit_number, total_time)' ||
                   ' values (' || in_test_run_id || ', ' || in_test_run_id || ', 0)';
      wt_assert.raises (
         msg_in         => 'insert plsql_profiler_units (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'insert into plsql_profiler_data (runid, unit_number, line#)' ||
                   ' values (' || in_test_run_id || ', ' || in_test_run_id || ', 0)';
      wt_assert.raises (
         msg_in         => 'insert plsql_profiler_data (RUNID: ' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      commit;
   end tl_insert_plsql_profiler_recs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_delete_plsql_profiler_recs
         (in_test_run_id     in number)
   is
      l_sql_txt    varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from plsql_profiler_data' ||
                   ' where runid = ' || in_test_run_id;
      wt_assert.raises (
         msg_in         => 'delete plsql_profiler_data (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from plsql_profiler_units' ||
                   ' where runid = ' || in_test_run_id;
      wt_assert.raises (
         msg_in         => 'delete plsql_profiler_units (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from plsql_profiler_runs' ||
                   ' where runid = ' || in_test_run_id;
      wt_assert.raises (
         msg_in         => 'delete plsql_profiler_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      commit;
   end tl_delete_plsql_profiler_recs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_insert_test_runs
         (in_test_run_id  in NUMBER
         ,in_runner_name  in varchar2)
   is
      l_sql_txt    varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'insert into wt_test_runs' ||
                   ' (id, start_dtm, runner_owner, runner_name)' ||
                   ' values (' || in_test_run_id || ', sysdate, ''' ||
                                  g_current_user || ''', ''' ||
                                  in_runner_name || ''')';
      wt_assert.raises (
         msg_in         => 'Insert wt_test_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs (' || in_test_run_id || ') Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 1);
      commit;
   end tl_insert_test_runs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_delete_test_runs
         (in_test_run_id  in NUMBER)
   is
      l_sql_txt  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from wt_test_runs where id = ' || in_test_run_id;
      wt_assert.raises (
         msg_in         => 'Delete wt_test_runs (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs (' || in_test_run_id || ') Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 0);
      commit;
   end tl_delete_test_runs;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_insert_wt_profiles
         (in_rec  in wt_profiles%ROWTYPE)
   is
      l_sqlerrm  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into wt_profiles values in_rec;
         l_sqlerrm := SQLERRM;
         commit;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in        => 'Insert wt_profiles (' || in_rec.test_run_id ||
                                                   ',' || in_rec.line || ')',
         check_this_in => l_sqlerrm,
         against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles (' || in_rec.test_run_id || 
                                               ',' || in_rec.line || ') Count',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || in_rec.test_run_id ||
                             ' and line = ' || in_rec.line,
         against_value_in => 1);
   end tl_insert_wt_profiles;
--==============================================================--
      --------------------------------------  WTPLSQL Testing --
   procedure tl_delete_wt_profiles
         (in_test_run_id  in NUMBER)
   is
      l_sql_txt  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      l_sql_txt := 'delete from wt_profiles where test_run_id = ' ||
                    in_test_run_id;
      wt_assert.raises (
         msg_in         => 'Delete wt_profiles (' || in_test_run_id || ')',
         check_call_in  => l_sql_txt,
         against_exc_in => '');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles (' || in_test_run_id || ') Count',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || in_test_run_id,
         against_value_in => 0);
      commit;
   end tl_delete_wt_profiles;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


------------------------------------------------------------
-- Return DBMS_PROFILER specific error messages
function get_error_msg
      (retnum_in  in  binary_integer)
   return varchar2
is
   l_msg_prefix  varchar2(50) := 'DBMS_PROFILER Error: ';
begin
   case retnum_in
   when dbms_profiler.error_param then return l_msg_prefix ||
       'A subprogram was called with an incorrect parameter.';
   when dbms_profiler.error_io then return l_msg_prefix ||
       'Data flush operation failed.' ||
       ' Check whether the profiler tables have been created,' ||
       ' are accessible, and that there is adequate space.';
   when dbms_profiler.error_version then return l_msg_prefix ||
       'There is a mismatch between package and database implementation.' ||
       ' Oracle returns this error if an incorrect version of the' ||
       ' DBMS_PROFILER package is installed, and if the version of the' ||
       ' profiler package cannot work with this database version.';
   else return l_msg_prefix ||
       'Unknown error number ' || retnum_in;
   end case;
end get_error_msg;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_get_error_msg
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Get Error Messages';
      wt_assert.isnotnull (
         msg_in        => 'ERROR_PARAM Test 1',
         check_this_in => get_error_msg(dbms_profiler.error_param));
      wt_assert.this (
         msg_in        => 'ERROR_PARAM Test 2',
         check_this_in => regexp_like(get_error_msg(dbms_profiler.error_param)
                                     ,'incorrect parameter','i'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in        => 'ERROR_IO Test 1',
         check_this_in => get_error_msg(dbms_profiler.error_io));
      wt_assert.this (
         msg_in        => 'ERROR_IO Test 2',
         check_this_in => regexp_like(get_error_msg(dbms_profiler.error_io)
                                     ,'Data flush operation','i'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in        => 'ERROR_VERSION Test 1',
         check_this_in => get_error_msg(dbms_profiler.error_version));
      wt_assert.this (
         msg_in        => 'ERROR_VERSION Test 2',
         check_this_in => regexp_like(get_error_msg(dbms_profiler.error_version)
                                     ,'incorrect version','i'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in        => 'Unknown Error Test 1',
         check_this_in => get_error_msg(-9999));
      wt_assert.this (
         msg_in        => 'Unknown Error Test 2',
         check_this_in => regexp_like(get_error_msg(-9999)
                                     ,'Unknown error','i'));
   end t_get_error_msg;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_plsql_profiler_recs
      (in_profiler_runid  in number)
is
begin
   delete from plsql_profiler_data
    where runid = in_profiler_runid;
   delete from plsql_profiler_units
    where runid = in_profiler_runid;
   delete from plsql_profiler_runs
    where runid = in_profiler_runid;
end delete_plsql_profiler_recs;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_profiler_recs
   is
      c_test_run_id   constant number := -99;
      l_err_stack     varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete PL/SQL Profiler Records Happy Path 1';
      begin
         delete_plsql_profiler_recs(c_test_run_id);  -- Should run without error
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'delete_plsql_profiler_recs(' || c_test_run_id || ') 1',
         check_this_in   => l_err_stack);
      tl_count_plsql_profiler_recs(c_test_run_id, 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete PL/SQL Profiler Records Happy Path 2';
      tl_insert_plsql_profiler_recs(c_test_run_id);
      tl_count_plsql_profiler_recs(c_test_run_id, 1);
      begin
         delete_plsql_profiler_recs(c_test_run_id);  -- Should run without error
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'delete_plsql_profiler_recs(' || c_test_run_id || ') 2',
         check_this_in   => l_err_stack);
      tl_count_plsql_profiler_recs(c_test_run_id, 0);
   end t_delete_profiler_recs;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure load_ignr_aa
is
   cursor c_find_begin is
      select line
            ,instr(text,'--%WTPLSQL_begin_ignore_lines%--') col
       from  dba_source
       where owner = core_data.g_run_rec.dbout_owner
        and  name  = core_data.g_run_rec.dbout_name
        and  type  = core_data.g_run_rec.dbout_type
        and  text like '%--\%WTPLSQL_begin_ignore_lines\%--%' escape '\'
       order by line;
   buff_find_begin  c_find_begin%ROWTYPE;
   cursor c_find_end (in_line in number, in_col in number) is
      with q1 as (
      select line
            ,instr(text,'--%WTPLSQL_end_ignore_lines%--') col
       from  dba_source
       where owner = core_data.g_run_rec.dbout_owner
        and  name  = core_data.g_run_rec.dbout_name
        and  type  = core_data.g_run_rec.dbout_type
        and  line >= in_line
        and  text like '%--\%WTPLSQL_end_ignore_lines\%--%' escape '\'
      )
      select line
            ,col
       from  q1
       where line > in_line
          or (    line = in_line
              and col  > in_col)
       order by line
            ,col;
   buff_find_end  c_find_end%ROWTYPE;
begin
   g_ignr_aa.delete;
   open c_find_begin;
   loop
      fetch c_find_begin into buff_find_begin;
      exit when c_find_begin%NOTFOUND;
      open c_find_end (buff_find_begin.line, buff_find_begin.col);
      fetch c_find_end into buff_find_end;
      if c_find_end%NOTFOUND
      then
         select max(line)
          into  buff_find_end.line
          from  dba_source
          where owner = core_data.g_run_rec.dbout_owner
           and  name  = core_data.g_run_rec.dbout_name
           and  type  = core_data.g_run_rec.dbout_type;
      end if;
      close c_find_end;
      for i in buff_find_begin.line + g_rec.trigger_offset ..
               buff_find_end.line   + g_rec.trigger_offset
      loop
         g_ignr_aa(i) := 'X';
      end loop;
   end loop;
   close c_find_begin;
end load_ignr_aa;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_load_ignr_aa
   is
      l_recSAVE    wt_dbout_runs%ROWTYPE;
      l_ignrSAVE   ignr_aa_type;
      l_ignrTEST   ignr_aa_type;
      l_pname      varchar2(128) := 'WT_PROFILE_LOAD_IGNR';
      --------------------------------------  WTPLSQL Testing --
      procedure run_load_ignr is begin
         l_recSAVE  := g_rec;
         l_ignrSAVE := g_ignr_aa;
         g_ignr_aa.delete;
         g_rec.dbout_owner    := g_current_user;
         g_rec.dbout_name     := l_pname;
         g_rec.dbout_type     := 'PACKAGE BODY';
         g_rec.trigger_offset := 0;
         load_ignr_aa;
         l_ignrTEST := g_ignr_aa;
         g_ignr_aa := l_ignrSAVE;
         g_rec   := l_recSAVE;
      end run_load_ignr;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Setup';
      wt_assert.isnotnull
         (msg_in    => 'Number of IGNR_AA elements'
         ,check_this_in => g_ignr_aa.COUNT);
      tl_compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '  l_junk number;' );
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Happy Path 1';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 'begin'          || CHR(10) ||
                        '  l_junk := 1;' );
      run_load_ignr;
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Happy Path 2';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 3
            '  l_junk := 1;'                           );             -- Line 4
            -- end                                                    -- Line 5
      run_load_ignr;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 3);
      for i in 3 .. 5
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Happy Path 3';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           );             -- Line 7
      run_load_ignr;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 3);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Happy Path 4';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           || CHR(10) ||  -- Line 7
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 8
            '  l_junk := 4;'                           );             -- Line 9
            -- end                                                    -- Line 10
      run_load_ignr;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 6);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      for i in 8 .. 10
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Sad Path 1';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 3
            '  l_junk := 4;'                           );             -- Line 4
      run_load_ignr;
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Sad Path 2';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           || CHR(10) ||  -- Line 7
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 8
            '  l_junk := 4;'                           );             -- Line 9
      run_load_ignr;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 3);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Sad Path 3';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           || CHR(10) ||  -- Line 7
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 8
            '  l_junk := 4;'                           );             -- Line 9
      run_load_ignr;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_ignrTest.COUNT'
         ,check_this_in   => l_ignrTest.COUNT
         ,against_this_in => 5);
      for i in 4 .. 8
      loop
         wt_assert.eq
            (msg_in          => 'l_ignrTest.exists(' || i || ')'
            ,check_this_in   => l_ignrTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Ignr Teardown';
      tl_drop_db_object(l_pname, 'package');
      wt_assert.isnotnull
         (msg_in    => 'Number of IGNR_AA elements'
         ,check_this_in => g_ignr_aa.COUNT);
   end t_load_ignr_aa;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------



------------------------------------------------------------
procedure add_dbout_run
      (in_profiles_rec  in wt_profiles%ROWTYPE)
is
begin
   -- If this raises an exception, it must be done before any other values
   --   are set because they will not be rolled-back after the "raise".
   case in_profiles_rec.status
      when 'EXEC' then
         g_rec.executed_lines := nvl(g_rec.executed_lines,0) + 1;
         -- Only count the executed time.
         g_rec.min_executed_usecs := least(nvl(g_rec.min_executed_usecs,999999999)
                                          ,in_profiles_rec.min_usecs);
         g_rec.max_executed_usecs := greatest(nvl(g_rec.max_executed_usecs,0)
                                             ,in_profiles_rec.max_usecs);
         g_rec.tot_executed_usecs := nvl(g_rec.tot_executed_usecs,0) +
                                     ( in_profiles_rec.total_usecs /
                                       in_profiles_rec.total_occur  );
      when 'IGNR' then
         g_rec.ignored_lines := nvl(g_rec.ignored_lines,0) + 1;
      when 'EXCL' then
         g_rec.excluded_lines := nvl(g_rec.excluded_lines,0) + 1;
      when 'NOTX' then
         g_rec.notexec_lines := nvl(g_rec.notexec_lines,0) + 1;
      when 'UNKN' then
         g_rec.unknown_lines := nvl(g_rec.unknown_lines,0) + 1;
      else
         raise_application_error(-20011, 'Unknown Profile status "' ||
                                       in_profiles_rec.status || '"');
   end case;
   g_rec.test_run_id    := in_profiles_rec.test_run_id;
   g_rec.profiled_lines := nvl(g_rec.profiled_lines,0) + 1;
end add_dbout_run;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_add_dbout_run
   is
      l_recSAVE      wt_test_run_stats%ROWTYPE;
      l_recTEST      wt_test_run_stats%ROWTYPE;
      l_profileTEST  wt_profiles%ROWTYPE;
      l_sqlerrm      varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      -- Overview:
      -- 1) Save results in temporary variables
      -- 2) Clear add_dbout_run variables
      -- 3) Call add_dbout_run several times with test data.
      -- 4) Capture test results
      -- 5) Restore saved results
      -- 6) Confirm the test results using WT_ASSERT.
      --------------------------------------  WTPLSQL Testing --
      l_recSAVE   := g_rec;
      g_rec       := l_recTEST;
      l_profileTEST.test_run_id := -20;
      l_profileTEST.min_usecs   := 10;
      l_profileTEST.max_usecs   := 20;
      l_profileTEST.total_usecs := 30;
      l_profileTEST.total_occur := 1;
      l_profileTEST.status := 'EXEC';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'EXEC';
      add_dbout_run(l_profileTEST);
      --------------------------------------  WTPLSQL Testing --
      l_profileTEST.status := 'EXEC';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'EXEC';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'EXEC';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'IGNR';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'IGNR';
      add_dbout_run(l_profileTEST);
      --------------------------------------  WTPLSQL Testing --
      l_profileTEST.status := 'IGNR';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'IGNR';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'NOTX';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'NOTX';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'NOTX';
      add_dbout_run(l_profileTEST);
      --------------------------------------  WTPLSQL Testing --
      l_profileTEST.status := 'EXCL';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'EXCL';
      add_dbout_run(l_profileTEST);
      l_profileTEST.status := 'UNKN';
      add_dbout_run(l_profileTEST);
      --------------------------------------  WTPLSQL Testing --
      l_profileTEST.status := 'ABC';
      begin
         add_dbout_run(l_profileTEST);
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      l_recTEST := g_rec;
      g_rec     := l_recSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Add Profile Testing';
      wt_assert.eq (
         msg_in          => 'l_recTEST.test_run_id',
         check_this_in   => l_recTEST.test_run_id,
         against_this_in => -20);
      wt_assert.eq (
         msg_in          => 'l_recTEST.profiled_lines',
         check_this_in   => l_recTEST.profiled_lines,
         against_this_in => 15);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.min_executed_usecs',
         check_this_in   => l_recTEST.min_executed_usecs,
         against_this_in => 10);
      wt_assert.eq (
         msg_in          => 'l_recTEST.max_executed_usecs',
         check_this_in   => l_recTEST.max_executed_usecs,
         against_this_in => 20);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.tot_executed_usecs',
         check_this_in   => l_recTEST.tot_executed_usecs,
         against_this_in => 150);
      wt_assert.eq (
         msg_in          => 'l_recTEST.executed_lines',
         check_this_in   => l_recTEST.executed_lines,
         against_this_in => 5);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.ignored_lines',
         check_this_in   => l_recTEST.ignored_lines,
         against_this_in => 4);
      wt_assert.eq (
         msg_in          => 'l_recTEST.notexec_lines',
         check_this_in   => l_recTEST.notexec_lines,
         against_this_in => 3);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.excluded_lines',
         check_this_in   => l_recTEST.excluded_lines,
         against_this_in => 2);
      wt_assert.eq (
         msg_in          => 'l_recTEST.unknown_lines',
         check_this_in   => l_recTEST.unknown_lines,
         against_this_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
          msg_in          => 'Add Result Sad Path 1',
          check_this_in   => 'ORA-20011: Unknown Profile status "ABC"',
          against_this_in => l_sqlerrm);
   end t_add_dbout_run;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------





------------------------------------------------------------
procedure insert_wt_profile
      (in_test_run_id  in  number)
is
   prof_rec    wt_profiles%ROWTYPE;
   l_max_line  number;
   procedure l_set_status is begin
      if g_ignr_aa.EXISTS(prof_rec.line)
      then
         -- Found Statement to Ignore
         prof_rec.status := 'IGNR';
         return;
      end if;
      if prof_rec.total_occur > 0
      then
         -- Found Executed Statement
         prof_rec.status := 'EXEC';
         return;
      end if;
      if    prof_rec.total_occur = 0
        and prof_rec.total_usecs = 0
      then
         -- Check for declaration if Not Executed
         if regexp_like(prof_rec.text, '^[[:space:]]*' ||
                       '(FUNCTION|PROCEDURE|PACKAGE|TYPE|TRIGGER)' ||
                       '[[:space:]]', 'i')
         then
            -- Exclude declarations if Not Executed
            prof_rec.status := 'EXCL';
         elsif     prof_rec.line = l_max_line
               AND regexp_like(prof_rec.text, 'END', 'i')
         then
            prof_rec.status := 'EXCL';
         else
            -- Found Not Executed Statement
            prof_rec.status := 'NOTX';
         end if;
         return;
      end if;
      -- Everything else is unknown
      prof_rec.status := 'UNKN';
   end l_set_status;
begin
   -- This will not RAISE NO_DATA_FOUND because it uses a GROUP FUNCTION.
   select max(ppd.line#) into l_max_line
    from  plsql_profiler_units ppu
          join plsql_profiler_data  ppd
               on  ppd.unit_number = ppu.unit_number
               and ppd.runid       = g_rec.prof_runid
    where ppu.unit_owner = core_data.g_run_rec.dbout_owner
     and  ppu.unit_name  = core_data.g_run_rec.dbout_name
     and  ppu.unit_type  = core_data.g_run_rec.dbout_type
     and  ppu.runid      = g_rec.prof_runid;
   load_ignr_aa;
   prof_rec.test_run_id := in_test_run_id;
   for buf1 in (
      select src.line
            ,ppd.total_occur
            ,ppd.total_time
            ,ppd.min_time
            ,ppd.max_time
            ,src.text
       from  plsql_profiler_units ppu
             join plsql_profiler_data  ppd
                  on  ppd.unit_number = ppu.unit_number
                  and ppd.runid       = g_rec.prof_runid
             join dba_source  src
                  on  src.line  = ppd.line# + g_rec.trigger_offset
                  and src.owner = core_data.g_run_rec.dbout_owner
                  and src.name  = core_data.g_run_rec.dbout_name
                  and src.type  = core_data.g_run_rec.dbout_type
       where ppu.unit_owner = core_data.g_run_rec.dbout_owner
        and  ppu.unit_name  = core_data.g_run_rec.dbout_name
        and  ppu.unit_type  = core_data.g_run_rec.dbout_type
        and  ppu.runid      = g_rec.prof_runid )
   loop
      prof_rec.line        := buf1.line;
      prof_rec.total_occur := buf1.total_occur;
      prof_rec.total_usecs := buf1.total_time/1000;
      prof_rec.min_usecs   := buf1.min_time/1000;
      prof_rec.max_usecs   := buf1.max_time/1000;
      prof_rec.text        := buf1.text;
      prof_rec.status      := NULL;
      l_set_status;
      add_dbout_run(prof_rec);
      insert into wt_profiles values prof_rec;
   end loop;
   g_ignr_aa.delete;
   delete_plsql_profiler_recs(g_rec.prof_runid);
end insert_wt_profile;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_insert_wt_profile
   is
      units_rec      plsql_profiler_units%ROWTYPE;
      data_rec       plsql_profiler_data%ROWTYPE;
      l_recSAVE      wt_dbout_runs%ROWTYPE;
      l_recNULL      wt_dbout_runs%ROWTYPE;
      c_test_run_id  constant number := -97;
      l_pname        varchar2(128) := 'WT_PROFILE_INSERT_DBOUT';
      l_sqlerrm      varchar2(4000);
      l_err_stack    varchar2(32000);
      --------------------------------------  WTPLSQL Testing --
      procedure insert_plsql_profiler_data
            (in_line#        in number
            ,in_total_occur  in number
            ,in_total_time   in number)
      is
      begin
         data_rec.line#       := in_line#;
         data_rec.total_occur := in_total_occur;
         data_rec.total_time  := in_total_time;
      --------------------------------------  WTPLSQL Testing --
         begin
            insert into plsql_profiler_data values data_rec;
            commit;
            l_sqlerrm := SQLERRM;
         exception when others then
            l_sqlerrm := SQLERRM;
         end;
         wt_assert.eq (
            msg_in          => 'insert plsql_profiler_data (LINE#: ' || data_rec.line#|| ')',
            check_this_in   => SQLERRM,
            against_this_in => 'ORA-0000: normal, successful completion');
      end insert_plsql_profiler_data;
      --------------------------------------  WTPLSQL Testing --
      procedure test_dbout_profiler
            (in_line#     in  number
            ,in_col_name  in  varchar2
            ,in_value     in  varchar2)
      is
      begin
         wt_assert.eqqueryvalue
            (msg_in           => 'wt_profiles line ' || in_line# ||
                                               ', column ' || in_col_name
            ,check_query_in   => 'select ' || in_col_name ||
                                 ' from wt_profiles' ||
                                 ' where test_run_id = ' || c_test_run_id ||
                                 ' and line = ' || in_line#
            ,against_value_in => in_value);
      end test_dbout_profiler;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Setup';
      tl_compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '  l_junk number;' );
      --------------------------------------  WTPLSQL Testing --
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  if 0 = 1 then'                          || CHR(10) ||  -- Line 7
            '     l_junk := 3;'                        || CHR(10) ||  -- Line 8
            '  end if;'                                );             -- Line 9
      tl_insert_plsql_profiler_recs(c_test_run_id);
      tl_count_plsql_profiler_recs(c_test_run_id, 1);
      tl_insert_test_runs(c_test_run_id, 'Insert DBOUT Test');
      --------------------------------------  WTPLSQL Testing --
      units_rec.runid        := c_test_run_id;
      units_rec.unit_number  := 1;
      units_rec.unit_owner   := g_current_user;
      units_rec.unit_name    := l_pname;
      units_rec.unit_type    := 'PACKAGE BODY';
      units_rec.total_time   := 0;
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into plsql_profiler_units values units_rec;
         commit;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'insert UNIT 1 into plsql_profiler_units',
         check_this_in   => l_err_stack);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of UNIT 1 plsql_profiler_units'
         ,check_query_in   => 'select count(*) from plsql_profiler_units' ||
                              ' where runid = ' || c_test_run_id ||
                              ' and unit_number = 1'
         ,against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      data_rec.runid       := c_test_run_id;
      data_rec.unit_number := 1;
      data_rec.min_time    := 0;
      data_rec.max_time    := 1;
      insert_plsql_profiler_data(1, 0, 0);
      insert_plsql_profiler_data(2, 0, 1);
      insert_plsql_profiler_data(3, 1, 1);
      insert_plsql_profiler_data(5, 1, 1);
      insert_plsql_profiler_data(7, 1, 1);
      insert_plsql_profiler_data(8, 0, 0);
      insert_plsql_profiler_data(9, 1, 1);
      insert_plsql_profiler_data(10, 0, 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of UNIT 1 plsql_profiler_data'
         ,check_query_in   => 'select count(*) from plsql_profiler_data' ||
                              ' where runid = ' || c_test_run_id ||
                              ' and unit_number = 1'
         ,against_value_in => 8);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Happy Path';
      l_recSAVE := g_rec;
      g_rec.test_run_id     := c_test_run_id;
      g_rec.dbout_owner     := g_current_user;
      g_rec.dbout_name      := l_pname;
      g_rec.dbout_type      := 'PACKAGE BODY';
      g_rec.prof_runid      := c_test_run_id;
      g_rec.trigger_offset  := 0;
      g_rec.error_message   := '';
      --------------------------------------  WTPLSQL Testing --
      g_skip_add := TRUE;
      begin
         insert_wt_profile;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      g_skip_add := FALSE;
      g_rec := l_recSAVE;
      wt_assert.isnull (
         msg_in          => 'SQLERRM',
         check_this_in   => l_err_stack);
      --------------------------------------  WTPLSQL Testing --
      test_dbout_profiler(1, 'STATUS', 'EXCL');
      test_dbout_profiler(1, 'TEXT',   'package body WT_PROFILE_INSERT_DBOUT is' || CHR(10));
      test_dbout_profiler(2, 'STATUS', 'UNKN');
      test_dbout_profiler(2, 'TEXT',   'begin' || CHR(10));
      test_dbout_profiler(3, 'STATUS', 'EXEC');
      test_dbout_profiler(3, 'TEXT',   '  l_junk := 1;' || CHR(10));
      test_dbout_profiler(5, 'STATUS', 'IGNR');
      test_dbout_profiler(5, 'TEXT',   '  l_junk := 2;' || CHR(10));
      test_dbout_profiler(7, 'STATUS', 'EXEC');
      test_dbout_profiler(7, 'TEXT',   '  if 0 = 1 then' || CHR(10));
      test_dbout_profiler(8, 'STATUS', 'NOTX');
      test_dbout_profiler(8, 'TEXT',   '     l_junk := 3;' || CHR(10));
      test_dbout_profiler(9, 'STATUS', 'EXEC');
      test_dbout_profiler(9, 'TEXT',   '  end if;' || CHR(10));
      test_dbout_profiler(10, 'STATUS', 'EXCL');
      test_dbout_profiler(10, 'TEXT',   'end WT_PROFILE_INSERT_DBOUT;');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Teardown';
      tl_delete_wt_profiles(c_test_run_id);
      tl_delete_test_runs(c_test_run_id);
      tl_delete_plsql_profiler_recs(c_test_run_id);
      tl_count_plsql_profiler_recs(c_test_run_id, 0);
      tl_drop_db_object(l_pname, 'package');
   end t_insert_wt_profile;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
function is_profilable  -- find_dbout
   return boolean
is
   cursor c_readable
   is
      select src.name
       from  dba_source  src
       where src.owner  = core_data.g_run_rec.dbout_owner
        and  src.name   = core_data.g_run_rec.dbout_name
        and  src.type   = core_data.g_run_rec.dbout_type;
   b_readable  c_readable%ROWTYPE;
   ret_bool    boolean;
begin
   -- Find the first occurance of any PL/SQL source
   open c_readable;
   fetch c_readable into b_readable;
   ret_bool := c_readable%FOUND;
   close c_readable;
   return ret_bool;
end is_profilable;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_is_profilable
   is
      l_recSAVE    wt_dbout_runs%ROWTYPE;
      l_recNULL    wt_dbout_runs%ROWTYPE;
      l_recTEST    wt_dbout_runs%ROWTYPE;
      l_owner      varchar2(128);
      l_pname      varchar2(128) := 'WT_PROFILE_FIND_DBOUT';
      --------------------------------------  WTPLSQL Testing --
      procedure run_find_dbout is begin
         l_recSAVE := g_rec;
         g_rec := l_recNULL;
         find_dbout(l_owner, l_pname);
         l_recTEST := g_rec;
         g_rec := l_recSAVE;
      end run_find_dbout;
   begin
      select username into l_owner from user_users;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_is_profilable Setup';
      tl_compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '   l_junk number;' );
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 't_is_profilable Happy Path 1';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 'begin'          || CHR(10) ||
                        '  l_junk := 1;' );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type);
      wt_assert.isnull
         (msg_in          => 'l_recTEST.error_message'
         ,check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 2';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT "' || l_pname ||
                                     ':PACKAGE BODY" %--' || CHR(10) ||
            'begin'                                       || CHR(10) ||
            '  l_junk := 1;'                              );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => g_current_user);
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => l_pname);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type
         ,against_this_in => 'PACKAGE BODY');
      wt_assert.isnull
         (msg_in        => 'l_recTEST.error_message'
         ,check_this_in => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 3';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT "' || g_current_user ||
                                    '.' || l_pname ||
                                    ':PACKAGE BODY" %--' || CHR(10) ||
            'begin'                                      || CHR(10) ||
            '  l_junk := 1;'                             );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => g_current_user);
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => l_pname);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type
         ,against_this_in => 'PACKAGE BODY');
      wt_assert.isnull
         (msg_in        => 'l_recTEST.error_message'
         ,check_this_in => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 1';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  =>
            -- Don't remove the "||", otherwise this will set the DBOUT
            '  --% WTPLSQL SET DBOUT ' || '"BOGUS1" %--' || CHR(10) ||
            'begin'                                      || CHR(10) ||
            '  l_junk := 1;'                             );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in          => 'l_recTEST.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type);
      wt_assert.eq
         (msg_in          => 'l_recTEST.error_message'
         ,check_this_in   => l_recTEST.error_message
         ,against_this_in => 'Unable to find database object "BOGUS1".');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 2';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT "' || g_current_user ||
                                    '.' || l_pname || '" %--'  || CHR(10) ||
            'begin'                                            || CHR(10) ||
            '  l_junk := 1;'                                   );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => g_current_user);
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => l_pname);
      wt_assert.eq
         (msg_in          => 'l_recTEST.error_message'
         ,check_this_in   => l_recTEST.error_message
         ,against_this_in => 'Found too many database objects "WTP.WT_PROFILE_FIND_DBOUT".');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 3';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            -- Don't remove the "||", otherwise this will set the DBOUT
            '  --% WTPLSQL SET DBOUT ' || '"SYS.ALL_OBJECTS:VIEW" %--' || CHR(10) ||
            'begin'                                                    || CHR(10) ||
            '  l_junk := 1;'                                           );
      run_find_dbout;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => 'SYS');
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => 'ALL_OBJECTS');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'l_recTEST.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type
         ,against_this_in => 'VIEW');
      wt_assert.isnull
         (msg_in          => 'l_recTEST.error_message'
         ,check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Teardown';
      tl_drop_db_object(l_pname, 'package');
   end t_is_profilable;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- Find begining of PL/SQL Block in a Trigger
function trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2
      ,dbout_type_in   in  varchar2)
   return number
is
begin
   if dbout_type_in != 'TRIGGER'
   then
      return 0;
   end if;
   for buff in (
      select line, text from dba_source
       where owner = dbout_owner_in
        and  name  = dbout_name_in
        and  type  = 'TRIGGER'
      order by line )
   loop
      if regexp_instr(buff.text,
                      '(^declare$' ||
                      '|^declare[[:space:]]' ||
                      '|[[:space:]]declare$' ||
                      '|[[:space:]]declare[[:space:]])', 1, 1, 0, 'i') <> 0
         OR
         regexp_instr(buff.text,
                      '(^begin$' ||
                      '|^begin[[:space:]]' ||
                      '|[[:space:]]begin$' ||
                      '|[[:space:]]begin[[:space:]])', 1, 1, 0, 'i') <> 0 
      then
         return buff.line - 1;
      end if;
   end loop;
   return 0;
end trigger_offset;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_trigger_offset
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Trigger Offset Happy Path';
      wt_assert.eq (
         msg_in          => 'Trigger Test',
         check_this_in   => trigger_offset (dbout_owner_in => g_current_user
                                           ,dbout_name_in  => 'WT_SELF_TEST$TEST'
                                           ,dbout_type_in  => 'TRIGGER'),
         against_this_in => 3);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'Package Test',
         check_this_in   => trigger_offset (dbout_owner_in => g_current_user
                                           ,dbout_name_in  => 'WT_PROFILER'
                                           ,dbout_type_in  => 'PACKAGE BODY'),
         against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Trigger Offset Sad Path';
      wt_assert.eq (
         msg_in          => 'Non Existent Object',
         check_this_in   => trigger_offset (dbout_owner_in => 'BOGUS456'
                                           ,dbout_name_in  => 'BOGUS123'
                                           ,dbout_type_in  => 'TRIGGER'),
         against_this_in => 0);
   end t_trigger_offset;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
function calc_pct_coverage
      (in_test_run_id  in  number)
   return number
IS
BEGIN
   for buff in (
      select sum(case status when 'EXEC' then 1 else 0 end)    HITS
            ,sum(case status when 'NOTX' then 1 else 0 end)    MISSES
       from  wt_profiles  p
       where test_run_id = in_test_run_id  )
   loop
      if buff.hits + buff.misses = 0
      then
         return -1;
      else
         return round(100 * buff.hits / (buff.hits + buff.misses),2);
      end if;
   end loop;
   return null;
END calc_pct_coverage;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_calc_pct_coverage
   is
      c_test_run_id  constant number := -95;
      l_profile          wt_profiles%ROWTYPE;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Calculate Percent Coverage Setup';
      tl_insert_test_runs(c_test_run_id, 'Calculate Offset Test');
      l_profile.test_run_id  := c_test_run_id;
      l_profile.total_occur  := 1;
      l_profile.total_usecs  := 1;
      l_profile.min_usecs    := 1;
      l_profile.max_usecs    := 1;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Calculate Percent Coverage Happy Path 1';
      l_profile.line         := 1;
      l_profile.status       := 'EXEC';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      --------------------------------------  WTPLSQL Testing --
      l_profile.line         := 2;
      l_profile.status       := 'NOTX';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      --------------------------------------  WTPLSQL Testing --
      l_profile.line         := 3;
      l_profile.status       := 'EXEC';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      wt_assert.eq (
         msg_in          => 'Main Test',
         check_this_in   => calc_pct_coverage(c_test_run_id),
         against_this_in => 66.67);
      tl_delete_wt_profiles(c_test_run_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Calculate Percent Coverage Happy Path 2';
      l_profile.line         := 1;
      l_profile.status       := 'EXCL';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      --------------------------------------  WTPLSQL Testing --
      l_profile.line         := 2;
      l_profile.status       := 'UNKN';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      --------------------------------------  WTPLSQL Testing --
      l_profile.line         := 3;
      l_profile.status       := 'EXCL';
      l_profile.text         := 'Testing ' || l_profile.line;
      tl_insert_wt_profiles(l_profile);
      wt_assert.eq (
         msg_in          => 'Main Test',
         check_this_in   => calc_pct_coverage(c_test_run_id),
         against_this_in => -1);
      tl_delete_wt_profiles(c_test_run_id);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Calculate Percent Coverage Sad Path';
      wt_assert.isnull (
         msg_in        => 'Missing Test Run ID',
         check_this_in => calc_pct_coverage(-99990));
      wt_assert.isnull (
         msg_in        => 'NULL Test Run ID',
         check_this_in => calc_pct_coverage(null));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Calculate Percent Coverage Teardown';
      tl_delete_test_runs(c_test_run_id);
   end t_calc_pct_coverage;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure initialize
is
   l_rec_NULL     wt_dbout_runs%ROWTYPE;
   l_retnum       binary_integer;
begin
   g_rec := l_rec_NULL;
   -- g_ignr_aa.delete;  Not Needed
   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      -- In case a test failed and left this set to TRUE
      g_skip_insert := FALSE;
      g_skip_add    := FALSE;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
   if is_profilable
   then
      -- Check Versions
      l_retnum := dbms_profiler.INTERNAL_VERSION_CHECK;
      if l_retnum <> 0 then
         ------%WTPLSQL_begin_ignore_lines%------  Can't test this
         --dbms_profiler.get_version(major_version, minor_version);
         raise_application_error(-20005,
            'dbms_profiler.INTERNAL_VERSION_CHECK returned: ' || get_error_msg(l_retnum));
         ----------------%WTPLSQL_end_ignore_lines%----------------
      end if;
      -- This starts the PROFILER Running!!!
      l_retnum := dbms_profiler.START_PROFILER(run_number => g_rec.prof_runid);
      if l_retnum <> 0 then
         ------%WTPLSQL_begin_ignore_lines%------  Can't test this
         raise_application_error(-20006,
            'dbms_profiler.START_PROFILER returned: ' || get_error_msg(l_retnum));
         ----------------%WTPLSQL_end_ignore_lines%----------------
      end if;
   end if;
end initialize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_initialize
   is
      c_test_run_id   constant number := -96;
      l_owner         varchar2(128);
      l_pname         varchar2(128) := 'WT_PROFILE_INITIALIZE';
      l_recSAVE       wt_dbout_runs%ROWTYPE;
      l_recTEST       wt_dbout_runs%ROWTYPE;
      l_recOUT        wt_dbout_runs%ROWTYPE;
      l_sqlerrm       varchar2(4000);
   begin
      select username into l_owner from user_users;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Setup';
      tl_compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '  l_junk number;' );
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Initialize Test HAPPY Path 1';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'          || CHR(10) ||  -- Line 2
            '  l_junk := 7;' );             -- Line 3
      --------------------------------------  WTPLSQL Testing --
      l_recSAVE := g_rec;
      initialize
         (in_test_run_id      => c_test_run_id,
          in_runner_owner     => l_owner,
          in_runner_name      => l_pname,
          out_dbout_owner     => l_recOUT.dbout_owner,
          out_dbout_name      => l_recOUT.dbout_name,
          out_dbout_type      => l_recOUT.dbout_type,
          out_trigger_offset  => l_recOUT.trigger_offset,
          out_profiler_runid  => l_recOUT.prof_runid,
          out_error_message   => l_recOUT.error_message);
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'OUT dbout_owner',
         check_this_in   => l_recOUT.dbout_owner);
      wt_assert.isnull (
         msg_in          => 'OUT dbout_name',
         check_this_in   => l_recOUT.dbout_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'OUT dbout_type',
         check_this_in   => l_recOUT.dbout_type);
      wt_assert.isnull (
         msg_in          => 'OUT prof_runid',
         check_this_in   => l_recOUT.prof_runid);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'OUT trigger_offset',
         check_this_in   => l_recOUT.trigger_offset);
      wt_assert.isnull (
         msg_in          => 'OUT error_message',
         check_this_in   => l_recOUT.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_owner',
         check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_name',
         check_this_in   => l_recTEST.dbout_name);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_type',
         check_this_in   => l_recTEST.dbout_type);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.prof_runid',
         check_this_in   => l_recTEST.prof_runid);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.trigger_offset',
         check_this_in   => l_recTEST.trigger_offset);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.error_message',
         check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Initialize Test HAPPY Path 2';
      tl_compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                     || CHR(10) ||  -- Line 2
            '--% WTPLSQL SET DBOUT "' || l_pname ||
                                   ':PACKAGE BODY" %--' || CHR(10) ||  -- Line 3
            '  l_junk := 7;'                            );             -- Line 4
      --------------------------------------  WTPLSQL Testing --
      l_recSAVE := g_rec;
      initialize
         (in_test_run_id      => c_test_run_id,
          in_runner_owner     => l_owner,
          in_runner_name      => l_pname,
          out_dbout_owner     => l_recOUT.dbout_owner,
          out_dbout_name      => l_recOUT.dbout_name,
          out_dbout_type      => l_recOUT.dbout_type,
          out_trigger_offset  => l_recOUT.trigger_offset,
          out_profiler_runid  => l_recOUT.prof_runid,
          out_error_message   => l_recOUT.error_message);
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'OUT dbout_owner',
         check_this_in   => l_recOUT.dbout_owner,
         against_this_in => g_current_user);
      wt_assert.eq (
         msg_in          => 'OUT dbout_name',
         check_this_in   => l_recOUT.dbout_name,
         against_this_in => l_pname);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'OUT dbout_type',
         check_this_in   => l_recOUT.dbout_type,
         against_this_in => 'PACKAGE BODY');
      wt_assert.isnotnull (
         msg_in          => 'OUT prof_runid',
         check_this_in   => l_recOUT.prof_runid);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'OUT trigger_offset',
         check_this_in   => l_recOUT.trigger_offset,
         against_this_in => 0);
      wt_assert.isnull (
         msg_in          => 'OUT error_message',
         check_this_in   => l_recOUT.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.dbout_owner',
         check_this_in   => l_recTEST.dbout_owner,
         against_this_in => g_current_user);
      wt_assert.eq (
         msg_in          => 'l_recTEST.dbout_name',
         check_this_in   => l_recTEST.dbout_name,
         against_this_in => l_pname);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.dbout_type',
         check_this_in   => l_recTEST.dbout_type,
         against_this_in => 'PACKAGE BODY');
      wt_assert.isnotnull (
         msg_in          => 'l_recTEST.prof_runid',
         check_this_in   => l_recTEST.prof_runid);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'l_recTEST.trigger_offset',
         check_this_in   => l_recTEST.trigger_offset,
         against_this_in => 0);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.error_message',
         check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Teardown';
      tl_drop_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname);
   end t_initialize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- Because this procedure is called to cleanup after erorrs,
--  it must be able to run multiple times without causing damage.
procedure finalize
      (in_test_run_id   in number)
is
   l_rec_NULL  wt_dbout_runs%ROWTYPE;
begin
   -- Return if not profiling
   if g_rec.prof_runid is null
   then
      return;
   end if;
   -- Abort if there is no Test Run ID
   if in_test_run_id is null
   then
      raise_application_error (-20004, 'i_test_run_id is null');
   end if;
   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      if not g_skip_insert
      then
   $END
   begin
      -- DBMS_PROFILER.FLUSH_DATA is included with DBMS_PROFILER.STOP_PROFILER
      dbms_profiler.STOP_PROFILER;
   exception when others then
      g_rec := l_rec_NULL;
      raise;
   end;
   -- Calculate the trigger offset, if any.
   g_rec.test_run_id := in_test_run_id;
   g_rec.trigger_offset := trigger_offset
                              (dbout_owner_in => core_data.g_run_rec.dbout_owner
                              ,dbout_name_in  => core_data.g_run_rec.dbout_name
                              ,dbout_type_in  => core_data.g_run_rec.dbout_type );
   -- Save Results
   insert_wt_profile;
   insert into wt_dbout_runs values g_rec;
   $IF $$WTPLSQL_SELFTEST
   $THEN
      end if;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_finalize
   is
      l_recSAVE    wt_dbout_runs%ROWTYPE;
      l_recTEST    wt_dbout_runs%ROWTYPE;
      l_sqlerrm    varchar2(4000);
      l_err_stack  varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalize Happy Path 1';
      l_recSAVE := g_rec;
      g_rec.prof_runid := NULL;
      wt_assert.isnull (
         msg_in          => 'g_rec.prof_runid',
         check_this_in   => g_rec.prof_runid);
      --------------------------------------  WTPLSQL Testing --
      begin
         finalize;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      g_rec := l_recSAVE;
      wt_assert.isnull (
         msg_in          => 'format_error_stack and format_error_backtrace',
         check_this_in   => l_err_stack);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalize Happy Path 2';
      l_recSAVE := g_rec;
      g_rec.test_run_id    := -1;
      g_rec.dbout_owner    := 'TEST OWNER';
      g_rec.dbout_name     := 'TEST NAME';
      g_rec.dbout_type     := 'TEST TYPE';
      g_rec.prof_runid     := -2;
      g_rec.trigger_offset := -3;
      g_rec.error_message  := 'TEST MESSAGE';
      --------------------------------------  WTPLSQL Testing --
      g_skip_insert := TRUE;
      begin
         finalize;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      g_skip_insert := FALSE;
      --------------------------------------  WTPLSQL Testing --
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
      wt_assert.isnull (
         msg_in          => 'SQLERRM',
         check_this_in   => l_err_stack);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.test_run_id',
         check_this_in   => l_recTEST.test_run_id);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_owner',
         check_this_in   => l_recTEST.dbout_owner);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_name',
         check_this_in   => l_recTEST.dbout_name);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.dbout_type',
         check_this_in   => l_recTEST.dbout_type);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'l_recTEST.prof_runid',
         check_this_in   => l_recTEST.prof_runid);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.trigger_offset',
         check_this_in   => l_recTEST.trigger_offset);
      wt_assert.isnull (
         msg_in          => 'l_recTEST.error_message',
         check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalize Sad Path 1';
      l_recSAVE := g_rec;
      begin
         initialize
            (in_test_run_id      => null,
             in_runner_owner     => l_owner,
             in_runner_name      => 'Sad Path 1',
             out_dbout_owner     => l_recOUT.dbout_owner,
             out_dbout_name      => l_recOUT.dbout_name,
             out_dbout_type      => l_recOUT.dbout_type,
             out_trigger_offset  => l_recOUT.trigger_offset,
             out_profiler_runid  => l_recOUT.prof_runid,
             out_error_message   => l_recOUT.error_message);
         l_sqlerrm := SQLERRM;
      --------------------------------------  WTPLSQL Testing --
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
      wt_assert.eq (
         msg_in          => 'SQLERRM',
         check_this_in   => l_sqlerrm,
         against_this_in => 'ORA-20004: i_test_run_id is null');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Finalize Sad Path 2';
      l_recSAVE := g_rec;
      g_rec.prof_runid := -1;
      g_rec.test_run_id := NULL;
      begin
         finalize;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      --------------------------------------  WTPLSQL Testing --
      g_rec := l_recSAVE;
      wt_assert.eq (
         msg_in          => 'SQLERRM',
         check_this_in   => l_sqlerrm,
         against_this_in => 'ORA-20000: g_rec.test_run_id is null');
   end t_finalize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_run_id
      (in_test_run_id  in number)
is
   l_profiler_runid  number;
begin
   select profiler_runid into l_profiler_runid
    from wt_test_runs where id = in_test_run_id;
   delete_plsql_profiler_recs(l_profiler_runid);
   delete from wt_profiles
    where test_run_id = in_test_run_id;
   delete from wt_dbout_runs
    where test_run_id = in_test_run_id;
exception
   when NO_DATA_FOUND
   then
      return;
end delete_run_id;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_run_id
   is
      c_test_run_id  constant number := -98;
      l_run          wt_dbout_runs%ROWTYPE;
      l_profile      wt_profiles%ROWTYPE;
      l_err_stack    varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Setup';
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs Count 0',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || c_test_run_id,
         against_value_in => 0);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles Count 0',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      tl_insert_test_runs(c_test_run_id, 'Delete Records Test');
      --------------------------------------  WTPLSQL Testing --
      l_profile.test_run_id  := c_test_run_id;
      l_profile.line         := 1;
      l_profile.status       := 'EXEC';
      l_profile.total_occur  := 1;
      l_profile.total_usecs  := 1;
      l_profile.min_usecs    := 1;
      l_profile.max_usecs    := 1;
      l_profile.text         := 'Testing';
      tl_insert_wt_profiles(l_profile);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Happy Path 1';
      begin
         delete_run_id(c_test_run_id);
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in        => 'SQLERRM',
         check_this_in => l_err_stack);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles Count 2',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Sad Path 1';
      begin
         delete_run_id(-9876);
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in        => 'SQLERRM',
         check_this_in => l_err_stack);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles Count 2',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Sad Path 2';
      begin
         delete_run_id(NULL);
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in        => 'SQLERRM',
         check_this_in => l_err_stack);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_profiles Count 2',
         check_query_in   => 'select count(*) from wt_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Teardown';
      tl_delete_test_runs(c_test_run_id);
   end t_delete_run_id;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN
   is
   begin
      wtplsql.g_DBOUT := 'WT_PROFILER:PACKAGE BODY';
      select username into g_current_user from user_users;
      t_get_error_msg;
      t_delete_profiler_recs;
      t_is_profilable;
      t_load_ignr_aa;
      t_insert_wt_profile;
      t_initialize;
      t_finalize;
      t_trigger_offset;
      t_calc_pct_coverage;
      t_delete_run_id;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_profile;
