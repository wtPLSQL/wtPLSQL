
--
--  Core Installation
--

-- Enable SQL*Plus Variables
set define "&"
set concat "."

accept schema_owner CHAR default 'wtp_demo' -
prompt 'Enter Schema Name (WTP_DEMO): '

prompt 'Connect String must be empty or start with @'
accept connect_string CHAR default 'wtp' -
prompt 'Enter Connect String (): '
