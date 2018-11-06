create or replace package body wt_testcase
as

---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function get_id
      (in_testcase   in varchar2)
   return number
is
   rec  wt_testcases%ROWTYPE;
begin
   select id into rec.id from wt_testcases
    where testcase = in_testcase;
   return rec.id;
exception
   when NO_DATA_FOUND
   then
      rec.id       := wt_testcases_seq.nextval;
      rec.testcase := in_testcase;
      insert into wt_testcases values rec;
      return rec.id;
end get_id;

------------------------------------------------------------
procedure clear_unused
is
begin
   delete from wt_testcases
    where id not in (
          select testcase_id
           from  wt_results );
end clear_unused;

end wt_testcase;
