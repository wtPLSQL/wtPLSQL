[Demos and Examples](README.md)

# Test Table Constraints

---

The syntax diagram in Oracle's "Database SQL Language Reference" (11.2) gives the list of [constraints](https://docs.oracle.com/cd/E11882_01/server.112/e41084/clauses002.htm#CJAEDFIB) this way:

* Not Null
* Unique (Key)
* Primary Key
* References (Foreign Key)
* Check

Typical, these constraints are assumed to work without testing.  Here we create a Test Runner to test the constraints on a table.

## Table with Constraints

A table with constraints is needed for testing.  This table has several constraints

Run this:

```
create table table_test_tab
  (id     number        constraint table_test_tab_nn1 not null
  ,name   varchar2(10)  constraint table_test_tab_nn2 not null
  ,constraint table_test_tab_pk primary key (id)
  ,constraint table_test_tab_uk1 unique (name)
  ,constraint table_test_tab_ck1 check (name = upper(name))
  );
```

For brevity, the check constraint will be the only constraint tested.

## Test Runner

Create a simple test runner.

Run this:

```
create or replace package table_test_pkg authid definer
as
   procedure wtplsql_run;
end table_test_pkg;
/
```

The constraint being tested ensures the name is in upper case.  Testing of the constraint requires a modification of the data in the table.  The consequences of leaving this modified data after the test must be considered.  In this test, the data modification will not be preserved.

This test case will only test a happy path.

Run this:

```
create or replace package body table_test_pkg
as
   procedure t_happy_path_1
   is
      l_rec  table_test_tab%ROWTYPE; 
   begin
      wt_assert.g_testcase := 'Happy Path 1';
      wt_assert.raises (
         msg_in         => 'Successful Insert',
         check_call_in  => 'insert into table_test_tab (id, name) values (1, ''TEST1'')',
         against_exc_in => '');
      select * into l_rec from table_test_tab where id = 1;
      wt_assert.eq (
         msg_in          => 'Confirm l_rec.name',
         check_this_in   => l_rec.name,
         against_this_in => 'TEST1');
      rollback;
   end t_happy_path_1;
   procedure t_sad_path_1
   is
   begin
      wt_assert.g_testcase := 'Sad Path 1';
      wt_assert.raises (
         msg_in          => 'Raise Error',
         check_call_in   => 'insert into table_test_tab (id, name) values (1, ''Test1'')',
         against_exc_in  => 'ORA-02290: check constraint (WTP_DEMO.TABLE_TEST_TAB_CK1) violated');
   end t_sad_path_1;
   procedure wtplsql_run is
   begin
      t_happy_path_1;
      t_sad_path_1;
   end wtplsql_run;
end table_test_pkg;
/
```

## Check the results

Run this to setup HOOKS:

```
begin
   wtp.wt_test_run.delete_hooks;
   wtp.junit_core_report.delete_hooks;
   wtp.wt_core_report.insert_hooks;
   update wtp.hooks
     set  run_string = 'begin wtp.wt_core_report.dbms_out(in_detail_level => 30); end;'
    where hook_name  = 'after_test_run'
     and  run_string = 'begin wtp.wt_core_report.dbms_out(in_detail_level => 10); end;';
   wtp.hook.init;
end;
/
```

Run this:

```
begin
   wtplsql.test_run('TABLE_TEST_PKG');
end;
/
```

And Get This:

```
  wtPLSQL wtpsrc 1.003, wtptst 1.003, wtpsav 1.003, wtpgrb 1.003
  Start Date/Time: 13-Apr-2024 01:14:13 AM
  Test Results for WT_DEMO.TABLE_TEST_PKG
  ------------------------------------------------------------------
  Minimum Elapsed msec:          0      Total Assertions:          3
  Average Elapsed msec:          1     Failed Assertions:          0
  Maximum Elapsed msec:          2       Total Testcases:          2
  Total Run Time (sec):        0.0      Failed Testcases:          0
                                          Testcase Yield:        100%

  WT_DEMO.TABLE_TEST_PKG Test Runner Details
  --------------------------------------------------------------
---***  Happy Path 1  ***-------------------------------------------------------
 PASS .755ms Successful Insert. RAISES/THROWS - No exception was expected. Exception raised was "". Exception raised by: "insert into table_test_tab (id, name) values (1, 'TEST1')".
 PASS .184ms Confirm l_rec.name. EQ - Expected "TEST1" and got "TEST1"
---***  Sad Path 1  ***---------------------------------------------------------
 PASS 2.27ms Raise Error. RAISES/THROWS - Expected exception "%ORA-02290: check constraint (WT_DEMO.TABLE_TEST_TAB_CK1) violated%". Actual exception raised was "ORA-02290: check constraint (WT_DEMO.TABLE_TEST_TAB_CK1) violated". Exception raised by: "insert into table_test_tab (id, name) values (1, 'Test1')".
```

This is report level 30, the most detailed level of reporting.  Starting from the top, we find the test runner executed 1 test case and 2 assertions.  All tests passed for a 100% yield.  There is no code coverage for the constraints.

This is not a complete test.  More test cases are needed to confirm other constraints and sad path testing.

---
[Demos and Examples](README.md)
