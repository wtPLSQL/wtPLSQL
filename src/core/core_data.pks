create or replace package core_data
   authid definer
is

   SUBTYPE long_name is varchar2(128);

   TYPE run_rec_type is record
      (test_runner_owner  long_name                         -- Owner of the Test Runner
      ,test_runner_name   long_name                         -- Name of the Test Runner
      ,start_dtm          timestamp(3) with local time zone -- Test Runner Start Date/Time
      ,end_dtm            timestamp(3) with local time zone -- Test Runner End Date/Time
      ,runner_sec         number(6,1)    default 0          -- Total Runtime for Test Runner in Seconds
      ,error_message      varchar2(4000)                    -- Error Message
      ,tc_cnt             number(7)      default 0          -- Number of Test Cases
      ,tc_fail            number(7)      default 0          -- Number of Failed Test Cases
      ,asrt_fst_dtm       timestamp(3) with local time zone -- Date/Time of First Assertion
      ,asrt_lst_dtm       timestamp(3) with local time zone -- Date/Time of Last Assertion
      ,asrt_cnt           number(7)      default 0          -- Number of Assertions across all Test Cases
      ,asrt_fail          number(7)      default 0          -- Number of Assertion Failures across all Test Cases
      ,asrt_min_msec      number(10)                        -- Minumum Assertion Interval in Milliseconds across all Test Cases
      ,asrt_max_msec      number(10)                        -- Maximum Assertion Interval in Milliseconds across all Test Cases
      ,asrt_tot_msec      number(10)     default 0          -- Total Assertion Intervals in Milliseconds across all Test Cases
      ,asrt_sos_msec      number(20)     default 0          -- Sum of Squares of Assertion Interval in Milliseconds across all Test Cases
      ,dbout_owner        long_name                         -- Owner of the Database Object Under Test
      ,dbout_name         long_name                         -- Name of the Database Object Under Test
      ,dbout_type         varchar2(20)                      -- Type of the Database Object Under Test
      );
   g_run_rec  run_rec_type;

   TYPE tcases_rec_type is record
      (asrt_cnt       number(7)      default 0          -- Number of Assertions in this Test Case
      ,asrt_fail      number(7)      default 0          -- Number of Failed Assertsion in this Test Case
      ,asrt_min_msec  number(10)                        -- Minumum Assertion Interval in Milliseconds in this Test Cases
      ,asrt_max_msec  number(10)                        -- Maximum Assertion Interval in Milliseconds in this Test Cases
      ,asrt_tot_msec  number(10)     default 0          -- Total Assertion Interval in Milliseconds in this Test Cases
      ,asrt_sos_msec  number(20)     default 0          -- Sum of Squares Assertion Interval in Milliseconds in this Test Cases
      );
   TYPE tcases_aa_type is table of tcases_rec_type index by long_name;
   g_tcases_aa   tcases_aa_type;

   TYPE results_rec_type is record
      (result_seq     number(8)      default 0          -- Sequence Number of the Assertion
      ,testcase       long_name                         -- Test Case Name of the Assertion
      ,executed_dtm   timestamp(6) with local time zone -- Execution Date/Time of the Assertion
      ,interval_msecs number(10,3)                      -- Interval from Previous Assertion in Milliseconds
      ,assertion      varchar2(15)                      -- Name of the Assertion
      ,pass           boolean                           -- Did the Assertion Pass? (TRUE/FALSE)
      ,message        varchar2(200)                     -- Identifcation Message of the Assertion
      ,details        varchar2(4000)                    -- Test Details of the Assertion
      );
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
   
   procedure final1;
   
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