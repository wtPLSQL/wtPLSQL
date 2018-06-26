
/*file truncit.sp */
CREATE OR REPLACE PROCEDURE truncit (
   tab IN VARCHAR2,
   sch IN VARCHAR2 := NULL
)
IS
BEGIN
   EXECUTE IMMEDIATE 'truncate table ' || NVL (sch, USER) || '.' || tab;
END;
/

/*file tabcount.sf */
CREATE OR REPLACE FUNCTION tabcount (
   sch IN VARCHAR2,
   tab IN VARCHAR2)
   RETURN INTEGER
IS
   retval  INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
      'SELECT COUNT(*) FROM ' || sch || '.' || tab
      INTO retval; 
   RETURN retval;
EXCEPTION
    WHEN OTHERS 
    THEN
       RETURN NULL; 
END;
/

CREATE OR REPLACE PACKAGE ut_truncit
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_TRUNCIT;
   PROCEDURE wtplsql_run;
END ut_truncit;
/

/*file ut_truncit.pkb */
CREATE OR REPLACE PACKAGE BODY ut_truncit
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      EXECUTE IMMEDIATE 
         'CREATE TABLE temp_emp AS SELECT * FROM DUAL';
   END;
   
   PROCEDURE ut_teardown
   IS
   BEGIN
      EXECUTE IMMEDIATE 
         'DROP TABLE temp_emp';
   END;

   -- For each program to test...
   PROCEDURE ut_TRUNCIT IS
   BEGIN
      TRUNCIT (
            TAB => 'temp_emp'
            ,
            SCH => USER
       );

      utAssert.eq (
         'Test of TRUNCIT',
         tabcount (USER, 'temp_emp'),
         0
         );
   END ut_TRUNCIT;

   --% WTPLSQL SET DBOUT "TRUNCIT:PROCEDURE" %--

   PROCEDURE wtplsql_run IS
   BEGIN
      ut_setup;
      ut_TRUNCIT;
      ut_teardown;
   END wtplsql_run;
END ut_truncit;
/

set serveroutput on size unlimited format word_wrapped

begin
   wtplsql.test_run('UT_TRUNCIT');
   wt_text_report.dbms_out(in_runner_name  => 'UT_TRUNCIT'
                          ,in_detail_level => 30);
end;
/
