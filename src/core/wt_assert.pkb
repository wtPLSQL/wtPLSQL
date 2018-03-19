create or replace package body wt_assert is

   -- See (public) RESET_GLOBALS procedure for default global values
   TYPE g_rec_type is record
      (last_pass        boolean
      ,last_assert      wt_results.assertion%TYPE
      ,last_msg         wt_results.message%TYPE
      ,last_details     wt_results.details%TYPE);
   g_rec  g_rec_type;

   $IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
   $THEN
      temp_rowid1 CONSTANT rowid          := chartorowid('AAAFd1AAFAAAABSAA/');
      temp_rowid2 CONSTANT rowid          := chartorowid('AAAFd1AAFAAAABSAB/');
      temp_long1  CONSTANT long           := hextoraw('0123456789ABCDEF0123456789ABCDEF');
      temp_long2  CONSTANT long           := hextoraw('FEDCBA9876543210FEDCBA9876543210');
      temp_raw1   CONSTANT raw(2)         := hextoraw('2345');
      temp_raw2   CONSTANT raw(2)         := hextoraw('6789');
      temp_lraw1  CONSTANT long raw       := hextoraw('0123456789ABCDEF0123456789ABCDEF');
      temp_lraw2  CONSTANT long raw       := hextoraw('FEDCBA9876543210FEDCBA9876543210');
      temp_blob1           BLOB;
      temp_blob2  CONSTANT BLOB           := hextoraw('FEDCBA9876543210FEDCBA9876543210');
      temp_nc1    CONSTANT NVARCHAR2(12)  := 'NCHAR1';
      temp_nc2    CONSTANT NVARCHAR2(12)  := 'NCHAR2';
      temp_bool   CONSTANT boolean        := NULL;
      temp_clob1           CLOB;
      temp_clob2  CONSTANT CLOB           := 'This is another clob.';
      temp_nclob1          NCLOB;
      temp_nclob2 CONSTANT NCLOB          := 'This is another clob.';
      temp_xml1            XMLTYPE;
      temp_xml2   CONSTANT XMLTYPE        := xmltype('<?xml version="1.0" encoding="UTF-8"?><note>2</note>');
      temp_pint1  CONSTANT pls_integer    := 2;
      temp_pint2  CONSTANT pls_integer    := 3;
      temp_date   CONSTANT date           := sysdate;
      temp_tstmp  CONSTANT timestamp      := systimestamp;
      temp_tstlzn CONSTANT timestamp with local time zone := systimestamp;
      temp_tstzn  CONSTANT timestamp with time zone := systimestamp;
      temp_intds1 CONSTANT interval day to second   := interval '+01 01:01:01.001' day to second;
      temp_intds2 CONSTANT interval day to second   := interval '+02 02:02:02.002' day to second;
      temp_intym1 CONSTANT interval year to month   := interval '+01-01' year to month;
      temp_intym2 CONSTANT interval year to month   := interval '+02-02' year to month;
      temp_rec          g_rec_type;
      temp_raise_excpt  BOOLEAN;
      temp_testcase     VARCHAR2(4000);
      wtplsql_skip_save boolean := FALSE;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------

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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_boolean_to_status
   is
   begin
      wt_assert.g_testcase := 'BOOLEAN_TO_STATUS';
      wt_assert.eq
         (msg_in            => 'Test for "TRUE" conversion'
         ,check_this_in     => boolean_to_status(TRUE)
         ,against_this_in   => C_PASS);
      wt_assert.eq
         (msg_in            => 'Test for "FALSE" conversion'
         ,check_this_in     => boolean_to_status(FALSE)
         ,against_this_in   => C_FAIL);
      wt_assert.isnull
         (msg_in            => 'Test for NULL'
         ,check_this_in     => boolean_to_status(temp_bool));
   end tc_boolean_to_status;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure process_assertion
is
begin
   $IF $$WTPLSQL_SELFTEST $THEN  ------%WTPLSQL_begin_ignore_lines%------
      -- This will skip over the wt_result.save call below during some self-tests
      if not wtplsql_skip_save then
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
   wt_result.save
      (in_assertion      => g_rec.last_assert
      ,in_status         => case g_rec.last_pass
                            when TRUE then C_PASS
                                      else C_FAIL
                            end
      ,in_details        => g_rec.last_details
      ,in_testcase       => g_testcase
      ,in_message        => g_rec.last_msg);
   $IF $$WTPLSQL_SELFTEST $THEN   ------%WTPLSQL_begin_ignore_lines%------
      -- This will skip over the wt_result.save call above during some self-tests
      end if;
   $END  ----------------%WTPLSQL_end_ignore_lines%----------------
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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_process_assertion
   is
      ASSERT_TEST_EXCEPTION  exception;
      PRAGMA EXCEPTION_INIT(ASSERT_TEST_EXCEPTION, -20003);
      procedure test_exception
      is
      begin
         wt_assert.eq
            (msg_in          => 'Process Assertion Actual Test'
            ,check_this_in   => SQLERRM
            ,against_this_in => 'ORA-20003:    --  Test Case:' ||
                                ' PROCESS_ASSERTION  --' || CHR(10) ||
                                '#FAIL#Process Assertion Forced Failure.' ||
                                ' THIS - Expected "PASS" and got "FAIL"');
      end test_exception;
   begin
      g_testcase         := 'PROCESS_ASSERTION';
      g_rec.last_assert  := 'THIS';
      g_rec.last_pass    := FALSE;
      g_rec.last_details := 'Expected "PASS" and got "FAIL"';
      g_rec.last_msg     := 'Process Assertion Forced Failure';
      wt_assert.g_raise_exception  := TRUE;
      wtplsql_skip_save  := TRUE;
      process_assertion;  -- Should throw exception
      wtplsql_skip_save  := FALSE;
      wt_assert.g_raise_exception  := FALSE;
   exception
      when ASSERT_TEST_EXCEPTION then
         wtplsql_skip_save := FALSE;
         g_raise_exception := FALSE;
   end tc_process_assertion;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_compare_queries
   is
   begin
      wt_assert.g_testcase := 'COMPARE_QUERIES';
      compare_queries (
         check_query_in     => 'select bogus123 from bogus456',
         against_query_in   => 'select bogus987 from bogus654');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in           => 'Bad Query Test 1 g_rec.last_pass',
         check_this_in    => temp_rec.last_pass,
         against_this_in  => FALSE);
      wt_assert.isnotnull(
         msg_in          => 'Bad Query Test 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this(
         msg_in          => 'Bad Query Test 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            '%PL/SQL: ORA-00942: table or view does not exist%'));
      compare_queries (
         check_query_in     => 'select table_name from user_tables',
         against_query_in   => 'select tablespace_name from user_tables');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in           => 'Bad Query Test 2 g_rec.last_pass',
         check_this_in    => temp_rec.last_pass,
         against_this_in  => FALSE);
      wt_assert.isnotnull(
         msg_in          => 'Bad Query Test 2a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this(
         msg_in          => 'Bad Query Test 2b g_rec.last_details',
         check_this_in   => temp_rec.last_details like
                            '%Comparison Query: with check_query as' ||
                            ' (select table_name from user_tables%');
   end tc_compare_queries;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

