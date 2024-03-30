
--
--  List Invalid Objects for "wtpgrb" Install Type
--

declare
   procedure do_it (in_schema in varchar2) is
   begin
      for buff in (
         with q1 as (
         select owner
               ,object_name
               ,object_type
               ,status
          from  dba_objects obj
          where obj.owner = in_schema
           and  (   obj.object_type != 'TYPE'
                 or obj.object_name not like 'SYSTP%==')
           and  obj.status != 'VALID'
         UNION ALL
         select syn.table_owner
               ,syn.synonym_name
               ,'PUBLIC_SYNONYM'     OBJECT_TYPE
               ,obj.status
          from  dba_synonyms syn
                join dba_objects  obj
                     on  obj.object_name = syn.synonym_name
                     and obj.owner       = syn.owner
                     and obj.status     != 'VALID'
          where syn.owner       = 'PUBLIC'
           and  syn.table_owner = in_schema
         )
         select '"' || owner       || '",' ||
                '"' || object_name || '",' ||
                '"' || object_type || '",' ||
                '"' || status      || '"'     RECORD_DATA
          from  q1
          order by RECORD_DATA)
      loop
         dbms_output.put_line(buff.RECORD_DATA);
      end loop;
   end do_it;
begin
   dbms_output.put_line('"OWNER","OBJECT_NAME","OBJECT_TYPE","STATUS"');
   do_it('ODBCAPTURE');
end;
/
