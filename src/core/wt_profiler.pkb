create or replace package body wt_profiler
as

   TYPE rec_type is record
      (test_run_id     wt_test_runs.id%TYPE
      ,dbout_owner     wt_test_runs.dbout_owner%TYPE
      ,dbout_name      wt_test_runs.dbout_name%TYPE
      ,dbout_type      wt_test_runs.dbout_type%TYPE
      ,prof_runid      binary_integer
      ,trigger_offset  binary_integer
      ,error_message   varchar2(4000));
   g_rec  rec_type;
   
   TYPE anno_aa_type is table
      of varchar2(1)
      index by PLS_INTEGER;
   anno_aa   anno_aa_type;


----------------------
--  Private Procedures
----------------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure compile_db_object
         (in_ptype   in varchar2
         ,in_pname   in varchar2
         ,in_source  in varchar2)
   is
      l_sqlerrm  varchar2(4000);
      l_errtxt   varchar2(32000) := '';
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         execute immediate 'create or replace ' ||
            in_ptype || ' ' || in_pname || ' is ' || CHR(10) ||
            in_source || CHR(10) || 'end ' || in_pname || ';';
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq
         (msg_in          => 'Compile ' || in_ptype || ' ' || in_pname
         ,check_this_in   => l_sqlerrm
         ,against_this_in => 'ORA-0000: normal, successful completion');
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
      wt_assert.objexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => USER,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end compile_db_object;
--==============================================================--
   procedure drop_db_object
      (in_pname  in  varchar2,
       in_ptype  in  varchar2)
   is
      l_sqlerrm  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         execute immediate
            'drop ' || in_ptype || ' ' || in_pname;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq
         (msg_in          => 'Drop ' || in_ptype || ' ' || in_pname
         ,check_this_in   => l_sqlerrm
         ,against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.objnotexists (
         msg_in        => in_pname || ' ' || in_ptype,
         obj_owner_in  => USER,
         obj_name_in   => upper(in_pname),
         obj_type_in   => upper(in_ptype));
   end drop_db_object;
--==============================================================--
   procedure count_plsql_profiler_records
         (in_test_run_id     in number
         ,in_expected_count  in number)
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_runs'
         ,check_query_in   => 'select count(*) from plsql_profiler_runs' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_units'
         ,check_query_in   => 'select count(*) from plsql_profiler_units' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of plsql_profiler_data'
         ,check_query_in   => 'select count(*) from plsql_profiler_data' ||
                              ' where runid = ' || in_test_run_id
         ,against_value_in => in_expected_count);
   end count_plsql_profiler_records;
--==============================================================--
   procedure insert_plsql_profiler_records
         (in_test_run_id     in number)
   is
      l_sqlerrm       varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into plsql_profiler_runs (runid)
                         values (in_test_run_id);
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'insert into plsql_profiler_runs',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into plsql_profiler_units (runid,    unit_number, total_time)
                          values (in_test_run_id, in_test_run_id,          0);
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'insert into plsql_profiler_units',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into plsql_profiler_data (runid,    unit_number, line#)
                         values (in_test_run_id, in_test_run_id,     0);
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'insert into plsql_profiler_data',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
   end insert_plsql_profiler_records;
--==============================================================--
   procedure delete_plsql_profiler_records
         (in_test_run_id     in number)
   is
      l_sqlerrm       varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         delete from plsql_profiler_data
          where runid = in_test_run_id;
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'delete from plsql_profiler_data',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      --------------------------------------  WTPLSQL Testing --
      begin
         delete from plsql_profiler_units
          where runid = in_test_run_id;
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'delete from plsql_profiler_units',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      --------------------------------------  WTPLSQL Testing --
      begin
         delete from plsql_profiler_runs
          where runid = in_test_run_id;
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'delete from plsql_profiler_runs',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      COMMIT;
   end delete_plsql_profiler_records;
--==============================================================--
   procedure insert_test_runs
         (in_test_run_id  in NUMBER)
   is
      l_sqlerrm  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         insert into wt_test_runs
               (id, start_dtm, runner_owner, runner_name)
            values
               (in_test_run_id, sysdate, USER, 'Unit Testing');
         l_sqlerrm := SQLERRM;
         commit;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in        => 'Insert wt_test_runs',
         check_this_in => l_sqlerrm,
         against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 1);
   end insert_test_runs;
