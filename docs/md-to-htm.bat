
REM pandoc -f gfm -t html --lua-filter=md-to-htm.lua -o %1.htm %1.md

for %%f in (*.md) do (
   REM echo %%~nf.htm
   pandoc -f gfm -t html --lua-filter=md-to-htm.lua -o %%~nf.htm %%~nf.md
   )
