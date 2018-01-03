create or replace package profiler authid current_user
as

   TYPE rec_type is record
      (test_run_id     test_runs.id%TYPE
      ,dbout_owner     test_runs.dbout_owner%TYPE
      ,dbout_name      test_runs.dbout_name%TYPE
      ,dbout_type      test_runs.dbout_type%TYPE
      ,prof_runid      binary_integer
      ,error_message   varchar2(4000));
   g_rec  rec_type;

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
