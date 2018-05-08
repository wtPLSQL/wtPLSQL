
--execute wtplsql.test_run('WT_ASSERT');
--execute wt_text_report.dbms_out('WT_ASSERT',FALSE,FALSE,TRUE,TRUE);

--execute wtplsql.test_run('WT_RESULT');
--execute wt_text_report.dbms_out('WT_RESULT',FALSE,FALSE,TRUE,TRUE);

execute wtplsql.test_run('WT_PROFILER');
execute wt_text_report.dbms_out('WT_PROFILER',FALSE,FALSE,TRUE,TRUE);

select * from all_objects
 where object_name = 'ALL_OBJECTS';

select * from all_source
 where name = 'ALL_OBJECTS';
