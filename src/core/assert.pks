create or replace package assert authid current_user
is

   -- See RESET_GLOBALS procedure for default global values

   -- Raise exception whenever an assertion fails.
   --   Modify as required
   g_raise_exception  boolean := FALSE;

   -- Testcase name for a series of assetions.
   --   Modify as required
   g_testcase         results.testcase%TYPE;

   -- Conversion Formats
   --   Modify as required
   g_date_format     varchar2(50);
   g_tstamp_format   varchar2(50);
   g_tstamp_tz_fmt   varchar2(50);

   -- Data from the last assertion
   --   Do Not Modify
   g_last_pass        boolean;
   g_last_assert      results.assertion%TYPE;
   g_last_msg         results.message%TYPE;
   g_last_details     results.details%TYPE;
   g_last_error       results.error_message%TYPE;

   procedure reset_globals;

   procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false);

   -- string inputs overload
   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   varchar2,
      against_this_in   in   varchar2,
      null_ok_in        in   boolean := false);

   -- boolean inputs overload
   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   boolean,
      against_this_in   in   boolean,
      null_ok_in        in   boolean := false);

   -- date inputs overload
   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   date,
      against_this_in   in   date,
      null_ok_in        in   boolean := false);

   -- string version
   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   -- boolean version
   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

   -- string version
   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   -- boolean version
   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

/*
   procedure eqquery (
      msg_in            in   varchar2,
      check_this_in     in   varchar2,
      against_this_in   in   varchar2);

   -- check a query against a single varchar2 value overload
   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   varchar2,
      null_ok_in         in   boolean := false);

   -- check a query against a single date value overload
   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   date,
      null_ok_in         in   boolean := false);

   -- check a query against a single number value overload
   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   number,
      null_ok_in         in   boolean := false);

   --check a given call throws a named exception overload
   procedure raises (
      msg_in           in   varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   varchar2);

   --check a given call throws an exception with a given sqlcode overload
   procedure raises (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   number );

   --check a given call throws a named exception overload
   --  note: this assertion name is "raises"
   procedure throws (
      msg_in           in   varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   varchar2 );

   --check a given call throws an exception with a given sqlcode overload
   --  note: this assertion name is "raises"
   procedure throws (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   number );

   -- description: checking object exist
   procedure objexists (
      msg_in            in   varchar2,
      check_this_in     in   varchar2,
      null_ok_in        in   boolean := false);

   procedure objnotexists (
      msg_in            in   varchar2,
      check_this_in     in   varchar2,
      null_ok_in        in   boolean := false);

   -- character array version overload
   procedure eqoutput (
      msg_in                in   varchar2,
      check_this_in         in   dbms_output.chararr,                     
      against_this_in       in   dbms_output.chararr,
      ignore_case_in        in   boolean := false,
      ignore_whitespace_in  in   boolean := false,
      null_ok_in            in   boolean := true);

   -- string & delimiter version overload
   procedure eqoutput (
      msg_in                in   varchar2,
      check_this_in         in   dbms_output.chararr,                     
      against_this_in       in   varchar2,
      line_delimiter_in     in   char := null,
      ignore_case_in        in   boolean := false,
      ignore_whitespace_in  in   boolean := false,
      null_ok_in            in   boolean := true);
*/
  
end assert;
/
