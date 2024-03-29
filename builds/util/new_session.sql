
--
-- New Oracle Database Session
--
-- Parameters
--   1 - Connection String. Ex. username/password@//host:port/pdb.domain
--

----------------------------------------
prompt
prompt New Session
connect &1.

----------------------------------------
prompt
prompt Reset Output Connections
execute DBMS_JAVA.SET_OUTPUT(1000000);
set serveroutput on size unlimited format wrapped
execute DBMS_OUTPUT.ENABLE(NULL);

----------------------------------------
prompt
prompt Show Database Connection
select 'db: ' || name ||
       ', con: ' || sys_context('USERENV', 'CON_NAME') ||
       ', tstmp: ' || systimestamp
 from  v$database;
