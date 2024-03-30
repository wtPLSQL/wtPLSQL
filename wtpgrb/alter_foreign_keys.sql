
--
--  Alter "wtpgrb" Install Type Foreign Keys
--
-- Command Line Parameters:
--   1 - ENABLE/DISABLE
--

declare
   procedure missing_parent_sql
         (in_owner       sys.dba_constraints.owner%TYPE
         ,in_constraint  sys.dba_constraints.constraint_name%TYPE)
   is
      TYPE fk_rec_type is record
         (child_owner    sys.dba_constraints.owner%TYPE
         ,child_table    sys.dba_constraints.table_name%TYPE
         ,child_column   sys.dba_cons_columns.column_name%TYPE
         ,parent_owner   sys.dba_constraints.owner%TYPE
         ,parent_table   sys.dba_constraints.table_name%TYPE
         ,parent_column  sys.dba_cons_columns.column_name%TYPE);
      TYPE fk_nt_type is table of fk_rec_type;
      fk_nt  fk_nt_type;
      sql_txt  varchar2(1000);
   begin
      select ctab.owner child_owner,  ctab.table_name child_table,  ccol.column_name child_column,
             ptab.owner parent_owner, ptab.table_name parent_table, pcol.column_name parent_column
       bulk  collect into fk_nt
       from  sys.dba_constraints  ctab
             join sys.dba_cons_columns  ccol
                  on  ccol.owner = ctab.owner and ccol.constraint_name = ctab.constraint_name
             join sys.dba_constraints  ptab
                  on  ptab.owner = ctab.r_owner and ptab.constraint_name = ctab.r_constraint_name
             join sys.dba_cons_columns  pcol
                  on  pcol.owner = ptab.owner and pcol.constraint_name = ptab.constraint_name
                  and pcol.position = ccol.position
       where ctab.owner = in_owner and ctab.constraint_name = in_constraint
       order by ccol.position;
      if SQL%NOTFOUND then return; end if;
      dbms_output.put_line('-- ORA-20000: Query to find missing parent keys:');
      -- ORA-20000:  select "CHILD_KEY" from from "CHILD_OWNER"."CHILD_TABLE" group by "CHILD_KEY"
      sql_txt := '-- ORA-20000:  select "' || fk_nt(1).child_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).child_column;
      end loop;
      sql_txt := sql_txt || '" from "' || fk_nt(1).child_owner || '"."' || fk_nt(1).child_table ||
                        '" group by "' || fk_nt(1).child_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).child_column;
      end loop;
      dbms_output.put_line (sql_txt || '"');
      -- ORA-20000: MINUS select "PARENT_KEY" from "PARENT_OWNER"."PARENT_TABLE";
      sql_txt := '-- ORA-20000:  MINUS select "' || fk_nt(1).parent_column;
      for i in 2 .. fk_nt.LAST
      loop
         sql_txt := sql_txt || '", "' || fk_nt(i).parent_column;
      end loop;
      sql_txt := sql_txt || '" from "' || fk_nt(1).parent_owner || '"."' || fk_nt(1).parent_table || '";';
      dbms_output.put_line (sql_txt);
   end missing_parent_sql;
   procedure do_it (in_schema in varchar2)
   is
      sql_txt  varchar2(1000);
   begin
      for buff in (select owner, table_name, constraint_name from dba_constraints
                    where constraint_type = 'R' and owner = in_schema
                    order by owner, table_name, constraint_name)
      loop
         sql_txt := 'alter table "' || buff.owner || '"."' || buff.table_name ||
                       '" &1. constraint "' || buff.constraint_name || '"';
         dbms_output.put_line(sql_txt || ';');
         begin
            execute immediate sql_txt;
         exception when others then
            dbms_output.put_line('-- *');
            dbms_output.put_line('-- ERROR at line :');
            dbms_output.put_line('-- ' || SQLERRM);
            missing_parent_sql(buff.owner,buff.constraint_name);
         end;
      end loop;
      dbms_output.put_line('-- ' || in_schema || ' Alter Foreign Keys is done.');
   end do_it;
begin
   dbms_output.put_line('Alter Foreign Keys for wtpgrb Install Type');
   do_it('ODBCAPTURE');
end;
/
