[Website Home Page](README.md)

# Simple Stuff

---

A login, or database session, is required to interact with the Oracle database.  The SQL below will create a user that can run these examples.  If you already have a database login, this is not necessary.

```
create user wtp_demo identified by wtp_demo
   default tablespace users
   quota unlimited on users
   temporary tablespace temp;

grant create session   to wtp_demo;
grant create type      to wtp_demo;
grant create sequence  to wtp_demo;
grant create table     to wtp_demo;
grant create trigger   to wtp_demo;
grant create view      to wtp_demo;
grant create procedure to wtp_demo;
```

The simplest check for a wtPLSQL installation is to select the "version from dual".

Run this:
```
select wtplsql.show_version from dual;
```
and get this:
```
SHOW_VERSION
------------
1.1.0
```

Another simple test is an ad-hoc assertion. This test requires DBMS_OUTPUT. The results of this test are not recorded.

Run this:
```
set serveroutput on size unlimited format word_wrapped

begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end;
/
```
And get this:
```
PASS Ad-Hoc Test. EQ - Expected "1" and got "1"
```

Note: This ad-hoc test also demonstrates implicit data type conversion.

---
[Website Home Page](README.md)