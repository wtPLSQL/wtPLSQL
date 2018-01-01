create or replace package body assert is

-- See RESET_GLOBALS procedure at bottom of package for default global values


----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
function boolean_to_status
      (in_boolean  in boolean)
   return varchar2
is
begin
   if in_boolean
   then
      return result.C_PASS;
   end if;
   return result.C_FAIL;
end;

------------------------------------------------------------
procedure process_assertion
is
begin
   result.save
      (in_assertion      => g_last_assert
      ,in_status         => case g_last_pass when TRUE then result.C_PASS
                                                       else result.C_FAIL
                            end
      ,in_details        => g_last_details
      ,in_testcase       => g_testcase
      ,in_message        => g_last_msg);
   if g_raise_exception and not g_last_pass
   then
      raise_application_error(-20000, text_report.format_test_result
                                         (in_assertion      => g_last_assert
                                         ,in_status         => case g_last_pass when TRUE then result.C_PASS
                                                                                          else result.C_FAIL
                                                               end
                                         ,in_details        => g_last_details
                                         ,in_testcase       => g_testcase
                                         ,in_message        => g_last_msg) );
   end if;
end process_assertion;


---------------------
--  Public Procedures
---------------------

procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false)
is
begin
   g_last_assert  := 'THIS';
   g_last_msg     := msg_in;
   g_last_pass    := check_this_in;
   g_last_details := 'Expected "'  || result.C_PASS ||
                     '" and got "' || boolean_to_status(check_this_in) || '"';
   process_assertion;
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
   g_last_assert  := 'EQ';
   g_last_msg     := msg_in;
   g_last_pass    := (   nvl(check_this_in = against_this_in, false)
                      or (    check_this_in is null
                          and against_this_in is null
                          and null_ok_in              )
                     );
   g_last_details := 'Expected "'  || against_this_in ||
                     '" and got "' || check_this_in   ||
                     '"';
   process_assertion;
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
   g_last_assert  := 'ISNOTNULL';
   g_last_msg     := msg_in;
   g_last_pass    := (check_this_in is not null);
   g_last_details := 'Expected NOT NULL and got "' ||
                      check_this_in || '"';
   process_assertion;
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
   g_last_assert  := 'ISNULL';
   g_last_msg     := msg_in;
   g_last_pass    := (check_this_in is null);
   g_last_details := 'Expected NULL and got "' ||
                      check_this_in || '"';
   process_assertion;
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
      (in_format in varchar2)
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
      (in_format in varchar2)
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
      (in_format in varchar2)
is
begin
   execute immediate 'alter session set NLS_TIMESTAMP_TZ_FORMAT = ''' ||
                      in_format || '''';
end set_NLS_TIMESTAMP_TZ_FORMAT;

------------------------------------------------------------
procedure reset_globals
is
begin
   g_raise_exception := FALSE;
   g_testcase        := '';
   g_last_pass       := NULL;
   g_last_assert     := '';
   g_last_msg        := '';
   g_last_details    := '';
end reset_globals;

begin

   reset_globals;

end assert;
/