function last_assert
   return wt_results.assertion%TYPE
is
begin
   return g_rec.last_assert;
end last_assert;

function last_msg
   return wt_results.message%TYPE
is
begin
   return g_rec.last_msg;
end last_msg;

function last_details
   return wt_results.details%TYPE
is
begin
   return g_rec.last_details;
end last_details;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_last_values
   is
   begin
      wt_assert.g_testcase := 'Last Values Tests';
      wt_assert.eq (
         msg_in          => 'Last Pass',
         check_this_in   => last_pass,
         against_this_in => g_rec.last_pass,
         null_ok_in      => TRUE);
      wt_assert.eq (
         msg_in          => 'Last Assert',
         check_this_in   => last_assert,
         against_this_in => g_rec.last_assert,
         null_ok_in      => TRUE);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'Last MSG',
         check_this_in   => last_msg,
         against_this_in => temp_rec.last_msg,
         null_ok_in      => TRUE);
      wt_assert.eq (
         msg_in          => 'Last Details',
         check_this_in   => last_details,
         against_this_in => g_rec.last_details,
         null_ok_in      => TRUE);
   end tc_last_values;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_reset_globals
   is
   begin
      reset_globals;  -- Resets g_testcase
      temp_rec         := g_rec;
      temp_raise_excpt := g_raise_exception;
      temp_testcase    := g_testcase;
      g_testcase       := 'RESET_GLOBALS';
      wt_assert.isnull(
         msg_in        => 'g_testcase is null',
         check_this_in => temp_testcase);
      wt_assert.eq(
         msg_in          => 'g_raise_exception is FALSE',
         check_this_in   => temp_raise_excpt,
         against_this_in => FALSE);
      wt_assert.isnull
         (msg_in        => 'g_rec.last_pass is null'
         ,check_this_in => temp_rec.last_pass);
      wt_assert.isnull
         (msg_in        => 'g_rec.last_assert is null'
         ,check_this_in => temp_rec.last_assert);
      wt_assert.isnull
         (msg_in        => 'g_rec.last_msg is null'
         ,check_this_in => temp_rec.last_msg);
      wt_assert.isnull
         (msg_in        => 'g_rec.last_details is null'
         ,check_this_in => temp_rec.last_details);
   end tc_reset_globals;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

procedure set_NLS_DATE_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS')
is
begin
   execute immediate 'alter session set NLS_DATE_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_DATE_FORMAT;

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

procedure set_NLS_TIMESTAMP_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6')
is
begin
   execute immediate 'alter session set NLS_TIMESTAMP_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_TIMESTAMP_FORMAT;

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

