
-- Database Installation Assist
--   Wrapper for Database Installation Scripts
--
--   Parameters
--   1) Script Name
--   2) Schema Name
--   3) System Connect String

prompt === DBI Started: &1.

define DBI_SCRIPT_NAME="&1."
define DBI_SCHEMA_NAME="&2."
define DBI_SYSTEM_CONNECT="&3."

variable dbi_beg_dtm varchar2(40)
variable dbi_beg_secs number

set feedback off
begin
   -- Initialize Timer
   :dbi_beg_dtm  := to_char(systimestamp,'YYYY-MM-DD') || 'T' ||
                    to_char(systimestamp,'HH24:MI:SS');
   :dbi_beg_secs := dbms_utility.get_time;
   -- Set Current Schema
   if length('&DBI_SCHEMA_NAME.') > 0
   then
      execute immediate 'alter session set current_schema = "&DBI_SCHEMA_NAME."';
   end if;
end;
/

set feedback on
set blockterminator off
set sqlblanklines on

@"&DBI_SCRIPT_NAME." "&DBI_SYSTEM_CONNECT."
set serveroutput on size unlimited format wrapped

set sqlblanklines off
set blockterminator on
set feedback off
begin
   -- Reset Current Schema
   if length('&DBI_SCHEMA_NAME.') > 0
   then
      execute immediate 'alter session set current_schema = "' || USER || '"';
   end if;
   -- Show Timer Results
   dbms_output.put_line('=== DBI Completed at ' || to_char(systimestamp,'YYYY-MM-DD') || 'T' ||
                                                   to_char(systimestamp,'HH24:MI:SS') ||
      ' for a duration of '   || trim( (dbms_utility.get_time - :dbi_beg_secs) / 100 ) ||
      ' seconds (started at ' || :dbi_beg_dtm || ')');
end;
/

set feedback on
