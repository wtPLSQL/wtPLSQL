
CREATE OR REPLACE FUNCTION betwnStr (
   string_in IN VARCHAR2,
   start_in  IN INTEGER,
   end_in    IN INTEGER
)
RETURN VARCHAR2
IS
BEGIN
   RETURN (
      SUBSTR (
         string_in,
         start_in,
         end_in - start_in + 1
      )
   );
END;
/

CREATE OR REPLACE PACKAGE ut_betwnstr
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;
   
   PROCEDURE ut_betwnstr;
   PROCEDURE wtplsql_run;
END ut_betwnstr;
/

CREATE OR REPLACE PACKAGE BODY ut_betwnstr
IS
   PROCEDURE ut_setup IS
   BEGIN
      NULL;
   END;
   
   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_betwnstr IS
   BEGIN
      utAssert.eq (
         'Typical valid usage',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 3,
            END_IN => 5
         ),
         'cde'
      );

      utAssert.isnull (
         'NULL start',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => NULL,
            END_IN => 5
         )
      );
      
      utAssert.isnull (
         'NULL end',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 2,
            END_IN => NULL
         )
      );
      
      utAssert.isnull (
         'End smaller than start',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 5,
            END_IN => 2
         )
      );
      
      utAssert.eq (
         'End larger than string length',
         BETWNSTR(
            STRING_IN => 'abcdefg',
            START_IN => 3,
            END_IN => 200
         ),
         'cdefg'
      );

   END ut_BETWNSTR;

   --% WTPLSQL SET DBOUT "BETWNSTR:FUNCTION" %--
   PROCEDURE wtPLSQL_run IS
   BEGIN
      ut_setup;
      ut_betwnstr;
      ut_teardown;
   END wtPLSQL_run;
   
END ut_betwnstr;
/

set serveroutput on size unlimited format word_wrapped

begin
   wtplsql.test_run('UT_BETWNSTR');
   wt_text_report.dbms_out(USER,'UT_BETWNSTR',30);
end;
/