procedure set_NLS_TIMESTAMP_TZ_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6 TZH:TZM')
is
begin
   execute immediate 'alter session set NLS_TIMESTAMP_TZ_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_TIMESTAMP_TZ_FORMAT;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_nls_settings
   is
   begin
      wt_assert.g_testcase := 'NLS Settings';
      set_NLS_DATE_FORMAT('DD-MON-YYYY');
      wt_assert.eq
         (msg_in          => 'Check get_NLS_DATE_FORMAT 1'
         ,check_this_in   => get_NLS_DATE_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_DATE_FORMAT;
      wt_assert.eq
         (msg_in          => 'Check get_NLS_DATE_FORMAT 2'
         ,check_this_in   => get_NLS_DATE_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS');
      set_NLS_TIMESTAMP_FORMAT('DD-MON-YYYY');
      wt_assert.eq
         (msg_in          => 'Check get_NLS_TIMESTAMP_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_TIMESTAMP_FORMAT;
      wt_assert.eq
         (msg_in          => 'Check get_NLS_TIMESTAMP_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6');
      set_NLS_TIMESTAMP_TZ_FORMAT('DD-MON-YYYY');
      wt_assert.eq
         (msg_in          => 'Check get_NLS_TIMESTAMP_TZ_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_TIMESTAMP_TZ_FORMAT;
      wt_assert.eq
         (msg_in          => 'Check get_NLS_TIMESTAMP_TZ_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6 TZH:TZM');
   end tc_nls_settings;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
   -- NULL_OK_IN is not used, but included for legacy calls
   g_rec.last_pass    := nvl(check_this_in, FALSE);
   g_rec.last_details := 'Expected "' || C_PASS ||
                        '" and got "' || boolean_to_status(check_this_in) || '"';
   process_assertion;
   wt_profiler.resume;
end this;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_this
   is
   begin
      wt_assert.g_testcase := 'This Tests';
      --------------------------------------  WTPLSQL Testing --
      wt_assert.this (
         msg_in         => 'This Tests Happy Path',
         check_this_in  => TRUE);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'This Tests Happy Path g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'This Tests Happy Path g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'THIS');
      wt_assert.eq (
         msg_in          => 'This Tests Happy Path g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'This Tests Happy Path');
      wt_assert.eq (
         msg_in          => 'This Tests Happy Path g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected "PASS" and got "PASS"');
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      this (
         msg_in         => 'Not Used',
         check_this_in  => FALSE);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'This Tests Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      this (
         msg_in         => 'Not Used',
         check_this_in  => NULL);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'This Tests Sad Path 2',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
   end tc_this;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
   g_rec.last_details := 'Expected "' || substr(against_this_in,1,1000) ||
                        '" and got "' || substr(check_this_in  ,1,1000) ||
                        '"';
   process_assertion;
   wt_profiler.resume;
end eq;

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

-- EQ: XMLTYPE
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   XMLTYPE,
   against_this_in   in   XMLTYPE)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'EQ';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (xmltype.getclobval(check_this_in)  =
                          xmltype.getclobval(against_this_in)  );
   g_rec.last_details := 'Expected "' || substr(xmltype.getclobval(against_this_in),1,1000) ||
                        '" and got "' || substr(xmltype.getclobval(check_this_in)  ,1,1000) ||
                        '"';
   process_assertion;
   wt_profiler.resume;
end eq;

-- EQ: CLOB
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   CLOB,
   against_this_in   in   CLOB,
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
   g_rec.last_details := 'Expected "' || substr(against_this_in,1,1000) ||
                        '" and got "' || substr(check_this_in  ,1,1000) ||
                        '"';
   process_assertion;
   wt_profiler.resume;
end eq;

-- EQ: BLOB
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   BLOB,
   against_this_in   in   BLOB,
   null_ok_in        in   boolean := false)
is
   compare_results  number;
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'EQ';
   g_rec.last_msg     := msg_in;
   compare_results    := nvl(DBMS_LOB.COMPARE(check_this_in, against_this_in),-1);
   g_rec.last_pass    := (    (compare_results = 0)
                           or (    check_this_in is null
                              and against_this_in is null
                              and null_ok_in              )
                         );
   g_rec.last_details := 'DBMS_LOB.COMPARE on BLOBs, compare_results: ' || compare_results;
   process_assertion;
   wt_profiler.resume;
end eq;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_eq
   is
   begin
      wt_assert.g_testcase := 'EQ Tests';
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ VARCHAR2 Happy Path 1',
         check_this_in   => 'X',
         against_this_in => 'X');
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Happy Path 1 g_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'EQ VARCHAR2 Happy Path 1'));
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details = 'Expected "X" and got "X"'));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ VARCHAR2 Happy Path 2',
         check_this_in   => 'X',
         against_this_in => 'X',
         null_ok_in      => TRUE);
      eq (
         msg_in          => 'EQ VARCHAR2 Happy Path 3',
         check_this_in   => '',
         against_this_in => '',
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 'X',
         against_this_in => 'Y');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 1 check_this_in value',
         check_this_in   => 'X');
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 1 against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => 'Y');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 2 check_this_in value',
         check_this_in   => '');
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 2 against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Sad Path 2',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => '');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 3 check_this_in value',
         check_this_in   => '');
      wt_assert.isnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 3 against_this_in value',
         check_this_in   => '');
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Sad Path 3',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 'X',
         against_this_in => 'Y',
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 4 check_this_in value',
         check_this_in   => 'X');
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 4 against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Sad Path 4',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => 'Y',
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 5 check_this_in value',
         check_this_in   => '');
      wt_assert.isnotnull (
         msg_in          => 'EQ VARCHAR2 Sad Path 5 against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'EQ VARCHAR2 Sad Path 5',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes ROWID, LONG, RAW, and NVARCHAR2
      eq (
         msg_in          => 'EQ ROWID Happy Path 1',
         check_this_in   => temp_rowid1,
         against_this_in => temp_rowid1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_rowid1,
         against_this_in => temp_rowid2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ ROWID Sad Path 1 check_this_in value',
         check_this_in   => temp_rowid1);
      wt_assert.isnotnull (
         msg_in          => 'EQ ROWID Sad Path 1 against_this_in value',
         check_this_in   => temp_rowid2);
      wt_assert.this (
         msg_in          => 'EQ ROWID Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ LONG Happy Path 1',
         check_this_in   => temp_long1,
         against_this_in => temp_long1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_long1,
         against_this_in => temp_long2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ LONG Sad Path 1 check_this_in value',
         check_this_in   => temp_long1);
      wt_assert.isnotnull (
         msg_in          => 'EQ LONG Sad Path 1 against_this_in value',
         check_this_in   => temp_long2);
      wt_assert.this (
         msg_in          => 'EQ LONG Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ RAW Happy Path 1',
         check_this_in   => temp_raw1,
         against_this_in => temp_raw1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_raw1,
         against_this_in => temp_raw2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ RAW Sad Path 1 check_this_in value',
         check_this_in   => temp_raw1);
      wt_assert.isnotnull (
         msg_in          => 'EQ RAW Sad Path 1 against_this_in value',
         check_this_in   => temp_raw2);
      wt_assert.this (
         msg_in          => 'EQ RAW Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ LONG RAW Happy Path 1',
         check_this_in   => temp_lraw1,
         against_this_in => temp_lraw1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_lraw1,
         against_this_in => temp_lraw2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ LONG RAW Sad Path 1 check_this_in value',
         check_this_in   => temp_lraw1);
      wt_assert.isnotnull (
         msg_in          => 'EQ LONG RAW Sad Path 1 against_this_in value',
         check_this_in   => temp_lraw2);
      wt_assert.this (
         msg_in          => 'EQ LONG RAW Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ NVARCHAR2 Happy Path 1',
         check_this_in   => temp_nc1,
         against_this_in => temp_nc1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nc1,
         against_this_in => temp_nc2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ NVARCHAR2 Sad Path 1 check_this_in value',
         check_this_in   => temp_nc1);
      wt_assert.isnotnull (
         msg_in          => 'EQ NVARCHAR2 Sad Path 1 against_this_in value',
         check_this_in   => temp_nc2);
      wt_assert.this (
         msg_in          => 'EQ NVARCHAR2 Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: boolean overload
      eq (
         msg_in          => 'EQ BOOLEAN Happy Path 1',
         check_this_in   => FALSE,
         against_this_in => FALSE);
      eq (
         msg_in          => 'EQ BOOLEAN Happy Path 2',
         check_this_in   => FALSE,
         against_this_in => FALSE,
         null_ok_in      => TRUE);
      eq (
         msg_in          => 'EQ BOOLEAN Happy Path 3',
         check_this_in   => temp_bool,
         against_this_in => temp_bool,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 1 check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 1 against_this_in value',
         check_this_in   => TRUE);
      wt_assert.this (
         msg_in          => 'EQ BOOLEAN Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => temp_bool);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 2 check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnull (
         msg_in          => 'EQ BOOLEAN Sad Path 2 against_this_in value',
         check_this_in   => temp_bool);
      wt_assert.this (
         msg_in          => 'EQ BOOLEAN Sad Path 2',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => TRUE,
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 3 check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 3 against_this_in value',
         check_this_in   => TRUE);
      wt_assert.this (
         msg_in          => 'EQ BOOLEAN Sad Path 3',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => temp_bool,
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BOOLEAN Sad Path 4 check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnull (
         msg_in          => 'EQ BOOLEAN Sad Path 4 against_this_in value',
         check_this_in   => temp_bool);
      wt_assert.this (
         msg_in          => 'EQ BOOLEAN Sad Path 4',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: NUMBER implicit conversion (includes PLS_INTEGER)
      eq (
         msg_in          => 'EQ NUMBER Happy Path 1',
         check_this_in   => 4,
         against_this_in => 4);
      eq (
         msg_in          => 'EQ PLS_INTEGER Happy Path 1',
         check_this_in   => temp_pint1,
         against_this_in => temp_pint1);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 4,
         against_this_in => 5);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ NUMBER Sad Path 1 check_this_in value',
         check_this_in   => 4);
      wt_assert.isnotnull (
         msg_in          => 'EQ NUMBER Sad Path 1 against_this_in value',
         check_this_in   => 5);
      wt_assert.this (
         msg_in          => 'EQ NUMBER Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_pint1,
         against_this_in => temp_pint2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ PLS_INTEGER Sad Path 1 check_this_in value',
         check_this_in   => temp_pint1);
      wt_assert.isnotnull (
         msg_in          => 'EQ PLS_INTEGER Sad Path 1 against_this_in value',
         check_this_in   => temp_pint2);
      wt_assert.this (
         msg_in          => 'EQ PLS_INTEGER Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion (includes TIMESTAMP and INTERVAL)
      eq (
         msg_in          => 'EQ DATE Happy Path 1',
         check_this_in   => temp_date,
         against_this_in => temp_date);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_date,
         against_this_in => temp_date + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ DATE Sad Path 1 check_this_in value',
         check_this_in   => temp_date);
      wt_assert.isnotnull (
         msg_in          => 'EQ DATE Sad Path 1 against_this_in value',
         check_this_in   => temp_date + 1/24);
      wt_assert.this (
         msg_in          => 'EQ DATE Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ TIMSETAMP Happy Path 1',
         check_this_in   => temp_tstmp,
         against_this_in => temp_tstmp);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstmp,
         against_this_in => temp_tstmp + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP Sad Path 1 check_this_in value',
         check_this_in   => temp_tstmp);
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP Sad Path 1 against_this_in value',
         check_this_in   => temp_tstmp + 1/24);
      wt_assert.this (
         msg_in          => 'EQ TIMESTAMP Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ TIMSETAMP WITH LOCAL TIME ZONE Happy Path 1',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstlzn,
         against_this_in => temp_tstlzn + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP WITH LOCAL TIME ZONE Sad Path 1 check_this_in value',
         check_this_in   => temp_tstlzn);
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP WITH LOCAL TIME ZONE Sad Path 1 against_this_in value',
         check_this_in   => temp_tstlzn + 1/24);
      wt_assert.this (
         msg_in          => 'EQ TIMESTAMP WITH LOCAL TIME ZONE Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ TIMSETAMP WITH TIME ZONE Happy Path 1',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP WITH TIME ZONE Sad Path 1 check_this_in value',
         check_this_in   => temp_tstzn);
      wt_assert.isnotnull (
         msg_in          => 'EQ TIMESTAMP WITH TIME ZONE Sad Path 1 against_this_in value',
         check_this_in   => temp_tstzn + 1/24);
      wt_assert.this (
         msg_in          => 'EQ TIMESTAMP WITH TIME ZONE Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ INTERVAL DAY TO SECOND Happy Path 1',
         check_this_in   => temp_intds1,
         against_this_in => temp_intds1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_intds1,
         against_this_in => temp_intds2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ INTERVAL DAY TO SECOND Sad Path 1 check_this_in value',
         check_this_in   => temp_intds1);
      wt_assert.isnotnull (
         msg_in          => 'EQ INTERVAL DAY TO SECOND Sad Path 1 against_this_in value',
         check_this_in   => temp_intds2);
      wt_assert.this (
         msg_in          => 'EQ INTERVAL DAY TO SECOND Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      eq (
         msg_in          => 'EQ INTERVAL YEAR TO MONTH Happy Path 1',
         check_this_in   => temp_intym1,
         against_this_in => temp_intym1);
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_intym1,
         against_this_in => temp_intym2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ INTERVAL YEAR TO MONTH Sad Path 1 check_this_in value',
         check_this_in   => temp_intym1);
      wt_assert.isnotnull (
         msg_in          => 'EQ INTERVAL YEAR TO MONTH Sad Path 1 against_this_in value',
         check_this_in   => temp_intym2);
      wt_assert.this (
         msg_in          => 'EQ INTERVAL YEAR TO MONTH Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: XMLTYPE overload
      eq (
         msg_in          => 'EQ XMLTYPE Happy Path 1',
         check_this_in   => temp_xml1,
         against_this_in => temp_xml1);
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'EQ XMLTYPE Happy Path 1 g_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'EQ XMLTYPE Happy Path 1'));
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQ XMLTYPE Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_xml1,
         against_this_in => temp_xml2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Sad Path 1 check_this_in value',
         check_this_in   => xmltype.getclobval(temp_xml1));
      wt_assert.isnotnull (
         msg_in          => 'EQ XMLTYPE Sad Path 1 against_this_in value',
         check_this_in   => xmltype.getclobval(temp_xml2));
      wt_assert.this (
         msg_in          => 'EQ XMLTYPE Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: CLOB overload
      eq (
         msg_in          => 'EQ CLOB Happy Path 1',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob1);
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'EQ CLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'EQ CLOB Happy Path 1'));
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQ CLOB Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      eq (
         msg_in          => 'EQ CLOB Happy Path 2',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob1,
         null_ok_in      => TRUE);
      eq (
         msg_in          => 'EQ CLOB Happy Path 3',
         check_this_in   => cast (NULL as CLOB),
         against_this_in => cast (NULL as CLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Sad Path 1 check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Sad Path 1 against_this_in value',
         check_this_in   => temp_clob2);
      wt_assert.this (
         msg_in          => 'EQ CLOB Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => cast (NULL as CLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Sad Path 2 check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnull (
         msg_in          => 'EQ CLOB Sad Path 2 against_this_in value',
         check_this_in   => cast (NULL as CLOB));
      wt_assert.this (
         msg_in          => 'EQ CLOB Sad Path 2',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => cast (NULL as CLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ CLOB Sad Path 3 check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnull (
         msg_in          => 'EQ CLOB Sad Path 3 against_this_in value',
         check_this_in   => cast (NULL as CLOB));
      wt_assert.this (
         msg_in          => 'EQ CLOB Sad Path 3',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- NCLOB
      eq (
         msg_in          => 'EQ NCLOB Happy Path 2',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob1);
      eq (
         msg_in          => 'EQ NCLOB Happy Path 2',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob1,
         null_ok_in      => TRUE);
      eq (
         msg_in          => 'EQ NCLOB Happy Path 3',
         check_this_in   => cast (NULL as NCLOB),
         against_this_in => cast (NULL as NCLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ NCLOB Sad Path 1 check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnotnull (
         msg_in          => 'EQ NCLOB Sad Path 1 against_this_in value',
         check_this_in   => temp_nclob2);
      wt_assert.this (
         msg_in          => 'EQ NCLOB Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => cast (NULL as NCLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ NCLOB Sad Path 2 check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnull (
         msg_in          => 'EQ NCLOB Sad Path 2 against_this_in value',
         check_this_in   => cast (NULL as NCLOB));
      wt_assert.this (
         msg_in          => 'EQ NCLOB Sad Path 2',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => cast (NULL as NCLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ NCLOB Sad Path 3 check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnull (
         msg_in          => 'EQ NCLOB Sad Path 3 against_this_in value',
         check_this_in   => cast (NULL as NCLOB));
      wt_assert.this (
         msg_in          => 'EQ NCLOB Sad Path 3',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: BLOB overload
      eq (
         msg_in          => 'EQ BLOB Happy Path 1',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob1);
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'EQ BLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'EQ BLOB Happy Path 1'));
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQ BLOB Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details =
                            'DBMS_LOB.COMPARE on BLOBs, compare_results: 0'));
      eq (
         msg_in          => 'EQ BLOB Happy Path 2',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob1,
         null_ok_in      => TRUE);
      eq (
         msg_in          => 'EQ BLOB Happy Path 3',
         check_this_in   => cast (NULL as BLOB),
         against_this_in => cast (NULL as BLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Sad Path 1 check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Sad Path 1 against_this_in value',
         check_this_in   => temp_blob2);
      wt_assert.this (
         msg_in          => 'EQ BLOB Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => cast (NULL as BLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Sad Path 2 check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnull (
         msg_in          => 'EQ BLOB Sad Path 2 against_this_in value',
         check_this_in   => cast (NULL as BLOB));
      wt_assert.this (
         msg_in          => 'EQ BLOB Sad Path 2',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => cast (NULL as BLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'EQ BLOB Sad Path 3 check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnull (
         msg_in          => 'EQ BLOB Sad Path 3 against_this_in value',
         check_this_in   => cast (NULL as BLOB));
      wt_assert.this (
         msg_in          => 'EQ BLOB Sad Path 3',
         check_this_in   => (temp_rec.last_pass = FALSE));
   end tc_eq;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
                          substr(check_this_in,1,2000) || '"';
   process_assertion;
   wt_profiler.resume;
end isnotnull;

-- ISNOTNULL boolean overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnotnull (msg_in        => msg_in
             ,check_this_in => boolean_to_status(check_this_in));
end isnotnull;

-- ISNOTNULL CLOB overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   CLOB)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   g_rec.last_details := 'Expected NOT NULL and got "' ||
                          substr(check_this_in,1,2000) || '"';
   process_assertion;
   wt_profiler.resume;
end isnotnull;

-- ISNOTNULL BLOB overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   BLOB)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   if g_rec.last_pass
   then
      g_rec.last_details := 'BLOB is NOT NULL';
   else
      g_rec.last_details := 'BLOB is NULL';
   end if;
   process_assertion;
   wt_profiler.resume;
end isnotnull;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_isnotnull
   is
   begin
      wt_assert.g_testcase := 'ISNOTNULL Tests';
      --------------------------------------  WTPLSQL Testing --
      isnotnull (
         msg_in        => 'ISNOTNULL VARCHAR2 Happy Path 1',
         check_this_in => 'X');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL VARCHAR2 Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNOTNULL VARCHAR2 Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      wt_assert.eq (
         msg_in          => 'ISNOTNULL VARCHAR2 Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNOTNULL VARCHAR2 Happy Path 1');
      wt_assert.eq (
         msg_in          => 'ISNOTNULL VARCHAR2 Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NOT NULL and got "X"');
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => '');
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL VARCHAR2 Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnotnull (
         msg_in        => 'ISNOTNULL BOOLEAN Happy Path 2',
         check_this_in => TRUE);
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => temp_bool);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BOOLEAN Sad Path 2',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnotnull (
         msg_in        => 'ISNOTNULL CLOB Happy Path 1',
         check_this_in => temp_clob1);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL CLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNOTNULL CLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      wt_assert.eq (
         msg_in          => 'ISNOTNULL CLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNOTNULL CLOB Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'ISNOTNULL CLOB Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'ISNOTNULL CLOB Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected NOT NULL and got "<?xml version="1.0" encoding="UTF-8"?>%'));
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => cast (null as CLOB));
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL CLOB Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnotnull (
         msg_in        => 'ISNOTNULL BLOB Happy Path 1',
         check_this_in => temp_blob1);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNOTNULL BLOB Happy Path 1');
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BLOB Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'BLOB is NOT NULL');
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => cast (null as BLOB));
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNOTNULL BLOB Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
   end tc_isnotnull;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
                      substr(check_this_in,1,2000) || '"';
   process_assertion;
   wt_profiler.resume;
end isnull;

-- ISNULL boolean overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnull (msg_in        => msg_in
          ,check_this_in => boolean_to_status(check_this_in));
end isnull;

-- ISNULL CLOB overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   CLOB)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   g_rec.last_details := 'Expected NULL and got "' ||
                      substr(check_this_in,1,2000) || '"';
   process_assertion;
   wt_profiler.resume;
