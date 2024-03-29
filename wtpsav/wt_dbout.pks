create or replace package wt_dbout
   authid definer
as

   -- Return a DBOUT Surrogate Key.
   -- Return NULL if the DBOUT does not exist.
   function get_id
      (in_owner  in varchar2
      ,in_name   in varchar2
      ,in_type   in varchar2)
   return number;

   -- Return a DBOUT Surrogate Key.
   -- Add the DBOUT if it does not exist.
   function dim_id
      (in_owner  in varchar2
      ,in_name   in varchar2
      ,in_type   in varchar2)
   return number;

   -- Delete all records with no child records
   procedure delete_records;
   
   --   WtPLSQL Self Test Procedures
   --
   -- alter system set PLSQL_CCFLAGS = 
   --    'WTPLSQL_SELFTEST:TRUE'
   --    scope=BOTH;
   --
   $IF $$WTPLSQL_SELFTEST
   $THEN
      procedure WTPLSQL_RUN;
   $END

end wt_dbout;
