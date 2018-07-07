
create or replace view wt_test_runs_gui_tree as
with q_root as (
select 0                  ID
      ,NULL               PARENT_ID
      ,'Text Runner IDs'  TEXT
 from  dual
), q_owners as (
select 0 - min(id)        ID
      ,0                  PARENT_ID
      ,runner_owner       TEXT
      ,runner_owner
 from  wt_test_runs
 group by runner_owner
), q_runners as (
select (select min(id) from q_owners) -
        min(r.id)         ID
      ,o.id               PARENT_ID
      ,r.runner_name      TEXT
      ,r.runner_owner
      ,r.runner_name
 from  wt_test_runs  r
       join q_owners  o
            on  o.text = r.runner_owner
 group by o.id
      ,r.runner_name
      ,r.runner_owner
), q_run_ids as (
select i.id               ID
      ,r.id               PARENT_ID
      ,to_char(i.start_dtm,'YYYY/MM/DD HH24:MI:SS')
                          TEXT
      ,i.runner_owner
      ,i.runner_name
 from  wt_test_runs  i
       join q_runners  r
            on  r.runner_owner = i.runner_owner
            and r.runner_name  = i.runner_name
), q_main as (
select id, parent_id, text from q_root
union all
select id, parent_id, text from q_owners
union all
select id, parent_id, text from q_runners
union all
select id, parent_id, text from q_run_ids
)
--select * from q_root;
--select * from q_owners;
--select * from q_runners;
--select * from q_run_ids;
select * from q_main;
