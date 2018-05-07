
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
/
