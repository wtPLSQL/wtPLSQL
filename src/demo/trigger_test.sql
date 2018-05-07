
create sequence trigger_test_seq;

create table trigger_test_tab
  (id           number
  ,name         varchar2(30)
  ,created_dtm  date
  ,constraint trigger_test_tab_pk primary key (id)
  );

create or replace trigger trigger_test_bir
  before insert on trigger_test_tab
  for each row
begin
  if :new.id is null
  then
     :new.id := trigger_test_seq.nextval;
  end if;
  if :new.created_dtm is null
  then
     :new.created_dtm := sysdate;
  end if;
end;
/

create or replace package trigger_test_pkg
   authid definer
as

   -- This package is dedicated to wtPLSQL testing
   procedure wtplsql_run;

end trigger_test_pkg;
/

create or replace package body trigger_test_pkg
as

procedure insert_test
is
   l_rec        trigger_test_tab%ROWTYPE;
   l_num_recs   number;
   l_sqlerrm    varchar2(4000);
begin
   --
   select count(*) into l_num_recs from trigger_test_tab;
   begin
      insert into trigger_test_tab (name) values ('Test1')
         returning id into l_rec.id;
      l_sqlerrm := SQLERRM;
   exception when others then
      l_sqlerrm := SQLERRM;
   end;
   --
   wt_assert.eq (
      msg_in          => 'SQLERRM String',
      check_this_in   => l_sqlerrm,
      against_this_in => 'ORA-0000: normal, successful completion');
   if not wt_assert.last_pass
   then
     rollback;
     return;
   end if;
   --
   wt_assert.eqqueryvalue (
      msg_in           => 'Number of Rows After Test',
      check_query_in   => 'select count(*) from trigger_test_tab',
      against_value_in => l_num_recs + 1);
   if not wt_assert.last_pass
   then
      rollback;
      return;
   end if;
   --
   wt_assert.isnotnull (
      msg_in        => 'l_rec.id',
      check_this_in => l_rec.id);
   if not wt_assert.last_pass
   then
      rollback;
      return;
   end if;
   --
   select * into l_rec from trigger_test_tab where id = l_rec.id;
   wt_assert.eq (
      msg_in          => 'l_rec.name',
      check_this_in   => l_rec.name,
      against_this_in => 'Test1');
   wt_assert.isnotnull (
      msg_in          => 'l_rec.created_dtm',
      check_this_in   => l_rec.created_dtm);
   --
   rollback;
   wt_assert.eqqueryvalue (
      msg_in           => 'Number of Rows After Rollback',
      check_query_in   => 'select count(*) from trigger_test_tab',
      against_value_in => l_num_recs);
end insert_test;

procedure wtplsql_run  --% WTPLSQL SET DBOUT "TRIGGER_TEST_BIR" %--
is
begin
   insert_test;
end wtplsql_run;

end trigger_test_pkg;
/