--==============================================================--
   procedure delete_test_runs
         (in_test_run_id  in NUMBER)
   is
      l_sqlerrm  varchar2(4000);
   begin
      --------------------------------------  WTPLSQL Testing --
      begin
         delete from wt_test_runs where id = in_test_run_id;
         l_sqlerrm := SQLERRM;
         commit;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in        => 'Delete wt_test_runs',
         check_this_in => l_sqlerrm,
         against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_test_runs Count',
         check_query_in   => 'select count(*) from wt_test_runs' ||
                             ' where id = ' || in_test_run_id,
         against_value_in => 0);
   end delete_test_runs;
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
      wt_assert.isnotnull (
         msg_in        => 'ERROR_IO Test 1',
         check_this_in => get_error_msg(dbms_profiler.error_io));
      wt_assert.this (
         msg_in        => 'ERROR_IO Test 2',
         check_this_in => regexp_like(get_error_msg(dbms_profiler.error_io)
                                     ,'Data flush operation','i'));
      wt_assert.isnotnull (
         msg_in        => 'ERROR_VERSION Test 1',
         check_this_in => get_error_msg(dbms_profiler.error_version));
      wt_assert.this (
         msg_in        => 'ERROR_VERSION Test 2',
         check_this_in => regexp_like(get_error_msg(dbms_profiler.error_version)
                                     ,'incorrect version','i'));
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
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
   delete from plsql_profiler_data
    where runid = in_profiler_runid;
   delete from plsql_profiler_units
    where runid = in_profiler_runid;
   delete from plsql_profiler_runs
    where runid = in_profiler_runid;
   COMMIT;
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
      wt_assert.isnull (
         msg_in          => 'delete_plsql_profiler_recs(' || c_test_run_id || ') 1',
         check_this_in   => l_err_stack);
      count_plsql_profiler_records(c_test_run_id, 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete PL/SQL Profiler Records Happy Path 2';
      insert_plsql_profiler_records(c_test_run_id);
      count_plsql_profiler_records(c_test_run_id, 1);
      begin
         delete_plsql_profiler_recs(c_test_run_id);  -- Should run without error
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      wt_assert.isnull (
         msg_in          => 'delete_plsql_profiler_recs(' || c_test_run_id || ') 2',
         check_this_in   => l_err_stack);
      count_plsql_profiler_records(c_test_run_id, 0);
   end t_delete_profiler_recs;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure find_dbout
      (in_pkg_name  in  varchar2)
is
   C_HEAD_RE CONSTANT varchar2(30) := '--% WTPLSQL SET DBOUT "';
   C_MAIN_RE CONSTANT varchar2(30) := '[[:alnum:]._$#]+';
   C_TAIL_RE CONSTANT varchar2(30) := '" %--';
   --
   -- Head Regular Expression is
   --   '--% WTPLSQL SET DBOUT "' - literal string
   -- Main Regular Expression is
   --   '[[:alnum:]._$#]'         - Any alpha, numeric, ".", "_", "$", or "#" character
   --   +                         - One or more of the previous characters
   -- Tail Regular Expression is
   --   '" %--'                   - literal string
   --
   -- Note: Packages, Procedures, Functions, and Types are in the same namespace
   --       and cannot have the same names.  However, Triggers can have the same
   --       name as any of the other objects.  Results are unknown if a Trigger
   --       name is the same as a Package, Procedure, Function or Type name.
   --
   cursor c_annotation is
      select regexp_substr(src.text, C_HEAD_RE||C_MAIN_RE||C_TAIL_RE)  TEXT
       from  all_source  src
       where src.owner = USER
        and  src.name  = in_pkg_name
        and  src.type  = 'PACKAGE BODY'
        and  regexp_like(src.text, C_HEAD_RE||C_MAIN_RE||C_TAIL_RE)
       order by src.line;
   l_target   varchar2(32000);
   l_pos      number;
begin
   open c_annotation;
   fetch c_annotation into l_target;
   if c_annotation%NOTFOUND
   then
      close c_annotation;
      return;
   end if;
   close c_annotation;
   -- Strip the Head Sub-String
   l_target := regexp_replace(SRCSTR      => l_target
                             ,PATTERN     => '^' || C_HEAD_RE
                             ,REPLACESTR  => ''
                             ,POSITION    => 1
                             ,OCCURRENCE  => 1);
   -- Strip the Tail Sub-String
   l_target := regexp_replace(SRCSTR      => l_target
                             ,PATTERN     => C_TAIL_RE || '$'
                             ,REPLACESTR  => ''
                             ,POSITION    => 1
                             ,OCCURRENCE  => 1);
   -- Locate the Owner/Name separator
   l_pos := instr(l_target,'.');
   begin
      select obj.owner
            ,obj.object_name
            ,obj.object_type
        into g_rec.dbout_owner
            ,g_rec.dbout_name
            ,g_rec.dbout_type
       from  all_objects  obj
       where obj.object_type in ('FUNCTION', 'PROCEDURE', 'PACKAGE BODY',
                                 'TYPE BODY', 'TRIGGER')
        and  (   (    l_pos = 0
                  and obj.owner       = USER
                  and obj.object_name = l_target  )
              OR (    l_pos = 1
                  and obj.owner       = USER
                  and obj.object_name = substr(l_target,2,512) )
              OR (    l_pos > 1
                  and obj.owner       = substr(l_target,1,l_pos-1)
                  and obj.object_name = substr(l_target,l_pos+1,512) ) )
        and  exists (
             select 'x' from all_source src
              where src.owner  = obj.owner
               and  src.name   = obj.object_name
               and  src.type   = obj.object_type );
   exception when NO_DATA_FOUND
   then
      g_rec.error_message := 'Unable to find Database Object "' ||
                              l_target || '". ';
   end;
end find_dbout;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_find_dbout
   is
      l_recSAVE    rec_type;
      l_recNULL    rec_type;
      l_recTEST    rec_type;
      l_pname      varchar2(128) := 'WT_PROFILE_FIND_DBOUT';
      procedure run_find_dbout is begin
         l_recSAVE := g_rec;
         g_rec := l_recNULL;
         find_dbout(l_pname);
         l_recTEST := g_rec;
         g_rec := l_recSAVE;
      end run_find_dbout;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Setup';
      compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '   l_junk number;' );
      l_recTEST := g_rec;
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => USER);
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => $$PLSQL_UNIT);
      wt_assert.eq
         (msg_in        => 'g_rec.dbout_type'
         ,check_this_in => l_recTEST.dbout_type
         ,against_this_in => 'PACKAGE BODY');
      wt_assert.isnull
         (msg_in        => 'g_rec.error_message'
         ,check_this_in => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 1';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 'begin' || CHR(10) || '  l_junk := 1;' );
      run_find_dbout;
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name);
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type);
      wt_assert.isnull
         (msg_in          => 'g_rec.error_message'
         ,check_this_in   => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 2';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT "' || l_pname || '" %--'  || CHR(10) ||
            'begin'                                            || CHR(10) ||
            '  l_junk := 1;'                                   );
      run_find_dbout;
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => USER);
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => l_pname);
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type
         ,against_this_in => 'PACKAGE BODY');
      wt_assert.isnull
         (msg_in        => 'g_rec.error_message'
         ,check_this_in => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Happy Path 3';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT "' || USER ||
                                    '.' || l_pname || '" %--'  || CHR(10) ||
            'begin'                                            || CHR(10) ||
            '  l_junk := 1;'                                   );
      run_find_dbout;
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner
         ,against_this_in => USER);
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name
         ,against_this_in => l_pname);
      wt_assert.eq
         (msg_in          => 'g_rec.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type
         ,against_this_in => 'PACKAGE BODY');
      wt_assert.isnull
         (msg_in        => 'g_rec.error_message'
         ,check_this_in => l_recTEST.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Sad Path 1';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            '  --% WTPLSQL SET DBOUT ' || '"BOGUS1" %--'       || CHR(10) ||
            'begin'                                            || CHR(10) ||
            '  l_junk := 1;'                                   );
      run_find_dbout;
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_owner'
         ,check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_name'
         ,check_this_in   => l_recTEST.dbout_name);
      wt_assert.isnull
         (msg_in          => 'g_rec.dbout_type'
         ,check_this_in   => l_recTEST.dbout_type);
      wt_assert.eq
         (msg_in          => 'g_rec.error_message'
         ,check_this_in   => l_recTEST.error_message
         ,against_this_in => 'Unable to find Database Object "BOGUS1". ');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Find DBOUT Teardown';
      drop_db_object(l_pname, 'package');
   end t_find_dbout;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure load_anno_aa
