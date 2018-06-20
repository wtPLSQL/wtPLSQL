[Demos and Examples](README.md)

# Test a Table Trigger

---

## Triggers

The "Database PL/SQL Language Reference" (11.2) groups triggers this way:
* Simple DML Trigger
* Compound DML Trigger
* Instead of DML Trigger
* System Trigger

All of these triggers are testable with wtPLSQL?

For brevity, the simple DML trigger will be used in these examples.

## Test a Table Insert Trigger

Create a Table and Trigger.

Run this:

```
create table

create trigger
```

## Create a Simple Test Runner

All test runners are written as a PL/SQL package. A simple package is created first.  A DBOUT is also identified.

Run this:

```
create or replace package test_simple_object authid definer
as
   procedure wtplsql_run;
end test_simple_object;
/
```

And run this:

```
create or replace package body test_simple_object
as
   --% WTPLSQL SET DBOUT "?????????????????:TABLE TRIGGER" %--
   procedure wtplsql_run
   as
   begin
      null;
   end wtplsql_run;
end test_simple_object;
/
```

## Add Trigger Test Cases

The constructor has 2 basic functions:
* NULL the the minimum value
* Set number of observations to zero

Run this:

```
create or replace package body test_simple_object
as

end test_simple_object;
/
```

Check the results of the 

Run this:

```
set serveroutput on size unlimited format word_wrapped

begin
   wtplsql.test_run('????????????????');
   wt_text_report.dbms_out(USER,'??????????????',30);
end;
/
```

And Get This:

```

```

This is report level 30, the most detailed level of reporting.  Starting from the top, we find the test runner executed .


## Testing View/Other Triggers


---
[Demos and Examples](README.md)
