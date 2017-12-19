create or replace package body profiler
as

   g_owner       test_runs.dbout_owner%TYPE;
   g_name        test_runs.dbout_name%TYPE;
   g_type        test_runs.dbout_type%TYPE;

----------------------
--  Private Procedures
----------------------

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
        into g_owner
            ,g_name
            ,g_type
       from  all_objects
       where owner        = nvl(substr(target,1,pos-1),USER)
        and  object_name  = substr(target,pos+1,256);
   exception when NO_DATA_FOUND then return;
   end;
end find_dbout;

---------------------
--  Public Procedures
---------------------

procedure initialize
      (in_test_run_id  in  number)
is
begin
   g_owner := NULL;
   g_name  := NULL;
   g_type  := NULL;
   if in_test_run_id is null
   then
      raise_application_error  (-20000, 'i_test_run_id is null');
   end if;
   find_dbout(in_test_run_id);
   if g_name is not null
   then
      update test_runs
        set  dbout_owner = g_owner
            ,dbout_name  = g_name
            ,dbout_type  = g_type
       where id = in_test_run_id;
   end if;
end initialize;

procedure finalize
is
begin
   null;
end finalize;

end profiler;