is
   cursor c_find_begin is
      select line
            ,instr(text,'--%WTPLSQL_begin_ignore_lines%--') col
       from  all_source
       where owner = g_rec.dbout_owner
        and  name  = g_rec.dbout_name
        and  type  = g_rec.dbout_type
        and  text like '%--\%WTPLSQL_begin_ignore_lines\%--%' escape '\'
       order by line;
   buff_find_begin  c_find_begin%ROWTYPE;
   cursor c_find_end (in_line in number, in_col in number) is
      with q1 as (
      select line
            ,instr(text,'--%WTPLSQL_end_ignore_lines%--') col
       from  all_source
       where owner = g_rec.dbout_owner
        and  name  = g_rec.dbout_name
        and  type  = g_rec.dbout_type
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
   anno_aa.delete;
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
          from  all_source
          where owner = g_rec.dbout_owner
           and  name  = g_rec.dbout_name
           and  type  = g_rec.dbout_type;
      end if;
      close c_find_end;
      for i in buff_find_begin.line + g_rec.trigger_offset ..
               buff_find_end.line   + g_rec.trigger_offset
      loop
         anno_aa(i) := 'X';
      end loop;
   end loop;
   close c_find_begin;
end load_anno_aa;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_load_anno_aa
   is
      l_recSAVE    rec_type;
      l_annoSAVE   anno_aa_type;
      l_annoTEST   anno_aa_type;
      l_pname      varchar2(128) := 'WT_PROFILE_LOAD_ANNO';
      --------------------------------------  WTPLSQL Testing --
      procedure run_load_anno is begin
         l_recSAVE  := g_rec;
         l_annoSAVE := anno_aa;
         anno_aa.delete;
         g_rec.dbout_owner := USER;
         g_rec.dbout_name  := l_pname;
         g_rec.dbout_type  := 'PACKAGE BODY';
         load_anno_aa;
         l_annoTEST := anno_aa;
         anno_aa := l_annoSAVE;
         g_rec   := l_recSAVE;
      end run_load_anno;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Setup';
      wt_assert.isnotnull
         (msg_in    => 'Number of ANNO_AA elements'
         ,check_this_in => anno_aa.COUNT);
      compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '  l_junk number;' );
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Happy Path 1';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 'begin' || CHR(10) || '  l_junk := 1;' );
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Happy Path 2';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 3
            '  l_junk := 1;'                           );             -- Line 4
            -- end                                                    -- Line 5
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 3);
      for i in 3 .. 5
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Happy Path 3';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           );             -- Line 7
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 3);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Happy Path 4';
      compile_db_object
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
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 6);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      for i in 8 .. 10
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Sad Path 1';
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 3
            '  l_junk := 4;'                           );             -- Line 4
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Sad Path 2';
      compile_db_object
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
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 3);
      for i in 4 .. 6
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Sad Path 3';
      compile_db_object
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
      run_load_anno;
      wt_assert.eq
         (msg_in          => 'l_annoTest.COUNT'
         ,check_this_in   => l_annoTest.COUNT
         ,against_this_in => 5);
      for i in 4 .. 8
      loop
         wt_assert.eq
            (msg_in          => 'l_annoTest.exists(' || i || ')'
            ,check_this_in   => l_annoTest.exists(i)
            ,against_this_in => TRUE);
      end loop;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Load Anno Teardown';
      drop_db_object(l_pname, 'package');
      wt_assert.isnotnull
         (msg_in    => 'Number of ANNO_AA elements'
         ,check_this_in => anno_aa.COUNT);
   end t_load_anno_aa;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure insert_dbout_profile
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   prof_rec    wt_dbout_profiles%ROWTYPE;
   l_max_line  number;
   procedure l_set_status is begin
      if anno_aa.EXISTS(prof_rec.line)
      then
         -- Found Annotated Statement
         prof_rec.status := 'ANNO';
         return;
      end if;
      if prof_rec.total_occur > 0
      then
         -- Found Executed Statement
         prof_rec.status := 'EXEC';
         return;
      end if;
      if    prof_rec.total_occur = 0
        and prof_rec.total_time  = 0
      then
         -- Check for declaration if Not Executed
         if regexp_like(prof_rec.text, '^[[:space:]]*' ||
                       '(FUNCTION|PROCEDURE|PACKAGE|TYPE|TRIGGER)' ||
                       '[[:space:]]', 'i')
         then
            -- Exclude declarations if Not Executed
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
   prof_rec.test_run_id := g_rec.test_run_id;
   load_anno_aa;
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
             join all_source  src
                  on  src.line  = ppd.line# + g_rec.trigger_offset
                  and src.owner = g_rec.dbout_owner
                  and src.name  = g_rec.dbout_name
                  and src.type  = g_rec.dbout_type
       where ppu.unit_owner = g_rec.dbout_owner
        and  ppu.unit_name  = g_rec.dbout_name
        and  ppu.unit_type  = g_rec.dbout_type
        and  ppu.runid      = g_rec.prof_runid )
   loop
      prof_rec.line        := buf1.line;
      prof_rec.total_occur := buf1.total_occur;
      prof_rec.total_time  := buf1.total_time;
      prof_rec.min_time    := buf1.min_time;
      prof_rec.max_time    := buf1.max_time;
      prof_rec.text        := buf1.text;
      prof_rec.status      := NULL;
      l_set_status;
      l_max_line := buf1.line;
      insert into wt_dbout_profiles values prof_rec;
   end loop;
   -- Exclude the last line if Not Executed
   update wt_dbout_profiles
     set  status = 'EXCL'
    where test_run_id = g_rec.test_run_id
     and  line        = l_max_line
     and  status      = 'NOTX'
     and  regexp_like(text, 'END', 'i');
   COMMIT;
   -- Delete PLSQL Profiler has it's own
   --   PRAGMA AUTONOMOUS_TRANSACTION and COMMIT;
   anno_aa.delete;
   delete_plsql_profiler_recs(g_rec.prof_runid);
