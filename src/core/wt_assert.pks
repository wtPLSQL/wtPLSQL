create or replace package wt_assert authid current_user
is

   C_PASS  CONSTANT varchar2(10) := 'PASS';
   C_FAIL  CONSTANT varchar2(10) := 'FAIL';

   -- See RESET_GLOBALS procedure for default global values

   -- Raise exception whenever an assertion fails.
   --   Modify as required
   g_raise_exception  boolean := FALSE;

   -- Testcase name for a series of assetions.
   --   Modify as required
   g_testcase         wt_results.testcase%TYPE;

   function last_pass
   return boolean;

   function last_assert
   return wt_results.assertion%TYPE;

   function last_msg
   return wt_results.message%TYPE;

   function last_details
   return wt_results.details%TYPE;

   procedure reset_globals;

   -- Date/Time Formats are configured at the Session Level
   function get_NLS_DATE_FORMAT
      return varchar2;
   procedure set_NLS_DATE_FORMAT
      (in_format in varchar2);
   function get_NLS_TIMESTAMP_FORMAT
      return varchar2;
   procedure set_NLS_TIMESTAMP_FORMAT
      (in_format in varchar2);
   function get_NLS_TIMESTAMP_TZ_FORMAT
       return varchar2;
   procedure set_NLS_TIMESTAMP_TZ_FORMAT
       (in_format in varchar2);

   ------------------------
   --   Datatypes Supported
   --     Oracle Data Type Families
   --   https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/predefined.htm#LNPLS2047
   --
   -- BFILE*
   -- BLOB*
   -- BOOLEAN
   -- VARCHAR2 - Includes ROWID, LONG, RAW, and NVARCHAR2
   -- CLOB* - Includes NCLOB
   -- DATE - Includes TIMESTAMP and INTERVAL
   -- NUMBER - Includes PLS_INTEGER
   -- XMLTYPE*
   --
   --     Implicit Data Conversion
   --   Note: VARCHAR2, DATE, and NUMBER are combined into VARCHAR2
   --   https://docs.oracle.com/cd/E11882_01/server.112/e41084/sql_elements002.htm#i163326
   --

   procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false);

   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   varchar2,
      against_this_in   in   varchar2,
      null_ok_in        in   boolean := false);

   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   boolean,
      against_this_in   in   boolean,
      null_ok_in        in   boolean := false);

   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

   procedure raises (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   varchar2);

   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   varchar2,
      null_ok_in         in   boolean := false);

   procedure eqquery (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_query_in   in   varchar2);

   procedure eqtable (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null);

   procedure eqtabcount (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null);

   procedure objexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2);

   procedure objexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   procedure objnotexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2);

   procedure objnotexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

end wt_assert;
