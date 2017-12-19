create or replace package body wtplsql
as

   TYPE runners_nt_type is table of varchar2(128);
   g_runners_nt      runners_nt_type;
   g_test_runs_rec   test_runs%ROWTYPE;

----------------------
--  Private Procedures
----------------------

procedure load_runners
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
end load_runners;

procedure find_dbout
is
   C_HEAD_RE CONSTANT varchar2(30) := '--%WTPLSQL_set_dbout[(]';
   C_MAIN_RE CONSTANT varchar2(30) := '[[:alnum:]._$#]+';
   C_TAIL_RE CONSTANT varchar2(30) := '[)]%--';
   --
   -- Head Regular Expression is
   --   '--%WTPLSQL_set_dbout' - literal string
   --   '[(]'                  - Open parenthesis character
   -- Main Regular Expression is
   --   '[[:alnum:]._$#]'      - Any alpha, numeric, ".", "_", "$", or "#" character
   --   +                      - One or more of the previous characters
   -- Tail Regular Expression is
   --   '[)]'                  - Close parenthesis character
   --   '%--'                  - literal string
   --
   -- Note: Packages, Procedure, Functions, and Types are in the same namespace
   --       and cannot have the same names.  However, Triggers can have the same
   --       name as any of the other objects.  Results are unknown if a Trigger
   --       name is the same as a Package, Procedure, Function or Type name.
   --
   cursor c_annotation is
      select text
       from  user_source
       where name = g_test_runs_rec.runner_name
        and  regexp_like(text, C_HEAD_RE || C_MAIN_RE || C_TAIL_RE)
       order by line;
   b_annotation  c_annotation%ROWTYPE;
   target  varchar2(256);
   pos     number;
begin
   open c_annotation;
   fetch c_annotation into b_annotation;
   if c_annotation%NOTFOUND
   then
      close c_annotation;
      return;
   end if;
   close c_annotation;
   -- Extract the Annotation from the Text
   target := regexp_substr(SRCSTR      => b_annotation.text
                          ,PATTERN     => C_HEAD_RE || C_MAIN_RE || C_TAIL_RE
                          ,POSITION    => 1
                          ,OCCURRENCE  => 1);
   -- Strip the Head Sub-String
   target := regexp_replace(SRCSTR      => target
                           ,PATTERN     => '^.*' || C_HEAD_RE
                           ,REPLACESTR  => ''
                           ,POSITION    => 1
                           ,OCCURRENCE  => 1);
   -- Strip the Tail Sub-String
   target := regexp_replace(SRCSTR      => target
                           ,PATTERN     => C_TAIL_RE || '.*$'
                           ,REPLACESTR  => ''
                           ,POSITION    => 1
                           ,OCCURRENCE  => 1);
   -- Locate the Owner/Name separator
   pos := instr(target,'.');
   begin
      select owner, object_name, object_type
        into g_test_runs_rec.dbout_owner
            ,g_test_runs_rec.dbout_name
            ,g_test_runs_rec.dbout_type
       from  all_objects
       where owner        = nvl(substr(target,1,pos-1),USER)
        and  object_name  = substr(target,pos+1,256);
   exception when NO_DATA_FOUND then return;
   end;
end find_dbout;

---------------------
--  Public Procedures
---------------------

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
   g_test_runs_rec.runner_name  := in_package_name;
   g_test_runs_rec.runner_owner := USER;
   insert into test_runs values g_test_runs_rec;
   --results.initialize(g_test_runs_rec.id);
   profiler.initialize(g_test_runs_rec.id);
   begin
      execute immediate in_package_name || '.WTPLSQL_RUN';
   exception when others then
      g_test_runs_rec.error_message := substr(dbms_utility.format_error_stack  ||
                                              dbms_utility.format_error_backtrace
                                             ,1,4000);
   end;
   profiler.finalize;
   --results.finalize;
   if g_test_runs_rec.error_message is not null
   then
      update test_runs
        set  error_message = g_test_runs_rec.error_message
       where id = g_test_runs_rec.id;
   end if;
end test_run;

procedure test_all
is
begin
   load_runners;
   for i in 1 .. g_runners_nt.COUNT
   loop
      test_run(g_runners_nt(i));
   end loop;
end test_all;

end wtplsql;
