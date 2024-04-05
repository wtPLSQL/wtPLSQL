
--
--  Re-create Invalid Public Synonyms
--

----------------------------------------
prompt
prompt Re-create Invalid Public Synonyms
set serveroutput on size unlimited format wrapped

Declare
   sql_txt varchar(2000);
Begin
 for buff in (with q1 as (
              select owner, object_name, editionable
               from  dba_objects
               where status != 'VALID'
              )
              select syn.synonym_name, syn.table_owner, syn.table_name,
                     case q1.editionable when 'Y'  then ' EDITIONABLE'
                                         when NULL then ''
                                                   else ' NONEDITIONABLE'
                     end                  EDITIONABLE
                from dba_synonyms  syn
                     join q1
                          on  q1.owner       = syn.owner
                          and q1.object_name = syn.synonym_name
                     join dba_users  usr
                          on  usr.username = syn.table_owner
                          and (   usr.oracle_maintained is null
                               OR usr.oracle_maintained != 'Y')
               where syn.owner = 'PUBLIC' )
  loop
    begin
      sql_txt := 'CREATE OR REPLACE' || buff.EDITIONABLE || ' PUBLIC SYNONYM "' ||
                  buff.synonym_name || '" for "' || buff.table_owner || '"."' ||
                  buff.table_name ||'"';
      dbms_output.put_line(sql_txt);
      execute immediate sql_txt;
    exception
      when others then
        dbms_output.put_line('ERROR:' || CHR(10) || SQLERRM || CHR(10));
        dbms_output.put_line('----------------------------------------');
    end;
  end loop;
end;
/
