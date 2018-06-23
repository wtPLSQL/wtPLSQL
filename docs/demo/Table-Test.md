[Demos and Examples](README.md)

# Test a Trigger

---

## Triggers
There are many kinds of triggers.  All of them use PL/SQL to define actions taken when the the trigger is activated.

The "Database PL/SQL Language Reference" (11.2) [groups triggers](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_trigger.htm#BABBJHHG) this way:
* Simple DML Trigger
* Compound DML Trigger
* Instead of DML Trigger
* System Trigger

[Simple DML Triggers](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_trigger.htm#BABBJHHG):
* before delete
* before insert
* before update
* after delete
* after insert
* after update

[Compound DML Triggers](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_trigger.htm#BABDFIFA):
* before delete statement
* before insert statement
* before update statement
* before each row deleted
* before each row inserted
* before each row updated
* instead of each row deleted
* instead of each row inserted
* instead of each row updated
* after each row deleted
* after each row inserted
* after each row updated
* after delete statement
* after insert statement
* after update statement

[Instead of DML Triggers](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_trigger.htm#CIHEIGBE):
* instead of delete
* instead of insert
* instead of update

[System Triggers](https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/create_trigger.htm#BABHEFGE):
* before alter statement
* before analyze statement
* before associate statistics statement
* before audit statement
* before comment statement
* before create statement
* before database shutdown
* before disassociate statistics statement
* before drop statement
* before grant statement
* before noaudit statement
* before rename statement
* before revoke statement
* before truncate statement
* before user logoff
* instead of alter statement
* instead of analyze statement
* instead of associate statistics statement
* instead of audit statement
* instead of comment statement
* instead of create statement
* instead of disassociate statistics statement
* instead of drop statement
* instead of grant statement
* instead of noaudit statement
* instead of rename statement
* instead of revoke statement
* instead of truncate statement
* after alter statement
* after analyze statement
* after associate statistics statement
* after audit statement
* after comment statement
* after create statement
* after database startup
* after db role change
* after disassociate statistics statement
* after drop statement
* after grant statement
* after noaudit statement
* after rename statement
* after revoke statement
* after servererror
* after truncate statement
* after user logon
* after user suspend

For brevity, an example is provided for only one of these triggers.

## Table with Insert Trigger

Before a trigger an be created, a table must be created.  The table will have a surrogate key, a natural key, and audit data.

Run this:

```
create sequence trigger_test_seq;

create table trigger_test_tab
  (id           number        constraint trigger_test_tab_nn1 not null
  ,name         varchar2(30)  constraint trigger_test_tab_nn2 not null
  ,created_dtm  date          constraint trigger_test_tab_nn3 not null
  ,constraint trigger_test_tab_pk primary key (id)
  ,constraint trigger_test_tab_uk1 unique (name)
  );
```

The trigger to be tested does 2 things
1) Populate the surrogate key, if needed.
2) Overwrite the audit data.

Run this:

```
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
```

## Create a Simple Test Runner

All test runners are written as a PL/SQL package. A simple package is created first.  A DBOUT is also identified.

Run this:

```
create or replace package trigger_test_pkg authid definer
as
   procedure wtplsql_run;
end trigger_test_pkg;
/
```

And run this:

```
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
```

## Add a Trigger Test Case

The trigger being tested is a table DML trigger. Testing of a table trigger like this requires a modification of the data in the table.  The consequences of leaving this modified data after the test must be considered.  In this test, the data modification will not be preserved. 

This test case will only test a happy path.

Run this:

```
create or replace package body trigger_test_pkg
as
   procedure t_happy_path_1
   is
      l_rec        trigger_test_tab%ROWTYPE;
   begin
      wt_assert.g_testcase := 'Constructor Happy Path 1';
      -- This uncommitted DML will ROLLBACK if an exception is raised.
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
```

Check the results of the 

Run this:

```
set serveroutput on size unlimited format word_wrapped

begin
   wtplsql.test_run('TRIGGER_TEST_PKG');
   wt_text_report.dbms_out(USER,'TRIGGER_TEST_PKG',30);
end;
/
```

And Get This:

```
    wtPLSQL 1.1.0 - Run ID 58: 23-Jun-2018 12:04:20 PM

  Test Results for WTP_DEMO.TRIGGER_TEST_PKG
       Total Test Cases:        1       Total Assertions:        3
  Minimum Interval msec:        0      Failed Assertions:        0
  Average Interval msec:       76       Error Assertions:        0
  Maximum Interval msec:      228             Test Yield:   100.00%
   Total Run Time (sec):      0.2

  Code Coverage for TRIGGER WTP_DEMO.TRIGGER_TEST_BIR
          Ignored Lines:        0   Total Profiled Lines:        5
         Excluded Lines:        0   Total Executed Lines:        4
  Minimum LineExec usec:        1     Not Executed Lines:        0
  Average LineExec usec:      137          Unknown Lines:        1
  Maximum LineExec usec:      326          Code Coverage:   100.00%
  Trigger Source Offset:        3

 - WTP_DEMO.TRIGGER_TEST_PKG Test Result Details (Test Run ID 58)
-----------------------------------------------------------
 ---- Test Case: Constructor Happy Path 1
 PASS  228ms l_rec.id. ISNOTNULL - Expected NOT NULL and got "15"
 PASS    0ms l_rec.name. EQ - Expected "Test1" and got "Test1"
 PASS    0ms l_rec.created_dtm. ISNOTNULL - Expected NOT NULL and got "23-JUN-2018 12:04:20"

 - WTP_DEMO.TRIGGER_TEST_BIR TRIGGER Code Coverage Details (Test Run ID 58)
Source               TotTime MinTime   MaxTime     
  Line Stat Occurs    (usec)  (usec)    (usec) Text
------ ---- ------ --------- ------- --------- ------------
     4 UNKN      0        11      11        11 begin
     5 EXEC      1       216     216       216   if :new.id is null
     7 EXEC      1       326     326       326      :new.id := trigger_test_seq.nextval;
     9 EXEC      1         4       1         3   :new.created_dtm := sysdate;
    10 EXEC      1         2       2         2 end;
```

This is report level 30, the most detailed level of reporting.  Starting from the top, we find the test runner executed 1 test case and 3 assertions.  All tests passed for a 100% yield.  The code coverage for the trigger shows 5 profiles, 4 executed, and a code coverage of 100%.  Notice the trigger offset of 3 which aligns the source code with the profiled lines.

---
[Demos and Examples](README.md)
