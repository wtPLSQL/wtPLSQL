
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

create type flock_nt_type
  as table of number;

----------------------------------------

create type flock_obj_type
   as object
   (flock_nt   flock_nt_type
   ,member procedure send_cluck
         (in_id  in number
         ,in_msg in varchar2)
   );

----------------------------------------
-- Tables
----------------------------------------

create sequence cluckers_seq;

create table cluckers
  (id         number
  ,name       varchar2(30)
  ,flock_obj  flock_obj_type
  ,constraint customers_pk primary key (id)
  ,constraint customers_nk1 unique (name)
  );

create trigger cluckers_bir
  before insert on cluckers
  for each row
begin
  if :new.id is null
  then
     :new.id := cluckers_seq.nextval;
  end if;
end;
/

----------------------------------------

create table clucks
  (clucker_id     number
  ,cluck_tstmp    timestamp
  ,flock_mate_id  number         constraint clucks_nn1 not null
  ,message        varchar2(140)  constraint clucks_nn2 not null
  ,constraint clucks_pk primary key (clucker_id, cluck_tstmp)
  ,constraint clucks_fk1 foreign key (clucker_id) references cluckers
  ,constraint clucks_fk2 foreign key (flock_mate_id) references cluckers
  );

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

@clucking.pks
/

----------------------------------------
-- Package Bodies
----------------------------------------

@clucking.pkb
/

spool off
