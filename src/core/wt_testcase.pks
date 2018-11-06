create or replace package wt_testcase
   authid definer
as

   function get_id
      (in_testcase   in varchar2)
   return number;

   procedure clear_unused;

end wt_testcase;
