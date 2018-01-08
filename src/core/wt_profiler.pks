create or replace package wt_profiler authid current_user
as

   procedure initialize
      (in_test_run_id      in  number,
       in_runner_name      in  varchar2,
       out_dbout_owner     out varchar2,
       out_dbout_name      out varchar2,
       out_dbout_type      out varchar2,
       out_trigger_offset  out number,
       out_profiler_runid  out number);

   procedure finalize;

   procedure pause;

   procedure resume;

   function trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2
      ,dbout_type_in   in  varchar2)
   return number;

   function calc_pct_coverage
      (in_test_run_id  in  number)
   return number;

   procedure delete_records
      (in_test_run_id  in number);

end wt_profiler;
