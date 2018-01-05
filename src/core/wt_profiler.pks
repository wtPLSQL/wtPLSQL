create or replace package wt_profiler authid current_user
as

   function get_dbout_owner
   return wt_test_runs.dbout_owner%TYPE;
   
   function get_dbout_name
   return wt_test_runs.dbout_name%TYPE;
   
   function get_dbout_type
   return wt_test_runs.dbout_type%TYPE;

   procedure initialize
      (in_test_run_id   in  number,
       out_dbout_owner  out varchar2,
       out_dbout_name   out varchar2,
       out_dbout_type   out varchar2);

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

end wt_profiler;
