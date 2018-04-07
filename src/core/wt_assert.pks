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
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS');
   function get_NLS_TIMESTAMP_FORMAT
      return varchar2;
   procedure set_NLS_TIMESTAMP_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6');
   function get_NLS_TIMESTAMP_TZ_FORMAT
       return varchar2;
   procedure set_NLS_TIMESTAMP_TZ_FORMAT
      (in_format in varchar2 default 'DD-MON-YYYY HH24:MI:SS.FF6 TZH:TZM');

   ------------------------
   --   Datatypes Supported
   --     Oracle Data Type Families
   --   https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/predefined.htm#LNPLS2047
   --
   -- VARCHAR2 - Includes ROWID, LONG*, RAW, LONG RAW*, and NVARCHAR2
   -- DATE** - Includes TIMESTAMP and INTERVAL
   -- NUMBER** - Includes PLS_INTEGER
   -- BOOLEAN
   -- XMLTYPE
   -- CLOB - Includes NCLOB
   -- BLOB
   --
   -- *LONG and LONG RAW data length is limited to VARCHAR2 length in PL/SQL (32K).
   -- **VARCHAR2 includes DATE and NUMBER using Implicit Data Conversions:
   --   https://docs.oracle.com/cd/E11882_01/server.112/e41084/sql_elements002.htm#i163326
   --

   procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false);

   --
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

   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   XMLTYPE,
      against_this_in   in   XMLTYPE);

   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   CLOB,
      against_this_in   in   CLOB,
      null_ok_in        in   boolean := false);

   procedure eq (
      msg_in            in   varchar2,
      check_this_in     in   BLOB,
      against_this_in   in   BLOB,
      null_ok_in        in   boolean := false);

   --
   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   CLOB);

   procedure isnotnull (
      msg_in          in   varchar2,
      check_this_in   in   BLOB);

   --
   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   boolean);

   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   CLOB);

   procedure isnull (
      msg_in          in   varchar2,
      check_this_in   in   BLOB);

   --
   procedure raises (
      msg_in                varchar2,
      check_call_in    in   varchar2,
      against_exc_in   in   varchar2);

   --
   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   varchar2,
      null_ok_in         in   boolean := false);

   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   XMLTYPE);

   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   CLOB,
      null_ok_in         in   boolean := false);

   procedure eqqueryvalue (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_value_in   in   BLOB,
      null_ok_in         in   boolean := false);

   --
   procedure eqquery (
      msg_in             in   varchar2,
      check_query_in     in   varchar2,
      against_query_in   in   varchar2);

   --
   procedure eqtable (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null);

   --
   procedure eqtabcount (
      msg_in             in   varchar2,
      check_this_in      in   varchar2,
      against_this_in    in   varchar2,
      check_where_in     in   varchar2 := null,
      against_where_in   in   varchar2 := null);

   --
   procedure objexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2,
      obj_type_in   in   varchar2 default null);

   procedure objexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   --
   procedure objnotexists (
      msg_in        in   varchar2,
      obj_owner_in  in   varchar2,
      obj_name_in   in   varchar2,
      obj_type_in   in   varchar2 default null);

   procedure objnotexists (
      msg_in          in   varchar2,
      check_this_in   in   varchar2);

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_assert;
