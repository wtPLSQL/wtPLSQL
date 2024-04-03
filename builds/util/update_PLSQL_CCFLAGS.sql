
--
-- Update PLSQL_CCFLAGS parameter
--
-- This block is IDEMPOTENT. It can run more than once
--   and give the same result.
--
-- Command Line Parameters
--   1 - Attribute Name (ex. WTPLSQL_ENABLE or WTPLSQL_SELFTEST)
--   2 - Attribute Value (ex. TRUE or FALSE)
--   3 - PDB_SYS: Connect String for SYS in the Pluggable Database
--

define ATTR_NAME="&1."
define ATTR_VAL="&2."
define PDB_SYS="&3."

connect &PDB_SYS.

declare
   parm_value   v$parameter.value%TYPE;
   function update_parm_value
         (parm_val_in   in varchar2
         ,attribute_in  in varchar2
         ,value_in      in varchar2)
      return varchar2
   is
      parm_len    number;
      attr_pos    number;
      comma_pos   number;
   begin
      --dbms_output.put_line(attribute_in || value_in);
      parm_len := length(parm_val_in);
      --dbms_output.put_line('  parm_len: ' || parm_len);
      if parm_len = 0
      then
         -- "parm_val_in" is empty
         return attribute_in || value_in;
      end if;
      attr_pos := instr(parm_val_in, attribute_in, 1);
      --dbms_output.put_line('  attr_pos: ' || attr_pos);
      if attr_pos = 0
      then
         -- "parm_val_in" does not include our attribute
         return attribute_in || value_in || ', ' || parm_val_in;
      end if;
      comma_pos := instr(parm_val_in, ',', attr_pos);
      --dbms_output.put_line('  comma_pos: ' || comma_pos);
      if comma_pos = 0
      then
         -- "parm_val_in" includes our attribute, but no following "comma"
         return substr(parm_val_in, 1, attr_pos - 1) ||
                attribute_in || value_in;
      end if;
      -- "parm_val_in" includes our attribute, but no following "comma"
      return substr(parm_val_in, 1, attr_pos - 1) ||
             attribute_in || value_in ||
             substr(parm_val_in, comma_pos, parm_len);
   end update_parm_value;
begin
   select p.value
    into  parm_value
    from  dual  d
     left join v$parameter  p
               on  d.dummy = 'X'
    where name in 'plsql_ccflags';
   --dbms_output.put_line('OLD parm_value: ' || parm_value);
   parm_value := update_parm_value(parm_value, '&ATTR_NAME.', '&ATTR_VAL.');
   --dbms_output.put_line('NEW parm_value: ' || parm_value);
   execute immediate 'alter system set PLSQL_CCFLAGS = ''' ||
                      parm_value || ''' scope=BOTH';
end;
/
