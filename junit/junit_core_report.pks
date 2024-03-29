create or replace package junit_core_report
   authid definer
as

   g_in_process  boolean := FALSE;

   procedure xml_header;

   procedure xml_body;

   procedure xml_trailer;

   procedure before_test_all;

   procedure show_current;

   procedure after_test_all;

end junit_core_report;
