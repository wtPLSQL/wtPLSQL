
--
-- Update "grbtst" IDENTITY SEQUENCES
--   1 - Schema List
--

declare
   UNDEFINED_SEQUENCE  EXCEPTION;  -- sequence not yet defined in this session
   PRAGMA EXCEPTION_INIT (UNDEFINED_SEQUENCE, -8002);
   l_last_seq   number;
   l_max_val    number;
   sql_txt      varchar2(4000);
begin
   dbms_output.put_line('Update ID Sequences started');
   for buff in (
      select tic.owner
            ,tic.table_name
            ,tic.column_name
            ,tic.sequence_name
       from  dba_tab_identity_cols  tic
       where tic.owner in (&1.)
      order by tic.owner
            ,tic.table_name
            ,tic.column_name
            ,tic.sequence_name )
   loop
      -- Find the Current Sequence Value
      sql_txt := 'select ' || buff.owner || '.' || buff.sequence_name ||
                 '.currval from dual';
      begin
         execute immediate sql_txt into l_last_seq;
      exception when UNDEFINED_SEQUENCE
      then
         -- Find the Last Number for the Sequence
         select ds.last_number into l_last_seq
          from  dba_sequences  ds
          where ds.sequence_owner = buff.owner
           and  ds.sequence_name  = buff.sequence_name;
      end;
      -- Find the maximum IDENTITY column value
      sql_txt := 'select max(' || buff.column_name || ')' ||
                 ' from ' || buff.owner || '.' || buff.table_name;
      execute immediate sql_txt into l_max_val;
      -- Display values found
      dbms_output.put_line(buff.owner || '.' || buff.sequence_name || ' Last Sequence: ' || l_last_seq ||
                   ', ' || buff.owner || '.' || buff.table_name || ' max(' || buff.column_name || ') = ' || l_max_val);
      if l_last_seq < l_max_val
      then
         -- Increment the sequence as necessary
         sql_txt := 'begin' ||
                    ' while ' || buff.owner || '.' || buff.sequence_name || '.nextval < ' || l_max_val ||
                    ' loop null; end loop;' ||
                    'end;';
         dbms_output.put_line(sql_txt);
         execute immediate sql_txt;-- using l_last_seq;
      end if;
   end loop;
   dbms_output.put_line('Identity Sequence Updates is done.');
end;
/
