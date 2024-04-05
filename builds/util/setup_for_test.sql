
--
--  Setup for Unit Testing
--
--  Run as SYS or SYSTEM
--

set serveroutput on size unlimited format wrapped

----------------------------------------
prompt
prompt Show the Services for this PDB
select name from v$services;
prompt Using the following service at localhost:1521
execute dbms_output.put_line(SYS_CONTEXT('USERENV','SERVICE_NAME'));

----------------------------------------
prompt
prompt Update PLSQL_CCFLAGS parameter
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
      parm_len := length(parm_val_in);
      if parm_len = 0
      then
         -- "parm_val_in" is empty
         return attribute_in || ':' || value_in;
      end if;
      attr_pos := instr(parm_val_in, attribute_in, 1);
      if attr_pos = 0
      then
         -- "parm_val_in" does not include our attribute
         return attribute_in || ':' || value_in || ', ' || parm_val_in;
      end if;
      comma_pos := instr(parm_val_in, ',', attr_pos);
      if comma_pos = 0
      then
         -- "parm_val_in" includes our attribute, but no following "comma"
         return substr(parm_val_in, 1, attr_pos - 1) ||
                attribute_in || ':' || value_in;
      end if;
      -- "parm_val_in" includes our attribute with a following "comma"
      return substr(parm_val_in, 1, attr_pos - 1) ||
             attribute_in || ':' || value_in ||
             substr(parm_val_in, comma_pos, parm_len);
   end update_parm_value;
begin
   select p.value
    into  parm_value
    from  dual  d
     left join v$parameter  p
               on  d.dummy = 'X'
    where name in 'plsql_ccflags';
   dbms_output.put_line('OLD parm_value: ' || parm_value);
   parm_value := update_parm_value(parm_value, 'WTPLSQL_SELFTEST', 'TRUE');
   --parm_value := update_parm_value(parm_value, 'WTPLSQL_ENABLE'  , 'TRUE');
   dbms_output.put_line('NEW parm_value: ' || parm_value);
   execute immediate 'alter system set PLSQL_CCFLAGS = ''' ||
                      parm_value || ''' scope=BOTH';
end;
/

----------------------------------------
prompt
prompt Recompile All Packages
declare
  procedure run_sql (in_sql in varchar2) is begin
    dbms_output.put_line(in_sql);
    execute immediate in_sql;
  exception when others then
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line('----------------------------------------');
  end run_sql;
begin
  for buff in (select obj.object_type, obj.owner, obj.object_name
                from  dba_objects  obj
                      join dba_users  usr
                           on  usr.username = obj.owner
                           and (   obj.oracle_maintained is null
                                OR obj.oracle_maintained != 'Y')
                where obj.object_type in ('FUNCTION','PACKAGE','PROCEDURE','LIBRARY','TYPE','TRIGGER','VIEW'))
  loop
     run_sql('alter ' || buff.object_type || ' "'        ||
                         buff.owner       || '"."'       ||
                         buff.object_name || '" compile' );
  end loop;
end;
/

----------------------------------------
prompt
prompt Recreate Database Links
declare
   procedure run_sql (in_sql in varchar2) is
      -- ORA-02024: database link not found
      no_db_link exception;
      pragma exception_init(no_db_link, -02024);
   begin
      dbms_output.put_line(in_sql);
      execute immediate in_sql;
   exception
      when no_db_link then
         null;  -- Ignore this errror;
      when others then
         dbms_output.put_line(SQLERRM || CHR(10));
   end run_sql;
begin
   -- Test every Schema Owner in the Database
   for buff in (select proc.owner             TEST_OWNER
                 from  dba_procedures  proc
                 where proc.procedure_name = 'WTPLSQL_RUN'
                  and  proc.object_type    = 'PACKAGE'
              group by proc.owner
              order by proc.owner )
   loop
      run_sql('drop database link "WTP"."' || buff.TEST_OWNER || '"');
      run_sql('create database link "WTP"."' || buff.TEST_OWNER  ||
                            '" connect to "' || buff.TEST_OWNER  ||
                         '" identified by "' || buff.TEST_OWNER  ||
               '" using ''//localhost:1521/' || SYS_CONTEXT('USERENV','SERVICE_NAME') || '''');
   end loop;
end;
/

exit
