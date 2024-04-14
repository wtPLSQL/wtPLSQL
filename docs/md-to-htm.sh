
# pandoc -f gfm -t html --lua-filter=md-to-htm.lua -o %1.htm %1.md

ls *.md | while read FILE
do
   # /%md - Match pattern at end of expansion
   # /htm - Replace match with "htm"
   #echo "${FILE/%md/htm}" "${FILE}"
   pandoc -f gfm -t html --lua-filter=md-to-htm.lua -o "${FILE/%md/htm}" "${FILE}"
done
