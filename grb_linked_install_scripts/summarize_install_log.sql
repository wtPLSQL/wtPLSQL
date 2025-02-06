
--
-- Summary Installation Log
--   1 - Installation Type
--

declare
   TYPE err_aa_type is table of pls_integer index by varchar2(4000);
   err_aa      err_aa_type;
   line_txt    varchar2(4000);
   so_far      pls_integer;
   end_pos     pls_integer;
   procedure add_line is
   begin
      if regexp_like(line_txt, '(ORA-|SQL-|SP2-|PLS-|PL2-|TNS-|SQL[*]Loader-[0-9]+:|WARNING: Prerequisite BUILD_TYPE|Record [0-9]+: Rejected)')
      then
         line_txt := regexp_replace(line_txt, '\r$');
         begin
            err_aa(line_txt) := err_aa(line_txt) + 1;
         exception when NO_DATA_FOUND then
            err_aa(line_txt) := 1;
         end;
      end if;
   end add_line;
begin
   for buff in (select t1.file_name, t1.load_dtm, t1.contents
                 from  odbcapture_installation_logs  t1
                 where t1.build_type = '&1.'
                  and  t1.load_dtm = (select max(load_dtm) from odbcapture_installation_logs  t2
                                       where t2.build_type = t1.build_type
                                        and  t2.file_name    = t1.file_name)
                 order by t1.file_name, t1.load_dtm)
   loop
      dbms_output.put_line('Processing file ' || buff.file_name ||
                                 ' (' || to_char(buff.load_dtm,'YYYY-MM-DD HH24:MI:SS') || ')');
      err_aa.DELETE;
      so_far := 0;
      loop
         end_pos := instr(buff.contents, chr(10), so_far + 1);
         exit when end_pos = 0;
         line_txt := substr(buff.contents, so_far + 1, end_pos - so_far - 1);
         add_line;
         so_far := end_pos;
      end loop;
      line_txt := substr(buff.contents, so_far + 1, 4000);
      add_line;
      if err_aa.COUNT = 0 then continue; end if;
      line_txt := err_aa.FIRST;
      loop
         dbms_output.put_line('  ' || err_aa(line_txt) || ' lines: ' || line_txt);
         exit when line_txt = err_aa.LAST;
         line_txt := err_aa.NEXT(line_txt);
      end loop;
   end loop;
end;
/
