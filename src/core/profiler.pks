create or replace package profiler authid current_user
as

   procedure initialize
      (in_test_run_id  in  number);

   procedure finalize;

end profiler;
