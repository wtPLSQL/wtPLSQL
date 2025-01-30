
Prompt Running Set User Authentication

declare
   l_password  varchar2(50) := 'PASSWORD';
begin
   execute immediate 'alter user "ODBCAPTURE" identified by "' || l_password || '"';
   execute immediate 'alter user "ODBCTEST" identified by "' || l_password || '"';
end;
/
