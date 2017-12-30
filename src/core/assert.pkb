create or replace package body assert is

   -- See RESET_GLOBALS procedure for default global values

----------------------
--  Private Procedures
----------------------

/*
------------------------------------------------------------
function find_obj (check_this_in in varchar2)
   return boolean
is
   v_st         varchar2 (20);
   v_err        varchar2 (100);
   v_schema     varchar2 (100);
   v_obj_name   varchar2 (100);
   v_point      number           := instr (check_this_in, '.');
   v_state      boolean          := false ;
   v_val        varchar2 (30);
   cursor c_obj is
      select object_name
        from all_objects
       where object_name = upper (v_obj_name)
         and owner = upper (v_schema);
begin
   if v_point = 0 then
      v_schema := user;
      v_obj_name := check_this_in;
   else
      v_schema := substr(check_this_in, 0, (v_point-1));
      v_obj_name := substr(check_this_in, (v_point+1));
   end if;
   open c_obj;
   fetch c_obj into v_val;
   if c_obj%found then
      v_state := true ;
   else
      v_state := false ;
   end if;
   close c_obj;
   return v_state;
exception
   when others then
      return false ;
end find_obj;
*/

------------------------------------------------------------
procedure process_assertion
is
begin
   result.save
      (in_assertion      => g_last_assert
      ,in_status         => case g_last_pass when TRUE then 'PASS'
                                                       else 'FAIL'
                            end
      ,in_details        => g_last_details
      ,in_testcase       => g_testcase
      ,in_message        => g_last_msg
      ,in_error_message  => g_last_error);
   if g_raise_exception and not g_last_pass
   then
      raise_application_error(-20000, '');
   end if;
end process_assertion;

---------------------
--  Public Procedures
---------------------

procedure this (
      msg_in          in   varchar2,
      check_this_in   in   boolean,
      null_ok_in      in   boolean := false)
is
begin
   g_last_assert  := 'this';
   g_last_msg     := msg_in;
   g_last_pass    := check_this_in;
   g_last_details := 'Expected "TRUE" and got "' ||
                      case check_this_in
                         when TRUE  then 'TRUE'
                         when FALSE then 'FALSE'
                                    else ''
                         end || '"';
   g_last_error   := '';
   process_assertion;
end this;

------------------------------------------------------------
-- string inputs overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   varchar2,
   against_this_in   in   varchar2,
   null_ok_in        in   boolean := false)
is
begin
   g_last_assert  := 'eq';
   g_last_msg     := msg_in;
   g_last_pass    := (   nvl(check_this_in = against_this_in, false)
                      or (    check_this_in is null
                          and against_this_in is null
                          and null_ok_in              )
                     );
   g_last_details := 'Expected "'  || against_this_in ||
                     '" and got "' || check_this_in   ||
                     '"';
   g_last_error   := '';
   process_assertion;
end eq;

------------------------------------------------------------
-- boolean inputs overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   boolean,
   against_this_in   in   boolean,
   null_ok_in        in   boolean := false)
is
begin
   eq (msg_in           => msg_in
      ,check_this_in    => case check_this_in
                              when TRUE  then 'TRUE'
                              when FALSE then 'FALSE'
                                         else ''
                              end
      ,against_this_in  => case against_this_in
                              when TRUE  then 'TRUE'
                              when FALSE then 'FALSE'
                                         else ''
                              end
      ,null_ok_in       => null_ok_in);
end eq;

------------------------------------------------------------
-- date inputs overload
procedure eq (
   msg_in            in   varchar2,
   check_this_in     in   date,
   against_this_in   in   date,
   null_ok_in        in   boolean := false)
is
begin
   eq (msg_in           => msg_in
      ,check_this_in    => to_char(check_this_in, g_date_format)
      ,against_this_in  => to_char(against_this_in, g_date_format)
      ,null_ok_in       => null_ok_in);
end eq;