end isnull;

-- ISNULL BLOB overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   BLOB)
is
begin
   wt_profiler.pause;
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   if g_rec.last_pass
   then
      g_rec.last_details := 'BLOB is NULL';
   else
      g_rec.last_details := 'BLOB is NOT NULL';
   end if;
   process_assertion;
   wt_profiler.resume;
end isnull;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_isnull
   is
   begin
      wt_assert.g_testcase := 'ISNULL Tests';
      --------------------------------------  WTPLSQL Testing --
      isnull (
         msg_in        => 'ISNULL VARCHAR2 Happy Path 1',
         check_this_in => '');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNULL VARCHAR2 Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNULL VARCHAR2 Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      wt_assert.eq (
         msg_in          => 'ISNULL VARCHAR2 Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNULL VARCHAR2 Happy Path 1');
      wt_assert.eq (
         msg_in          => 'ISNULL VARCHAR2 Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NULL and got ""');
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => 'X');
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNULL VARCHAR2 Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnull (
         msg_in        => 'ISNULL BOOLEAN Happy Path 1',
         check_this_in => temp_bool);
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => FALSE);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNULL BOOLEAN Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnull (
         msg_in        => 'ISNULL CLOB Happy Path 1',
         check_this_in => cast (null as CLOB));
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNULL CLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNULL CLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      wt_assert.eq (
         msg_in          => 'ISNULL CLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNULL CLOB Happy Path 1');
      wt_assert.eq (
         msg_in          => 'ISNULL CLOB Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NULL and got ""');
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => temp_clob1);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNULL CLOB Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      isnull (
         msg_in        => 'ISNULL BLOB Happy Path 1',
         check_this_in => cast (null as BLOB));
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'ISNULL BLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'ISNULL BLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      wt_assert.eq (
         msg_in          => 'ISNULL BLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'ISNULL BLOB Happy Path 1');
      wt_assert.eq (
         msg_in          => 'ISNULL BLOB Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'BLOB is NULL');
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => temp_blob1);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'ISNULL BLOB Sad Path 1',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
   end tc_isnull;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
   begin
      execute immediate 'begin ' || check_call_in || '; end;';
      wt_profiler.pause;
   exception when OTHERS then
      l_sqlerrm := SQLERRM;
      l_errstack := substr(dbms_utility.format_error_stack  ||
                           dbms_utility.format_error_backtrace
                           ,1,4000);
      wt_profiler.pause;
   end;
   --
   g_rec.last_assert  := 'RAISES';
   g_rec.last_msg     := msg_in;
   if l_sqlerrm like '%' || against_exc_in || '%'
   then
      g_rec.last_pass := TRUE;
   else
      g_rec.last_pass := FALSE;
   end if;
   g_rec.last_details := 'Expected exception "%'           || against_exc_in ||
                       '%". Actual exception raised was "' || l_errstack     ||
                               '". Exception raised by: '  || check_call_in  ;
   process_assertion;
   wt_profiler.resume;
end raises;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_raises
   is
   begin
      wt_assert.g_testcase := 'Raises Test';
      --------------------------------------  WTPLSQL Testing --
      raises (
         msg_in         => 'Raises Tests Happy Path',
         check_call_in  => 'wt_assert.bogus',
         against_exc_in => 'PLS-00302: component ''BOGUS'' must be declared');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'Raises Tests Happy Path g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'Raises Tests Happy Path g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'RAISES');
      wt_assert.eq (
         msg_in          => 'Raises Tests Happy Path g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Raises Tests Happy Path');
      wt_assert.isnotnull (
         msg_in          => 'Raises Tests Happy Path a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'Raises Tests Happy Path b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected exception "%PLS-00302: component ''BOGUS'' must be declared%". ' ||
                            'Actual exception raised was "%PLS-00302: component ''BOGUS'' must be declared%'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      raises (
         msg_in         => 'Not Used',
         check_call_in  => 'wt_assert.bogus',
         against_exc_in => 'Incorrect Exception');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'Raises Tests Sad Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'Raises Tests Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'Raises Tests Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected exception "%Incorrect Exception%". ' ||
                            'Actual exception raised was "ORA-%'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      raises (
         msg_in         => 'Not Used',
         check_call_in  => 'wt_assert.set_NLS_DATE_FORMAT',
         against_exc_in => 'Incorrect Exception');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'Raises Tests Sad Path 2 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'Raises Tests Sad Path 2b g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%Incorrect Exception%". ' ||
                            'Actual exception raised was "". ' ||
                            'Exception raised by: wt_assert.set_NLS_DATE_FORMAT');
   end tc_raises;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- EQQUERYVALUE
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
   g_rec.last_details := 'Expected "' || substr(against_value_in,1,1000) ||
                        '" and got "' || substr(l_rc_buff       ,1,1000) ||
                      '" for Query: ' || substr(check_query_in  ,1,1000) ;
   --
   process_assertion;
   wt_profiler.resume;
   --
