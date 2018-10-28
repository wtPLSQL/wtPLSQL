create or replace package body wt_hook
as


----------------------
--  Private Procedures
----------------------


------------------------------------------------------------
procedure run_hooks
      (in_hook_name  in varchar2)
is
begin
   for i in 1 .. run_aa(in_hook_name).COUNT
   loop
      execute immediate run_aa(in_hook_name)(i);
   end loop;
end run_hooks;


---------------------
--  Public Procedures
---------------------


------------------------------------------------------------
procedure before_test_all
is
begin
   if before_test_all_active
   then
      run_hooks('before_test_all');
   end if;
end before_test_all;

------------------------------------------------------------
procedure before_run_init
is
begin
   if before_run_init_active
   then
      run_hooks('before_run_init');
   end if;
end before_run_init;

------------------------------------------------------------
procedure after_run_init
is
begin
   if after_run_init_active
   then
      run_hooks('after_run_init');
   end if;
end after_run_init;

------------------------------------------------------------
procedure after_assertion
is
begin
   if after_assertion_active
   then
      run_hooks('after_assertion');
   end if;
end after_assertion;

------------------------------------------------------------
procedure before_run_final
is
begin
   if before_run_final_active
   then
      run_hooks('before_run_final');
   end if;
end before_run_final;

------------------------------------------------------------
procedure after_run_final
is
begin
   if after_run_final_active
   then
      run_hooks('after_run_final');
   end if;
end after_run_final;

------------------------------------------------------------
procedure after_test_all
is
begin
   if after_test_all_active
   then
      run_hooks('after_test_all');
   end if;
end after_test_all;

------------------------------------------------------------
procedure before_delete_runs
is
begin
   if before_delete_runs_active
   then
      run_hooks('before_delete_runs');
   end if;
end before_delete_runs;

------------------------------------------------------------
procedure after_delete_runs
is
begin
   if after_delete_runs_active
   then
      run_hooks('after_delete_runs');
   end if;
end after_delete_runs;

------------------------------------------------------------

begin

   for buff in (
      select hook_name
       from  wt_hooks
       group by hook_name )
   loop
      select run_string bulk collect into run_nt
       from  wt_hooks
       where hook_name = buff.hook_name
       order by wt_hooks.seq;
      if SQL%FOUND
      then
         run_aa(buff.hook_name) := run_nt;
         case buff.hook_name
            when 'before_test_all'     then before_test_all_active    := TRUE;
            when 'before_run_init'     then before_run_init_active    := TRUE;
            when 'after_run_init'      then after_run_init_active     := TRUE;
            when 'after_assertion'     then after_assertion_active    := TRUE;
            when 'before_run_final'    then before_run_final_active   := TRUE;
            when 'after_run_final'     then after_run_final_active    := TRUE;
            when 'after_test_all'      then after_test_all_active     := TRUE;
            when 'before_delete_runs'  then before_delete_runs_active := TRUE;
            when 'after_delete_runs'   then after_delete_runs_active  := TRUE;
          end case;
      end if;
   end loop;

end wt_hook;
