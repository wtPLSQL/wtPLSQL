
@common_setup.sql

drop user &schema_owner. cascade;

set serveroutput on size unlimited format truncated

-- Public Synonyms
declare
   sql_txt   varchar2(4000);
begin
   for buff in (select synonym_name from dba_synonyms
                 where owner = 'PUBLIC'
				  and  regexp_like(table_owner, '&schema_owner.', 'i') )
   loop
      sql_txt := 'drop public synonym ' || buff.synonym_name;
      dbms_output.put_line(sql_txt);
	  execute immediate sql_txt;
   end loop
end;
/

declare
   C_FLAG  CONSTANT varchar2(100) := 'WTPLSQL_ENABLE:';
   parm_value   v_$parameter.value%TYPE;
begin
   select value into parm_value
    from  v_$parameter
    where name in 'plsql_ccflags';
   if instr(parm_value, C_FLAG) <> 0
   then
      DBMS_OUTPUT.PUT_LINE('Remove ' || C_FLAG ||
            ' from PLSQL_CCFLAGS: "' || parm_value || '"');
   end if;
end;
/