end insert_dbout_profile;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_insert_dbout_profile
   is
      units_rec      plsql_profiler_units%ROWTYPE;
      data_rec       plsql_profiler_data%ROWTYPE;
      l_recSAVE      rec_type;
      l_recNULL      rec_type;
      c_test_run_id  constant number := -97;
      l_pname        varchar2(128) := 'WT_PROFILE_INSERT_DBOUT';
      l_sqlerrm      varchar2(4000);
      l_err_stack    varchar2(32000);
      procedure insert_data is begin
      begin
         insert into plsql_profiler_data values data_rec;
         commit;
         l_sqlerrm := SQLERRM;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in          => 'insert into plsql_profiler_data',
         check_this_in   => SQLERRM,
         against_this_in => 'ORA-0000: normal, successful completion');
      end insert_data;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Setup';
      compile_db_object
         (in_ptype   => 'package'
         ,in_pname   => l_pname
         ,in_source  => '  l_junk number;' );
      compile_db_object
         (in_ptype   => 'package body'
         ,in_pname   => l_pname
         ,in_source  => 
            'begin'                                    || CHR(10) ||  -- Line 2
            '  l_junk := 1;'                           || CHR(10) ||  -- Line 3
            '  --%WTPLSQL_begin_' || 'ignore_lines%--' || CHR(10) ||  -- Line 4
            '  l_junk := 2;'                           || CHR(10) ||  -- Line 5
            '  --%WTPLSQL_end_' || 'ignore_lines%--'   || CHR(10) ||  -- Line 6
            '  l_junk := 3;'                           );             -- Line 7
      insert_plsql_profiler_records(c_test_run_id);
      count_plsql_profiler_records(c_test_run_id, 1);
      insert_test_runs(c_test_run_id);
      --------------------------------------  WTPLSQL Testing --
      units_rec.runid        := c_test_run_id;
      units_rec.unit_number  := 1;
      units_rec.unit_owner   := USER;
      units_rec.unit_name    := upper(l_pname);
      units_rec.unit_type    := 'PACKAGE BODY';
      units_rec.total_time   := 0;
      begin
         insert into plsql_profiler_units values units_rec;
         commit;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
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
      --
      data_rec.line#       := 1;
      data_rec.total_occur := 0;
      data_rec.total_time  := 0;
      insert_data;
      --
      data_rec.line#       := 2;
      data_rec.total_occur := 0;
      data_rec.total_time  := 0;
      insert_data;
      --
      data_rec.line#       := 3;
      data_rec.total_occur := 1;
      data_rec.total_time  := 1;
      insert_data;
      --
      data_rec.line#       := 5;
      data_rec.total_occur := 1;
      data_rec.total_time  := 1;
      insert_data;
      --
      data_rec.line#       := 7;
      data_rec.total_occur := 1;
      data_rec.total_time  := 1;
      insert_data;
      --
      data_rec.line#       := 8;
      data_rec.total_occur := 0;
      data_rec.total_time  := 0;
      insert_data;
      --
      wt_assert.eqqueryvalue
         (msg_in           => 'Number of UNIT 1 plsql_profiler_data'
         ,check_query_in   => 'select count(*) from plsql_profiler_data' ||
                              ' where runid = ' || c_test_run_id ||
                              ' and unit_number = 1'
         ,against_value_in => 6);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Happy Path';
      l_recSAVE := g_rec;
      g_rec.test_run_id     := c_test_run_id;
      g_rec.dbout_owner     := USER;
      g_rec.dbout_name      := upper(l_pname);
      g_rec.dbout_type      := 'PACKAGE BODY';
      g_rec.prof_runid      := c_test_run_id;
      g_rec.trigger_offset  := 0;
      g_rec.error_message   := '';
      begin
         insert_dbout_profile;
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      g_rec := l_recSAVE;
      wt_assert.isnull (
         msg_in          => 'SQLERRM',
         check_this_in   => l_err_stack);
      wt_assert.eq (
         msg_in          => 'anno_aa.COUNT',
         check_this_in   => anno_aa.COUNT,
         against_this_in => 3);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Insert DBOUT Profile Teardown';
      delete_test_runs(c_test_run_id);
      delete_plsql_profiler_records(c_test_run_id);
      count_plsql_profiler_records(c_test_run_id, 0);
   end t_insert_dbout_profile;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure initialize
      (in_test_run_id      in  number,
       in_runner_name      in  varchar2,
       out_dbout_owner     out varchar2,
       out_dbout_name      out varchar2,
       out_dbout_type      out varchar2,
       out_trigger_offset  out number,
       out_profiler_runid  out number,
       out_error_message   out varchar2)