------------------------------------------------------------
-- string version
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2)
is
begin
   g_last_assert  := 'isnotnull';
   g_last_msg     := msg_in;
   g_last_pass    := (check_this_in is not null);
   g_last_details := 'Expected NOT NULL and got "' ||
                      check_this_in || '"';
   g_last_error   := '';
   process_assertion;
end isnotnull;

------------------------------------------------------------
-- string version
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   varchar2)
is
begin
   g_last_assert  := 'isnull';
   g_last_msg     := msg_in;
   g_last_pass    := (check_this_in is null);
   g_last_details := 'Expected NULL and got "' ||
                      check_this_in || '"';
   g_last_error   := '';
   process_assertion;
end isnull;

------------------------------------------------------------
-- boolean version
procedure isnotnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnotnull (msg_in        => msg_in
             ,check_this_in => case check_this_in
                                  when TRUE  then 'TRUE'
                                  when FALSE then 'FALSE'
                                             else ''
                                  end);
end isnotnull;

------------------------------------------------------------
-- boolean version
procedure isnull (
   msg_in          in   varchar2,
   check_this_in   in   boolean)
is
begin
   isnull (msg_in        => msg_in
          ,check_this_in => case check_this_in
                               when TRUE  then 'TRUE'
                               when FALSE then 'FALSE'
                                          else ''
                               end);
end isnull;

