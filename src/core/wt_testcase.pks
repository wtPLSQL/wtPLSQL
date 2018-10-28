create or replace package wt_testcase
   authid definer
as

   function get_testcase_id
      (in_testcase   in varchar2)
   return number;

   procedure clear_testcases;

end wt_testcase;
