
BEGIN
 DBMS_SCHEDULER.DROP_CREDENTIAL('WTP_DEMO');
 --DBMS_SCHEDULER.CREATE_CREDENTIAL('WTP_DEMO', 'WTP_DEMO', 'wtp_demo');
END;
/

BEGIN
 DBMS_SCHEDULER.CREATE_DATABASE_DESTINATION (
  destination_name     => 'LOOPBACK',
  agent                => 'DBHOST1',
  tns_name             => 'ORCLDW',
  comments             => 'Instance named orcldw on host dbhost1.example.com');
END;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name            =>  'DEMO_TEST', 
    job_type            =>  'PLSQL_BLOCK',
   -- job_action          =>  'begin wtplsql.test_all@wtp_demo; end;',
    job_action          =>  'begin wtplsql.test_run@wtp_demo(''UT_TRUNCIT''); end;',
    enabled             => TRUE);
  COMMIT;
END;
/

BEGIN
  DBMS_SCHEDULER.ENABLE('DEMO_TEST');
END;
/

select * from wt_test_runs
 order by id desc;

select * from wt_scheduler_jobs;

select inst_id, value from sys.gv_$parameter where name = 'job_queue_processes';

select * from trigger_test_tab@wtp_demo;

drop database link wtp_demo;

  CREATE DATABASE LINK "WTP_DEMO"
   CONNECT TO "WTP_DEMO" IDENTIFIED BY wtp_demo
   USING '//localhost:1521/XE';

select host from user_db_links;

begin
   execute immediate 'drop database link test';
exception when others then
   raise_application_error (-20000, SQLERRM);
end;
/

declare
   --
   -- Using DBMS_SYS_SQL To Execute Statements As Another User
   --    by Alex Fatkulin - November 5, 2007
   -- https://blog.pythian.com/using-dbms_sys_sql-to-execute-statements-as-another-user/
   --
   uid             number;
   sys_cursor      INTEGER;
   rows_processed  INTEGER;
begin
   select user_id into uid
    from  dba_users 
    where username = :APP_USER;
   sys_cursor := sys.dbms_sys_sql.open_cursor;
   sys.dbms_sys_sql.parse_as_user
      (c             => sys_cursor
      ,statement     => 'begin wtplsql.test_all; end;'
      ,language_flag => dbms_sql.native
      ,userid        => uid);
   rows_processed := sys.dbms_sys_sql.execute(sys_cursor);
   sys.dbms_sql.close_cursor(sys_cursor);
exception
when others then
   sys.dbms_sql.close_cursor(sys_cursor);
end;
/

select * from wt_test_runs
 order by id desc;

select SYS_CONTEXT('USERENV','DB_NAME') from dual;

drop database link loopback;
create database link loopback 
  connect to wtp_demo identified by wtp_demo
  using '//localhost:1521/XE';

begin
   --wtplsql.test_all@loopback;
   wtplsql.test_run@loopback('UT_TRUNCIT');
end;
/

select db_link from user_db_links;
