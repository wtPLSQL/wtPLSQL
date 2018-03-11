create or replace package body wt_assert is

   -- See (public) RESET_GLOBALS procedure for default global values
   TYPE g_rec_type is record
      (last_pass        boolean
      ,last_assert      wt_results.assertion%TYPE
      ,last_msg         wt_results.message%TYPE
      ,last_details     wt_results.details%TYPE);
   g_rec  g_rec_type;

----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
function boolean_to_status
      (in_boolean  in boolean)
   return varchar2
is
begin
   if in_boolean is null
   then
      return '';
   elsif in_boolean
   then
      return C_PASS;
   end if;
   return C_FAIL;
end boolean_to_status;

------------------------------------------------------------
procedure process_assertion
is
begin
   wt_result.save
      (in_assertion      => g_rec.last_assert
      ,in_status         => case g_rec.last_pass
                            when TRUE then C_PASS
                                      else C_FAIL
                            end
      ,in_details        => g_rec.last_details
      ,in_testcase       => g_testcase
      ,in_message        => g_rec.last_msg);
   if g_raise_exception and not g_rec.last_pass
   then
      raise_application_error(-20003, wt_text_report.format_test_result
                                         (in_assertion      => g_rec.last_assert
                                         ,in_status         => C_FAIL
                                         ,in_details        => g_rec.last_details
                                         ,in_testcase       => g_testcase
                                         ,in_message        => g_rec.last_msg) );
   end if;
end process_assertion;

------------------------------------------------------------
procedure compare_queries (
      check_query_in     in   varchar2,
      against_query_in   in   varchar2)
is
   l_ret_txt    varchar2(10);
   l_qry_txt    varchar2(32000);
   l_exec_txt   varchar2(32767);
begin
   -- Define Query for the Comparison
   l_qry_txt := 'with check_query as (' || check_query_in   ||
                '), against_query as (' || against_query_in ||
                '), q1 as (select * from check_query'       ||
                   ' MINUS select * from against_query'     ||
                '), q2 as (select * from against_query'     ||
                   ' MINUS select * from check_query'       ||
                ') select * from q1 UNION select * from q2' ;
   ----------------------------------------
   -- Define EXECUTE IMMEDIATE text
   l_exec_txt :=
'declare
   cursor cur is ' || l_qry_txt || ';
   rec cur%rowtype;
begin     
   open cur;
   fetch cur into rec;
	:ret_txt := case cur%FOUND when TRUE then ''FOUND''
                              else ''NOTFOUND'' end;
   close cur;
end;';
   ----------------------------------------
   -- Run the Comparison
   execute immediate l_exec_txt using out l_ret_txt;
   if l_ret_txt = 'FOUND'
   then
      g_rec.last_pass := FALSE; -- Some Difference Found
   else
      g_rec.last_pass := TRUE;  -- Nothing found, queries match
   end if;
   -- No Exceptions Raised
   g_rec.last_details := 'Comparison Query: ' || l_qry_txt;
exception
   when OTHERS
   then
      g_rec.last_details := SQLERRM || CHR(10) ||
                            'FAILURE of Compare Query: ' || l_qry_txt || ';';
      g_rec.last_pass    := FALSE;
end compare_queries;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function last_pass
   return boolean
is
begin
   return g_rec.last_pass;
end last_pass;

------------------------------------------------------------
function last_assert
   return wt_results.assertion%TYPE
is
begin
   return g_rec.last_assert;
end last_assert;

------------------------------------------------------------
function last_msg
   return wt_results.message%TYPE
is
begin
   return g_rec.last_msg;
end last_msg;

------------------------------------------------------------
function last_details
   return wt_results.details%TYPE
is
begin
   return g_rec.last_details;
end last_details;

------------------------------------------------------------
procedure reset_globals
is
begin
   g_raise_exception   := FALSE;
   g_testcase          := '';
   g_rec.last_pass     := NULL;
   g_rec.last_assert   := '';
   g_rec.last_msg      := '';
   g_rec.last_details  := '';
