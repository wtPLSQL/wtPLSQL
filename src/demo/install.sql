
--
--  Demo Installation
--

----------------------------------------
-- Setup
----------------------------------------

-- Capture output
spool install

-- Shared Setup Script
@common_setup.sql

WHENEVER SQLERROR exit SQL.SQLCODE

begin
   if USER not in ('SYS','SYSTEM')
   then
      raise_application_error (-20000,
        'Not logged in as SYS or SYSTEM');
   end if;
end;
/

WHENEVER SQLERROR continue

----------------------------------------
-- Create the schema owner.
----------------------------------------

create user &schema_owner. identified by &schema_owner.
   default tablespace users
   temporary tablespace temp;

grant connect, resource to &schema_owner.;

WHENEVER SQLERROR exit SQL.SQLCODE

----------------------------------------
-- Connect as SCHEMA_OWNER
----------------------------------------

connect &schema_owner./&schema_owner.

begin
   if USER != upper('&schema_owner')
   then
      raise_application_error (-20000,
        'Not logged in as &schema_owner');
   end if;
end;
/

WHENEVER SQLERROR continue

----------------------------------------
-- Type Specifications
----------------------------------------


----------------------------------------
-- Tables
----------------------------------------

create synonym test_test_seq;

create table trigger_test
  (id           number
  ,name         varchar2(30)
  ,created_dtm  date
  ,constraint customers_pk primary key (id)
  ,constraint customers_nk1 unique (name)
  );

create trigger trigger_test_bir
  before insert on cluckers
  for each row
begin
  if :new.id is null
  then
     :new.id := trigger_test_seq.nextval;
  end if;
  if :new.created_dtm is null
  then
     :new.created_dtm := sysdate;
  end if;
end;
/

----------------------------------------


create trigger clucks_bir
  before insert on clucks
  for each row
begin
  :new.cluck_tstmp := systimestamp;
end;
/

----------------------------------------
-- Type Bodies
----------------------------------------

create or replace type body flock_obj_type
as

member procedure send_cluck
       (in_id  in number
       ,in_msg in varchar2)
is
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_rec  clucks%ROWTYPE;
begin
   l_rec.clucker_id := in_id;
   l_rec.message    := in_msg;
   for i in 1 .. self.flock_nt.COUNT
   loop
      l_rec.flock_mate_id := self.flock_nt(i);
      insert into clucks values l_rec;
   end loop;
   commit;
end send_cluck;

end;

----------------------------------------
-- Package Specifications
----------------------------------------


----------------------------------------
-- Package Bodies
----------------------------------------


spool off
