
create or replace type type_test_typ as object
   (fill_dtm  date
   ,gallons   number(6)
   ,miles     number(9)
   ,member procedure fill_up
          (in_fill_dtm  date
          ,in_gallons   number
          ,in_miles     number)
   ,member function get_mpg
       return number
   );
/

create or replace type body type_test_typ
is

member procedure fill_up
      (in_fill_dtm  date
      ,in_gallons   number
      ,in_miles     number)
is
begin
   null;
end;

member function get_mpg
   return number
is
begin
   null;
end;

end;
/
