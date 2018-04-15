
create type flock_obj_type
   as object
   (flock_nt   flock_nt_type
   ,member procedure send_cluck (in_msg in varchar2)
   );
