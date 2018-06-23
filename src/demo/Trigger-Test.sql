
create sequence trigger_test_seq;

create table trigger_test_tab
  (id           number        constraint trigger_test_tab_nn1 not null
  ,name         varchar2(30)  constraint trigger_test_tab_nn2 not null
  ,created_dtm  date          constraint trigger_test_tab_nn3 not null
  ,constraint trigger_test_tab_pk primary key (id)
  ,constraint trigger_test_tab_uk1 unique (name)
  );

create or replace trigger trigger_test_bir
  before insert on trigger_test_tab
  for each row
begin
  if :new.id is null
  then
     :new.id := trigger_test_seq.nextval;
  end if;
  :new.created_dtm := sysdate;
end;
/

create or replace package trigger_test_pkg authid definer
as
   procedure wtplsql_run;
end trigger_test_pkg;
/

create or replace package body trigger_test_pkg
as
   --% WTPLSQL SET DBOUT "TRIGGER_TEST_BIR:TRIGGER" %--
   procedure wtplsql_run
   as
   begin
      null;
   end wtplsql_run;
end trigger_test_pkg;
/

create or replace package body trigger_test_pkg
as
   procedure t_happy_path_1
   is
      l_rec        trigger_test_tab%ROWTYPE;
   begin
      wt_assert.g_testcase := 'Constructor Happy Path 1';
      insert into trigger_test_tab (name) values ('Test1')
         returning id into l_rec.id;
      wt_assert.isnotnull (
         msg_in        => 'l_rec.id',
         check_this_in => l_rec.id);
      select * into l_rec from trigger_test_tab where id = l_rec.id;
      wt_assert.eq (
         msg_in          => 'l_rec.name',
         check_this_in   => l_rec.name,
         against_this_in => 'Test1');
      wt_assert.isnotnull (
         msg_in          => 'l_rec.created_dtm',
         check_this_in   => l_rec.created_dtm);
      rollback;
   end t_happy_path_1;
   --% WTPLSQL SET DBOUT "TRIGGER_TEST_BIR:TRIGGER" %--
   procedure wtplsql_run
   is
   begin
      t_happy_path_1;
   end wtplsql_run;
end trigger_test_pkg;
/

set serveroutput on size unlimited format word_wrapped

begin
   wtplsql.test_run('TRIGGER_TEST_PKG');
   wt_text_report.dbms_out(USER,'TRIGGER_TEST_PKG',30);
end;
/

select * from user_source where name = 'TRIGGER_TEST_BIR';
