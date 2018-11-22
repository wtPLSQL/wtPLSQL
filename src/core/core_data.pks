create or replace package core_data
   authid definer
is

   SUBTYPE long_name is varchar2(128);

   TYPE run_rec_type is record
      (runner_owner   long_name
      ,runner_name    long_name
      ,dbout_owner    long_name
      ,dbout_name     long_name
      ,dbout_type     varchar2(20)
      ,start_dtm      timestamp
      ,end_dtm        timestamp
      ,error_message  varchar2(4000));
   g_run_rec  run_rec_type;

   TYPE results_rec_type is record
      (result_seq       number(8)
      ,executed_dtm     timestamp(6)      
      ,interval_msecs   number(10,3)
      ,testcase         long_name
      ,assertion        varchar2(15)
      ,pass             boolean
      ,details          varchar2(4000)
      ,message          varchar2(200));
   TYPE results_nt_type is table of results_rec_type;
   g_results_nt    results_nt_type;
   
   procedure init1
      (in_package_name  in  varchar2);

   procedure init2;

   procedure add
      (in_testcase   in varchar2
      ,in_assertion  in varchar2
      ,in_pass       in boolean
      ,in_details    in varchar2
      ,in_message    in varchar2);
   
   procedure finalize;
   
   procedure run_error
      (in_error_message  in  varchar2);

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

end core_data;