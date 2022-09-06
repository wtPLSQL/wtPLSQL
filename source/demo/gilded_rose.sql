
--
-- Here are the requirements for the GildedRose Code Kata:
--   1) All items have a SellIn value which denotes the number of days we have to sell the item
--   2) All items have a Quality value which denotes how valuable the item is
--   3) At the end of each day our system lowers both values for every item
--   4) Once the sell by date has passed, Quality degrades twice as fast
--   5) The Quality of an item is never negative
--   6) “Aged Brie” actually increases in Quality the older it gets
--   7) The Quality of an item is never more than 50
--   8) “Sulfuras”, being a legendary item, never has to be sold or decreases in Quality
--   9) “Backstage passes”, like aged brie, increases in Quality as it’s SellIn value approaches; Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but Quality drops to 0 after the concert
--  10) “Conjured” items degrade in Quality twice as fast as normal items
--
-- There are several kinds of requirements here.
--   -) Everything has/is: 1, 2 (these are attributes)
--   -) Always do, with exceptions: 3, 4, 6, 8, 9, 10 (these are processes)
--   -) Boundary conditions: 5, 7 (these define corner cases)
-- 


-- This is INCOMPLETE


create or replace package gilded_rose
   authid definer
as

   g_name     varchar2(100);
   g_sell_in  number(6);
   g_quality  number(6);

   --  Package variables are publicly modifiable in PL/SQL.
   --procedure initialize
   --   (in_name            in varchar2
   --   ,in_quality         in number
   --   ,in_days_remaining  in number);

   procedure tick;

   $IF $$WTPLSQL_ENABLE
   $THEN
      procedure WTPLSQL_RUN;
   $END

end gilded_rose;
/
show errors


create or replace package body gilded_rose
as

--  Package variables are publicly modifiable in PL/SQL.
--procedure initialize
--      (in_name            in varchar2
--      ,in_quality         in number
--      ,in_days_remaining  in number);

procedure tick
is
begin
   if    g_name <> 'Aged Brie'
     and g_name <> 'Backstage passes to a TAFKAL80ETC concert'
   then
      if g_quality > 0
      then
         if g_name <> 'Sulfuras, Hand of Ragnaros'
         then
            g_quality := g_quality - 1;
         end if;
      end if;
   else
      if (g_quality < 50)
      then
         g_quality := g_quality + 1;
         if g_name = 'Backstage passes to a TAFKAL80ETC concert'
         then
            if g_sell_in < 11
            then
               if g_quality < 50
               then
                  g_quality := g_quality + 1;
               end if;
            end if;
            if g_sell_in < 6
            then
               if g_quality < 50
               then
                  g_quality := g_quality + 1;
               end if;
            end if;
         end if;
      end if;
   end if;
   if g_name <> 'Sulfuras, Hand of Ragnaros'
      then
      g_sell_in := g_sell_in - 1;
   end if;
   if g_sell_in < 0
   then
      if g_name <> 'Aged Brie'
      then
         if g_name <> 'Backstage passes to a TAFKAL80ETC concert'
         then
            if g_quality > 0
            then
               if g_name <> 'Sulfuras, Hand of Ragnaros'
               then
                  g_quality := g_quality - 1;
               end if;
            end if;
         else
            g_quality := g_quality - g_quality;
         end if;
      else
         if g_quality < 50
         then
            g_quality := g_quality + 1;
         end if;
      end if;
   end if;
end tick;

$IF $$WTPLSQL_ENABLE
$THEN
procedure WTPLSQL_RUN
is
begin
   utassert.g_testcase_name = '
end WTPLSQL_RUN;
$END

end gilded_rose;
/
show errors
