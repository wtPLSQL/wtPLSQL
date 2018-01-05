create or replace package body assert_test
as


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure wtplsql_run
is
begin

   ut_assert.isnotnull
      (msg_in        => 'Test Test'
      ,check_this_in => 'Not Null');

end wtplsql_run;

end assert_test;
