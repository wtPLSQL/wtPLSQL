
--
-- Update Non-Identity SEQUENCES
--
-- Command Line Parmeters
--  1 - Table Owner
--  2 - Table Name
--  3 - Table Column Name
--  4 - Sequence Name
--  5 - Sequence Owner (optional)
--

declare
   UNDEFINED_SEQUENCE  EXCEPTION;  -- sequence not yet defined in this session
   PRAGMA EXCEPTION_INIT (UNDEFINED_SEQUENCE, -8002);
   l_tab_owner   varchar2(256) := '&1.';
   l_tab_name    varchar2(256) := '&2.';
   l_tab_column  varchar2(256) := '&3.';
   l_seq_name    varchar2(256) := '&4.';
   l_seq_owner   varchar2(256) := nvl('&5.', '&1.');
   l_last_seq    number;
   l_max_val     number;
   sql_txt       varchar2(4000);
begin
   -- Find the Current Sequence Value
   sql_txt := 'select "' || l_seq_owner || '"."' || l_seq_name || '".currval from dual';
   begin
      execute immediate sql_txt into l_last_seq;
   exception when UNDEFINED_SEQUENCE
   then
      -- Find the Last Number for the Sequence
      select last_number into l_last_seq
       from  dba_sequences
       where sequence_owner = l_seq_owner
        and  sequence_name  = l_seq_name;
   end;
   -- Find the maximum IDENTITY column value
   sql_txt := 'select max("' || l_tab_column || '") from "' || l_tab_owner || '"."' || l_tab_name || '"';
   execute immediate sql_txt into l_max_val;
   -- Display values found
   dbms_output.put_line(l_seq_owner || '.' || l_seq_name || ' Last Sequence: ' || l_last_seq ||
                ', ' || l_tab_owner || '.' || l_tab_name || '.max(' || l_tab_column || '): ' || l_max_val);
   if l_last_seq < l_max_val
   then
      -- Increment the sequence as necessary
      sql_txt := 'begin' ||
                 ' while "' || l_seq_owner || '"."' || l_seq_name || '".nextval < ' || l_max_val ||
                 ' loop null; end loop;' ||
                 'end;';
      dbms_output.put_line(sql_txt);
      execute immediate sql_txt;-- using l_last_seq;
   end if;
end;
/
