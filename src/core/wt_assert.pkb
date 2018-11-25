create or replace package body wt_assert is

   $IF $$WTPLSQL_SELFTEST $THEN  ------%WTPLSQL_begin_ignore_lines%------
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
      --------------------------------------  WTPLSQL Testing --
      temp_nc1    CONSTANT NVARCHAR2(12)  := 'NCHAR1';
      temp_nc2    CONSTANT NVARCHAR2(12)  := 'NCHAR2';
      temp_bool   CONSTANT boolean        := NULL;
      temp_clob1           CLOB;
      temp_clob2  CONSTANT CLOB           := 'This is another clob.';
      temp_nclob1          NCLOB;
      temp_nclob2 CONSTANT NCLOB          := 'This is another clob.';
      temp_xml1            XMLTYPE;
      temp_xml2   CONSTANT XMLTYPE        := xmltype('<?xml version="1.0" encoding="UTF-8"?><note>2</note>');
      --------------------------------------  WTPLSQL Testing --
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
      --------------------------------------  WTPLSQL Testing --
      temp_rec          g_rec_type;
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
      return 'TRUE';
   end if;
   return 'FALSE';
end boolean_to_status;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_boolean_to_status
   is
   begin
      wt_assert.g_testcase := 'BOOLEAN_TO_STATUS';
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in            => 'Test for "TRUE" conversion'
         ,check_this_in     => boolean_to_status(TRUE)
         ,against_this_in   => 'TRUE');
      wt_assert.eq
         (msg_in            => 'Test for "FALSE" conversion'
         ,check_this_in     => boolean_to_status(FALSE)
         ,against_this_in   => 'FALSE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in            => 'Test for NULL'
         ,check_this_in     => boolean_to_status(temp_bool));
   end t_boolean_to_status;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure process_assertion
is
begin
$IF $$WTPLSQL_SELFTEST $THEN  ------%WTPLSQL_begin_ignore_lines%------
   if not wtplsql_skip_save then
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
   if core_data.g_run_rec.runner_name is null
   then
      hook.ad_hoc_report;
   else
      core_data.add
         (in_testcase  => g_testcase
         ,in_assertion => g_rec.last_assert
         ,in_pass      => g_rec.last_pass
         ,in_details   => g_rec.last_details
         ,in_message   => g_rec.last_msg);
   end if;
$IF $$WTPLSQL_SELFTEST $THEN   ------%WTPLSQL_begin_ignore_lines%------
   end if;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
   hook.after_assertion;
   if     g_rec.raise_exception
      and not g_rec.last_pass
   then
      raise_application_error(-20003, g_rec.last_msg      || CHR(10) ||
         ' Assertion ' || g_rec.last_assert || ' Failed.' || CHR(10) ||
         ' Testcase: ' || g_testcase                      || CHR(10) ||
                   ' ' || g_rec.last_details              );
   end if;
end process_assertion;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_process_assertion
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      g_testcase            := 'PROCESS_ASSERTION';
      g_rec.last_assert     := 'THIS';
      g_rec.last_pass       := FALSE;
      g_rec.last_details    := 'Expected "PASS" and got "FAIL"';
      g_rec.last_msg        := 'Process Assertion Forced Failure';
      g_rec.raise_exception := TRUE;
      wtplsql_skip_save  := TRUE;
      process_assertion;  -- Should throw exception
      wtplsql_skip_save  := FALSE;
      --------------------------------------  WTPLSQL Testing --
   exception
      when ASSERT_FAILURE_EXCEPTION then
         wtplsql_skip_save := FALSE;
   end t_process_assertion;
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
   procedure t_compare_queries
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'COMPARE_QUERIES Bad Query Test 1';
      compare_queries (
         check_query_in     => 'select bogus123 from bogus456',
         against_query_in   => 'select bogus987 from bogus654');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in           => 'temp_rec.last_pass',
         check_this_in    => temp_rec.last_pass,
         against_this_in  => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull(
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this(
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            '%PL/SQL: ORA-00942: table or view does not exist%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'COMPARE_QUERIES Bad Query Test 2';
      compare_queries (
         check_query_in     => 'select table_name from user_tables',
         against_query_in   => 'select tablespace_name from user_tables');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in           => 'temp_rec.last_pass',
         check_this_in    => temp_rec.last_pass,
         against_this_in  => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull(
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this(
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details like
                            '%Comparison Query: with check_query as' ||
                            ' (select table_name from user_tables%');
   end t_compare_queries;
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
   return varchar2
is
begin
   return g_rec.last_assert;
end last_assert;

function last_msg
   return varchar2
is
begin
   return g_rec.last_msg;
end last_msg;

function last_details
   return varchar2
is
begin
   return g_rec.last_details;
end last_details;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_last_values
   is
   begin
      --------------------------------------  WTPLSQL Testing --
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
      --------------------------------------  WTPLSQL Testing --
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
   end t_last_values;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure reset_globals
is
begin
   g_testcase            := '';
   g_rec.last_pass       := NULL;
   g_rec.raise_exception := FALSE;
   g_rec.last_assert     := '';
   g_rec.last_msg        := '';
   g_rec.last_details    := '';
end reset_globals;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_reset_globals
   is
   begin
      reset_globals;  -- Resets g_testcase
      temp_rec         := g_rec;
      temp_testcase    := g_testcase;
      --------------------------------------  WTPLSQL Testing --
      g_testcase       := 'RESET_GLOBALS';
      wt_assert.isnull(
         msg_in        => 'temp_testcase',
         check_this_in => temp_testcase);
      wt_assert.isnull
         (msg_in        => 'temp_rec.last_pass'
         ,check_this_in => temp_rec.last_pass);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq(
         msg_in          => 'temp_rec.raise_exception',
         check_this_in   => temp_rec.raise_exception,
         against_this_in => FALSE);
      wt_assert.isnull
         (msg_in        => 'temp_rec.last_assert'
         ,check_this_in => temp_rec.last_assert);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull
         (msg_in        => 'temp_rec.last_msg'
         ,check_this_in => temp_rec.last_msg);
      wt_assert.isnull
         (msg_in        => 'temp_rec.last_details'
         ,check_this_in => temp_rec.last_details);
   end t_reset_globals;
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
   procedure t_nls_settings
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'NLS Settings';
      set_NLS_DATE_FORMAT('DD-MON-YYYY');
      wt_assert.eq
         (msg_in          => 'get_NLS_DATE_FORMAT 1'
         ,check_this_in   => get_NLS_DATE_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_DATE_FORMAT;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'get_NLS_DATE_FORMAT 2'
         ,check_this_in   => get_NLS_DATE_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS');
      set_NLS_TIMESTAMP_FORMAT('DD-MON-YYYY');
      wt_assert.eq
         (msg_in          => 'get_NLS_TIMESTAMP_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_TIMESTAMP_FORMAT;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'get_NLS_TIMESTAMP_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6');
      set_NLS_TIMESTAMP_TZ_FORMAT('DD-MON-YYYY');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq
         (msg_in          => 'get_NLS_TIMESTAMP_TZ_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
         ,against_this_in => 'DD-MON-YYYY');
      set_NLS_TIMESTAMP_TZ_FORMAT;
      wt_assert.eq
         (msg_in          => 'get_NLS_TIMESTAMP_TZ_FORMAT 2'
         ,check_this_in   => get_NLS_TIMESTAMP_TZ_FORMAT
         ,against_this_in => 'DD-MON-YYYY HH24:MI:SS.FF6 TZH:TZM');
   end t_nls_settings;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------
--  Assertion Procedures
------------------------

------------------------------------------------------------
procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
      raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'THIS';
   g_rec.last_msg     := substr(msg_in,1,200);
   g_rec.last_pass    := nvl(check_this_in, FALSE);
   g_rec.last_details := 'Expected "TRUE" and got "' ||
                          boolean_to_status(check_this_in) || '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end this;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_this
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'This Happy Path';
      wt_assert.this (
         msg_in         => 'Run Test',
         check_this_in  => TRUE);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'THIS');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected "TRUE" and got "TRUE"');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'This Sad Path 1';
      wtplsql_skip_save := TRUE;
      this (
         msg_in         => 'Not Used',
         check_this_in  => FALSE);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'This Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         this (
            msg_in         => 'Not Used',
            check_this_in  => FALSE,
            raise_exc_in   => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'This Sad Path 3';
      wtplsql_skip_save := TRUE;
      this (
         msg_in         => 'Not Used',
         check_this_in  => NULL);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
   end t_this;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- EQ: string overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   varchar2,
   against_this_in   in   varchar2,
   null_ok_in        in   boolean := false,
   raise_exc_in      in   boolean := false)
is
begin
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
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eq;

-- EQ: boolean overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   boolean,
   against_this_in   in   boolean,
   null_ok_in        in   boolean := false,
   raise_exc_in      in   boolean := false)
is
begin
   eq (msg_in           => msg_in
      ,check_this_in    => boolean_to_status(check_this_in)
      ,against_this_in  => boolean_to_status(against_this_in)
      ,null_ok_in       => null_ok_in
      ,raise_exc_in     => raise_exc_in);
end eq;

-- EQ: XMLTYPE
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   XMLTYPE,
   against_this_in   in   XMLTYPE,
   null_ok_in        in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in      in   boolean := false)
is
begin
   g_rec.last_assert  := 'EQ';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (xmltype.getclobval(check_this_in)  =
                          xmltype.getclobval(against_this_in)  );
   g_rec.last_details := 'Expected "' || substr(xmltype.getclobval(against_this_in),1,1000) ||
                        '" and got "' || substr(xmltype.getclobval(check_this_in)  ,1,1000) ||
                        '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eq;

-- EQ: CLOB
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   CLOB,
   against_this_in   in   CLOB,
   null_ok_in        in   boolean := false,
   raise_exc_in      in   boolean := false)
