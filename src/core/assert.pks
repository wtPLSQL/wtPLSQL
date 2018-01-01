create or replace package assert authid current_user
is

   -- See RESET_GLOBALS procedure for default global values

   -- Raise exception whenever an assertion fails.
   --   Modify as required
   g_raise_exception  boolean := FALSE;

   -- Testcase name for a series of assetions.
   --   Modify as required
   g_testcase         results.testcase%TYPE;

   -- Data from the last assertion
   --   Do Not Modify
   g_last_pass        boolean;
   g_last_assert      results.assertion%TYPE;
   g_last_msg         results.message%TYPE;
   g_last_details     results.details%TYPE;

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

end assert;
/