is
   l_rec_NULL     rec_type;
   l_retnum       binary_integer;
begin
   out_dbout_owner     := '';
   out_dbout_name      := '';
   out_dbout_type      := '';
   out_trigger_offset  := NULL;
   out_profiler_runid  := NULL;
   out_error_message   := '';
   g_rec := l_rec_NULL;
   if in_test_run_id is null
   then
      raise_application_error  (-20004, 'i_test_run_id is null');
   end if;
   g_rec.test_run_id := in_test_run_id;
   find_dbout(in_pkg_name => in_runner_name);
   if g_rec.dbout_name is null
   then
      return;
   end if;
   out_dbout_owner    := g_rec.dbout_owner;
   out_dbout_name     := g_rec.dbout_name;
   out_dbout_type     := g_rec.dbout_type;
   out_error_message  := g_rec.error_message;
   g_rec.trigger_offset := wt_profiler.trigger_offset
                              (dbout_owner_in => g_rec.dbout_owner
                              ,dbout_name_in  => g_rec.dbout_name
                              ,dbout_type_in  => g_rec.dbout_type );
   out_trigger_offset := g_rec.trigger_offset;
   l_retnum := dbms_profiler.INTERNAL_VERSION_CHECK;
   if l_retnum <> 0 then
      --dbms_profiler.get_version(major_version, minor_version);
      raise_application_error(-20005,
         'dbms_profiler.INTERNAL_VERSION_CHECK returned: ' || get_error_msg(l_retnum));
   end if;
   -- This starts the PROFILER Running!!!
   l_retnum := dbms_profiler.START_PROFILER(run_number => g_rec.prof_runid);
   if l_retnum <> 0 then
      raise_application_error(-20006,
         'dbms_profiler.START_PROFILER returned: ' || get_error_msg(l_retnum));
   end if;
   out_profiler_runid := g_rec.prof_runid;
