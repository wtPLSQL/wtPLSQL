
/* Formatted on 2001/11/19 15:11 (Formatter Plus v4.5.2) */
CREATE OR REPLACE PACKAGE str
IS
   FUNCTION betwn (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2;

   FUNCTION betwn2 (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2;

   PROCEDURE ut_setup;

   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_betwn;
   PROCEDURE wtplsql_run;
END str;
/
show errors

/* Formatted on 2001/11/19 15:15 (Formatter Plus v4.5.2) */
CREATE OR REPLACE PACKAGE BODY str
IS
   FUNCTION betwn (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
      l_start   PLS_INTEGER := start_in;
   BEGIN
      IF l_start = 0
      THEN
         l_start := 1;
      END IF;

      RETURN (SUBSTR (
                 string_in,
                 l_start,
                   end_in
                 - l_start
                 + 1
              )
             );
   END;

   FUNCTION betwn2 (
      string_in   IN   VARCHAR2,
      start_in    IN   PLS_INTEGER,
      end_in      IN   PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      -- Handle negative values
      IF end_in < 0
      THEN
         RETURN betwn (string_in, start_in, end_in);
      ELSE
         RETURN (SUBSTR (
                    string_in,
                      LENGTH (string_in)
                    + end_in
                    + 1,
                      start_in
                    - end_in
                    + 1
                 )
                );
      END IF;
   END;

   --%WTPLSQL_begin_ignore_lines%--

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
   PROCEDURE ut_betwn
   IS
   BEGIN
      utassert.eq (
         'Typical Valid Usage',
         str.betwn ('this is a string', 3, 7),
         'is is'
      );
      utassert.eq (
         'Test Negative Start',
         str.betwn ('this is a string', -3, 7),
         'ing'
      );
      utassert.isnull (
         'Start bigger than end',
         str.betwn ('this is a string', 3, 1)
      );
   END;

   --% WTPLSQL SET DBOUT "STR:PACKAGE BODY" %--
   PROCEDURE wtplsql_run IS
   BEGIN
      ut_setup;
      ut_betwn;
      ut_teardown;
   END wtplsql_run;

END str;
/
show errors

set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('STR');
   wt_text_report.dbms_out(in_runner_name  => 'STR'
                          ,in_detail_level => 30);
end;
/
