
--Re-create Invalid Public Synonyms

Declare
   sql_txt varchar(2000);
Begin
 for buff in (with q1 as (
              select * from dba_objects
               where owner = 'PUBLIC'
                 and status != 'VALID'
              )
              select syn.synonym_name, syn.table_owner, syn.table_name
                from dba_synonyms syn
               where owner = 'PUBLIC'
                 and synonym_name in (select object_name from q1)
                 and table_owner not in (select username from odbcapture.schema_list s 
                                          where s.install_order <=0)
                    ) loop
    begin
      sql_txt := 'CREATE OR REPLACE NONEDITIONABLE PUBLIC SYNONYM "' ||
                  buff.synonym_name || '" for "' || buff.table_owner || '"."' ||
                  buff.table_name ||'"';
      execute immediate sql_txt;
    exception
      when others then
        dbms_output.put_line('ERROR:' || CHR(10) || SQLERRM || CHR(10));
        dbms_output.put_line(sql_txt);
        dbms_output.put_line('----------------------------------------');
    end;
  end loop;
end;
/