end initialize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_initialize
   is
      c_test_run_id   constant number := -96;
      l_recSAVE       rec_type;
      l_recTEST       rec_type;
      l_recOUT        rec_type;
      l_err_stack     varchar2(32000);
   begin
      --------------------------------------  WTPLSQL Testing --
/*
      wt_assert.g_testcase := 'Initialize Test HAPPY Path 1';
      l_recSAVE := g_rec;
      initialize
         (in_test_run_id      => c_test_run_id,
          in_runner_name      => 'Happy Path 1',
          out_dbout_owner     => l_recOUT.dbout_owner,
          out_dbout_name      => l_recOUT.dbout_name,
          out_dbout_type      => l_recOUT.dbout_type,
          out_trigger_offset  => l_recOUT.trigger_offset,
          out_profiler_runid  => l_recOUT.prof_runid,
          out_error_message   => l_recOUT.error_message);
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
*/
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Initialize Test Sad Path 1';
      l_recSAVE := g_rec;
      begin
         initialize
            (in_test_run_id      => null,
             in_runner_name      => 'Sad Path 1',
             out_dbout_owner     => l_recOUT.dbout_owner,
             out_dbout_name      => l_recOUT.dbout_name,
             out_dbout_type      => l_recOUT.dbout_type,
             out_trigger_offset  => l_recOUT.trigger_offset,
             out_profiler_runid  => l_recOUT.prof_runid,
             out_error_message   => l_recOUT.error_message);
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      l_recTEST := g_rec;
      g_rec := l_recSAVE;
      wt_assert.isnull (
         msg_in          => 'SQLERRM',
         check_this_in   => l_err_stack);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'OUT dbout_owner',
         check_this_in   => l_recOUT.dbout_owner);
      wt_assert.isnull (
         msg_in          => 'OUT dbout_name',
         check_this_in   => l_recOUT.dbout_name);
      wt_assert.isnull (
         msg_in          => 'OUT dbout_type',
         check_this_in   => l_recOUT.dbout_type);
      wt_assert.isnull (
         msg_in          => 'OUT prof_runid',
         check_this_in   => l_recOUT.prof_runid);
      wt_assert.isnull (
         msg_in          => 'OUT trigger_offset',
         check_this_in   => l_recOUT.trigger_offset);
      wt_assert.isnull (
         msg_in          => 'OUT error_message',
         check_this_in   => l_recOUT.error_message);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'g_rec.dbout_owner',
         check_this_in   => l_recTEST.dbout_owner);
      wt_assert.isnull (
         msg_in          => 'g_rec.dbout_name',
         check_this_in   => l_recTEST.dbout_name);
      wt_assert.isnull (
         msg_in          => 'g_rec.dbout_type',
         check_this_in   => l_recTEST.dbout_type);
      wt_assert.isnull (
         msg_in          => 'g_rec.prof_runid',
         check_this_in   => l_recTEST.prof_runid);
      wt_assert.isnull (
         msg_in          => 'g_rec.trigger_offset',
         check_this_in   => l_recTEST.trigger_offset);
      wt_assert.isnull (
         msg_in          => 'g_rec.error_message',
         check_this_in   => l_recTEST.error_message);
   end t_initialize;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- Because this procedure is called to cleanup after erorrs,
