declare
   invalid_sql_statment EXCEPTION;
   PRAGMA EXCEPTION_INIT(invalid_sql_statment, -900);
   src_clob  CLOB;
   tmp_clob  CLOB;
   end_ptr   number;
   end_str   varchar2(32767);
   -- Big Put Line, because DBMS_OUTPUT.PUT_LINE can't
   procedure big_put_line
   is
      max_len number := 32767;           -- Max Line Length
      ptr     number := 1;               -- Current Position in IN_TXT
      oset    number;                    -- Offset from PTR to a LF
      safety  number := 1;               -- Number of iterations
   begin
      while length(substr(src_clob, ptr)) > max_len
      loop
         -- Try to find a Line Feed at the sweet spot
         oset := instr(substr(src_clob, ptr, max_len),CHR(10),-1);
         --dbms_output.put_line('safety: ' || safety ||
         --                      ', ptr: ' || ptr    ||
         --                     ', oset: ' || oset   );
         if oset <= 0
         then
            raise_application_error(-20000, 'Unknown OSET returned from INSTR: ' || OSET);
         end if;
         -- Output the next segment and move ptr
         dbms_output.put_line(substr(src_clob, ptr, oset-1));
         ptr := ptr + oset;
         safety := safety + 1;
         if safety >= 100000
         then
            raise_application_error(-20000, 'Safety exceeded ');
         end if;
      end loop;
      dbms_output.put_line(substr(src_clob, ptr));
      dbms_output.put_line('/' || CHR(10) || '----------');
   end big_put_line;
   function find_end_ptr (in_type  in varchar2)
      return number
   is
      orig_end_ptr  number;
      new_end_ptr   number;
      old1_end_ptr  number;
      old2_end_ptr  number;
      begin_ptr     number;
   begin
      orig_end_ptr := 17;  -- "CREATE PROCEDURE " is 17 characters
      new_end_ptr  := orig_end_ptr;
      old1_end_ptr := orig_end_ptr + 1;
      -- Adjust for smaller source
      while new_end_ptr > 0
      loop
         old2_end_ptr := old1_end_ptr;
         old1_end_ptr := new_end_ptr + 1;
         new_end_ptr := regexp_instr(tmp_clob          -- Source Char
                                    ,'[[:space:]]' ||  -- Find a space character (includes LF),
                                     'end'         ||  -- followed by the string "end",
                                     '[^;]*'       ||  -- followed by zero or more non-semi-colon characters,
                                     '[;]'             -- followed by a semi-colon.
                                    ,old1_end_ptr      -- Position
                                    ,1                 -- Occurrence
                                    ,0                 -- Return Option
                                    ,'i'               -- Match Parameter
                                    ,0                 -- Sub Expr
                                    );
      end loop;
      if     old2_end_ptr > orig_end_ptr + 1
         and in_type      = 'PACKAGE BODY'
      then
         -- A package body with a possible "initialization part"
         begin_ptr := regexp_instr(tmp_clob          -- Source Char
                                  ,'[[:space:]]' ||  -- Find a space character (includes LF),
                                   'begin'       ||  -- followed by the string "begin",
                                   '[[:space:]]'     -- followed by a space character (includes LF),
                                  ,old2_end_ptr      -- Position
                                  ,1                 -- Occurrence
                                  ,0                 -- Return Option
                                  ,'i'               -- Match Parameter
                                  ,0                 -- Sub Expr
                                  );
      else
         begin_ptr := 0;
      end if;
      if begin_ptr > 0
      then
         -- Found an initialization part, start before it
         return begin_ptr;
      else
         -- No initialization part, start before the last END
         return old1_end_ptr;
      end if;
   end find_end_ptr;
   function get_procedures
         (in_owner  in varchar2
         ,in_name   in varchar2)
      return varchar2
   is
      ret_str       varchar2(32767);
      add_teardown  boolean;
   begin
      for proc_buff in (
         select procedure_name
          from  dba_procedures
          where owner          = in_owner
           and  object_name    = in_name
           and  object_type    = 'PACKAGE'
           and  procedure_name is not null
           and  procedure_name like 'ZTST\_%' escape '\'
          order by procedure_name )
      loop
         case proc_buff.procedure_name
         when 'ZTST_SETUP'
         then
            ret_str := '   ' || proc_buff.procedure_name ||
                         ';' || CHR(10) || ret_str;
         when 'ZTST_TEARDOWN'
         then
            add_teardown := TRUE;
         else
            ret_str := ret_str ||
                         '   ' || 'wt_assert.g_testcase := ' ||
                           substr(proc_buff.procedure_name,1,50) ||
                           ';' || CHR(10) ||
                         '   ' || proc_buff.procedure_name ||
                           ';' || CHR(10);
         end case;
      end loop;
      if add_teardown
      then
         ret_str := ret_str || '   ZTST_TEARDOWN;' || CHR(10);
      end if;
    return ret_str;
   end get_procedures;
begin
   for obj_rec in (
      select object_type, owner, object_name
       from  dba_objects  obj
       where object_name like 'ZTST\_%' escape '\'
        and  object_name not like '%\_DATA' escape '\'
        and  object_type in ('PACKAGE', 'PACKAGE BODY')
        and  owner       = :SCHEMA_NAME
        and  owner       not in ('SYS','UTP')
        and  not exists (select 'x' from dba_source  src
                          where src.owner          = obj.owner
                           and  src.name           = obj.object_name
                           and  src.type           = obj.object_type
                           and  regexp_like(src.text, wtplsql.C_RUNNER_ENTRY_POINT, 'i') )
       order by object_type desc, owner, object_name )
       -- Package Bodies before Package Specifications
   loop
      src_clob := dbms_metadata.get_ddl(object_type => case obj_rec.object_type
                                                       when 'PACKAGE'      then 'PACKAGE_SPEC'
                                                       when 'PACKAGE BODY' then 'PACKAGE_BODY'
                                                                           else obj_rec.object_type
                                                       end
                                       ,name        => obj_rec.object_name
                                       ,schema      => obj_rec.owner);
      tmp_clob := regexp_replace(src_clob, '\r$', '');
      end_ptr := find_end_ptr(obj_rec.object_type);
      end_str  := substr(tmp_clob, end_ptr);
      case obj_rec.object_type
      when 'PACKAGE'
      then
         src_clob := substr(tmp_clob, 1, end_ptr-1) || CHR(10) ||
               '   procedure ' || wtplsql.C_RUNNER_ENTRY_POINT || ';' || 
                                            CHR(10) || CHR(10) || end_str;
      when 'PACKAGE BODY'
      then
         src_clob := substr(tmp_clob, 1, end_ptr-1)   || CHR(10) ||
                    'procedure ' || wtplsql.C_RUNNER_ENTRY_POINT ||
                                          ' is begin' || CHR(10) ||
              get_procedures(obj_rec.owner, obj_rec.object_name) ||
                          'end ' || wtplsql.C_RUNNER_ENTRY_POINT || ';'
                                           || CHR(10) || CHR(10) || end_str;
      else
         raise_application_error(-20000, 'Unknown Object Type: ' || obj_rec.object_type);
      end case;
      dbms_output.put_line('Compiling ' || obj_rec.object_type ||
                                    ' ' || obj_rec.owner       ||
                                    '.' || obj_rec.object_name );
      begin
         execute immediate src_clob;
      exception when invalid_sql_statment
      then
         big_put_line;
      end;
   end loop;
end;
/
