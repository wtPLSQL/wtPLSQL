
-- Create the wtPLSQL schema owner.

create user wtp identified by wtp
   default tablespace users
   temporary tablespace temp;

grant connect, resource to wtp;
--grant create view to wtp;