end reset_globals;

------------------------------------------------------------
function get_NLS_DATE_FORMAT
      return varchar2
is
   l_format   varchar2(50);
begin
   select value into l_format
    from  nls_session_parameters
    where parameter in 'NLS_DATE_FORMAT';
   return l_format;
end get_NLS_DATE_FORMAT;

------------------------------------------------------------
procedure set_NLS_DATE_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS')
is
begin
   execute immediate 'alter session set NLS_DATE_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_DATE_FORMAT;

------------------------------------------------------------
function get_NLS_TIMESTAMP_FORMAT
      return varchar2
is
   l_format   varchar2(50);
begin
   select value into l_format
    from  nls_session_parameters
    where parameter in 'NLS_TIMESTAMP_FORMAT';
   return l_format;
end get_NLS_TIMESTAMP_FORMAT;

------------------------------------------------------------
procedure set_NLS_TIMESTAMP_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6')
is
begin
   execute immediate 'alter session set NLS_TIMESTAMP_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_TIMESTAMP_FORMAT;

------------------------------------------------------------
function get_NLS_TIMESTAMP_TZ_FORMAT
      return varchar2
is
   l_format   varchar2(50);
begin
   select value into l_format
    from  nls_session_parameters
    where parameter in 'NLS_TIMESTAMP_TZ_FORMAT';
   return l_format;
end get_NLS_TIMESTAMP_TZ_FORMAT;

------------------------------------------------------------
procedure set_NLS_TIMESTAMP_TZ_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6 +TZH:TZM')
is
begin
   execute immediate 'alter session set NLS_TIMESTAMP_TZ_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_TIMESTAMP_TZ_FORMAT;


------------------------
--  Assertion Procedures
------------------------

------------------------------------------------------------
procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'THIS';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    :=    (    null_ok_in = FALSE
                             AND nvl(check_this_in,'FALSE') )
                         OR (    null_ok_in = TRUE
                             AND check_this_in is null
                             AND );
   g_rec.last_details := 'Expected "'  || C_PASS ||
                         '" and got "' || boolean_to_status(check_this_in) || '"';
   process_assertion;
   wt_profiler.resume;
end this;

------------------------------------------------------------
-- EQ: string overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   varchar2,
   against_this_in   in   varchar2,
   null_ok_in        in   boolean := false)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'EQ';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (   nvl(check_this_in = against_this_in, false)
                          or (    check_this_in is null
                              and against_this_in is null
                              and null_ok_in              )
                         );
   g_rec.last_details := 'Expected "'  || against_this_in ||
                         '" and got "' || check_this_in   ||
                         '"';
   process_assertion;
   wt_profiler.resume;
end eq;

------------------------------------------------------------
-- EQ: boolean overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   boolean,
   against_this_in   in   boolean,
   null_ok_in        in   boolean := false)
is
begin
   eq (msg_in           => msg_in
      ,check_this_in    => boolean_to_status(check_this_in)
      ,against_this_in  => boolean_to_status(against_this_in)
      ,null_ok_in       => null_ok_in);
end eq;

------------------------------------------------------------
-- ISNOTNULL string overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   g_rec.last_details := 'Expected NOT NULL and got "' ||
                          check_this_in || '"';
   process_assertion;
   wt_profiler.resume;
end isnotnull;

------------------------------------------------------------
-- ISNOTNULL boolean overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnotnull (msg_in        => msg_in
             ,check_this_in => boolean_to_status(check_this_in));
end isnotnull;

------------------------------------------------------------
-- ISNULL string overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   g_rec.last_details := 'Expected NULL and got "' ||
                          check_this_in || '"';
   process_assertion;
   wt_profiler.resume;
end isnull;

------------------------------------------------------------
-- ISNULL boolean overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnull (msg_in        => msg_in
          ,check_this_in => boolean_to_status(check_this_in));
end isnull;

------------------------------------------------------------
--  Check a given call raises an exception
procedure raises (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   varchar2)
is
   l_sqlerrm    varchar2(4000);
   l_errstack   varchar2(4000);
