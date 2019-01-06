
/*file calc_secs_between.sp */
CREATE OR REPLACE PROCEDURE calc_secs_between (
   date1 IN DATE,
   date2 IN DATE,
   secs OUT NUMBER)
IS
BEGIN
   -- 24 hours in a day, 
   -- 60 minutes in an hour,
   -- 60 seconds in a minute...
   secs := (date2 - date1) * 24 * 60 * 60;
END;
/

CREATE OR REPLACE PACKAGE ut_calc_secs_between
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_CALC_SECS_BETWEEN;
   PROCEDURE wtplsql_run;
END ut_calc_secs_between;
/

CREATE OR REPLACE PACKAGE BODY ut_calc_secs_between
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   -- For each program to test...
   PROCEDURE ut_CALC_SECS_BETWEEN 
   IS
      secs PLS_INTEGER;
   BEGIN
      CALC_SECS_BETWEEN (
            DATE1 => SYSDATE
            ,
            DATE2 => SYSDATE
            ,
            SECS => secs
       );
   
      utAssert.eq (
         'Same dates',
         secs, 
         0
         );
         
      CALC_SECS_BETWEEN (
            DATE1 => SYSDATE
            ,
            DATE2 => SYSDATE+1
            ,
            SECS => secs
       );
   
      utAssert.eq (
         'Exactly one day',
         secs, 
         24 * 60 * 60
         );
         
   END ut_CALC_SECS_BETWEEN;

   --% WTPLSQL SET DBOUT "CALC_SECS_BETWEEN:PROCEDURE" %--
   PROCEDURE wtPLSQL_run IS
   BEGIN
      ut_setup;
      ut_CALC_SECS_BETWEEN;
      ut_teardown;
   END wtPLSQL_run;

END ut_calc_secs_between;
/

set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('UT_CALC_SECS_BETWEEN');
   wt_text_report.dbms_out(in_runner_name  => 'UT_CALC_SECS_BETWEEN'
                          ,in_detail_level => 30);
end;
/
