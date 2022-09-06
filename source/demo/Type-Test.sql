
create or replace type simple_test_obj_type authid definer
   as object
   (minimum_value  number
   ,observations   number
   ,CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
       return self as result
   ,member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
   );
/
show errors

create or replace type body simple_test_obj_type is
    CONSTRUCTOR FUNCTION simple_test_obj_type
          (SELF IN OUT NOCOPY simple_test_obj_type)
          return self as result
    is
    begin
       minimum_value  := null;
       observations   := 0;
       return;
    end simple_test_obj_type;
    member procedure add_observation
          (SELF IN OUT NOCOPY simple_test_obj_type
          ,in_observation  number)
    is
    begin
       If minimum_value is null then minimum_value := in_observation;
       else minimum_value := least(minimum_value, in_observation);
       end if;
       observations := observations + 1;
    end add_observation;
end;
/
show errors

create or replace package test_simple_object authid definer
as
   procedure wtplsql_run;
end test_simple_object;
/
show errors

create or replace package body test_simple_object
as
   --% WTPLSQL SET DBOUT "SIMPLE_TEST_OBJ_TYPE:TYPE BODY" %--
   procedure t_constructor
   is
      simple_test_obj  simple_test_obj_type;
   begin
      wt_assert.g_testcase := 'Constructor Happy Path 1';
      simple_test_obj := simple_test_obj_type();
      wt_assert.isnull(msg_in        => 'Object MINIMUM_VALUE'
                      ,check_this_in => simple_test_obj.MINIMUM_VALUE);
      wt_assert.eq(msg_in          => 'Object OBSERVATIONS'
                  ,check_this_in   => simple_test_obj.OBSERVATIONS
                  ,against_this_in => 0);
   end t_constructor;
   procedure wtplsql_run
   as
   begin
      t_constructor;
   end wtplsql_run;
end test_simple_object;
/
show errors

set serveroutput on size unlimited format truncated

begin
   wtplsql.test_run('TEST_SIMPLE_OBJECT');
   wt_persist_report.dbms_out(USER,'TEST_SIMPLE_OBJECT',30);
end;
/
