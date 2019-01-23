
cd core
echo exit | sqlplus / as sysdba @install
cd ..

cd persist
echo exit | sqlplus / as sysdba @install
cd ..

REM cd gui
REM echo exit | sqlplus / as sysdba @install
REM cd ..

REM cd demo
REM echo exit | sqlplus / as sysdba @install
REM cd ..

pause