--  it must be able to run multiple times without causing damage.
procedure finalize
is
   l_rec_NULL  rec_type;
begin
   if g_rec.dbout_name is null
   then
      return;
   end if;
   if g_rec.test_run_id is null
   then
      raise_application_error  (-20000, 'g_rec.test_run_id is null');
   end if;
   -- DBMS_PROFILER.FLUSH_DATA is included with DBMS_PROFILER.STOP_PROFILER
   dbms_profiler.STOP_PROFILER;
   insert_dbout_profile;
   g_rec := l_rec_NULL;
end finalize;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_finalize
   is
   begin
      wt_assert.g_testcase := 'Finalize Test';
      --------------------------------------  WTPLSQL Testing --
   end t_finalize;
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
      select line, text from all_source
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
      wt_assert.g_testcase := 'Trigger Offset Test';
      --------------------------------------  WTPLSQL Testing --
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
       from  wt_dbout_profiles  p
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
   begin
      wt_assert.g_testcase := 'Calculate Percentage Offset';
      --------------------------------------  WTPLSQL Testing --
   end t_calc_pct_coverage;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure delete_records
      (in_test_run_id  in number)
is
   l_profiler_runid  number;
begin
   select profiler_runid into l_profiler_runid
    from wt_test_runs where id = in_test_run_id;
   delete_plsql_profiler_recs(l_profiler_runid);
   delete from wt_dbout_profiles
    where test_run_id = in_test_run_id;
