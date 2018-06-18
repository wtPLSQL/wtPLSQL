
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

select wtplsql.show_version from dual;

set serveroutput on size unlimited format word_wrapped

begin
   wt_assert.eq(msg_in          => 'Ad-Hoc Test'
               ,check_this_in   =>  1
               ,against_this_in => '1');
end;
/