end eqqueryvalue;

-- EQQUERYVALUE XMLTYPE Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   XMLTYPE)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     XMLTYPE;
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
   g_rec.last_pass    := (xmltype.getclobval(l_rc_buff)       =
                          xmltype.getclobval(against_value_in)  );
   g_rec.last_details := 'Expected "' || substr(xmltype.getclobval(against_value_in),1,1000) ||
                        '" and got "' || substr(xmltype.getclobval(l_rc_buff       ),1,1000) ||
                      '" for Query: ' || substr(                   check_query_in   ,1,1000) ;
   --
   process_assertion;
   wt_profiler.resume;
   --
end eqqueryvalue;

-- EQQUERYVALUE CLOB Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   CLOB,
      null_ok_in         in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     CLOB;
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
   g_rec.last_details := 'Expected "' || substr(against_value_in,1,1000) ||
                        '" and got "' || substr(l_rc_buff       ,1,1000) ||
                      '" for Query: ' || substr(check_query_in  ,1,1000) ;
   --
   process_assertion;
   wt_profiler.resume;
   --
end eqqueryvalue;

-- EQQUERYVALUE BLOB Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   BLOB,
      null_ok_in         in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc            rc_type;
   l_rc_buff       BLOB;
   compare_results number;
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
   compare_results    := nvl(DBMS_LOB.COMPARE(l_rc_buff, against_value_in),-1);
   g_rec.last_pass    := (   (compare_results = 0)
                          or (    l_rc_buff is null
                              and against_value_in is null
                              and null_ok_in               )  );
   g_rec.last_details := 'DBMS_LOB.COMPARE between BLOB and Query: ' ||
                           substr(check_query_in  ,1,2000) ||
                        ', compare_results: ' || compare_results;
   --
   process_assertion;
   wt_profiler.resume;
   --