begin
   wt_profiler.pause;
   --
   g_rec.last_assert  := 'RAISES';
   g_rec.last_msg     := msg_in;
   --
   begin
      execute immediate 'begin ' || check_call_in || '; end;';
   exception when OTHERS then
      l_sqlerrm := SQLERRM;
      l_errstack := substr(dbms_utility.format_error_stack  ||
                           dbms_utility.format_error_backtrace
                           ,1,4000);
   end;
   if l_sqlerrm like '%' || against_exc_in || '%'
   then
      g_rec.last_pass := TRUE;
   else
      g_rec.last_pass := FALSE;
   end if;
   --
   g_rec.last_details := 'Expected exception "%'           || against_exc_in ||
                       '%". Actual exception raised was "' || l_errstack     ||
                               '". Exception raised by: '  || check_call_in  ;
   process_assertion;
   wt_profiler.resume;
end raises;

------------------------------------------------------------
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   varchar2,
      null_ok_in         in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     varchar2 (32000);
begin
   wt_profiler.pause;
   --
   g_rec.last_assert  := 'EQQUERYVALUE';
   g_rec.last_msg     := msg_in;
   --
   open l_rc for check_query_in;
   fetch l_rc into l_rc_buff;
   close l_rc;
   --
   g_rec.last_pass    := (   l_rc_buff = against_value_in
                      or (    l_rc_buff is null
                          and against_value_in is null
                          and null_ok_in               )  );
   g_rec.last_details := 'Expected "' || against_value_in ||
                    '" and got "' || l_rc_buff        ||
                  '" for Query: ' || check_query_in   ;
   --
   process_assertion;
   wt_profiler.resume;
   --
end eqqueryvalue;

------------------------------------------------------------
procedure eqquery (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_query_in   in   varchar2)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'EQQUERY';
   g_rec.last_msg     := msg_in;
   compare_queries(check_query_in, against_query_in);
   process_assertion;
   wt_profiler.resume;
end eqquery;

------------------------------------------------------------
procedure eqtable (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null)
is
   l_check_query    varchar2(16000) := 'select * from ' || check_this_in;
   l_against_query  varchar2(16000) := 'select * from ' || against_this_in;
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'EQTABLE';
   g_rec.last_msg     := msg_in;
   if check_where_in is not null
   then
      l_check_query := l_check_query || ' where ' || check_where_in;
   end if;
   if against_where_in is not null
   then
      l_against_query := l_against_query || ' where ' || against_where_in;
   end if;
   compare_queries(l_check_query, l_against_query);
   process_assertion;
   wt_profiler.resume;
end eqtable;

------------------------------------------------------------
procedure eqtabcount (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null)
is
   l_query      varchar2(16000) := 'select count(*) from ' || check_this_in;
   l_cnt        number;
   l_success    boolean;
   l_check_cnt  number;
   procedure run_query is
      type rc_type is ref cursor;
      l_rc rc_type;
   begin
      open l_rc for l_query;
      fetch l_rc into l_cnt;
      close l_rc;
      l_success := TRUE;
   exception
      when OTHERS
      then
         g_rec.last_details := SQLERRM || CHR(10) ||
                           'FAILURE of Compare Query: ' || l_query || ';';
         g_rec.last_pass    := FALSE;
         l_success      := FALSE;
         process_assertion;
         wt_profiler.resume;
   end run_query;
begin
   wt_profiler.pause;
   --
   g_rec.last_assert  := 'EQTABCOUNT';
   g_rec.last_msg     := msg_in;
   --
   l_query := 'select count(*) from ' || check_this_in;
   if check_where_in is not null
   then
      l_query := l_query || ' where ' || check_where_in;
   end if;
   run_query;
   if NOT l_success then return; end if;
   l_check_cnt := l_cnt;
   --
   l_query := 'select count(*) from ' || against_this_in;
   if against_where_in is not null
   then
      l_query := l_query || ' where ' || against_where_in;
   end if;
   run_query;
   if NOT l_success then return; end if;
   g_rec.last_pass    := (l_check_cnt = l_cnt);
   --
   g_rec.last_details := 'Expected '  || l_cnt       || ' rows from "' || against_this_in ||
                     '" and got ' || l_check_cnt || ' rows from "' || check_this_in   ||
                     '"';
   process_assertion;
   wt_profiler.resume;
