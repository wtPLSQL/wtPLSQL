
--
--  Prepare for View Install
--

prompt
prompt Create Temp Publicly Updateable Table
create table TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
create public synonym TEMP_PUBLICLY_UPDATEABLE_TABLE for TEMP_PUBLICLY_UPDATEABLE_TABLE;

prompt
prompt Check for Prerequisite BUILD_TYPEs
declare
   procedure do_it (in_btype varchar2) is
      TYPE c_main_ref_cur is REF CURSOR;
      c_main           c_main_ref_cur;
      b_max_load_dtm   date;
   begin
      open c_main for 'select max(load_dtm) max_load_dtm'  ||
                      ' from ODBCAPTURE_INSTALLATION_LOGS' ||
                      ' where build_type = ''' || in_btype || '''';
      fetch c_main into b_max_load_dtm;
      if b_max_load_dtm IS NULL
      then
         dbms_output.put_line('WARNING: Prerequisite BUILD_TYPE "' || in_btype ||
                              '" not found in ODBCAPTURE_INSTALLATION_LOGS table.');
      else
         dbms_output.put_line(' -) "' || in_btype || '" last loaded on ' ||
                               to_char(b_max_load_dtm, 'DD-Mon-YYYY HH24:MI:SS') );
      end if;
      close c_main;
   exception when others then
      if SQLCODE = -942    -- Table or view does not exist
      then
         dbms_output.put_line('NOTE: ODBCAPTURE_INSTALLATION_LOGS table not available to check "' ||
                              in_btype || '".');
         close c_main;
      else
         raise;
      end if;
   end;
begin
   dbms_output.put_line('Prerequisite BUILD_TYPEs for "grbsrc"');
end;
/

