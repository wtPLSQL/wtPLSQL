
--
--  Current Test Runners View Installation
--

create view wt_qual_test_runners_vw as
select owner
      ,object_name    PACKAGE_NAME
 from  dba_procedures
 where procedure_name = wtplsql.get_runner_entry_point
  and  object_type    = 'PACKAGE';

comment on table wt_qual_test_runners_vw is 'All PL/SQL Packages with the required Test Runner Entry Point.';
comment on column wt_qual_test_runners_vw.owner is 'Owner of the Qualified Test Runner Package';
comment on column wt_qual_test_runners_vw.package_name is 'Name of the Qualified Test Runner Package';

grant select on wt_qual_test_runners_vw to public;
