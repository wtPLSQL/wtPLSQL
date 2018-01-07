create or replace package body wt_profiler
as

   TYPE rec_type is record
      (test_run_id     wt_test_runs.id%TYPE
      ,dbout_owner     wt_test_runs.dbout_owner%TYPE
      ,dbout_name      wt_test_runs.dbout_name%TYPE
      ,dbout_type      wt_test_runs.dbout_type%TYPE
      ,prof_runid      binary_integer
      ,trigger_offset  binary_integer
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
procedure delete_plsql_profiler_recs
is
begin
   delete from plsql_profiler_data;
   delete from plsql_profiler_units;
   delete from plsql_profiler_runs;
end delete_plsql_profiler_recs;

------------------------------------------------------------
procedure reset_g_rec
is
   l_rec_NULL  rec_type;
begin
   g_rec := l_rec_NULL;
end reset_g_rec;

------------------------------------------------------------
procedure find_dbout
      (in_pkg_name  in  varchar2)
is

   C_HEAD_RE CONSTANT varchar2(30) := '--% WTPLSQL SET DBOUT "';
   C_MAIN_RE CONSTANT varchar2(30) := '[[:alnum:]._$#]+';
   C_TAIL_RE CONSTANT varchar2(30) := '" %--';
   --
   -- Head Regular Expression is
   --   '--% WTPLSQL SET DBOUT "' - literal string
   -- Main Regular Expression is
   --   '[[:alnum:]._$#]'         - Any alpha, numeric, ".", "_", "$", or "#" character
   --   +                         - One or more of the previous characters
   -- Tail Regular Expression is
   --   '" %--'                   - literal string
   --
   -- Note: Packages, Procedure, Functions, and Types are in the same namespace
   --       and cannot have the same names.  However, Triggers can have the same
   --       name as any of the other objects.  Results are unknown if a Trigger
   --       name is the same as a Package, Procedure, Function or Type name.
   --
   cursor c_annotation is
      select regexp_substr(src.text, C_HEAD_RE||C_MAIN_RE||C_TAIL_RE)  TEXT
       from  user_source  src
       where src.name = in_pkg_name
        and  src.type = 'PACKAGE BODY'
        and  regexp_like(src.text, C_HEAD_RE||C_MAIN_RE||C_TAIL_RE)
       order by src.line;
   target        varchar2(32000);
   pos           number;

begin

   open c_annotation;
   fetch c_annotation into target;
   if c_annotation%NOTFOUND
   then
      close c_annotation;
      return;
   end if;
   close c_annotation;

   -- Strip the Head Sub-String
   target := regexp_replace(SRCSTR      => target
                           ,PATTERN     => '^' || C_HEAD_RE
                           ,REPLACESTR  => ''
                           ,POSITION    => 1
                           ,OCCURRENCE  => 1);
   -- Strip the Tail Sub-String
   target := regexp_replace(SRCSTR      => target
                           ,PATTERN     => C_TAIL_RE || '$'
                           ,REPLACESTR  => ''
                           ,POSITION    => 1
                           ,OCCURRENCE  => 1);

   -- Locate the Owner/Name separator
   pos := instr(target,'.');
   begin
      select obj.owner
            ,obj.object_name
            ,obj.object_type
        into g_rec.dbout_owner
            ,g_rec.dbout_name
            ,g_rec.dbout_type
       from  all_objects  obj
       where obj.object_type in ('FUNCTION', 'PROCEDURE', 'PACKAGE BODY',
                                 'TYPE BODY', 'TRIGGER')
        and  (   (    pos = 0
                  and obj.owner       = USER
                  and obj.object_name = target  )
              OR (    pos = 1
                  and obj.owner       = USER
                  and obj.object_name = substr(target,2,512) )
              OR (    pos > 1
                  and obj.owner       = substr(target,1,pos-1)
                  and obj.object_name = substr(target,pos+1,512) ) )
        and  exists (
             select 'x' from all_source src
              where src.owner  = obj.owner
               and  src.name   = obj.object_name
               and  src.type   = obj.object_type );
   exception when NO_DATA_FOUND
   then
      g_rec.error_message := 'Unable to find Database Object "' ||
                              target || '". ';
   end;

end find_dbout;

------------------------------------------------------------
procedure insert_dbout_profile
is
begin
   insert into wt_dbout_profiles
      with q1 as (
      select src.line
            ,case
             when ne.text is not null           then 'EXCL'
             when     ppd.total_occur = 0
                  and ppd.total_time  = 0       then 'NOTX'
             when    (    ppd.total_occur  = 0
                      and ppd.total_time != 0 )
                  or (    ppd.total_occur != 0
                      and ppd.total_time  = 0 ) then 'UNKN'
                                                else 'EXEC'
             end                STATUS
            ,ppd.total_occur
            ,ppd.total_time
            ,ppd.min_time
            ,ppd.max_time
            ,src.text
       from  plsql_profiler_units ppu
             join plsql_profiler_data  ppd
                  on  ppd.unit_number = ppu.unit_number
                  and ppd.runid       = g_rec.prof_runid
             join all_source  src
                  on  src.line  = ppd.line# + g_rec.trigger_offset
                  and src.owner = g_rec.dbout_owner
                  and src.name  = g_rec.dbout_name
                  and src.type  = g_rec.dbout_type
        left join wt_not_executable ne
                  on  ne.text = src.text
       where ppu.unit_owner = g_rec.dbout_owner
        and  ppu.unit_name  = g_rec.dbout_name
        and  ppu.unit_type  = g_rec.dbout_type
        and  ppu.runid      = g_rec.prof_runid
      )
      select g_rec.test_run_id
            ,line
            ,status
            ,sum(total_occur)   TOTAL_OCCUR
            ,sum(total_time)    TOTAL_TIME
            ,min(min_time)      MIN_TIME
            ,max(max_time)      MAX_TIME
            ,text
       from q1
       group by line
            ,status
            ,text;
end insert_dbout_profile;

------------------------------------------------------------
procedure update_anno_status
is

   cursor c_find_begin is
      select line
            ,instr(text,'--%WTPLSQL_begin_ignore_lines%--') col
       from  all_source
       where owner = g_rec.dbout_owner
        and  name  = g_rec.dbout_name
        and  type  = g_rec.dbout_type
        and  text like '%--\%WTPLSQL_begin_ignore_lines\%--%' escape '\'
       order by line;
   buff_begin  c_find_begin%ROWTYPE;

   cursor c_find_end (in_line in number, in_col in number) is
      with q1 as (
      select line
            ,instr(text,'--%WTPLSQL_end_ignore_lines%--') col
       from  all_source
       where owner = g_rec.dbout_owner
        and  name  = g_rec.dbout_name
        and  type  = g_rec.dbout_type
        and  line >= in_line
        and  text like '%--\%WTPLSQL_end_ignore_lines\%--%' escape '\'
      )
      select line
            ,col
       from  q1
       where line > in_line
          or (    line = in_line
              and col  > in_col)
       order by line
            ,col;
   buff_end  c_find_end%ROWTYPE;

begin

   open c_find_begin;
   loop
      fetch c_find_begin into buff_begin;

      exit when c_find_begin%NOTFOUND;

      open c_find_end (buff_begin.line, buff_begin.col);
      fetch c_find_end into buff_end;
      if c_find_end%NOTFOUND
      then
         buff_end.line := NULL;
      end if;
      close c_find_end;

      update wt_dbout_profiles
        set  status = 'ANNO'
       where test_run_id = g_rec.test_run_id
        and  line >= buff_begin.line + g_rec.trigger_offset
        and  (   buff_end.line is NULL
              OR line <= buff_end.line + g_rec.trigger_offset );

      exit when buff_end.line is NULL;

   end loop;
   close c_find_begin;

end update_anno_status;


---------------------
--  Public Procedures
---------------------

------------------------------------------------------------
function get_dbout_owner
   return wt_test_runs.dbout_owner%TYPE
is
begin
   return g_rec.dbout_owner;
end get_dbout_owner;

------------------------------------------------------------
function get_dbout_name
   return wt_test_runs.dbout_name%TYPE
is
begin
   return g_rec.dbout_name;
end get_dbout_name;

------------------------------------------------------------
function get_dbout_type
   return wt_test_runs.dbout_type%TYPE
is
begin
   return g_rec.dbout_type;
end get_dbout_type;

------------------------------------------------------------
procedure initialize
      (in_test_run_id      in  number,
       in_runner_name      in  varchar2,
       out_dbout_owner     out varchar2,
       out_dbout_name      out varchar2,
       out_dbout_type      out varchar2,
       out_trigger_offset  out number,
       out_profiler_runid  out number)
is

   retnum       binary_integer;

begin

   out_dbout_owner := NULL;
   out_dbout_name  := NULL;
   out_dbout_type  := NULL;

   if in_test_run_id is null
   then
      raise_application_error  (-20000, 'i_test_run_id is null');
   end if;

   reset_g_rec;
   g_rec.test_run_id := in_test_run_id;

   find_dbout(in_pkg_name => in_runner_name);
   if g_rec.dbout_name is null
   then
      return;
   end if;
   out_dbout_owner    := g_rec.dbout_owner;
   out_dbout_name     := g_rec.dbout_name;
   out_dbout_type     := g_rec.dbout_type;
 
   g_rec.trigger_offset := wt_profiler.trigger_offset
                              (dbout_owner_in => g_rec.dbout_owner
                              ,dbout_name_in  => g_rec.dbout_name
                              ,dbout_type_in  => g_rec.dbout_type );
   out_trigger_offset := g_rec.trigger_offset;

   delete_plsql_profiler_recs;
   
   retnum := dbms_profiler.INTERNAL_VERSION_CHECK;
   if retnum <> 0 then
      --dbms_profiler.get_version(major_version, minor_version);
      raise_application_error(-20000,
         'dbms_profiler.INTERNAL_VERSION_CHECK returned: ' || get_error_msg(retnum));
   end if;
   -- This starts the PROFILER Running!!!
   retnum := dbms_profiler.START_PROFILER(run_number => g_rec.prof_runid);
   if retnum <> 0 then
      raise_application_error(-20000,
         'dbms_profiler.START_PROFILER returned: ' || get_error_msg(retnum));
   end if;
   out_profiler_runid := g_rec.prof_runid;

end initialize;

------------------------------------------------------------
-- Because this procedure is called to cleanup after erorrs,
--  it must be able to run multiple times without causing damage.
procedure finalize
is
begin

   if g_rec.dbout_name is null
   then
      return;
   end if;
   if g_rec.test_run_id is null
   then
      raise_application_error  (-20000, 'g_rec.test_run_id is null');
   end if;

   -- DBMS_PROFILER.FLUSH_DATA is included with DBMS_PROFILER.STOP_PROFILER
   dbms_profiler.STOP_PROFILER;

   insert_dbout_profile;

   update_anno_status;

   reset_g_rec;

end finalize;

------------------------------------------------------------
PROCEDURE pause
IS
BEGIN
   if g_rec.dbout_name is null
   then
      return;
   end if;
   dbms_profiler.PAUSE_PROFILER;
END pause;

------------------------------------------------------------
PROCEDURE resume
IS
BEGIN
   if g_rec.dbout_name is null
   then
      return;
   end if;
   dbms_profiler.RESUME_PROFILER;
END resume;

------------------------------------------------------------
-- Find begining of PL/SQL Block in a Trigger
function trigger_offset
      (dbout_owner_in  in  varchar2
      ,dbout_name_in   in  varchar2
      ,dbout_type_in   in  varchar2)
   return number
is
begin
   if dbout_type_in != 'TRIGGER'
   then
      return 0;
   end if;
   for buff in (
      select line, text from all_source
       where owner = dbout_owner_in
        and  name  = dbout_name_in
        and  type  = 'TRIGGER'
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
end trigger_offset;

------------------------------------------------------------
function calc_pct_coverage
      (in_test_run_id  in  number)
   return number
IS
BEGIN
   for buff in (
      select sum(case status when 'EXEC' then 1 else 0 end)    HITS
            ,sum(case status when 'NOTX' then 1 else 0 end)    MISSES
       from  wt_dbout_profiles  p
       where test_run_id = in_test_run_id  )
   loop
      if buff.hits + buff.misses = 0
      then
         return -1;
      else
         return round(100 * buff.hits / (buff.hits + buff.misses),2);
      end if;
   end loop;
   return null;
END calc_pct_coverage;

------------------------------------------------------------
procedure clear_tables
IS
BEGIN
   delete from wt_dbout_profiles;
   delete_plsql_profiler_recs;
END clear_tables;

end wt_profiler;
