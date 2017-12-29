create or replace package body profiler
as

   TYPE rec_type is record
      (test_run_id     test_runs.id%TYPE
      ,owner           test_runs.dbout_owner%TYPE
      ,name            test_runs.dbout_name%TYPE
      ,type            test_runs.dbout_type%TYPE
      ,prof_runid      binary_integer
      ,error_message   varchar2(4000));
   g_rec  rec_type;

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
procedure reset_g_rec
is
   l_rec_NULL  rec_type;
begin
   g_rec := l_rec_NULL;
end reset_g_rec;

------------------------------------------------------------
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
      select src.text
       from  user_source  src
             join test_runs  tr
                  on  tr.runner_name = src.name
                  and tr.id          = g_rec.test_run_id
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
        into g_rec.owner
            ,g_rec.name
            ,g_rec.type
       from  all_objects
       where owner        = nvl(substr(target,1,pos-1),USER)
        and  object_name  = substr(target,pos+1,256);
   exception when NO_DATA_FOUND
   then
      g_rec.error_message := 'Unable to find Database Object "' || target || '". ';
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
   reset_g_rec;
   g_rec.test_run_id := in_test_run_id;
   find_dbout;
   update test_runs
     set  dbout_owner   = g_rec.owner
         ,dbout_name    = g_rec.name
         ,dbout_type    = g_rec.type
         ,error_message = substr(error_message || g_rec.error_message, 1, 4000)
    where id = g_rec.test_run_id;
   if g_rec.name is not null
   then
      retnum := dbms_profiler.INTERNAL_VERSION_CHECK;
      if retnum <> 0 then
         raise_application_error(-20000,
            'dbms_profiler.INTERNAL_VERSION_CHECK returned: ' || get_error_msg(retnum));
      end if;
      -- This starts the PROFILER Running!!!
      retnum := dbms_profiler.START_PROFILER(run_number => g_rec.prof_runid);
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
      select g_rec.test_run_id              TEST_RUN_ID
            ,ppd.line#
            ,case
             when ne.text is not null
             then
                  'EXCL'
             when    ppd.total_occur != 0 and ppd.total_time != 0
                  or ppd.total_occur  = 0 and ppd.total_time  = 0
             then
                  'MISS'
             else
                  'HIT'
             end                            STATUS
            ,src.text
            ,sum(ppd.total_occur)           TOTAL_OCCUR
            ,sum(ppd.total_time)            TOTAL_TIME
            ,min(ppd.min_time)              MIN_TIME
            ,max(ppd.max_time)              MAX_TIME
       from  plsql_profiler_units ppu
             join plsql_profiler_data  ppd
                  on  ppd.unit_number = ppu.unit_number
                  and ppd.runid       = ppu.runid
             join all_source  src
                  on  src.owner = ppu.unit_owner
                  and src.name  = ppu.unit_name
                  and src.type  = ppu.unit_type
                  and (   (    ppu.unit_type != 'TRIGGER'
                           and src.line       = ppd.line#)
                       OR (    ppu.unit_type = 'TRIGGER'
                           and src.line      = ppd.line# + profiler.trigger_offset
                                                              (ppu.unit_owner
                                                              ,ppu.unit_name
                                                              ,ppu.unit_type) ) )
        left join not_executable ne
                  on  ne.text = src.text
       where ppu.unit_owner = g_rec.owner
        and  ppu.unit_name  = g_rec.name
        and  ppu.unit_type  = g_rec.type
        and  ppu.runid      = g_rec.prof_runid;
begin
   if g_rec.name is null
   then
      return;
   end if;
   if g_rec.test_run_id is null
   then
      raise_application_error  (-20000, 'g_rec.test_run_id is null');
   end if;
   delete from plsql_profiler_data;
   delete from plsql_profiler_units;
   delete from plsql_profiler_runs;
   -- DBMS_PROFILER.FLUSH_DATA is included with DBMS_PROFILER.STOP_PROFILER
   dbms_profiler.STOP_PROFILER;
   for buff in c_main
   loop
      insert into dbout_profiles values buff;
   end loop;
   reset_g_rec;
end finalize;

------------------------------------------------------------
PROCEDURE pause
IS
BEGIN
   if g_rec.name is null
   then
      return;
   end if;
   dbms_profiler.PAUSE_PROFILER;
END pause;

------------------------------------------------------------
PROCEDURE resume
IS
BEGIN
   if g_rec.name is null
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
