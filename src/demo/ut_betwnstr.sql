
create or replace function betwnstr
      (string_in in varchar2,
       start_in  in integer,
       end_in    in integer)
   return varchar2
is
begin
   return (
      substr (
         string_in,
         start_in,
         end_in - start_in + 1
      )
   );
end;
/

create or replace package ut_betwnstr
is
   procedure wtplsql_run;
end ut_betwnstr;
/

create or replace package body ut_betwnstr
is

   --% WTPLSQL SET DBOUT "BETWNSTR:FUNCTION" %--

procedure wtplsql_run is
begin

   utAssert.eq (
      'Typical valid usage',
      betwnstr(
         string_in => 'abcdefg',
         start_in => 3,
         end_in => 5
      ),
      'cde'
   );

   utAssert.isnull (
      'NULL start',
      betwnstr(
         string_in => 'abcdefg',
         start_in => NULL,
         end_in => 5
      )
   );
   
   utAssert.isnull (
      'NULL end',
      betwnstr(
         string_in => 'abcdefg',
         start_in => 2,
         end_in => NULL
      )
   );
   
   utAssert.isnull (
      'End smaller than start',
      betwnstr(
         string_in => 'abcdefg',
         start_in => 5,
         end_in => 2
      )
   );
   
   utAssert.eq (
      'End larger than string length',
      betwnstr(
         string_in => 'abcdefg',
         start_in => 3,
         end_in => 200
      ),
      'cdefg'
   );

end wtplsql_run;
   
end ut_betwnstr;
/
