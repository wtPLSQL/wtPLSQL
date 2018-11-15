create or replace package wt_profile
   authid definer
as

   TYPE rec_type is record
      (test_run_id     wt_test_runs.id%TYPE
      ,dbout_owner     wt_test_runs.dbout_owner%TYPE
      ,dbout_name      wt_test_runs.dbout_name%TYPE
      ,dbout_type      wt_test_runs.dbout_type%TYPE
      ,prof_runid      binary_integer
      ,trigger_offset  binary_integer
      ,error_message   varchar2(4000));
   g_rec  rec_type;
   
   TYPE ignr_aa_type is table
      of varchar2(1)
      index by PLS_INTEGER;
   g_ignr_aa   ignr_aa_type;

   procedure initialize
      (in_test_run_id      in  number,
       in_runner_owner     in  varchar2,
       in_runner_name      in  varchar2,
       out_dbout_owner     out varchar2,
       out_dbout_name      out varchar2,
       out_dbout_type      out varchar2,
       out_trigger_offset  out number,
       out_profiler_runid  out number,
       out_error_message   out varchar2);

   procedure finalize;

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

   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_profile;
