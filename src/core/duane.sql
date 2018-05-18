
execute wt_text_report.dbms_out(in_detail_level => 50);
execute wt_text_report.dbms_out;

-- Need to test the new insert_test_runs_summary.
-- Need to create the view that uses this data.

with q1 as (
select dbout_owner
      ,dbout_name
      ,dbout_type
      ,max(start_dtm)          MAX_START_DTM
 from  wt_test_runs
 group by dbout_owner
      ,dbout_name
      ,dbout_type
)
select obj.owner
      ,obj.object_name
      ,obj.object_type
      ,q1.max_start_dtm
      ,stat.
 from  all_objects  obj
  left join q1
            on  q1.dbout_owner = obj.owner
            and q1.dbout_name  = obj.object_name
            and q1.dbout_type  = obj.object_type
  left join wt_test_runs  run
            on  run.dbout_owner = q1.dbout_owner
            and run.dbout_name  = q1.dbout_name
            and run.dbout_type  = q1.dbout_type
            and run.start_dtm   = q1.max_start_dtm
  left join wt_test_run_stats  stat
            on  stat.test_run_id = run.id
 where obj.object_type in ('FUNCTION','LIBRARY','OPERATOR',
          'PACKAGE','PACKAGE BODY','PROCEDURE','TABLE',
          'TRIGGER','TYPE','TYPE BODY','VIEW')
  and  obj.owner = USER
 group by obj.owner
      ,obj.object_name
      ,obj.object_type
      ,q1.max_start_dtm
 order by obj.owner
      ,obj.object_name
      ,obj.object_type;