exception
   when NO_DATA_FOUND
   then
      return;
end delete_records;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_delete_records
   is
      c_test_run_id  constant number := -98;
      l_rec          wt_dbout_profiles%ROWTYPE;
      l_num_recs     number;
      l_sqlerrm      varchar2(4000);
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
         msg_in           => 'wt_dbout_profiles Count 0',
         check_query_in   => 'select count(*) from wt_dbout_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      insert_test_runs(c_test_run_id);
      --------------------------------------  WTPLSQL Testing --
      l_rec.test_run_id  := c_test_run_id;
      l_rec.line         := 1;
      l_rec.status       := 'EXEC';
      l_rec.total_occur  := 1;
      l_rec.total_time   := 1;
      l_rec.min_time     := 1;
      l_rec.max_time     := 1;
      l_rec.text         := 'Testing';
      begin
         insert into wt_dbout_profiles values l_rec;
         l_sqlerrm := SQLERRM;
         commit;
      exception when others then
         l_sqlerrm := SQLERRM;
      end;
      wt_assert.eq (
         msg_in        => 'Insert 2',
         check_this_in => l_sqlerrm,
         against_this_in => 'ORA-0000: normal, successful completion');
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_dbout_profiles Count 1',
         check_query_in   => 'select count(*) from wt_dbout_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Happy Path 1';
      begin
         delete_records(c_test_run_id);
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      exception when others then
         l_err_stack := dbms_utility.format_error_stack     ||
                        dbms_utility.format_error_backtrace ;
      end;
      wt_assert.isnull (
         msg_in        => 'SQLERRM',
         check_this_in => l_err_stack);
      wt_assert.eqqueryvalue (
         msg_in           => 'wt_dbout_profiles Count 2',
         check_query_in   => 'select count(*) from wt_dbout_profiles' ||
                             ' where test_run_id = ' || c_test_run_id,
         against_value_in => 0);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Delete Records Teardown';
      delete_test_runs(c_test_run_id);
   end t_delete_records;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure WTPLSQL_RUN  --% WTPLSQL SET DBOUT "WT_PROFILER" %--
   is
   begin
      t_get_error_msg;
      t_delete_profiler_recs;
      t_find_dbout;
      t_load_anno_aa;
      t_insert_dbout_profile;
      t_initialize;
      t_finalize;
      t_trigger_offset;
      t_calc_pct_coverage;
      t_delete_records;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_profiler;
