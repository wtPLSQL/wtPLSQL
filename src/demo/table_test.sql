
create table table_test_tab
  (id     number
  ,name   varchar2(10)
  ,constraint table_test_tab_pk primary key (id)
  ,constraint table_test_tab_ck1 check (name = upper(name))
  );

create or replace package table_test_pkg
   authid definer
as

   -- This package is dedicated to wtPLSQL testing
   procedure wtplsql_run;

end table_test_pkg;
/

create or replace package body table_test_pkg
as

procedure happy_path_1
is
   l_rec        table_test_tab%ROWTYPE;
   l_num_recs   number;
   l_sqlerrm    varchar2(4000);
begin

   wt_assert.g_testcase := 'Happy Path 1';
   select count(*) into l_num_recs from table_test_tab;
   wt_assert.raises (
      msg_in         => 'Successful Insert',
      check_call_in  => 'insert into table_test_tab (id, name) values (1, ''TEST1'')',
      against_exc_in => '');

   wt_assert.eqqueryvalue (
      msg_in           => 'Number of Rows After Insert',
      check_query_in   => 'select count(*) from table_test_tab',
      against_value_in => l_num_recs + 1);
   if not wt_assert.last_pass
   then
      rollback;
      return;
   end if;

   select * into l_rec from table_test_tab where id = 1;
   wt_assert.eq (
      msg_in          => 'Confirm l_rec.name',
      check_this_in   => l_rec.name,
      against_this_in => 'TEST1');

   rollback;

   wt_assert.eqqueryvalue (
      msg_in           => 'Number of Rows After Rollback',
      check_query_in   => 'select count(*) from table_test_tab',
      against_value_in => l_num_recs);

end happy_path_1;

procedure sad_path_1
is
   l_sqlerrm    varchar2(4000);
begin
   wt_assert.g_testcase := 'Sad Path 1';
   wt_assert.raises (
      msg_in         => 'Primary Key Constraint Test 1',
      check_call_in  => 'insert into table_test_tab (id, name) values (NULL, ''TEST1'')',
      against_exc_in => 'ORA-01400: cannot insert NULL into ("WTP_DEMO"."TABLE_TEST_TAB"."ID")');
   wt_assert.raises (
      msg_in         => 'Primary Key Constraint Test 2 Setup',
      check_call_in  => 'insert into table_test_tab (id, name) values (2, ''TEST1'')',
      against_exc_in => '');
   wt_assert.raises (
      msg_in         => 'Primary Key Constraint Test 2',
      check_call_in  => 'insert into table_test_tab (id, name) values (2, ''TEST1'')',
      against_exc_in => 'ORA-00001: unique constraint (WTP_DEMO.TABLE_TEST_TAB_PK) violated');
   wt_assert.raises (
      msg_in         => 'Check Constraint 1 Test 3',
      check_call_in  => 'insert into table_test_tab (id, name) values (3, ''Test1'')',
      against_exc_in => 'ORA-02290: check constraint (WTP_DEMO.TABLE_TEST_TAB_CK1) violated');
   rollback;
end sad_path_1;

procedure wtplsql_run  --% WTPLSQL SET DBOUT "TABLE_TEST_TAB" %--
is
begin
   happy_path_1;
   sad_path_1;
end wtplsql_run;

end table_test_pkg;
/