is
begin
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
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eq;

-- EQ: BLOB
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   BLOB,
   against_this_in   in   BLOB,
   null_ok_in        in   boolean := false,
   raise_exc_in      in   boolean := false)
is
   compare_results  number;
begin
   g_rec.last_assert  := 'EQ';
   g_rec.last_msg     := msg_in;
   compare_results    := nvl(DBMS_LOB.COMPARE(check_this_in, against_this_in),-1);
   g_rec.last_pass    := (    (compare_results = 0)
                           or (    check_this_in is null
                              and against_this_in is null
                              and null_ok_in              )
                         );
   g_rec.last_details := 'DBMS_LOB.COMPARE on BLOBs, compare_results: ' || compare_results;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eq;

-------------------------------------------------------------------------
--   This is the start of a MASSIVE Unit Test on the "EQ" assertion   ---
-------------------------------------------------------------------------

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_eq
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => 'X',
         against_this_in => 'X');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'Run Test'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details = 'Expected "X" and got "X"'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => 'X',
         against_this_in => 'X',
         null_ok_in      => TRUE);
      wt_assert.g_testcase := 'EQ VARCHAR2 Happy Path 3';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => '',
         against_this_in => '',
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 'X',
         against_this_in => 'Y');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => 'X');
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eq (
            msg_in          => 'Not Used',
            check_this_in   => 'X',
            against_this_in => 'Y',
            raise_exc_in    => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 3';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => 'Y');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'check_this_in value',
         check_this_in   => '');
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 4';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => '');
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'check_this_in value',
         check_this_in   => '');
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => '');
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 5';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 'X',
         against_this_in => 'Y',
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => 'X');
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ VARCHAR2 Sad Path 6';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => '',
         against_this_in => 'Y',
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnull (
         msg_in          => 'check_this_in value',
         check_this_in   => '');
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => 'Y');
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes ROWID
      wt_assert.g_testcase := 'EQ ROWID Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_rowid1,
         against_this_in => temp_rowid1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ ROWID Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_rowid1,
         against_this_in => temp_rowid2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_rowid1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_rowid2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes LONG
      wt_assert.g_testcase := 'EQ LONG Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_long1,
         against_this_in => temp_long1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ LONG Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_long1,
         against_this_in => temp_long2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_long1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_long2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes RAW
      wt_assert.g_testcase := 'EQ RAW Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_raw1,
         against_this_in => temp_raw1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ RAW Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_raw1,
         against_this_in => temp_raw2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_raw1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_raw2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes LONG RAW
      wt_assert.g_testcase := 'EQ LONG RAW Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_lraw1,
         against_this_in => temp_lraw1);
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes LONG RAW
      wt_assert.g_testcase := 'EQ LONG RAW Happy Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_lraw1,
         against_this_in => temp_lraw2);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ LONG RAW Sad Path 1';
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_lraw1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_lraw2);
      wt_assert.this (
         msg_in          => 'Sad Path 1',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- VARCHAR2 includes Includes NVARCHAR2
      wt_assert.g_testcase := 'EQ NVARCHAR2 Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_nc1,
         against_this_in => temp_nc1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NVARCHAR2 Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nc1,
         against_this_in => temp_nc2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_nc1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_nc2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => FALSE,
         against_this_in => FALSE);
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => FALSE,
         against_this_in => FALSE,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Path 3';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_bool,
         against_this_in => temp_bool,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Sad 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => TRUE);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Sad 2';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => temp_bool);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_bool);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Sad 3';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => TRUE,
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => TRUE);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BOOLEAN Happy Sad 4';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => FALSE,
         against_this_in => temp_bool,
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => FALSE);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_bool);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NUMBER Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => 4,
         against_this_in => 4);
      wt_assert.g_testcase := 'EQ NUMBER Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => 9876543210987654321098765432109876543210,
         against_this_in => 9876543210987654321098765432109876543210);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NUMBER Happy Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => 4,
         against_this_in => 5);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => 4);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => 5);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: NUMBER implicit conversion includes PLS_INTEGER
      wt_assert.g_testcase := 'EQ PLS_INTEGER Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_pint1,
         against_this_in => temp_pint1);
      wtplsql_skip_save := TRUE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ PLS_INTEGER Sad Path 1';
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_pint1,
         against_this_in => temp_pint2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_pint1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_pint2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ DATE Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_date,
         against_this_in => temp_date);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ DATE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_date,
         against_this_in => temp_date + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_date);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_date + 1/24);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion includes TIMESTAMP
      wt_assert.g_testcase := 'EQ TIMSETAMP Happy Path 1';
      eq (
         msg_in          => 'EQ TIMSETAMP Happy Path 1',
         check_this_in   => temp_tstmp,
         against_this_in => temp_tstmp);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ TIMSETAMP Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstmp,
         against_this_in => temp_tstmp + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_tstmp);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_tstmp + 1/24);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion includes TIMESTAMP
      wt_assert.g_testcase := 'EQ TIMSETAMP WITH LOCAL TIME ZONE Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ TIMSETAMP WITH LOCAL TIME ZONE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstlzn,
         against_this_in => temp_tstlzn + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_tstlzn);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_tstlzn + 1/24);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion includes TIMESTAMP
      wt_assert.g_testcase := 'EQ TIMSETAMP WITH TIME ZONE Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ TIMSETAMP WITH TIME ZONE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_tstzn,
         against_this_in => temp_tstzn + 1/24);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_tstzn);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_tstzn + 1/24);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion includes INTERVAL
      wt_assert.g_testcase := 'EQ INTERVAL DAY TO SECOND Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_intds1,
         against_this_in => temp_intds1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ INTERVAL DAY TO SECOND Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_intds1,
         against_this_in => temp_intds2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_intds1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_intds2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      -- EQ: DATE implicit conversion includes INTERVAL
      wt_assert.g_testcase := 'EQ INTERVAL YEAR TO MONTH Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_intym1,
         against_this_in => temp_intym1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ INTERVAL YEAR TO MONTH Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_intym1,
         against_this_in => temp_intym2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_intym1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_intym2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ XMLTYPE Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_xml1,
         against_this_in => temp_xml1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => ' g_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'Run Test'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ XMLTYPE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_xml1,
         against_this_in => temp_xml2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => xmltype.getclobval(temp_xml1));
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => xmltype.getclobval(temp_xml2));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ XMLTYPE Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eq (
            msg_in          => 'Not Used',
            check_this_in   => temp_xml1,
            against_this_in => temp_xml2,
            raise_exc_in    => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'Run Test'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob1,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Happy Path 3';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => cast (NULL as CLOB),
         against_this_in => cast (NULL as CLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => temp_clob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_clob2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eq (
            msg_in          => 'Not Used',
            check_this_in   => temp_clob1,
            against_this_in => temp_clob2,
            raise_exc_in    => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Sad Path 3';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => cast (NULL as CLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as CLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ CLOB Sad Path 4';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_clob1,
         against_this_in => cast (NULL as CLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_clob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as CLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob1);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob1,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Happy Path 3';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => cast (NULL as NCLOB),
         against_this_in => cast (NULL as NCLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => temp_nclob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_nclob2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eq (
            msg_in          => 'Not Used',
            check_this_in   => temp_nclob1,
            against_this_in => temp_nclob2,
            raise_exc_in    => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Sad Path 3';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => cast (NULL as NCLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as NCLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ NCLOB Sad Path 4';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_nclob1,
         against_this_in => cast (NULL as NCLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_nclob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as NCLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Happy Path 1';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_pass value',
         check_this_in   => temp_rec.last_pass);
      wt_assert.this (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => (temp_rec.last_pass = TRUE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_assert value',
         check_this_in   => temp_rec.last_assert);
      wt_assert.this (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => (temp_rec.last_assert = 'EQ'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_msg value',
         check_this_in   => temp_rec.last_msg);
      wt_assert.this (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => (temp_rec.last_msg = 'Run Test'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details =
                            'DBMS_LOB.COMPARE on BLOBs, compare_results: 0'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Happy Path 2';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob1,
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Happy Path 3';
      eq (
         msg_in          => 'Run Test',
         check_this_in   => cast (NULL as BLOB),
         against_this_in => cast (NULL as BLOB),
         null_ok_in      => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => temp_blob2);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnotnull (
         msg_in          => 'against_this_in value',
         check_this_in   => temp_blob2);
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eq (
            msg_in          => 'Not Used',
            check_this_in   => temp_blob1,
            against_this_in => temp_blob2,
            raise_exc_in    => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Sad Path 3';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => cast (NULL as BLOB));
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as BLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQ BLOB Sad Path 4';
      wtplsql_skip_save := TRUE;
      eq (
         msg_in          => 'Not Used',
         check_this_in   => temp_blob1,
         against_this_in => cast (NULL as BLOB),
         null_ok_in      => TRUE);
      wtplsql_skip_save := FALSE;
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.isnotnull (
         msg_in          => 'check_this_in value',
         check_this_in   => temp_blob1);
      wt_assert.isnull (
         msg_in          => 'against_this_in value',
         check_this_in   => cast (NULL as BLOB));
      wt_assert.this (
         msg_in          => 'last_pass = FALSE',
         check_this_in   => (temp_rec.last_pass = FALSE));
   end t_eq;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------

-----------------------------------------------------------------------
--   This is the end of a MASSIVE Unit Test on the "EQ" assertion   ---
-----------------------------------------------------------------------


------------------------------------------------------------
-- ISNOTNULL string overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   g_rec.last_details := 'Expected NOT NULL and got "' ||
                          substr(check_this_in,1,2000) || '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnotnull;

-- ISNOTNULL boolean overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   isnotnull (msg_in        => msg_in
             ,check_this_in => boolean_to_status(check_this_in)
             ,null_ok_in    => null_ok_in
             ,raise_exc_in  => raise_exc_in);
end isnotnull;

-- ISNOTNULL CLOB overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   CLOB,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   g_rec.last_details := 'Expected NOT NULL and got "' ||
                          substr(check_this_in,1,2000) || '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnotnull;

-- ISNOTNULL BLOB overload
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   BLOB,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNOTNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is not null);
   if g_rec.last_pass
   then
      g_rec.last_details := 'BLOB is NOT NULL';
   else
      g_rec.last_details := 'BLOB is NULL';
   end if;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnotnull;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_isnotnull
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL VARCHAR2 Happy Path 1';
      isnotnull (
         msg_in        => 'Run Test',
         check_this_in => 'X');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NOT NULL and got "X"');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL VARCHAR2 Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => '');
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL VARCHAR2 Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnotnull (
            msg_in        => 'Not Used',
            check_this_in => '',
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BOOLEAN Happy Path 1';
      isnotnull (
         msg_in        => 'Run Test',
         check_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BOOLEAN Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => temp_bool);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BOOLEAN Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnotnull (
            msg_in        => 'Not Used',
            check_this_in => temp_bool,
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL CLOB Happy Path 1';
      isnotnull (
         msg_in        => 'Run Test',
         check_this_in => temp_clob1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected NOT NULL and got "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL CLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => cast (null as CLOB));
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL CLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnotnull (
            msg_in        => 'Not Used',
            check_this_in => cast (null as CLOB),
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BLOB Happy Path 1';
      isnotnull (
         msg_in        => 'Run Test',
         check_this_in => temp_blob1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNOTNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'BLOB is NOT NULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnotnull (
         msg_in        => 'Not Used',
         check_this_in => cast (null as BLOB));
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNOTNULL BLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnotnull (
            msg_in        => 'Not Used',
            check_this_in => cast (null as BLOB),
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
   end t_isnotnull;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- ISNULL string overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   g_rec.last_details := 'Expected NULL and got "' ||
                      substr(check_this_in,1,2000) || '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnull;

-- ISNULL boolean overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   isnull (msg_in        => msg_in
          ,check_this_in => boolean_to_status(check_this_in)
          ,null_ok_in    => null_ok_in
          ,raise_exc_in  => raise_exc_in);
end isnull;

-- ISNULL CLOB overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   CLOB,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   g_rec.last_details := 'Expected NULL and got "' ||
                      substr(check_this_in,1,2000) || '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnull;

-- ISNULL BLOB overload
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   BLOB,
   null_ok_in      in   boolean := false,   -- Not Used, utPLSQL V1 API
   raise_exc_in    in   boolean := false)
is
begin
   g_rec.last_assert  := 'ISNULL';
   g_rec.last_msg     := msg_in;
   g_rec.last_pass    := (check_this_in is null);
   if g_rec.last_pass
   then
      g_rec.last_details := 'BLOB is NULL';
   else
      g_rec.last_details := 'BLOB is NOT NULL';
   end if;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end isnull;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_isnull
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL VARCHAR2 Happy Path 1';
      isnull (
         msg_in        => 'Run Test',
         check_this_in => '');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NULL and got ""');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL VARCHAR2 Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => 'X');
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL VARCHAR2 Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnull (
            msg_in        => 'Not Used',
            check_this_in => 'X',
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BOOLEAN Happy Path 1';
      isnull (
         msg_in        => 'Run Test',
         check_this_in => temp_bool);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BOOLEAN Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => FALSE);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BOOLEAN Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnull (
            msg_in        => 'Not Used',
            check_this_in => FALSE,
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL CLOB Happy Path 1';
      isnull (
         msg_in        => 'Run Test',
         check_this_in => cast (null as CLOB));
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected NULL and got ""');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL CLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => temp_clob1);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL CLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnull (
            msg_in        => 'Not Used',
            check_this_in => temp_clob1,
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BLOB Happy Path 1';
      isnull (
         msg_in        => 'Run Test',
         check_this_in => cast (null as BLOB));
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'ISNULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'BLOB is NULL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      isnull (
         msg_in        => 'Not Used',
         check_this_in => temp_blob1);
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'ISNULL BLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         isnull (
            msg_in        => 'Not Used',
            check_this_in => temp_blob1,
            raise_exc_in  => TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'g_rec.last_pass',
         check_this_in   => g_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
   end t_isnull;
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
      execute immediate check_call_in;
   exception when OTHERS then
      l_sqlerrm := SQLERRM;
      l_errstack := substr(dbms_utility.format_error_stack  ||
                           dbms_utility.format_error_backtrace
                           ,1,4000);
   end;
   --
   g_rec.last_assert  := 'RAISES/THROWS';
   g_rec.last_msg     := msg_in;
   if against_exc_in is null AND l_sqlerrm is null
   then
      -- Both are Null
      g_rec.last_pass := TRUE;
   elsif against_exc_in is null OR l_sqlerrm is null
   then
      -- If both were Null, it would have been caught above.
      --   So, only one can be Null
      g_rec.last_pass := FALSE;
   else
      -- If either was Null, it would have been caught above.
      g_rec.last_pass := l_sqlerrm like '%' || against_exc_in || '%';
   end if;
   if against_exc_in is null
   then
      g_rec.last_details := 'No exception was expected' ||
                             '. Exception raised was "' || l_sqlerrm      ||
                            '". Exception raised by: "' || check_call_in  || '".';
   elsif l_sqlerrm is null
   then
      g_rec.last_details := 'Expected exception "%'           || against_exc_in ||
                          '%". No exception was raised by: "' || check_call_in  || '".';
   else
      g_rec.last_details := 'Expected exception "%'           || against_exc_in ||
                          '%". Actual exception raised was "' || l_sqlerrm      ||
                                  '". Exception raised by: "' || check_call_in  || '".';
   end if;
   if not g_rec.last_pass
   then
      g_rec.last_details := 
         substr(g_rec.last_details || ' Error Stack: ' || l_errstack, 1, 4000);
   end if;
   process_assertion;
end raises;

procedure raises (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   number)
is
begin
   if against_exc_in is null
   then
      raises (
         msg_in          => msg_in,
         check_call_in   => check_call_in,
         against_exc_in  => '');
   else
      raises (
         msg_in          => msg_in,
         check_call_in   => check_call_in,
         against_exc_in  => '-' || lpad(abs(against_exc_in),5,'0'));
   end if;
end raises;

procedure throws (
      msg_in              varchar2,
      check_call_in   in  varchar2,
      against_exc_in  in  varchar2)
is
begin
   raises (
      msg_in          => msg_in,
      check_call_in   => check_call_in,
      against_exc_in  => against_exc_in);
end throws;

procedure throws (
      msg_in              varchar2,
      check_call_in   in  varchar2,
      against_exc_in  in  number)
is
begin
   raises (
      msg_in          => msg_in,
      check_call_in   => check_call_in,
      against_exc_in  => against_exc_in);
end throws;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_raises
   is
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Raises Tests Happy Path 1';
      raises (
         msg_in         => 'RAISES Varchar2 Test',
         check_call_in  => 'begin wt_assert.bogus; end;',
         against_exc_in => 'PLS-00302: component ''BOGUS'' must be declared');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'RAISES/THROWS');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'RAISES Varchar2 Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%PLS-00302: component ''BOGUS'' must be declared%". ' ||
                            'Actual exception raised was "ORA-06550: line 1, column 17:' || CHR(10) ||
                            'PLS-00302: component ''BOGUS'' must be declared' || CHR(10) ||
                            'ORA-06550: line 1, column 7:' || CHR(10) ||
                            'PL/SQL: Statement ignored". ' ||
                            'Exception raised by: "begin wt_assert.bogus; end;".');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Raises Tests Happy Path 2';
      raises (
         msg_in         => 'RAISES Number Test',
         check_call_in  => 'begin wt_assert.bogus; end;',
         against_exc_in => 302);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%-00302%". ' ||
                            'Actual exception raised was "' ||
                            'ORA-06550: line 1, column 17:' || CHR(10) ||
                            'PLS-00302: component ''BOGUS'' must be declared' || CHR(10) ||
                            'ORA-06550: line 1, column 7:' || CHR(10) ||
                            'PL/SQL: Statement ignored". ' ||
                            'Exception raised by: "begin wt_assert.bogus; end;".');
      --------------------------------------  WTPLSQL Testing --
      throws (
         msg_in         => 'THROWS Varchar2 Test',
         check_call_in  => 'begin wt_assert.bogus; end;',
         against_exc_in => 'PLS-00302: component ''BOGUS'' must be declared');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%PLS-00302: component ''BOGUS'' must be declared%". ' ||
                            'Actual exception raised was "' ||
                            'ORA-06550: line 1, column 17:' || CHR(10) ||
                            'PLS-00302: component ''BOGUS'' must be declared' || CHR(10) ||
                            'ORA-06550: line 1, column 7:' || CHR(10) ||
                            'PL/SQL: Statement ignored". ' ||
                            'Exception raised by: "begin wt_assert.bogus; end;".');
      --------------------------------------  WTPLSQL Testing --
      throws (
         msg_in         => 'THROWS Number Test',
         check_call_in  => 'begin wt_assert.bogus; end;',
         against_exc_in => 302);
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%-00302%". ' ||
                            'Actual exception raised was "' ||
                            'ORA-06550: line 1, column 17:' || CHR(10) ||
                            'PLS-00302: component ''BOGUS'' must be declared' || CHR(10) ||
                            'ORA-06550: line 1, column 7:' || CHR(10) ||
                            'PL/SQL: Statement ignored". ' ||
                            'Exception raised by: "begin wt_assert.bogus; end;".');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Raises Tests Happy Path 3';
      raises (
         msg_in         => 'RAISES Varchar2 No Error',
         check_call_in  => 'begin wt_assert.set_NLS_DATE_FORMAT(wt_assert.get_NLS_DATE_FORMAT); end;',
         against_exc_in => '');
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'No exception was expected. ' ||
                            'Exception raised was "". ' ||
                            'Exception raised by: "begin wt_assert.set_NLS_DATE_FORMAT(wt_assert.get_NLS_DATE_FORMAT); end;".');
      --------------------------------------  WTPLSQL Testing --
      raises (
         msg_in         => 'RAISES Number No Error',
         check_call_in  => 'begin wt_assert.set_NLS_DATE_FORMAT(wt_assert.get_NLS_DATE_FORMAT); end;',
         against_exc_in => cast (null as number));
      temp_rec := g_rec;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'No exception was expected. ' ||
                            'Exception raised was "". ' ||
                            'Exception raised by: "begin wt_assert.set_NLS_DATE_FORMAT(wt_assert.get_NLS_DATE_FORMAT); end;".');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Raises Tests Sad Path 1';
      wtplsql_skip_save := TRUE;
      raises (
         msg_in         => 'Not Used',
         check_call_in  => 'begin wt_assert.bogus; end;',
         against_exc_in => 'Incorrect Exception');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected exception "%Incorrect Exception%". ' ||
                            'Actual exception raised was "ORA-%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'Raises Tests Sad Path 2';
      wtplsql_skip_save := TRUE;
      raises (
         msg_in         => 'Not Used',
         check_call_in  => 'begin wt_assert.set_NLS_DATE_FORMAT; end;',
         against_exc_in => 'Incorrect Exception');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected exception "%Incorrect Exception%". ' ||
                            'No exception was raised by: "begin wt_assert.set_NLS_DATE_FORMAT; end;". ' ||
                            'Error Stack: ');
   end t_raises;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
-- EQQUERYVALUE
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   varchar2,
      null_ok_in         in   boolean := false,
      raise_exc_in       in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     varchar2(32000);
   l_errstack    varchar2(4000);
begin
   g_rec.last_assert     := 'EQQUERYVALUE';
   g_rec.last_msg        := msg_in;
   open l_rc for check_query_in;
   fetch l_rc into l_rc_buff;
   close l_rc;
   g_rec.last_pass    := (   l_rc_buff = against_value_in
                          or (    l_rc_buff is null
                              and against_value_in is null
                              and null_ok_in               )  );
   g_rec.last_details := 'Expected "' || substr(against_value_in,1,1000) ||
                        '" and got "' || substr(l_rc_buff       ,1,1000) ||
                      '" for Query: ' || substr(check_query_in  ,1,1000) ;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
exception when others then
   l_errstack := substr(dbms_utility.format_error_stack ||
                        dbms_utility.format_error_backtrace,1,2900);
   g_rec.last_details := 'Exception raised for Query: ' ||
                          substr(check_query_in  ,1,1000) ||
                          CHR(10) || l_errstack;
   g_rec.last_pass    := FALSE;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqqueryvalue;

-- EQQUERYVALUE XMLTYPE Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   XMLTYPE,
      null_ok_in         in   boolean := false,  -- Not Used, utPLSQL V1 API
      raise_exc_in       in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     XMLTYPE;
   l_errstack    varchar2(4000);
begin
   g_rec.last_assert  := 'EQQUERYVALUE';
   g_rec.last_msg     := msg_in;
   open l_rc for check_query_in;
   fetch l_rc into l_rc_buff;
   close l_rc;
   g_rec.last_pass    := (xmltype.getclobval(l_rc_buff)       =
                          xmltype.getclobval(against_value_in)  );
   g_rec.last_details := 'Expected "' || substr(xmltype.getclobval(against_value_in),1,1000) ||
                        '" and got "' || substr(xmltype.getclobval(l_rc_buff       ),1,1000) ||
                      '" for Query: ' || substr(                   check_query_in   ,1,1000) ;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
exception when others then
   l_errstack := substr(dbms_utility.format_error_stack ||
                        dbms_utility.format_error_backtrace,1,2900);
   g_rec.last_details := 'Exception raised for Query: ' ||
                          substr(check_query_in  ,1,1000) ||
                          CHR(10) || l_errstack;
   g_rec.last_pass    := FALSE;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqqueryvalue;

-- EQQUERYVALUE CLOB Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   CLOB,
      null_ok_in         in   boolean := false,
      raise_exc_in       in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc          rc_type;
   l_rc_buff     CLOB;
   l_errstack    varchar2(4000);
begin
   g_rec.last_assert  := 'EQQUERYVALUE';
   g_rec.last_msg     := msg_in;
   open l_rc for check_query_in;
   fetch l_rc into l_rc_buff;
   close l_rc;
   g_rec.last_pass    := (   l_rc_buff = against_value_in
                          or (    l_rc_buff is null
                              and against_value_in is null
                              and null_ok_in               )  );
   g_rec.last_details := 'Expected "' || substr(against_value_in,1,1000) ||
                        '" and got "' || substr(l_rc_buff       ,1,1000) ||
                      '" for Query: ' || substr(check_query_in  ,1,1000) ;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
exception when others then
   l_errstack := substr(dbms_utility.format_error_stack ||
                        dbms_utility.format_error_backtrace,1,2900);
   g_rec.last_details := 'Exception raised for Query: ' ||
                          substr(check_query_in  ,1,1000) ||
                          CHR(10) || l_errstack;
   g_rec.last_pass    := FALSE;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqqueryvalue;

-- EQQUERYVALUE BLOB Overload
procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   BLOB,
      null_ok_in         in   boolean := false,
      raise_exc_in       in   boolean := false)
is
   type rc_type is ref cursor;
   l_rc            rc_type;
   l_rc_buff       BLOB;
   compare_results number;
   l_errstack      varchar2(4000);
begin
   g_rec.last_assert  := 'EQQUERYVALUE';
   g_rec.last_msg     := msg_in;
   open l_rc for check_query_in;
   fetch l_rc into l_rc_buff;
   close l_rc;
   compare_results    := nvl(DBMS_LOB.COMPARE(l_rc_buff, against_value_in),-1);
   g_rec.last_pass    := (   (compare_results = 0)
                          or (    l_rc_buff is null
                              and against_value_in is null
                              and null_ok_in               )  );
   g_rec.last_details := 'DBMS_LOB.COMPARE between BLOB and Query: ' ||
                           substr(check_query_in  ,1,2000) ||
                        ', compare_results: ' || compare_results;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
exception when others then
   l_errstack := substr(dbms_utility.format_error_stack ||
                        dbms_utility.format_error_backtrace,1,2900);
   g_rec.last_details := 'Exception raised for Query: ' ||
                          substr(check_query_in  ,1,1000) ||
                          CHR(10) || l_errstack;
   g_rec.last_pass    := FALSE;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqqueryvalue;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_eqqueryvalue
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE VARCHAR2 Happy Path 1';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select dummy from DUAL',
         against_value_in   =>   'X',
         null_ok_in         =>   false);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Expected "X" and got "X" for Query: select dummy from DUAL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE VARCHAR2 Happy Path 2';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select max(dummy) from DUAL where 0 = 1',
         against_value_in   =>   '',
         null_ok_in         =>   true);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE VARCHAR2 Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select dummy from DUAL',
         against_value_in   =>   'Y');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE VARCHAR2 Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqqueryvalue (
            msg_in             =>   'Not Used',
            check_query_in     =>   'select dummy from DUAL',
            against_value_in   =>   'Y',
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE VARCHAR2 Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'Garbage query that won''t work',
         against_value_in   =>   'Y');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details like
            'Exception raised for Query: Garbage query that won''t work' ||
            CHR(10) || 'ORA-00900: invalid SQL statement%');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE XMLTYPE Happy Path 1';
      eqqueryvalue (
         msg_in           => 'Run Test',
         check_query_in   => 'select temp_xml from wt_self_test where id = 1',
         against_value_in => temp_xml1);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE XMLTYPE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_xml from wt_self_test where id = 1',
         against_value_in   =>   temp_xml2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>' ||
             '<note>2</note>" and got "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE XMLTYPE Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqqueryvalue (
            msg_in             =>   'Not Used',
            check_query_in     =>   'select temp_xml from wt_self_test where id = 1',
            against_value_in   =>   temp_xml2,
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE XMLTYPE Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'Garbage query that won''t work',
         against_value_in   =>   temp_xml2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details like
            'Exception raised for Query: Garbage query that won''t work' ||
            CHR(10) || 'ORA-00900: invalid SQL statement%');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE CLOB Happy Path 1';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select temp_clob from wt_self_test where id = 1',
         against_value_in   =>   temp_clob1,
         null_ok_in         =>   false);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE CLOB Happy Path 2';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select temp_clob from wt_self_test where 0 = 1',
         against_value_in   =>   '',
         null_ok_in         =>   true);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE CLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_clob from wt_self_test where id = 1',
         against_value_in   =>   temp_clob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected "This is another clob." and got "' ||
                            '<?xml version="1.0" encoding="UTF-8"?>%'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE CLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqqueryvalue (
            msg_in             =>   'Not Used',
            check_query_in     =>   'select temp_clob from wt_self_test where id = 1',
            against_value_in   =>   temp_clob2,
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE CLOB Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'Garbage query that won''t work',
         against_value_in   =>   temp_clob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details like
            'Exception raised for Query: Garbage query that won''t work' ||
            CHR(10) || 'ORA-00900: invalid SQL statement%');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE BLOB Happy Path 1';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select temp_blob from wt_self_test where id = 1',
         against_value_in   =>   temp_blob1,
         null_ok_in         =>   false);
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERYVALUE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'DBMS_LOB.COMPARE between BLOB and Query:' ||
                           ' select temp_blob from wt_self_test where id = 1, compare_results: 0');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE BLOB Happy Path 2';
      eqqueryvalue (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select temp_blob from wt_self_test where 0 = 1',
         against_value_in   =>   cast (null as BLOB),
         null_ok_in         =>   true);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE BLOB Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select temp_blob from wt_self_test where id = 1',
         against_value_in   =>   temp_blob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'DBMS_LOB.COMPARE between BLOB and Query: ' ||
               'select temp_blob from wt_self_test where id = 1, compare_results: -1');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE BLOB Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqqueryvalue (
            msg_in             =>   'Not Used',
            check_query_in     =>   'select temp_blob from wt_self_test where id = 1',
            against_value_in   =>   temp_blob2,
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERYVALUE BLOB Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqqueryvalue (
         msg_in             =>   'Not Used',
         check_query_in     =>   'Garbage query that won''t work',
         against_value_in   =>   temp_blob2);
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details like
            'Exception raised for Query: Garbage query that won''t work' ||
            CHR(10) || 'ORA-00900: invalid SQL statement%');
   end t_eqqueryvalue;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure eqquery (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_query_in   in   varchar2,
      raise_exc_in       in   boolean := false)