end eqqueryvalue;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_eqqueryvalue
   is
   begin
      wt_assert.g_testcase := 'EQQUERYVALUE Tests';
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE VARCHAR2 Happy Path 1',
         check_query_in     =>   'select dummy from DUAL',
         against_value_in   =>   'X',
         null_ok_in         =>   false);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE VARCHAR2 Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE VARCHAR2 Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE VARCHAR2 Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQQUERYVALUE VARCHAR2 Happy Path 1');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE VARCHAR2 Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected "X" and got "X" for Query: select dummy from DUAL');
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE VARCHAR2 Happy Path 2',
         check_query_in     =>   'select max(dummy) from DUAL where 0 = 1',
         against_value_in   =>   '',
         null_ok_in         =>   true);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select dummy from DUAL',
         against_value_in   =>   'Y');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE VARCHAR2 Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      -- XMLTYPE Overload
      eqqueryvalue (
         msg_in           => 'EQQUERYVALUE XMLTYPE Happy Path 1',
         check_query_in   => 'select temp_xml from wt_test_data where id = 1',
         against_value_in => temp_xml1);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE XMLTYPE Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE XMLTYPE Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE XMLTYPE Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQQUERYVALUE XMLTYPE Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'EQQUERYVALUE XMLTYPE Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERYVALUE XMLTYPE Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_xml from wt_test_data where id = 1',
         against_value_in   =>   temp_xml2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE XMLTYPE Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQQUERYVALUE XMLTYPE Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERYVALUE XMLTYPE Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>' ||
             '<note>2</note>" and got "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      -- CLOB Overload
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE CLOB Happy Path 1',
         check_query_in     =>   'select temp_clob from wt_test_data where id = 1',
         against_value_in   =>   temp_clob1,
         null_ok_in         =>   false);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE CLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE CLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE CLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQQUERYVALUE CLOB Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'EQQUERYVALUE CLOB Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERYVALUE CLOB Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE CLOB Happy Path 2',
         check_query_in     =>   'select temp_clob from wt_test_data where 0 = 1',
         against_value_in   =>   '',
         null_ok_in         =>   true);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_clob from wt_test_data where id = 1',
         against_value_in   =>   temp_clob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE CLOB Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQQUERYVALUE CLOB Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERYVALUE CLOB Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "This is another clob." and got "' ||
                            '<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      -- BLOB Overload
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE BLOB Happy Path 1',
         check_query_in     =>   'select temp_blob from wt_test_data where id = 1',
         against_value_in   =>   temp_blob1,
         null_ok_in         =>   false);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQQUERYVALUE BLOB Happy Path 1');
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'DBMS_LOB.COMPARE between BLOB and Query:' ||
                           ' select temp_blob from wt_test_data where id = 1, compare_results: 0');
      eqqueryvalue (
         msg_in             =>   'EQQUERYVALUE BLOB Happy Path 2',
         check_query_in     =>   'select temp_blob from wt_test_data where 0 = 1',
         against_value_in   =>   cast (null as BLOB),
         null_ok_in         =>   true);
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_blob from wt_test_data where id = 1',
         against_value_in   =>   temp_blob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'EQQUERYVALUE BLOB Sad Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'DBMS_LOB.COMPARE between BLOB and Query: ' ||
               'select temp_blob from wt_test_data where id = 1, compare_results: -1');
   end tc_eqqueryvalue;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_eqquery
   is
   begin
      wt_assert.g_testcase := 'EQQUERY Tests';
      wt_assert.eqquery (
         msg_in             =>   'EQQUERY Tests Happy Path 1',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from USER_TABLES');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQQUERY Tests Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQQUERY Tests Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERY');
      wt_assert.eq (
         msg_in          => 'EQQUERY Tests Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQQUERY Tests Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'EQQUERY Tests Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERY Tests Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqquery (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from USER_TABLES where 0 = 1');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERY Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQQUERY Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERY Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqquery (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from ALL_TABLES');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQQUERY Sad Path 2',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQQUERY Sad Path 2a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERY Sad Path 2b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                '%PL/SQL: ORA-01789: query block has incorrect number of result columns%'));
   end tc_eqquery;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_eqtable
   is
   begin
      wt_assert.g_testcase := 'EQTABLE Tests';
      wt_assert.eqtable (
         msg_in             =>   'EQTABLE Tests Happy Path 1',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'USER_TABLES',
         check_where_in     =>   '',
         against_where_in   =>   '');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQTABLE Tests Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQTABLE Tests Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQTABLE');
      wt_assert.eq (
         msg_in          => 'EQTABLE Tests Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQTABLE Tests Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'EQTABLE Tests Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABLE Tests Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      eqtable (
         msg_in             =>   'EQTABLE Tests Happy Path 2',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   'owner = ''' || USER || '''');
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqtable (
         msg_in             =>   'Not Used',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   '0 = 1');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQTABLE Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQTABLE Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABLE Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqtable (
         msg_in             =>   'Not Used',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'ALL_TABLES');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQTABLE Sad Path 2',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQTABLE Sad Path 2a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABLE Sad Path 2b g_rec.last_details',
         check_this_in   => temp_rec.last_details like
               '%PL/SQL: ORA-01789: query block has incorrect number of result columns%');
   end tc_eqtable;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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
   g_rec.last_details := 'Expected ' || l_cnt       || ' rows from "' || against_this_in ||
                        '" and got ' || l_check_cnt || ' rows from "' || check_this_in   ||
                        '"';
   process_assertion;
   wt_profiler.resume;
end eqtabcount;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_eqtabcount
   is
   begin
      wt_assert.g_testcase := 'EQTABCOUNT Tests';
      eqtabcount (
         msg_in             =>   'EQTABCOUNT Tests Happy Path 1',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   'owner = ''' || USER || '''');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'EQTABCOUNT Tests Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'EQTABCOUNT Tests Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQTABCOUNT');
      wt_assert.eq (
         msg_in          => 'EQTABCOUNT Tests Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'EQTABCOUNT Tests Happy Path 1');
      wt_assert.isnotnull (
         msg_in          => 'EQTABCOUNT Tests Happy Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABCOUNT Tests Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected % rows from "ALL_TABLES"' ||
                            ' and got % rows from "ALL_TABLES"'));
      eqtabcount (
         msg_in             =>   'EQTABCOUNT Tests Happy Path 2',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'USER_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   '');
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqtabcount (
         msg_in             =>   'Not Used',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''JOHN DOE''',
         against_where_in   =>   'owner = ''' || USER || '''');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQTABCOUNT Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQTABCOUNT Sad Path 1a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABCOUNT Sad Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected % rows from "ALL_TABLES" and ' ||
                                 'got % rows from "ALL_TABLES"'));
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      eqtabcount (
         msg_in             =>   'Not Used',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'USER_TAB_COLUMNS');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'EQTABCOUNT Sad Path 2',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'EQTABCOUNT Sad Path 2a g_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQTABCOUNT Sad Path 2b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
               'Expected % rows from "USER_TAB_COLUMNS" and got % rows from "USER_TABLES"'));
   end tc_eqtabcount;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

-- Concatenated SCHEMA_NAME.OBJECT_NAME
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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_object_exists
   is
   begin
      wt_assert.g_testcase := 'OBJEXISTS Tests';
      objexists (
         msg_in        =>   'OBJEXISTS Happy Path 1',
         obj_owner_in  =>   'SYS',
         obj_name_in   =>   'DUAL');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'OBJEXISTS');
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'OBJEXISTS Happy Path 1');
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "SYS.DUAL" is 1');
      objexists (
         msg_in          =>  'OBJEXISTS Happy Path 2',
         check_this_in   =>  'SYS.DUAL');
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      objexists (
         msg_in        =>   'Not Used',
         obj_owner_in  =>   'JOE SMITH',
         obj_name_in   =>   'BOGUS');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'OBJEXISTS Sad Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "JOE SMITH.BOGUS" is 0');
   end tc_object_exists;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


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

-- Concatenated SCHEMA_NAME.OBJECT_NAME
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

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure tc_object_not_exists
   is
   begin
      wt_assert.g_testcase := 'OBJNOTEXISTS Tests';
      objnotexists (
         msg_in        =>   'OBJNOTEXISTS Happy Path 1',
         obj_owner_in  =>   'BOGUS123',
         obj_name_in   =>   'BOGUS123');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Happy Path 1 g_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Happy Path 1 g_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'OBJNOTEXISTS');
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Happy Path 1 g_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'OBJNOTEXISTS Happy Path 1');
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Happy Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "BOGUS123.BOGUS123" is 0');
      objnotexists (
         msg_in          =>   'OBJNOTEXISTS Happy Path 2',
         check_this_in   =>   'BOGUS123.BOGUS123');
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := TRUE;
      objnotexists (
         msg_in        =>   'Not Used',
         obj_owner_in  =>   'SYS',
         obj_name_in   =>   'DUAL');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Sad Path 1',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'OBJNOTEXISTS Sad Path 1 g_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "SYS.DUAL" is 1');
   end tc_object_not_exists;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   -- Can't profile this package because all the "assert" tests
   --   pause profiling before they execute.
   procedure WTPLSQL_RUN
   is
   begin
      select temp_clob,  temp_nclob,  temp_xml,  temp_blob
       into  temp_clob1, temp_nclob1, temp_xml1, temp_blob1
       from  wt_test_data where id = 1;
      wt_assert.g_raise_exception := FALSE;
      tc_boolean_to_status;
      tc_process_assertion;
      tc_compare_queries;
      tc_nls_settings;
      tc_last_values;
      tc_reset_globals;
      tc_this;
      tc_eq;
      tc_isnotnull;
      tc_isnull;
      tc_raises;
      tc_eqqueryvalue;
      tc_eqquery;
      tc_eqtable;
      tc_eqtabcount;
      tc_object_exists;
      tc_object_not_exists;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_assert;
/
