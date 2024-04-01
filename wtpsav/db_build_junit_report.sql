
--
--  Create JUnit XML Report of Database Build Status for "wtpsav" Install Type
--

declare
   --
   procedure ot (in_txt in varchar2) is begin
      dbms_output.put_line(in_txt);
   end ot;
   --
   procedure do_it (in_schema in varchar2) is
   begin
      for tsuite in (
         with q1 as (
         select obj.owner
               ,count(obj.owner)                          NUM_TESTS
               ,sum(decode(obj.status, 'VALID', 0, 1))  NUM_FAILURES
               ,min(obj.last_ddl_time)                    TSTAMP
                -- Jenkins JUnit Plugin adds all these times together
                -- round((max(obj.last_ddl_time) - min(obj.last_ddl_time))*24*60*60)
               ,0                                         ELAPSED_SECS
          from  dba_objects obj
          where obj.owner = in_schema
          group by obj.owner
         UNION
         select syn.table_owner                           OWNER
               ,count(syn.table_owner)                    NUM_TESTS
               ,sum(decode(obj.status, 'VALID', 0, 1))  NUM_FAILURES
               ,min(obj.last_ddl_time)                    TSTAMP
                -- Jenkins JUnit Plugin adds all these times together
                -- round((max(obj.last_ddl_time) - min(obj.last_ddl_time))*24*60*60)
               ,0                                         ELAPSED_SECS
          from  dba_synonyms syn
                join dba_objects obj
                     on  obj.object_name = syn.synonym_name
                     and obj.owner       = syn.owner
          where syn.owner       = 'PUBLIC'
           and  syn.table_owner = in_schema
          group by syn.table_owner
         )
         select owner           -- TESTSUITE
               ,sum(NUM_TESTS)     NUM_TESTS
               ,sum(NUM_FAILURES)  NUM_FAILURES
               ,max(TSTAMP)        TSTAMP
               ,sum(ELAPSED_SECS)  ELAPSED_SECS
          from  q1
          group by owner
          order by owner)
      loop
         ot('  <testsuite name="' || tsuite.owner || '_schema_build'   ||
                      '" tests="' || tsuite.num_tests                  ||
                   '" failures="' || tsuite.num_failures               ||
                       '" time="' || tsuite.elapsed_secs               ||
                  '" timestamp="' || to_char(tsuite.tstamp,'YYYY-MM-DD"T"HH24:MI:SS') || '">');
         for tcase in (
            select obj.object_type                                  -- TESTCASE
                  ,replace(obj.object_name,'.','_')  OBJECT_NAME    -- CLASS
                  ,obj.STATUS
                  ,0                                     ELAPSED_SECS
             from  dba_objects obj
             where obj.owner = tsuite.owner
            UNION ALL
            select 'PUBLIC_SYNONYM'                  OBJECT_TYPE    -- TESTCASE
                  ,replace(obj.object_name,'.','_')  OBJECT_NAME    -- CLASS
                  ,obj.STATUS
                  ,0                                     ELAPSED_SECS
             from  dba_synonyms syn
                   join dba_objects  obj
                        on  obj.object_name = syn.synonym_name
                        and obj.owner       = syn.owner
             where syn.owner       = 'PUBLIC'
              and  syn.table_owner = tsuite.owner
            order by 1,2 )
         loop
            if tcase.status = 'VALID'
            then
               ot('    <testcase name="' || tcase.object_type  || ':' || 'db_object_status' ||
                         '" classname="' || tsuite.owner       || '.' || tcase.object_name  ||
                              '" time="' || tcase.elapsed_secs || '"/>'                     );
            else
               ot('    <testcase name="' || tcase.object_type  || ':' || 'db_object_status' ||
                         '" classname="' || tsuite.owner       || '.' || tcase.object_name  ||
                              '" time="' || tcase.elapsed_secs || '">'                      );
               ot('      <error message="' || tcase.object_type || ' failed">');
               ot('** Object Status is ' || tcase.status);
               for terror in (
                  select 'Line ' || line     ||
                        ', Col ' || position ||
                            ': ' || UTL_I18N.ESCAPE_REFERENCE(text, 'us7ascii')  ERROR_TXT
                   from  dba_errors
                   where owner = tsuite.owner
                    and  type  = decode(tcase.object_type,'PUBLIC_SYNONYM','SYNONYM',tcase.object_type)
                    and  name  = tcase.object_name
                   order by sequence )
               loop
                  ot(terror.error_txt);
               end loop;
               ot('      </error>');
               ot('    </testcase>');
            end if;
         end loop;
         ot('   </testsuite>');
      end loop;
   end do_it;
begin
   ot('<?xml version="1.0" encoding="UTF-8"?>');
   ot('<testsuites>');
   do_it('WTP');
   ot('</testsuites>');
end;
/