/*
------------------------------------------------------------
--
procedure eqquery (
   msg_in            in   varchar2,
   check_this_in     in   varchar2,
   against_this_in   in   varchar2,
   raise_exc_in      in   boolean := false )
is
   l_assert_name      varchar2(20) := 'eqquery';
   -- user passes in two select statements. use nds to minus them.
   ival   pls_integer;
   m1  varchar2(32767);
begin
   -- build message 1
   m1 := 'result set for "' || check_this_in     ||
                   ' does ' || c_not_placeholder ||
          'match that of "' || against_this_in   || '"';
   ieqminus (
      assert_name_in    => l_assert_name,
      msg_in            => msg_in,
      assert_details_in => message(m1),
      query1_in         => check_this_in,
      query2_in         => against_this_in,
      raise_exc_in      => raise_exc_in);
end eqquery;

------------------------------------------------------------
-- check a query against a single varchar2 value overload
procedure eqqueryvalue (
   msg_in             in   varchar2,
   check_query_in     in   varchar2,
   against_value_in   in   varchar2,
   null_ok_in         in   boolean := false ,
   raise_exc_in       in   boolean := false )
is
   l_assert_name  varchar2(20) := 'eqqueryvalue';
   l_value        varchar2 (2000);
   l_success      boolean;
   type cv_t is ref cursor;
   cv   cv_t;
   m1   varchar2(32767);
begin
   open cv for check_query_in;
   fetch cv into l_value;
   close cv;
   l_success :=    l_value = against_value_in
                or (    l_value is null
                    and against_value_in is null
                    and null_ok_in             );
   -- build message 1
   m1 := 'query "' || check_query_in || '" returned value "' ||
                             l_value || '" that does ';
   if l_success then
      m1 := m1 || 'match "' || against_value_in || '"';
   else
      m1 := m1 || 'not match "' || against_value_in || '"';
   end if;
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => l_success,
      msg_in            => msg_in,
      assert_details_in => m1,
      null_ok_in        => false,
      raise_exc_in      => raise_exc_in);
   -- for now ignore this condition.
   -- how do we handle two assertions inside a single assertion call?
   --        this (msg_in ||
   --           ''' || ''; got multiple values'',
   --                       check_this_in => false,
   --                       raise_exc_in => ' ||
   --           b2v (raise_exc_in) ||
   --           ');
end eqqueryvalue;

------------------------------------------------------------
-- check a query against a single date value overload
procedure eqqueryvalue (
   msg_in             in   varchar2,
   check_query_in     in   varchar2,
   against_value_in   in   date,
   null_ok_in         in   boolean := false ,
   raise_exc_in       in   boolean := false )
is
   l_assert_name  varchar2(20) := 'eqqueryvalue';
   l_value        date;
   l_success      boolean;
   type cv_t is ref cursor;
   cv   cv_t;
   m1   varchar2(32767);
begin
   open cv for check_query_in;
   fetch cv into l_value;
   close cv;
   l_success :=    (l_value = against_value_in)
                or (    l_value is null
                    and against_value_in is null
                    and null_ok_in             );
   -- build message 1
   m1 := 'query "' || check_query_in || '" returned value "' ||
          to_char(l_value,'dd-mon-yyyy hh24:mi:ss') || '" that does ';
   if l_success then
      m1 := m1 || 'match "';
   else
      m1 := m1 || 'not match "';
   end if;
   m1 := m1 || to_char(against_value_in, 'dd-mon-yyyy hh24:mi:ss') || '"';
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => l_success,
      msg_in            => msg_in,
      assert_details_in => m1,
      null_ok_in        => false,
      raise_exc_in      => raise_exc_in);
   -- for now ignore this condition.
   -- how do we handle two assertions inside a single assertion call?
   --        this (msg_in ||
   --           ''' || ''; got multiple values'',
   --                       check_this_in => false,
   --                       raise_exc_in => ' ||
   --           b2v (raise_exc_in) ||
   --           ');
end eqqueryvalue;

------------------------------------------------------------
-- check a query against a single number value overload
procedure eqqueryvalue (
   msg_in             in   varchar2,
   check_query_in     in   varchar2,
   against_value_in   in   number,
   null_ok_in         in   boolean := false ,
   raise_exc_in       in   boolean := false )
is
   l_assert_name  varchar2(20) := 'eqqueryvalue';
   l_value        number;
   l_success      boolean;
   type cv_t is ref cursor;
   cv   cv_t;
   m1   varchar2(32767);
begin
   open cv for check_query_in;
   fetch cv into l_value;
   close cv;
   l_success :=    (l_value = against_value_in)
                or (    l_value is null
                    and against_value_in is null
                    and null_ok_in            );
   -- build message 1
   m1 := 'query "' || check_query_in || '" returned value "' ||
                             l_value || '" that does ';
   if l_success then
      m1 := m1 || 'match "' || against_value_in || '"';
   else
      m1 := m1 || 'not match "' || against_value_in || '"';
   end if;
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => l_success,
      msg_in            => msg_in,
      assert_details_in => m1,
      null_ok_in        => false,
      raise_exc_in      => raise_exc_in);
   -- for now ignore this condition.
   -- how do we handle two assertions inside a single assertion call?
   --        this (msg_in ||
   --           ''' || ''; got multiple values'',
   --                       check_this_in => false,
   --                       raise_exc_in => ' ||
   --           b2v (raise_exc_in) ||
   --           ');
end eqqueryvalue;

------------------------------------------------------------
-- check a given call throws a named exception overload
procedure raises (
   msg_in                varchar2,
   check_call_in    in   varchar2,
   against_exc_in   in   varchar2 )
is
   l_assert_name        varchar2(20)     := 'raises';
   expected_indicator   pls_integer      := 1000;
   l_indicator          pls_integer;
   v_block              varchar2 (32767) :=
'begin
' || rtrim (rtrim (check_call_in), ';') || ';
:indicator := 0;
exception
when ' || against_exc_in || ' then
   :indicator := ' || expected_indicator || ';
when others then :indicator := sqlcode;
end;';
   m1  varchar2(32767);
begin
   --fire off the dynamic pl/sql
   execute immediate v_block using  out l_indicator;
   -- build message 1
   if not nvl(l_indicator = expected_indicator, false) then
      m1 := 'block "' || check_call_in ||
            '" does not raise exception "' || against_exc_in;
   else
      m1 := 'block "' || check_call_in ||
            '" raises exception "' || against_exc_in;
   end if;
   if l_indicator = expected_indicator then
      m1 := m1 || '';
   else
      m1 := m1 || '. instead it raises sqlcode = ' || l_indicator || '.';
   end if;
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => l_indicator = expected_indicator,
      msg_in            => msg_in,
      assert_details_in => message(m1),
      null_ok_in        => false);
end raises;

------------------------------------------------------------
--check a given call throws an exception with a given sqlcode overload
procedure raises (
   msg_in                varchar2,
   check_call_in    in   varchar2,
   against_exc_in   in   number  )
is
   l_assert_name        varchar2(20)     := 'raises';
   expected_indicator   pls_integer      := 1000;
   l_indicator          pls_integer;
   v_block              varchar2 (32767) :=
'begin
   ' || rtrim (rtrim (check_call_in), ';') || ';
   :indicator := 0;
exception
   when others then
      if sqlcode = ' || against_exc_in || ' then
         :indicator := ' || expected_indicator || ';
      else
         :indicator := sqlcode;
      end if;
end;';
   m1  varchar2(32767);
begin
   --fire off the dynamic pl/sql
   execute immediate v_block using  out l_indicator;
   -- build message 1
   if not nvl(l_indicator = expected_indicator, false) then
      m1 := 'block "' || check_call_in ||
            '" does not raise exception "' || against_exc_in;
   else
      m1 := 'block "' || check_call_in ||
            '" raises exception "' || against_exc_in;
   end if;
   if l_indicator = expected_indicator then
      m1 := m1 || '';
   else
      m1 := m1 || '. instead it raises sqlcode = ' || l_indicator || '.';
   end if;
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => l_indicator = expected_indicator,
      msg_in            => msg_in,
      assert_details_in => message(m1),
      null_ok_in        => false);
end raises;

------------------------------------------------------------
-- check a given call throws a named exception overload
procedure throws (
   msg_in                varchar2,
   check_call_in    in   varchar2,
   against_exc_in   in   varchar2 )
is
begin
   raises (
      msg_in,
      check_call_in,
      against_exc_in );
end throws;

------------------------------------------------------------
-- check a given call throws an exception with a given sqlcode overload
procedure throws (
   msg_in                varchar2,
   check_call_in    in   varchar2,
   against_exc_in   in   number )
is
begin
   raises (
      msg_in,
      check_call_in,
      against_exc_in );
end throws;

------------------------------------------------------------
--
procedure objexists (
   msg_in          in   varchar2,
   check_this_in   in   varchar2,
   null_ok_in      in   boolean := false ,
   raise_exc_in    in   boolean := false )
is
begin
   this (
      message(value_in   => 'this object exists',
              premsg_in  => check_this_in),
      message(value_in   => 'this object does not exist',
              premsg_in  => check_this_in),
      find_obj (check_this_in),
      null_ok_in,
      raise_exc_in,
      true );
end objexists;

------------------------------------------------------------
--
procedure objnotexists (
   msg_in          in   varchar2,
   check_this_in   in   varchar2,
   null_ok_in      in   boolean := false ,
   raise_exc_in    in   boolean := false )
is
begin
   this (
      message(value_in   => 'this object does not exist',
              premsg_in  => check_this_in),
      message(value_in   => 'this object exists',
              premsg_in  => check_this_in),
      not find_obj(check_this_in),
      null_ok_in,
      raise_exc_in,
      true );
end objnotexists;

------------------------------------------------------------
-- character array version overload
procedure eqoutput (
   msg_in                in   varchar2,
   check_this_in         in   dbms_output.chararr,                     
   against_this_in       in   dbms_output.chararr,
   ignore_case_in        in   boolean := false,
   ignore_whitespace_in  in   boolean := false,
   null_ok_in            in   boolean := true,
   raise_exc_in          in   boolean := false )
is
   l_assert_name      varchar2(20) := 'eqoutput';
   whitespace   constant char(5) := '!'||chr(9)||chr(10)||chr(13)||chr(32);
   nowhitespace constant char(1) := '!';
   v_check_index     binary_integer;
   v_against_index   binary_integer;
   v_message         varchar2(1000);
   v_line1           varchar2(1000);      
   v_line2           varchar2(1000);
   function preview_line (line_in varchar2) 
      return varchar2
   is
   begin
     if length(line_in) <= 100 then
       return line_in;
     else
       return substr(line_in, 1, 97) || '...';
     end if;
   end preview_line;
begin
   v_check_index := check_this_in.first;
   v_against_index := against_this_in.first;
   while v_check_index is not null and
         v_against_index is not null and
         v_message is null
   loop
      v_line1 := check_this_in(v_check_index);
      v_line2 := against_this_in(v_against_index);
      if ignore_case_in then
        v_line1 := upper(v_line1);
        v_line2 := upper(v_line2);
      end if;
      if ignore_whitespace_in then
        v_line1 := translate(v_line1, whitespace, nowhitespace);
        v_line2 := translate(v_line2, whitespace, nowhitespace);
      end if;
      if (nvl (v_line1 <> v_line2, not null_ok_in)) then
        v_message := message_expected (
                        expected_in => preview_line(check_this_in(v_check_index)),
                        and_got_in  => preview_line(against_this_in(v_against_index)) ) ||
            ' (comparing line ' || v_check_index || 
            ' of tested collection against line ' || v_against_index ||
            ' of reference collection)';
      end if;
      v_check_index := check_this_in.next(v_check_index);
      v_against_index := against_this_in.next(v_against_index);
   end loop;
   if v_message is null then
      if v_check_index is null and v_against_index is not null then
         v_message := message('extra line found at end of reference collection: ' || 
                               preview_line(against_this_in(v_against_index))     );
      elsif v_check_index is not null and v_against_index is null then
         v_message := message('extra line found at end of tested collection: ' || 
                               preview_line(check_this_in(v_check_index))      );
      end if;
   end if;
   report (
      assert_name_in    => l_assert_name,
      check_this_in     => v_message is null,
      msg_in            => msg_in,
      assert_details_in => nvl(v_message, message('collections match')),
      null_ok_in        => false,
      raise_exc_in      => raise_exc_in);
end eqoutput;

------------------------------------------------------------
-- string & delimiter version overload
procedure eqoutput (
   msg_in                in   varchar2,
   check_this_in         in   dbms_output.chararr,                     
   against_this_in       in   varchar2,
   line_delimiter_in     in   char := null,
   ignore_case_in        in   boolean := false,
   ignore_whitespace_in  in   boolean := false,
   null_ok_in            in   boolean := true,
   raise_exc_in          in   boolean := false
)
is
   l_buffer        dbms_output.chararr;
   l_against_this  varchar2(2000) := against_this_in;
   l_delimiter_pos binary_integer; 
begin
   if line_delimiter_in is null then
      l_against_this := replace(l_against_this, chr(13)||chr(10), chr(10));
   end if;
   while l_against_this is not null loop
      l_delimiter_pos := instr(l_against_this, nvl(line_delimiter_in, chr(10)));
      if l_delimiter_pos = 0 then
         l_buffer(l_buffer.count) := l_against_this;
         l_against_this := null;
      else
         l_buffer(l_buffer.count) := substr(l_against_this, 1, l_delimiter_pos - 1);
         l_against_this := substr(l_against_this, l_delimiter_pos + 1);
         --handle case of delimiter at end
         if l_against_this is null then
            l_buffer(l_buffer.count) := null;
         end if;
      end if;
   end loop;
   eqoutput(
      msg_in,
      check_this_in,                     
      l_buffer,
      ignore_case_in,
      ignore_whitespace_in,
      null_ok_in,
      raise_exc_in ); 
end eqoutput;
*/

------------------------------------------------------------
procedure reset_globals
is
begin
   g_raise_exception := FALSE;
   g_testcase        := '';
   g_last_pass       := NULL;
   g_last_assert     := '';
   g_last_msg        := '';
   g_last_details    := '';
   g_last_error      := '';
   g_date_format     := 'DD-MON-YYYY HH24:MI:SS';
   g_tstamp_format   := 'DD-MON-YYYY HH24:MI:SS.F9';
   g_tstamp_tz_fmt   := 'DD-MON-YYYY HH24:MI:SS.F9 TZH:TZM';
end reset_globals;

begin

   reset_globals;

end assert;
/
