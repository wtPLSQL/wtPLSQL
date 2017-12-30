create or replace package profiler authid current_user
as

   procedure initialize
      (in_test_run_id  in  number);

   procedure finalize;

   procedure pause;

   procedure resume;

   FUNCTION trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2)
   return number;

   function calc_pct_coverage
      (in_test_run_id  in  number)
   return number;

end profiler;
