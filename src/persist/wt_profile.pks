create or replace package wt_profile
   authid definer
as

   function is_profilable
      (in_dbout_owner  in varchar2
      ,in_dbout_name   in varchar2
      ,in_dbout_type   in varchar2)
   return boolean;

   function trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2
      ,dbout_type_in   in  varchar2)
   return number;

   function calc_pct_coverage
      (in_test_run_id  in  number)
   return number;

   procedure initialize;

   procedure finalize
      (in_test_run_id   in number);

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