end eqtabcount;

------------------------------------------------------------
procedure objexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2)
is
   l_num_objects  number;
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'OBJEXISTS';
   g_rec.last_msg     := msg_in;
   select count(*) into l_num_objects
    from  all_objects
    where object_name = obj_name_in
     and  (   obj_owner_in is null
           or obj_owner_in = owner);
   g_rec.last_pass    := case l_num_objects when 0 then FALSE else TRUE end;
   g_rec.last_details := 'Number of objects found for "' ||
                         case when obj_owner_in is null then ''
                              else obj_owner_in || '.' end ||
                         obj_name_in || '" is ' || l_num_objects;
   process_assertion;
   wt_profiler.resume;
end objexists;

------------------------------------------------------------
procedure objexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2)
is
   l_pos    number := instr(check_this_in, '.');
begin
   objexists(msg_in       => msg_in
            ,obj_owner_in => substr(check_this_in, 1, l_pos-1)
            ,obj_name_in  => substr(check_this_in, l_pos+1, length(check_this_in)));
end objexists;

------------------------------------------------------------
procedure objnotexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2)
is
   l_num_objects  number;
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'OBJNOTEXISTS';
   g_rec.last_msg     := msg_in;
   select count(*) into l_num_objects
    from  all_objects
    where object_name = obj_name_in
     and  (   obj_owner_in is null
           or obj_owner_in = owner);
   g_rec.last_pass    := case l_num_objects when 0 then TRUE else FALSE end;
   g_rec.last_details := 'Number of objects found for "' ||
                      case when obj_owner_in is null then ''
                           else obj_owner_in || '.' end ||
                      obj_name_in || '" is ' || l_num_objects;
   process_assertion;
   wt_profiler.resume;
end objnotexists;

------------------------------------------------------------
procedure objnotexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2)
is
   l_pos    number := instr(check_this_in, '.');
begin
   objnotexists(msg_in       => msg_in
               ,obj_owner_in => substr(check_this_in, 1, l_pos-1)
               ,obj_name_in  => substr(check_this_in, l_pos+1, length(check_this_in)));
end objnotexists;


--==============================================================--
--===============--%WTPLSQL_begin_ignore_lines%--===============--
--==============================================================--
--  Embedded Test Procedures

$IF $$WTPLSQL_SELFTEST
$THEN

--====================================--
procedure tc_boolean_to_status
is
   temp_boolean  boolean;
begin
   g_testcase := 'BOOLEAN_TO_STATUS';
   eq
      (msg_in            => 'Test for "TRUE" conversion'
      ,check_this_in     => boolean_to_status(TRUE)
      ,against_this_in   => C_PASS);
   eq
      (msg_in            => 'Test for "FALSE" conversion'
      ,check_this_in     => boolean_to_status(FALSE)
      ,against_this_in   => C_FAIL);
   temp_boolean := NULL;
   isnull
      (msg_in            => 'Test for NULL'
      ,check_this_in     => boolean_to_status(temp_boolean));
end tc_boolean_to_status;

--====================================--
procedure tc_process_assertion
is
   ASSERT_TEST_EXCEPTION  exception;
   PRAGMA EXCEPTION_INIT(ASSERT_TEST_EXCEPTION, -20003);
begin
   g_testcase := 'PROCESS_ASSERTION';
   g_raise_exception := TRUE;
   g_rec.last_assert  := 'THIS';
   g_rec.last_pass    := FALSE;
   g_rec.last_details := 'Expected "PASS" and got "FAIL"';
   g_rec.last_msg     := 'Process Assertion Forced Failure';
   process_assertion;
   g_raise_exception := FALSE;
