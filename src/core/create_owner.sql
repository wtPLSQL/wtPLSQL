
-- Create the schema owner.

set define &
define owner = "wtp_test"

create user &owner. identified by &owner.
   default tablespace users
   temporary tablespace temp;

grant connect, resource to &owner.;
--grant create view to wtp;

select value from v_$parameter where name in 'plsql_ccflags';

--alter system set PLSQL_CCFLAGS = '' scope=BOTH;

-- This block is IDEMPOTENT. It can run more than once and give
--   the same result.
declare
   C_FLAG  CONSTANT varchar2(100) := 'WTPLSQL_ENABLE:';
   parm_value   v_$parameter.value%TYPE;
   procedure set_plsql_ccflags (in_value in varchar2) is begin
      execute immediate 'alter system set PLSQL_CCFLAGS = ''' ||
                         in_value || ''' scope=BOTH';
   end set_plsql_ccflags;
begin
   select value into parm_value
    from  v_$parameter
    where name in 'plsql_ccflags';
   if nvl(length(parm_value),0) = 0
   then
      -- No Flags have been set
      set_plsql_ccflags(C_FLAG || 'TRUE');
   elsif regexp_instr(parm_value, '^(.*[,]){0,1}' || C_FLAG) = 0
   -- "^" anchors expression to beginning of line
   -- "(.+[,]){0,1}" is zero or one occurences of ( 1 or more characters
   --                of any kind follwed by a comma ).
   then
      -- C_FLAG is not already present
      set_plsql_ccflags(parm_value || 'TRUE, ' || C_FLAG);
   end if;
end;
/

select value from v_$parameter where name in 'plsql_ccflags';