is
begin
   g_rec.last_assert  := 'EQQUERY';
   g_rec.last_msg     := msg_in;
   compare_queries(check_query_in, against_query_in);
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqquery;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_eqquery
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERY Tests Happy Path 1';
      wt_assert.eqquery (
         msg_in             =>   'Run Test',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from USER_TABLES');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQQUERY');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'EQQUERY Tests Happy Path 1b g_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERY Tests Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqquery (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from USER_TABLES where 0 = 1');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERY Tests Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqquery (
            msg_in             =>   'Not Used',
            check_query_in     =>   'select * from USER_TABLES',
            against_query_in   =>   'select * from USER_TABLES where 0 = 1',
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQQUERY Tests Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqquery (
         msg_in             =>   'Not Used',
         check_query_in     =>   'select * from USER_TABLES',
         against_query_in   =>   'select * from ALL_TABLES');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                '%PL/SQL: ORA-01789: query block has incorrect number of result columns%'));
   end t_eqquery;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure eqtable (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null,
      raise_exc_in       in   boolean := false)
is
   l_check_query    varchar2(16000) := 'select * from ' || check_this_in;
   l_against_query  varchar2(16000) := 'select * from ' || against_this_in;
begin
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
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqtable;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_eqtable
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABLE Tests Happy Path 1';
      wt_assert.eqtable (
         msg_in             =>   'Run Test',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'USER_TABLES',
         check_where_in     =>   '',
         against_where_in   =>   '');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQTABLE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABLE Tests Happy Path 2';
      eqtable (
         msg_in             =>   'Run Test',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   'owner = ''' || USER || '''');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABLE Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqtable (
         msg_in             =>   'Not Used',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   '0 = 1');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Comparison Query: %'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABLE Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqtable (
            msg_in             =>   'Not Used',
            check_this_in      =>   'ALL_TABLES',
            against_this_in    =>   'ALL_TABLES',
            check_where_in     =>   'owner = ''' || USER || '''',
            against_where_in   =>   '0 = 1',
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABLE Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqtable (
         msg_in             =>   'Not Used',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'ALL_TABLES');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details like
               '%PL/SQL: ORA-01789: query block has incorrect number of result columns%');
   end t_eqtable;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure eqtabcount (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null,
      raise_exc_in       in   boolean := false)
is
   l_query      varchar2(16000) := 'select count(*) from ' || check_this_in;
   l_cnt        number;
   l_success    boolean;
   l_check_cnt  number;
   procedure l_run_query is
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
         g_rec.raise_exception := raise_exc_in;
         process_assertion;
   end l_run_query;
begin
   g_rec.last_assert  := 'EQTABCOUNT';
   g_rec.last_msg     := msg_in;
   --
   l_query := 'select count(*) from ' || check_this_in;
   if check_where_in is not null
   then
      l_query := l_query || ' where ' || check_where_in;
   end if;
   l_run_query;
   if NOT l_success then return; end if;
   l_check_cnt := l_cnt;
   --
   l_query := 'select count(*) from ' || against_this_in;
   if against_where_in is not null
   then
      l_query := l_query || ' where ' || against_where_in;
   end if;
   l_run_query;
   if NOT l_success then return; end if;
   g_rec.last_pass    := (l_check_cnt = l_cnt);
   --
   g_rec.last_details := 'Expected ' || l_cnt       || ' rows from "' || against_this_in ||
                        '" and got ' || l_check_cnt || ' rows from "' || check_this_in   ||
                        '"';
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end eqtabcount;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_eqtabcount
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Tests Happy Path 1';
      eqtabcount (
         msg_in             =>   'Run Test',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   'owner = ''' || USER || '''');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'EQTABCOUNT');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected % rows from "ALL_TABLES"' ||
                            ' and got % rows from "ALL_TABLES"'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Tests Happy Path 2';
      eqtabcount (
         msg_in             =>   'Run Test',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'USER_TABLES',
         check_where_in     =>   'owner = ''' || USER || '''',
         against_where_in   =>   '');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Sad Path 1';
      wtplsql_skip_save := TRUE;
      eqtabcount (
         msg_in             =>   'Not Used',
         check_this_in      =>   'ALL_TABLES',
         against_this_in    =>   'ALL_TABLES',
         check_where_in     =>   'owner = ''JOHN DOE''',
         against_where_in   =>   'owner = ''' || USER || '''');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
                            'Expected % rows from "ALL_TABLES" and ' ||
                                 'got % rows from "ALL_TABLES"'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         eqtabcount (
            msg_in             =>   'Not Used',
            check_this_in      =>   'ALL_TABLES',
            against_this_in    =>   'ALL_TABLES',
            check_where_in     =>   'owner = ''JOHN DOE''',
            against_where_in   =>   'owner = ''' || USER || '''',
            raise_exc_in       =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Sad Path 3';
      wtplsql_skip_save := TRUE;
      eqtabcount (
         msg_in             =>   'Not Used',
         check_this_in      =>   'USER_TABLES',
         against_this_in    =>   'USER_TAB_COLUMNS');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
               'Expected % rows from "USER_TAB_COLUMNS" and got % rows from "USER_TABLES"'));
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'EQTABCOUNT Sad Path 4';
      wtplsql_skip_save := TRUE;
      eqtabcount (
         msg_in             =>   'Not Used',
         check_this_in      =>   'BOGUS1',
         against_this_in    =>   'BOGUS2');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.isnotnull (
         msg_in          => 'temp_rec.last_details value',
         check_this_in   => temp_rec.last_details);
      --------------------------------------  WTPLSQL Testing --
      wt_assert.this (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => (temp_rec.last_details like
               '%table or view does not exist%'));
      wt_assert.this (
         msg_in          => 'temp_rec.last_details 2',
         check_this_in   => (temp_rec.last_details like
               '%FAILURE of Compare Query%'));
   end t_eqtabcount;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure objexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2,
      obj_type_in   in   varchar2 default null,
      raise_exc_in  in   boolean := false)
is
   l_num_objects  number;
begin
   g_rec.last_assert  := 'OBJEXISTS';
   g_rec.last_msg     := msg_in;
   select count(*) into l_num_objects
    from  all_objects
    where object_name = obj_name_in
     and  (   obj_owner_in is null
           or obj_owner_in = owner)
     and  (   obj_type_in is null
           or obj_type_in = object_type);
   g_rec.last_pass    := case l_num_objects when 0 then FALSE else TRUE end;
   g_rec.last_details := 'Number of objects found for "' ||
                         case when obj_owner_in is null then ''
                              else obj_owner_in || '.' end ||
                         obj_name_in || '"' ||
                         case when obj_type_in is null then ''
                              else '(' || obj_type_in || ')' end ||
                         ' is ' || l_num_objects;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end objexists;

-- Concatenated SCHEMA_NAME.OBJECT_NAME
procedure objexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2,
      null_ok_in      in   boolean := false,  -- Not Used, utPLSQL V1 API
      raise_exc_in    in   boolean := false)
is
   l_pos    number := instr(check_this_in, '.');
begin
   objexists(msg_in       => msg_in
            ,obj_owner_in => substr(check_this_in, 1, l_pos-1)
            ,obj_name_in  => substr(check_this_in, l_pos+1, length(check_this_in)));
end objexists;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_object_exists
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Happy Path 1';
      objexists (
         msg_in        =>   'Run Test',
         obj_owner_in  =>   'SYS',
         obj_name_in   =>   'DUAL');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'OBJEXISTS');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "SYS.DUAL" is 1');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Happy Path 2';
      objexists (
         msg_in        =>   'Run Test',
         obj_owner_in  =>   'SYS',
         obj_name_in   =>   'DUAL',
         obj_type_in   =>   'TABLE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Happy Path 3';
      objexists (
         msg_in          =>  'Run Test',
         check_this_in   =>  'SYS.DUAL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Happy Path 4';
      objexists (
         msg_in          =>  'Run Test',
         check_this_in   =>  'DUAL');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Sad Path 1';
      wtplsql_skip_save := TRUE;
      objexists (
         msg_in        =>   'Not Used',
         obj_owner_in  =>   'JOE SMITH',
         obj_name_in   =>   'BOGUS');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "JOE SMITH.BOGUS" is 0');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJEXISTS Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         objexists (
            msg_in        =>   'Not Used',
            obj_owner_in  =>   'JOE SMITH',
            obj_name_in   =>   'BOGUS',
            raise_exc_in  =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
   end t_object_exists;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


------------------------------------------------------------
procedure objnotexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2,
      obj_type_in   in   varchar2 default null,
      raise_exc_in  in   boolean := false)
is
   l_num_objects  number;
begin
   g_rec.last_assert  := 'OBJNOTEXISTS';
   g_rec.last_msg     := msg_in;
   select count(*) into l_num_objects
    from  all_objects
    where object_name = obj_name_in
     and  (   obj_owner_in is null
           or obj_owner_in = owner)
     and  (   obj_type_in is null
           or obj_type_in = object_type);
   g_rec.last_pass    := case l_num_objects when 0 then TRUE else FALSE end;
   g_rec.last_details := 'Number of objects found for "' ||
                         case when obj_owner_in is null then ''
                              else obj_owner_in || '.' end ||
                         obj_name_in || '"' ||
                         case when obj_type_in is null then ''
                              else '(' || obj_type_in || ')' end ||
                         ' is ' || l_num_objects;
   g_rec.raise_exception := raise_exc_in;
   process_assertion;
end objnotexists;

-- Concatenated SCHEMA_NAME.OBJECT_NAME
procedure objnotexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2,
      null_ok_in      in   boolean := false,  -- Not Used, utPLSQL V1 API
      raise_exc_in    in   boolean := false)
is
   l_pos    number := instr(check_this_in, '.');
begin
   objnotexists(msg_in       => msg_in
               ,obj_owner_in => substr(check_this_in, 1, l_pos-1)
               ,obj_name_in  => substr(check_this_in, l_pos+1, length(check_this_in)));
end objnotexists;

$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   procedure t_object_not_exists
   is
      l_found_exception  BOOLEAN;
   begin
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJNOTEXISTS Happy Path 1';
      objnotexists (
         msg_in        =>   'Run Test',
         obj_owner_in  =>   'BOGUS',
         obj_name_in   =>   'THING123');
      temp_rec := g_rec;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => TRUE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_assert',
         check_this_in   => temp_rec.last_assert,
         against_this_in => 'OBJNOTEXISTS');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_msg',
         check_this_in   => temp_rec.last_msg,
         against_this_in => 'Run Test');
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "BOGUS.THING123" is 0');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJNOTEXISTS Happy Path 2';
      objnotexists (
         msg_in        =>   'Run Test',
         obj_owner_in  =>   'BOGUS',
         obj_name_in   =>   'THING123',
         obj_type_in   =>   'PACKAGE');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJNOTEXISTS Happy Path 3';
      objnotexists (
         msg_in          =>   'Run Test',
         check_this_in   =>   'BOGUS.THING123');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJNOTEXISTS Sad Path 1';
      wtplsql_skip_save := TRUE;
      objnotexists (
         msg_in        =>   'Not Used',
         obj_owner_in  =>   'SYS',
         obj_name_in   =>   'DUAL');
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      --------------------------------------  WTPLSQL Testing --
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'temp_rec.last_details',
         check_this_in   => temp_rec.last_details,
         against_this_in => 'Number of objects found for "SYS.DUAL" is 1');
      --------------------------------------  WTPLSQL Testing --
      wt_assert.g_testcase := 'OBJNOTEXISTS Sad Path 2';
      wtplsql_skip_save := TRUE;
      begin
         objnotexists (
            msg_in        =>   'Not Used',
            obj_owner_in  =>   'SYS',
            obj_name_in   =>   'DUAL',
            raise_exc_in  =>   TRUE);
         l_found_exception := FALSE;
      exception when ASSERT_FAILURE_EXCEPTION then
         l_found_exception := TRUE;
      end;
      --------------------------------------  WTPLSQL Testing --
      temp_rec := g_rec;
      wtplsql_skip_save := FALSE;
      wt_assert.eq (
         msg_in          => 'temp_rec.last_pass',
         check_this_in   => temp_rec.last_pass,
         against_this_in => FALSE);
      wt_assert.eq (
         msg_in          => 'RAISE_EXC_IN Test, Exception Raised?',
         check_this_in   => l_found_exception,
         against_this_in => TRUE);
   end t_object_not_exists;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------


--==============================================================--
$IF $$WTPLSQL_SELFTEST  ------%WTPLSQL_begin_ignore_lines%------
$THEN
   -- Can't profile this package because all the "assert" tests
   --   pause profiling before they execute.
   procedure WTPLSQL_RUN
   is
   begin
      wtplsql.g_DBOUT := 'WT_ASSERT:PACKAGE BODY';
      hook.g_run_assert_hook := FALSE;
      select temp_clob,  temp_nclob,  temp_xml,  temp_blob
       into  temp_clob1, temp_nclob1, temp_xml1, temp_blob1
       from  wt_self_test where id = 1;
      --------------------------------------  WTPLSQL Testing --
      t_boolean_to_status;
      t_process_assertion;
      t_compare_queries;
      t_nls_settings;
      t_last_values;
      t_reset_globals;
      t_this;
      t_eq;
      --------------------------------------  WTPLSQL Testing --
      t_isnotnull;
      t_isnull;
      t_raises;
      t_eqqueryvalue;
      t_eqquery;
      t_eqtable;
      t_eqtabcount;
      t_object_exists;
      t_object_not_exists;
      --------------------------------------  WTPLSQL Testing --
      hook.g_run_assert_hook := TRUE;
   end WTPLSQL_RUN;
$END  ----------------%WTPLSQL_end_ignore_lines%----------------
--==============================================================--


end wt_assert;