exception
   when ASSERT_TEST_EXCEPTION then
      eq
         (msg_in          => 'Process Assertion Actual Test'
         ,check_this_in   => replace(SQLERRM,CHR(10),' ')
         ,against_this_in => replace('ORA-20003:    --  Test Case: PROCESS_ASSERTION  --
#FAIL#Process Assertion Forced Failure. THIS - Expected "PASS" and got "FAIL"',CHR(10),' '));
      g_raise_exception := FALSE;
end tc_process_assertion;

--====================================--
procedure tc_setters_and_getters
is
   temp_rec          g_rec_type;
   temp_testcase     VARCHAR2(4000);
   temp_raise_excpt  BOOLEAN;
begin
   reset_globals;  -- Resets g_testcase
   temp_rec         := g_rec;
   temp_raise_excpt := g_raise_exception;
   temp_testcase    := g_testcase;
   g_testcase       := 'Setter and Getters';
   -- Check G_REC values
   isnull(
      msg_in        => 'g_testcase is null',
      check_this_in => temp_testcase);
   eq(
      msg_in          => 'g_raise_exception is FALSE',
      check_this_in   => temp_raise_excpt,
      against_this_in => FALSE);
   isnull
      (msg_in        => 'g_rec.last_pass is null'
      ,check_this_in => temp_rec.last_pass);
   isnull
      (msg_in        => 'g_rec.last_assert is null'
      ,check_this_in => temp_rec.last_assert);
   isnull
      (msg_in        => 'g_rec.last_msg is null'
      ,check_this_in => temp_rec.last_msg);
   isnull
      (msg_in        => 'g_rec.last_details is null'
      ,check_this_in => temp_rec.last_details);
   -- Check NLS Values
   set_NLS_DATE_FORMAT('DD-MON-YYYY');
   eq
      (msg_in          => 'Check get_NLS_DATE_FORMAT 1'
      ,check_this_in   => get_NLS_DATE_FORMAT
      ,against_this_in => 'DD-MON-YYYY');
   set_NLS_DATE_FORMAT;
   eq
      (msg_in          => 'Check get_NLS_DATE_FORMAT 2'
      ,check_this_in   => get_NLS_DATE_FORMAT
      ,against_this_in => 'DD-MON-YYYY HH24:MI:SS');
   set_NLS_TIMESTAMP_FORMAT('DD-MON-YYYY');
   eq
      (msg_in          => 'Check get_NLS_TIMESTAMP_FORMAT 2'
      ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
      ,against_this_in => 'DD-MON-YYYY');
   set_NLS_TIMESTAMP_FORMAT;
   eq
      (msg_in          => 'Check get_NLS_TIMESTAMP_FORMAT 2'
      ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
      ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6');
   set_NLS_TIMESTAMP_TZ_FORMAT('DD-MON-YYYY');
   eq
      (msg_in          => 'Check get_NLS_TIMESTAMP_TZ_FORMAT 2'
      ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
      ,against_this_in => 'DD-MON-YYYY');
   set_NLS_TIMESTAMP_TZ_FORMAT;
   eq
      (msg_in          => 'Check get_NLS_TIMESTAMP_TZ_FORMAT 2'
      ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
      ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6 +TZH:TZM');
end tc_setters_and_getters;

--====================================--
procedure tc_this
is
   temp_rec   g_rec_type;
begin
   g_testcase := 'This Test';
   this (
      msg_in         => '',
      check_this_in  => '',
      null_ok_in     => FALSE);
   temp_rec := g_rec;
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'RAISES');
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Raises Tests Happy Path');
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_details',
      check_this_in   => substr(temp_rec.last_details,1,110),
      against_this_in => 'Expected exception "%PLS-00302: component ''BOGUS'' must be declared%". Actual exception raised was "ORA-06550: ');
end tc_this;

--====================================--
procedure tc_eqs
is
begin
   null;
end tc_eqs;

--====================================--
procedure tc_nulls
is
begin
   null;
end tc_nulls;

--====================================--

procedure tc_raises
is
   temp_rec   g_rec_type;
begin
   g_testcase := 'Raises Test';
   raises (
      msg_in         => 'Raises Tests Happy Path',
      check_call_in  => 'wt_assert.bogus',
      against_exc_in => 'PLS-00302: component ''BOGUS'' must be declared');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'RAISES');
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Raises Tests Happy Path');
   eq (
      msg_in          => 'Raises Tests Happy Path g_rec.last_details',
      check_this_in   => substr(temp_rec.last_details,1,110),
      against_this_in => 'Expected exception "%PLS-00302: component ''BOGUS'' must be declared%". Actual exception raised was "ORA-06550: ');
end tc_raises;

--====================================--
procedure tc_query_test
is
   temp_rec   g_rec_type;
begin
   g_testcase := 'Query Tests';
   -- Testing HAPPY PATH only
   eqqueryvalue (
      msg_in             =>   'Query Tests Happy Path 1',
      check_query_in     =>   'select dummy from DUAL',
      against_value_in   =>   'X',
      null_ok_in         =>   false);
   temp_rec := g_rec;
   eq (
      msg_in          => 'Query Tests Happy Path 1 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Query Tests Happy Path 1 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'EQQUERYVALUE');
   eq (
      msg_in          => 'Query Tests Happy Path 1 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Query Tests Happy Path 1');
   eq (
      msg_in          => 'Query Tests Happy Path 1 g_rec.last_details',
      check_this_in   => temp_rec.last_details,
      against_this_in => 'Expected "X" and got "X" for Query: select dummy from DUAL');
   --
   eqquery (
      msg_in             =>   'Query Tests Happy Path 2',
      check_query_in     =>   'select * from USER_TABLES',
      against_query_in   =>   'select * from USER_TABLES');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Query Tests Happy Path 2 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Query Tests Happy Path 2 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'EQQUERY');
   eq (
      msg_in          => 'Query Tests Happy Path 2 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Query Tests Happy Path 2');
   eq (
      msg_in          => 'Query Tests Happy Path 2 g_rec.last_details',
      check_this_in   => substr(temp_rec.last_details,1,18),
      against_this_in => 'Comparison Query: ');
   --
   eqtable (
      msg_in             =>   'Query Tests Happy Path 3',
      check_this_in      =>   'USER_TABLES',
      against_this_in    =>   'USER_TABLES',
      check_where_in     =>   '',
      against_where_in   =>   '');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Query Tests Happy Path 3 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Query Tests Happy Path 3 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'EQTABLE');
   eq (
      msg_in          => 'Query Tests Happy Path 3 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Query Tests Happy Path 3');
   eq (
      msg_in          => 'Query Tests Happy Path 3 g_rec.last_details',
      check_this_in   => substr(temp_rec.last_details,1,18),
      against_this_in => 'Comparison Query: ');
   --
   eqtable (
      msg_in             =>   'Query Tests Happy Path 4',
      check_this_in      =>   'ALL_TABLES',
      against_this_in    =>   'ALL_TABLES',
      check_where_in     =>   'owner = ''' || USER || '''',
      against_where_in   =>   'owner = ''' || USER || '''');
   --
   eqtabcount (
      msg_in             =>   'Query Tests Happy Path 5',
      check_this_in      =>   'USER_TABLES',
      against_this_in    =>   'ALL_TABLES',
      check_where_in     =>   '',
      against_where_in   =>   'owner = ''' || USER || '''');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Query Tests Happy Path 5 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Query Tests Happy Path 5 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'EQTABCOUNT');
   eq (
      msg_in          => 'Query Tests Happy Path 5 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Query Tests Happy Path 5');
   eq (
      msg_in          => 'Query Tests Happy Path 5 g_rec.last_details',
      check_this_in   => temp_rec.last_details,
      against_this_in => 'Expected 7 rows from "ALL_TABLES"' ||
                         ' and got 7 rows from "USER_TABLES"');
   --
   eqtabcount (
      msg_in             =>   'Query Tests Happy Path 5',
      check_this_in      =>   'ALL_TABLES',
      against_this_in    =>   'USER_TABLES',
      check_where_in     =>   'owner = ''' || USER || '''',
      against_where_in   =>   '');
   --
   compare_queries (
      check_query_in     => 'select bogus123 from bogus456',
      against_query_in   => 'select bogus987 from bogus654');
   temp_rec := g_rec;
   eq (
      msg_in           => 'Bad Query Test 1',
      check_this_in    => temp_rec.last_pass,
      against_this_in  => FALSE);
   eq(
      msg_in          => 'Bad Query Test 2',
      check_this_in   => instr(temp_rec.last_details
                              ,'ORA-06550: line 2, column 60:' || CHR(10) ||
                               'PL/SQL: ORA-00942: table or view does not exist'),
      against_this_in => 1);
   compare_queries (
      check_query_in     => 'select table_name from user_tables',
      against_query_in   => 'select tablespace_name from user_tables');
   temp_rec := g_rec;
   eq (
      msg_in           => 'Bad Query Test 3',
      check_this_in    => temp_rec.last_pass,
      against_this_in  => FALSE);
   eq(
      msg_in          => 'Bad Query Test 2',
      check_this_in   => instr(temp_rec.last_details
                              ,'Comparison Query: with check_query as' ||
                               ' (select table_name from user_tables'),
      against_this_in => 1);
end tc_query_test;

--====================================--
procedure tc_object_exists
is
   temp_rec   g_rec_type;
begin
   g_testcase := 'Object Exists';
   -- Testing HAPPY PATH only
   objexists (
      msg_in        =>   'Object Exists Happy Path 1',
      obj_owner_in  =>   'SYS',
      obj_name_in   =>   'DUAL');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Object Exists Happy Path 1 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Object Exists Happy Path 1 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'OBJEXISTS');
   eq (
      msg_in          => 'Object Exists Happy Path 1 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Object Exists Happy Path 1');
   eq (
      msg_in          => 'Object Exists Happy Path 1 g_rec.last_details',
      check_this_in   => temp_rec.last_details,
      against_this_in => 'Number of objects found for "SYS.DUAL" is 1');
   -- This is an overload of the above OBJEXISTS
   objexists (
      msg_in          =>  'Object Exists Happy Path 2',
      check_this_in   =>  'SYS.DUAL');
   --
   objnotexists (
      msg_in        =>   'Object Not Exists Happy Path 3',
      obj_owner_in  =>   'BOGUS123',
      obj_name_in   =>   'BOGUS123');
   temp_rec := g_rec;
   eq (
      msg_in          => 'Object Not Exists Happy Path 3 g_rec.last_pass',
      check_this_in   => temp_rec.last_pass,
      against_this_in => TRUE);
   eq (
      msg_in          => 'Object Not Exists Happy Path 3 g_rec.last_assert',
      check_this_in   => temp_rec.last_assert,
      against_this_in => 'OBJNOTEXISTS');
   eq (
      msg_in          => 'Object Not Exists Happy Path 3 g_rec.last_msg',
      check_this_in   => temp_rec.last_msg,
      against_this_in => 'Object Not Exists Happy Path 3');
   eq (
      msg_in          => 'Object Not Exists Happy Path 3 g_rec.last_details',
      check_this_in   => temp_rec.last_details,
      against_this_in => 'Number of objects found for "BOGUS123.BOGUS123" is 0');
   -- This is an overload of the above OBJEXISTS
   objnotexists (
      msg_in          =>   'Object Not Exists Happy Path 4',
      check_this_in   =>   'BOGUS123.BOGUS123');
end tc_object_exists;

--====================================--
procedure WTPLSQL_RUN
is
begin
   g_raise_exception := FALSE;
   -- This runs like a self-contained "in-circuit" test.
   tc_boolean_to_status;
   tc_process_assertion;
   tc_setters_and_getters;
   tc_this;
   tc_eqs;
   tc_nulls;
   tc_raises;
   tc_query_test;
   tc_object_exists;
end WTPLSQL_RUN;

$END
--==============================================================--


end wt_assert;
/
