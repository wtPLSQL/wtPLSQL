
--
--  Prepare for View Install
--

prompt
prompt Create_Temp_Publicly_Updateable_Table_SQL
create table SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE (c1 number);
grant all on SYSTEM.TEMP_PUBLICLY_UPDATEABLE_TABLE to PUBLIC with grant option;
