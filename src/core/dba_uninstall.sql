
@common_setup.sql

drop user &schema_owner. cascade;

-- Public Synonyms
drop public synonym ut_assert;
drop public synonym wt_assert;
drop public synonym wt_profiler;
drop public synonym wt_result;
drop public synonym wt_text_report;
drop public synonym wt_wtplsql;
drop public synonym wtplsql;

drop public synonym wt_test_runs;
drop public synonym wt_results;
drop public synonym wt_dbout_profiles;
drop public synonym wt_not_executable;

drop public synonym wt_test_runs_seq;


set serveroutput on

declare
   C_FLAG  CONSTANT varchar2(100) := 'WTPLSQL_ENABLE:';
   parm_value   v_$parameter.value%TYPE;
begin
   select value into parm_value
    from  v_$parameter
    where name in 'plsql_ccflags';
   if instr(parm_value, C_FLAG) <> 0
   then
      DBMS_OUTPUT.PUT_LINE('Remove ' || C_FLAG ||
            ' from PLSQL_CCFLAGS: "' || parm_value || '"');
   end if;
end;
/
