
# Create a Simple Test Runner

Test Runner Package Spec:
```
create or replace package simple_test_runner authid current_user
as
   procedure wtplsql_run;
end;
/
```
Test Runner Package Body:
```
create or replace package body simple_test_runner
as

procedure wtplsql_run
is
begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end wtplsql_run;

end;
/
```
This simple test runner contains the minimum elements of a test runner. It does the same test as the ad-hoc assertion in the [Demonstrations and Examples Page](README.md). However, the test results are not sent to DBMS_OUTPUT. The test results are saved in the wtPLSQL tables.

To execute the Test Runner, run this:
```
begin
   wtplsql_run(simple_test_runner);
end;
/
```

 The results can be queried from those tables. Alternatively, a default reporting package called 