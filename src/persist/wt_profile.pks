create or replace package wt_profile
   authid definer
as

   TYPE ignr_aa_type is table
      of varchar2(1)
      index by PLS_INTEGER;
   g_ignr_aa   ignr_aa_type;

   g_rec  wt_dbout_runs%ROWTYPE;

   procedure initialize;

   procedure finalize
      (in_test_run_id   in number);

   function trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2
      ,dbout_type_in   in  varchar2)
   return number;

   function calc_pct_coverage
      (in_test_run_id  in  number)
   return number;

   procedure delete_run_id
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
