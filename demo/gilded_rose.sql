
--
-- Here are the requirements for the GildedRose Code Kata:
--   1) All items have a SellIn value which denotes the number of days we have to sell the item.
--   2) All items have a Quality value which denotes how valuable the item is.
--   3) At the end of each day our system lowers both values for every item.
--   4) Once the sell by date has passed, Quality degrades twice as fast.
--   5) The Quality of an item is never negative.
--   6) "Aged Brie" actually increases in Quality the older it gets.
--   7) The Quality of an item is never more than 50.
--   8) "Sulfuras", being a legendary item, never has to be sold or decreases in Quality.
--   9) "Backstage passes", like aged brie, increases in Quality as it's SellIn value approaches.
--      Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less
--      but Quality drops to 0 after the concert.
--  10) "Conjured" items degrade in Quality twice as fast as normal items.
--
-- There are several kinds of requirements here.
--   -) 1 & 2 are Attributes.  Everything has/is
--   -) 3, 4, 6, 8, 9, & 10 are processes.  Always do, with exceptions.
--   -) 5 & 7 are corner cases, boundary conditions.
-- 

create table gilded_roses
   (name      varchar2(100) constraint gilded_roses_nn1 not null
   ,sell_in   number(6)     constraint gilded_roses_nn2 not null
   ,quality   number(6)     constraint gilded_roses_nn3 not null
   ,reduce    number(3)     constraint gilded_roses_nn4 not null
   ,reduce10  number(3)
   ,reduce5   number(3)
   ,constraint gilded_roses_ck1 check (quality between 0 and 50));

comment on column gilded_roses.name     is 'Name of Item';
comment on column gilded_roses.sell_in  is 'Number of Days to Sell';
comment on column gilded_roses.quality  is 'Value of Quality';
comment on column gilded_roses.reduce   is 'Quality Reduction Per Day';
comment on column gilded_roses.reduce10 is 'Quality Reduction Per Day with 10 days or less';
comment on column gilded_roses.reduce5  is 'Quality Reduction Per Day with 5 days or less';

insert into gilded_roses values ('Aged Brie'     ,  0, 30, -1);
insert into gilded_roses values ('Sulfuras'      , -1, 30,  0);
insert into gilded_roses values ('Backstage Pass', 30, 30, -1, -2, -3);
insert into gilded_roses values ('Conjured'      , 30, 30,  2);
insert into gilded_roses values ('Normal'        , 30, 30,  1);

create or replace package gilded_rose
   authid definer
as

   procedure end_of_day;

   $IF $$WTPLSQL_ENABLE
   $THEN
      procedure WTPLSQL_RUN;
   $END

end gilded_rose;
/
show errors


create or replace package body gilded_rose
as


procedure end_of_day
is
   TYPE gr_nt_type is table of gilded_roses%ROWTYPE;
   gr_nt   gr_nt_type;
begin
   select * bulk collect into gr_nt
    from  gilded_roses
    where sell_in >= 0;
   for i in 1 .. gr_nt.COUNT
   loop
      if    gr_nt(i).reduce5 is not null
        AND sell_in <= 5
      then
      elsif    gr_nt(i).reduce5 is not null
           AND sell_in <= 5
      then
      else
         gr_nt(i).sell_in := gr_nt(i).sell_in - 1;
         if gr_nt(i).sell_in < 0
         then
            gr_nt(i).quality := 0;
         else
            gr_nt(i).quality := gr_nt(i).quality - gr_nt(i).reduce;
         end if;
      end if;
      if gr_nt(i).quality > 50 then gr_nt(i).quality := 50; end if;
      if gr_nt(i).quality <  0 then gr_nt(i).quality :=  0; end if;
   end loop;
end end_of_day;

$IF $$WTPLSQL_ENABLE
$THEN
procedure WTPLSQL_RUN
is
begin
   utassert.g_testcase_name = '';
end WTPLSQL_RUN;
$END

end gilded_rose;
/
show errors
