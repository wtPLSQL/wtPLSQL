create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   test_runs%ROWTYPE;


----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure test_run
      (in_package_name  in  varchar2)
is
   test_runs_rec_NULL   test_runs%ROWTYPE;
begin
   if in_package_name is null
   then
      raise_application_error  (-20000, 'i_package_name is null');
   end if;
   g_test_runs_rec              := test_runs_rec_NULL;
   g_test_runs_rec.id           := test_runs_seq.nextval;
   g_test_runs_rec.start_dtm    := systimestamp;
   g_test_runs_rec.runner_name  := in_package_name;
   g_test_runs_rec.runner_owner := USER;
   insert into test_runs values g_test_runs_rec;
   result.initialize(g_test_runs_rec.id);
   profiler.initialize(g_test_runs_rec.id);
   COMMIT;
   begin
      execute immediate in_package_name || '.WTPLSQL_RUN';
   exception
      when OTHERS
      then
         g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                                 dbms_utility.format_error_backtrace
                                                ,1,4000);
   end;
   profiler.pause;
   ROLLBACK;
   profiler.finalize;
   result.finalize;
   g_test_runs_rec.end_dtm := systimestamp;
   update test_runs
     set  end_dtm       = g_test_runs_rec.end_dtm
         ,error_message = g_test_runs_rec.error_message
    where id = g_test_runs_rec.id;
   COMMIT;
exception
   when OTHERS
   then
      g_test_runs_rec.error_message := substr(g_test_runs_rec.error_message || CHR(10) ||
                                              dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace
                                             ,1,4000);
      update test_runs
        set  end_dtm       = g_test_runs_rec.end_dtm
            ,error_message = g_test_runs_rec.error_message
       where id = g_test_runs_rec.id;
      profiler.finalize;
      result.finalize;
      COMMIT;
end test_run;

------------------------------------------------------------
procedure test_all
is
begin
   select package_name
     bulk collect into g_runners_nt
    from  user_arguments  t1
    where object_name   = 'WTPLSQL_RUN'
     and  position      = 1
     and  sequence      = 0
     and  data_type     is null
     and  not exists (
          select 'x' from user_arguments  t2
           where t2.object_name = t1.object_name
            and  (   t2.overload is null
                  OR t2.overload = t1.overload)
            and  t2.position    > t1.position
            and  t2.sequence    > t1.sequence
          );
   for i in 1 .. g_runners_nt.COUNT
   loop
      test_run(g_runners_nt(i));
   end loop;
end test_all;

end wtplsql;
