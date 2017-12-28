create or replace package body profiler
as

   g_dbout_profiles_rec  dbout_profiles%ROWTYPE;
   g_owner               test_runs.dbout_owner%TYPE;
   g_name                test_runs.dbout_name%TYPE;
   g_type                test_runs.dbout_type%TYPE;
   g_runid               binary_integer;
   g_message             varchar2(4000);

----------------------
--  Private Procedures
----------------------

------------------------------------------------------------
-- Return DBMS_PROFILER specific error messages
function get_error_msg
      (retnum_in  in  binary_integer)
   return varchar2
is
   msg_prefix  varchar2(50) := 'DBMS_PROFILER Error: ';
begin
   case retnum_in
   when dbms_profiler.error_param then return msg_prefix ||
       'A subprogram was called with an incorrect parameter.';
   when dbms_profiler.error_io then return msg_prefix ||
       'Data flush operation failed.' ||
       ' Check whether the profiler tables have been created,' ||
       ' are accessible, and that there is adequate space.';
   when dbms_profiler.error_version then return msg_prefix ||
       'There is a mismatch between package and database implementation.' ||
       ' Oracle returns this error if an incorrect version of the' ||
       ' DBMS_PROFILER package is installed, and if the version of the' ||
       ' profiler package cannot work with this database version.';
   else return msg_prefix ||
       'Unknown error number ' || retnum_in;
   end case;
end get_error_msg;

------------------------------------------------------------
procedure reset_variables
is
   l_dbout_profiles_NULL  dbout_profiles%ROWTYPE;
begin
   g_owner   := NULL;
   g_name    := NULL;
   g_type    := NULL;
   g_message := NULL;
   g_dbout_profiles_rec := l_dbout_profiles_NULL;
end reset_variables;

------------------------------------------------------------
procedure find_dbout
      (in_test_run_id  in  number)
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
      select src.text
       from  user_source  src
             join test_runs  tr
                  on  tr.runner_name = src.name
                  and tr.id          = in_test_run_id
       where src.type = 'PACKAGE BODY'
        and  regexp_like(src.text, C_HEAD_RE || C_MAIN_RE || C_TAIL_RE)
       order by src.line;
   b_annotation  c_annotation%ROWTYPE;
   target        varchar2(256);
   pos           number;
begin
   open c_annotation;
   fetch c_annotation into b_annotation;
   if c_annotation%NOTFOUND
   then
      close c_annotation;
      return;
   end if;
   close c_annotation;
   target := b_annotation.text;
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
        into g_owner
            ,g_name
            ,g_type
       from  all_objects
       where owner        = nvl(substr(target,1,pos-1),USER)
        and  object_name  = substr(target,pos+1,256);
   exception when NO_DATA_FOUND
   then
      g_message := 'Unable to find Database Object "' || target || '". ';
   end;
end find_dbout;

---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
procedure initialize
      (in_test_run_id  in  number)
is
   retnum  binary_integer;
begin
   if in_test_run_id is null
   then
      raise_application_error  (-20000, 'i_test_run_id is null');
   end if;
   reset_variables;
   g_dbout_profiles_rec.test_run_id := in_test_run_id;
   find_dbout(in_test_run_id);
   update test_runs
     set  dbout_owner   = g_owner
         ,dbout_name    = g_name
         ,dbout_type    = g_type
         ,error_message = substr(error_message || g_message, 1, 4000)
    where id = g_dbout_profiles_rec.test_run_id;
   if g_name is not null
   then
      retnum := dbms_profiler.INTERNAL_VERSION_CHECK;
      if retnum <> 0 then
         raise_application_error(-20000,
            'dbms_profiler.INTERNAL_VERSION_CHECK returned: ' || get_error_msg(retnum));
      end if;
      -- This starts the PROFILER Running!!!
      retnum := dbms_profiler.START_PROFILER(run_number => g_runid);
      if retnum <> 0 then
         raise_application_error(-20000,
            'dbms_profiler.START_PROFILER returned: ' || get_error_msg(retnum));
      end if;
   end if;
end initialize;

------------------------------------------------------------
procedure finalize
is
   cursor c_main is
      select ppd.line#
            ,src.text
            ,sum(ppd.total_occur)           TOTAL_OCCUR
            ,sum(ppd.total_time)            TOTAL_TIME
            ,min(ppd.min_time)              MIN_TIME
            ,max(ppd.max_time)              MAX_TIME
       from  plsql_profiler_units ppu
             join plsql_profiler_data  ppd
                  on  ppd.unit_number = ppu.unit_number
                  and ppd.runid       = ppu.runid
                  and (   ppd.total_occur != 0 and ppd.total_time != 0
                       or ppd.total_occur  = 0 and ppd.total_time  = 0 )
             join all_source  src
                  on  src.owner = ppu.unit_owner
                  and src.name  = ppu.unit_name
                  and src.type  = ppu.unit_type
                  and src.line  = ppd.line# + profiler.trigger_offset
                                                         (ppu.unit_owner
                                                         ,ppu.unit_name
                                                         ,ppu.unit_type)
                  and not exists (select 'x' from not_executable ne
                                   where ne.text = src.text        )
       where ppu.unit_owner = g_owner
        and  ppu.unit_name  = g_name
        and  ppu.unit_type  = g_type
        and  ppu.runid      = g_runid;
begin
   if g_name is null
   then
      return;
   end if;
   if g_dbout_profiles_rec.test_run_id is null
   then
      raise_application_error  (-20000, 'g_dbout_profiles_rec.test_run_id is null');
   end if;
   delete from plsql_profiler_data;
   delete from plsql_profiler_units;
   delete from plsql_profiler_runs;
   -- DBMS_PROFILER.FLUSH_DATA is included with DBMS_PROFILER.STOP_PROFILER
   dbms_profiler.STOP_PROFILER;
   for buff in c_main
   loop
      g_dbout_profiles_rec.line#       := buff.line#;
      g_dbout_profiles_rec.text        := buff.text;
      g_dbout_profiles_rec.total_occur := buff.total_occur;
      g_dbout_profiles_rec.total_time  := buff.total_time;
      g_dbout_profiles_rec.min_time    := buff.min_time;
      g_dbout_profiles_rec.max_time    := buff.max_time;
      insert into dbout_profiles values g_dbout_profiles_rec;
   end loop;
   reset_variables;
end finalize;

------------------------------------------------------------
PROCEDURE pause
IS
BEGIN
   if g_name is null
   then
      return;
   end if;
   dbms_profiler.PAUSE_PROFILER;
END pause;

------------------------------------------------------------
PROCEDURE resume
IS
BEGIN
   if g_name is null
   then
      return;
   end if;
   dbms_profiler.RESUME_PROFILER;
END resume;

------------------------------------------------------------
-- Find begining of PL/SQL Block in a Trigger
FUNCTION trigger_offset
      (dout_name_in   in  varchar2
      ,dout_type_in   in  varchar2
      ,dout_owner_in  in  varchar2)
   return number
IS
BEGIN
   if nvl(dout_type_in,'BOGUS') <> 'TRIGGER' then
      return 0;
   end if;
   for buff in (
      select line, text from all_source
       where name  = dout_name_in
        and  type  = dout_type_in
        and  owner = dout_owner_in
      order by line )
   loop
      if regexp_instr(buff.text,
                      '(^declare$' ||
                      '|^declare[[:space:]]' ||
                      '|[[:space:]]declare$' ||
                      '|[[:space:]]declare[[:space:]])', 1, 1, 0, 'i') <> 0
         OR
         regexp_instr(buff.text,
                      '(^begin$' ||
                      '|^begin[[:space:]]' ||
                      '|[[:space:]]begin$' ||
                      '|[[:space:]]begin[[:space:]])', 1, 1, 0, 'i') <> 0 
      then
         return buff.line - 1;
      end if;
   end loop;
   return 0;
END trigger_offset;

------------------------------------------------------------
function calc_pct_coverage
      (in_test_run_id  in  number)
   return number
IS
   coverage_pct        number;
BEGIN
   with q1 as (
   select p.line#
         ,case when (    p.total_occur = 0
                     and p.total_time  = 0) then 0
                                            else 1
          end                  hit
    from  dbout_profiles  p
   )
   select 100 * nvl(sum(hit),0) /
          case count(line#) when 0 then 1
                                   else count(line#)
          end
    into  coverage_pct
    from  q1;
   return coverage_pct;
END calc_pct_coverage;

end profiler;
