set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 700 - wtPLSQL Core GUI
--
-- Application Export:
--   Application:     700
--   Name:            wtPLSQL Core GUI
--   Date and Time:   18:08 Monday November 5, 2018
--   Exported By:     WTP
--   Flashback:       0
--   Export Type:     Application Export
--   Version: 4.0.2.00.09
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_040000 or as the owner (parsing schema) of the application.
 
-- Application Statistics:
--   Pages:                    8
--     Items:                 27
--     Computations:           8
--     Validations:            0
--     Processes:             16
--     Regions:               41
--     Buttons:                6
--     Dynamic Actions:        5
--   Shared Components
--     Breadcrumbs:            1
--        Entries              2
--     Items:                  1
--     Computations:           1
--     Processes:              1
--     Parent Tabs:            0
--     Tab Sets:               1
--        Tabs:                6
--     NavBars:                1
--     Lists:                  0
--     Shortcuts:              0
--     Themes:                 1
--     Templates:
--        Page:               15
--        List:               15
--        Report:             11
--        Label:               5
--        Region:             25
--     Messages:               0
--     Build Options:          0
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040000 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,4779017982861389));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2010.05.13');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,700);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

--application/delete_application
 
begin
 
   -- Remove Application
wwv_flow_api.remove_flow(nvl(wwv_flow_application_install.get_application_id,700));
 
end;
/

 
begin
 
wwv_flow_audit.remove_audit_trail(nvl(wwv_flow_application_install.get_application_id,700));
null;
 
end;
/

--application/create_application
 
begin
 
wwv_flow_api.create_flow(
  p_id    => nvl(wwv_flow_application_install.get_application_id,700),
  p_display_id=> nvl(wwv_flow_application_install.get_application_id,700),
  p_owner => nvl(wwv_flow_application_install.get_schema,'WTP'),
  p_name  => nvl(wwv_flow_application_install.get_application_name,'wtPLSQL Core GUI'),
  p_alias => nvl(wwv_flow_application_install.get_application_alias,'WTPLSQLCORE'),
  p_page_view_logging => 'YES',
  p_default_page_template=> 4837525507414910 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=> 4837724123414910 + wwv_flow_api.g_id_offset,
  p_default_region_template=> 4840201642414912 + wwv_flow_api.g_id_offset,
  p_error_template=> 4837131094414910 + wwv_flow_api.g_id_offset,
  p_page_protection_enabled_y_n=> 'Y',
  p_checksum_salt_last_reset => '20181105180850',
  p_max_session_length_sec=> 28800,
  p_home_link=> 'f?p=&APP_ID.:3:&SESSION.',
  p_flow_language=> 'en',
  p_flow_language_derived_from=> 'FLOW_PRIMARY_LANGUAGE',
  p_allow_feedback_yn=> 'N',
  p_date_format=> 'DD-MON-YYYY HH24:MI:SS',
  p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'/i/'),
  p_publish_yn=> 'N',
  p_documentation_banner=> '',
  p_authentication=> 'CUSTOM2',
  p_login_url=> '',
  p_logout_url=> 'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_application_tab_set=> 1,
  p_logo_image => 'TEXT:wtPLSQL - White Box Test Server for PL/SQL',
  p_public_url_prefix => '',
  p_public_user=> 'APEX_PUBLIC_USER',
  p_dbauth_url_prefix => '',
  p_proxy_server=> nvl(wwv_flow_application_install.get_proxy,''),
  p_cust_authentication_process=> '.'||to_char(4845319779414920 + wwv_flow_api.g_id_offset)||'.',
  p_cust_authentication_page=> '',
  p_custom_auth_login_url=> '',
  p_flow_version=> 'wtPLSQL Core GUI V1.2.0',
  p_flow_status=> 'AVAILABLE_W_EDIT_LINK',
  p_flow_unavailable_text=> 'This application is currently unavailable at this time.',
  p_build_status=> 'RUN_AND_BUILD',
  p_exact_substitutions_only=> 'Y',
  p_vpd=> '',
  p_csv_encoding=> 'Y',
  p_auto_time_zone=> 'N',
  p_default_error_display_loc=> 'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_theme_id => 7,
  p_default_label_template => 4843803724414915 + wwv_flow_api.g_id_offset,
  p_default_report_template => 4843113555414914 + wwv_flow_api.g_id_offset,
  p_default_list_template => 4842217442414913 + wwv_flow_api.g_id_offset,
  p_default_menu_template => 4844109108414915 + wwv_flow_api.g_id_offset,
  p_default_button_template => 4838226535414911 + wwv_flow_api.g_id_offset,
  p_default_chart_template => 4839217975414912 + wwv_flow_api.g_id_offset,
  p_default_form_template => 4839304121414912 + wwv_flow_api.g_id_offset,
  p_default_wizard_template => 4840913627414912 + wwv_flow_api.g_id_offset,
  p_default_tabform_template => 4840201642414912 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>4840201642414912 + wwv_flow_api.g_id_offset,
  p_default_menur_template => 4838801336414912 + wwv_flow_api.g_id_offset,
  p_default_listr_template => 4839116402414912 + wwv_flow_api.g_id_offset,
  p_default_irr_template => 4839831975414912 + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WTP',
  p_last_upd_yyyymmddhh24miss=> '20181105180850',
  p_required_roles=> wwv_flow_utilities.string_to_table2(''));
 
 
end;
/

prompt  ...authorization schemes
--
 
begin
 
null;
 
end;
/

--application/shared_components/navigation/navigation_bar
prompt  ...navigation bar entries
--
 
begin
 
wwv_flow_api.create_icon_bar_item(
  p_id => 4845410456414920 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_icon_sequence=> 200,
  p_icon_image => '',
  p_icon_subtext=> 'Logout',
  p_icon_target=> '&LOGOUT_URL.',
  p_icon_image_alt=> 'Logout',
  p_icon_height=> 32,
  p_icon_width=> 32,
  p_icon_height2=> 24,
  p_icon_width2=> 24,
  p_nav_entry_is_feedback_yn => 'N',
  p_icon_bar_disp_cond=> '',
  p_icon_bar_disp_cond_type=> '',
  p_begins_on_new_line=> '',
  p_cell_colspan      => 1,
  p_onclick=> '',
  p_icon_bar_comment=> '');
 
 
end;
/

prompt  ...application processes
--
--application/shared_components/logic/application_processes/initialize_items
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'   -- Set Test Run ID based on Test Owner and (optionally) Test Runner'||chr(10)||
'   procedure set_run_id (in_runner_name varchar2 default NULL) is'||chr(10)||
'   begin'||chr(10)||
'      -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'      select max(id)'||chr(10)||
'       into  :P0_TEST_RUN_ID'||chr(10)||
'       from  wt_test_runs'||chr(10)||
'       where runner_owner = :P0_TEST_OWNER'||chr(10)||
'        and  (   in_runner_name is NULL'||chr(10)||
'              or in_runner_name = ';

p:=p||'runner_name);'||chr(10)||
'   end set_run_id;'||chr(10)||
'   -- Set Owner based on Test Run ID'||chr(10)||
'   procedure set_owner is'||chr(10)||
'   begin'||chr(10)||
'      -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'      select min(runner_owner)'||chr(10)||
'       into  :P0_TEST_OWNER'||chr(10)||
'       from  wt_test_runs'||chr(10)||
'       where id = :P0_TEST_RUN_ID;'||chr(10)||
'   end set_owner;'||chr(10)||
'   -- Set Runner based on Test Run ID'||chr(10)||
'   procedure set_runner is'||chr(10)||
'      num_recs  pls_integer;'||chr(10)||
'   begin'||chr(10)||
' ';

p:=p||'     -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'      select count(*)'||chr(10)||
'       into  num_recs'||chr(10)||
'       from  wt_test_runs'||chr(10)||
'       where id          = :P0_TEST_RUN_ID'||chr(10)||
'        and  runner_name = :P0_TEST_RUNNER;'||chr(10)||
'      if num_recs = 0'||chr(10)||
'      then'||chr(10)||
'         -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'         select min(runner_name)'||chr(10)||
'          into  :P0_TEST_RUNNER'||chr(10)||
'          from  wt_test_runs'||chr(10)||
'        ';

p:=p||'  where id = :P0_TEST_RUN_ID;'||chr(10)||
'      end if;'||chr(10)||
'   end set_runner;'||chr(10)||
'   -- Set Test Case based on Test Run ID if Test Case not valid'||chr(10)||
'   procedure set_test_case is'||chr(10)||
'      num_recs  pls_integer;'||chr(10)||
'   begin'||chr(10)||
'      -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'      select count(*)'||chr(10)||
'       into  num_recs'||chr(10)||
'       from  wt_testcase_runs'||chr(10)||
'       where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
'        and  testcase    = :P0_TES';

p:=p||'T_CASE;'||chr(10)||
'      if num_recs = 0'||chr(10)||
'      then'||chr(10)||
'         -- Group function will not raise NO_DATA_FOUND'||chr(10)||
'         select min(testcase)'||chr(10)||
'          into  :P0_TEST_CASE'||chr(10)||
'          from  wt_testcase_runs'||chr(10)||
'          where test_run_id = :P0_TEST_RUN_ID;'||chr(10)||
'      end if;'||chr(10)||
'   end set_test_case;'||chr(10)||
'BEGIN'||chr(10)||
'   -- Main Decision Logic'||chr(10)||
'   case'||chr(10)||
'      --'||chr(10)||
'      when    :P0_TEST_RUN_ID is not null'||chr(10)||
'           and (   :P0_OLD_TEST_RUN';

p:=p||'_ID is null'||chr(10)||
'                or :P0_OLD_TEST_RUN_ID != :P0_TEST_RUN_ID )'||chr(10)||
'      then'||chr(10)||
'         --   This is the most common case of getting called from a link'||chr(10)||
'         :P0_DBG := ''P0_TEST_RUN_ID changed from '' || :P0_OLD_TEST_RUN_ID ||'||chr(10)||
'                                            '' to '' || :P0_TEST_RUN_ID     ;'||chr(10)||
'         set_owner;                       -- Based on Test Run ID'||chr(10)||
'         set_runner;     ';

p:=p||'                 -- Based on Test Run ID'||chr(10)||
'         set_test_case;                   -- Based on Test Run ID'||chr(10)||
'                                          --   if Test Case not valid'||chr(10)||
'      --'||chr(10)||
'      when :P0_TEST_OWNER is NULL'||chr(10)||
'      then'||chr(10)||
'         -- Set everything to NULL'||chr(10)||
'         -- :P0_TEST_RUN_ID has not changed'||chr(10)||
'         :P0_DBG := ''P0_TEST_ONWER is null'';'||chr(10)||
'         :P0_TEST_RUNNER := NULL;'||chr(10)||
'         :P';

p:=p||'0_TEST_RUN_ID := NULL;'||chr(10)||
'         :P0_TEST_CASE   := NULL;'||chr(10)||
'      --'||chr(10)||
'      when    :P0_OLD_TEST_OWNER is null'||chr(10)||
'           or :P0_OLD_TEST_OWNER != :P0_TEST_OWNER'||chr(10)||
'      then'||chr(10)||
'         -- :P0_TEST_RUN_ID has not changed'||chr(10)||
'         -- :P0_TEST_OWNER is not null'||chr(10)||
'         :P0_DBG := ''P0_TEST_OWNER changed from '' || :P0_OLD_TEST_OWNER ||'||chr(10)||
'                                           '' to '' || :P0_TEST_OWNER     ;';

p:=p||''||chr(10)||
'         set_run_id;                      -- Based on Test Owner'||chr(10)||
'         set_runner;                      -- Based on Test Run ID'||chr(10)||
'         set_test_case;                   -- Based on Test Run ID'||chr(10)||
'                                          --   if Test Case not valid'||chr(10)||
'      --'||chr(10)||
'      when NOT (   (    :P0_TEST_RUNNER is null'||chr(10)||
'                    and :P0_OLD_TEST_RUNNER is null )'||chr(10)||
'                or :P';

p:=p||'0_TEST_RUNNER = :P0_OLD_TEST_RUNNER )'||chr(10)||
'      then'||chr(10)||
'         -- :P0_TEST_RUN_ID has not changed'||chr(10)||
'         -- :P0_TEST_OWNER is not null'||chr(10)||
'         -- :P0_TEST_OWNER has not changed'||chr(10)||
'         :P0_DBG := ''P0_TEST_RUNNER changed from '' || :P0_OLD_TEST_RUNNER ||'||chr(10)||
'                                            '' to '' || :P0_TEST_RUNNER     ;'||chr(10)||
'         set_run_id(:P0_TEST_RUNNER);     -- Based on Test Owner and Tes';

p:=p||'t Runner'||chr(10)||
'         set_test_case;                   -- Based on Test Run ID'||chr(10)||
'                                          --   if Test Case not valid'||chr(10)||
'      --'||chr(10)||
'      else'||chr(10)||
'         -- :P0_TEST_RUN_ID has not changed'||chr(10)||
'         -- :P0_TEST_OWNER is not null'||chr(10)||
'         -- :P0_TEST_OWNER has not changed'||chr(10)||
'         -- :P0_TEST_RUNNER has not changed'||chr(10)||
'         :P0_DBG := ''Do nothing'';'||chr(10)||
'         null;'||chr(10)||
'      --'||chr(10)||
'      e';

p:=p||'nd case;'||chr(10)||
'   :P0_OLD_TEST_RUN_ID := :P0_TEST_RUN_ID;'||chr(10)||
'   :P0_OLD_TEST_OWNER  := :P0_TEST_OWNER;'||chr(10)||
'   :P0_OLD_TEST_RUNNER := :P0_TEST_RUNNER;'||chr(10)||
'END;';

wwv_flow_api.create_flow_process(
  p_id => 5124821433507746 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 10,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Initialize Items',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Global Page Initialization Failed',
  p_process_when=> '',
  p_process_when_type=> '',
  p_process_comment=> '');
end;
 
null;
 
end;
/

prompt  ...application items
--
--application/shared_components/logic/application_items/fsp_after_login_url
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 5108203250645963 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'FSP_AFTER_LOGIN_URL',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_item_comment=> '');
 
null;
 
end;
/

prompt  ...application level computations
--
 
begin
 
--application/shared_components/logic/application_computations/p0_test_owner
wwv_flow_api.create_flow_computation (
  p_id => 5148803335141101 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_computation_sequence => 10,
  p_computation_item => 'P0_TEST_OWNER',
  p_computation_point    => 'ON_NEW_INSTANCE',
  p_computation_type => 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation => 'with q1 as ('||chr(10)||
'select max(runner_owner)  max_owner'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where runner_owner <= :APP_USER'||chr(10)||
'), q2 as ('||chr(10)||
'select min(runner_owner)  min_owner'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where runner_owner >= :APP_USER'||chr(10)||
')'||chr(10)||
'select nvl(q1.max_owner, q2.min_owner)'||chr(10)||
' from  q1 cross join q2',
  p_compute_when=> '',
  p_compute_when_type=> '',
  p_computation_error_message=>'',
  p_computation_comment=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

prompt  ...Application Tabs
--
 
begin
 
--application/shared_components/navigation/tabs/standard/t_dashboard
wwv_flow_api.create_tab (
  p_id=> 4846811586414924 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 10,
  p_tab_name=> 'T_DASHBOARD',
  p_tab_text => 'Dashboard',
  p_tab_step => 1,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_run_test
wwv_flow_api.create_tab (
  p_id=> 4847411144414925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 20,
  p_tab_name=> 'T_RUN_TEST',
  p_tab_text => 'Run Test',
  p_tab_step => 2,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_test_runner
wwv_flow_api.create_tab (
  p_id=> 4848009034414926 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 30,
  p_tab_name=> 'T_TEST_RUNNER',
  p_tab_text => 'Test Runner',
  p_tab_step => 3,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_test_cases
wwv_flow_api.create_tab (
  p_id=> 4977229177323155 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 40,
  p_tab_name=> 'T_TEST CASES',
  p_tab_text => 'Test Case',
  p_tab_step => 6,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_dbout_profile
wwv_flow_api.create_tab (
  p_id=> 5047612005953773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 50,
  p_tab_name=> 'T_DBOUT PROFILE',
  p_tab_text => 'DBOUT Profile',
  p_tab_step => 4,
  p_tab_also_current_for_pages => '4',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_about
wwv_flow_api.create_tab (
  p_id=> 4905926268694339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 60,
  p_tab_name=> 'T_ABOUT',
  p_tab_text => 'About',
  p_tab_step => 5,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_tab_comment  => '');
 
 
end;
/

prompt  ...Application Parent Tabs
--
 
begin
 
null;
 
end;
/

prompt  ...Shared Lists of values
--
--application/shared_components/user_interface/lov/p3_report_row_per_page
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 4952509356578433 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'P3_Report Row Per Page',
  p_lov_query=> '.'||to_char(4952509356578433 + wwv_flow_api.g_id_offset)||'.');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4952816929578434 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>10,
  p_lov_disp_value=>'10',
  p_lov_return_value=>'10',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4953007560578434 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>20,
  p_lov_disp_value=>'15',
  p_lov_return_value=>'15',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4953224813578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>30,
  p_lov_disp_value=>'20',
  p_lov_return_value=>'20',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4953425086578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>40,
  p_lov_disp_value=>'30',
  p_lov_return_value=>'30',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4953605022578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>50,
  p_lov_disp_value=>'50',
  p_lov_return_value=>'50',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4953800039578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>60,
  p_lov_disp_value=>'100',
  p_lov_return_value=>'100',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4954011164578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>70,
  p_lov_disp_value=>'200',
  p_lov_return_value=>'200',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4954208134578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>80,
  p_lov_disp_value=>'500',
  p_lov_return_value=>'500',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4954416221578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>90,
  p_lov_disp_value=>'1000',
  p_lov_return_value=>'1000',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4954628322578435 + wwv_flow_api.g_id_offset,
  p_lov_id=>4952509356578433 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>100,
  p_lov_disp_value=>'5000',
  p_lov_return_value=>'5000',
  p_lov_data_comment=> '');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/y_or_n
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 4923728354614299 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'Y_OR_N',
  p_lov_query=> '.'||to_char(4923728354614299 + wwv_flow_api.g_id_offset)||'.');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4924006022614301 + wwv_flow_api.g_id_offset,
  p_lov_id=>4923728354614299 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>1,
  p_lov_disp_value=>'Yes',
  p_lov_return_value=>'Y',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>4924205788614301 + wwv_flow_api.g_id_offset,
  p_lov_id=>4923728354614299 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>2,
  p_lov_disp_value=>'No',
  p_lov_return_value=>'N',
  p_lov_data_comment=> '');
 
null;
 
end;
/

prompt  ...Application Trees
--
--application/pages/page_groups
prompt  ...page groups
--
 
begin
 
null;
 
end;
/

--application/comments
prompt  ...comments: requires application express 2.2 or higher
--
 
--application/pages/page_00000
prompt  ...PAGE 0: Global
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 0
 ,p_name => 'Global'
 ,p_step_title => '0'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20181104135107'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'begin'||chr(10)||
' --  htp.p(''P0_TEST_OWNER      = '' || v(''P0_TEST_OWNER''      ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_TEST_RUNNER     = '' || v(''P0_TEST_RUNNER''     ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_TEST_RUN_ID     = '' || v(''P0_TEST_RUN_ID''     ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_TEST_CASE       = '' || v(''P0_TEST_CASE''       ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_DISPLAY         = '' || v(''P0_DISPLAY''         ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_OLD_';

s:=s||'TEST_OWNER  = '' || v(''P0_OLD_TEST_OWNER''  ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_OLD_TEST_RUNNER = '' || v(''P0_OLD_TEST_RUNNER'' ) || ''<br>'');'||chr(10)||
' --  htp.p(''P0_OLD_TEST_RUN_ID = '' || v(''P0_OLD_TEST_RUN_ID'' ) || ''<br>'');'||chr(10)||
'   null;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 5109401519013442 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Common Control',
  p_region_name=>'',
  p_plug_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_DISPLAY = ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5111411983271940 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 1,
  p_cMaxlength=> 1,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is set by each page.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5115915435597711 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TEST_OWNER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Runner Owner:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_POPUP_LOV',
  p_lov=> 'select owner DISPLAY'||chr(10)||
'      ,owner RETURN'||chr(10)||
' from  wt_qual_test_runners_vw'||chr(10)||
' group by owner'||chr(10)||
' order by owner',
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'All Owners',
  p_lov_null_value=> '',
  p_cSize=> 128,
  p_cMaxlength=> 128,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 2,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'NOT_ENTERABLE',
  p_attribute_02 => 'FIRST_ROWSET',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5116105869604358 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TEST_RUNNER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Runner Name:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_POPUP_LOV',
  p_lov=> 'select package_name DISPLAY'||chr(10)||
'      ,package_name RETURN'||chr(10)||
' from  wt_qual_test_runners_vw'||chr(10)||
' where owner = :P0_TEST_OWNER'||chr(10)||
' order by package_name',
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 128,
  p_cMaxlength=> 128,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 2,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'NOT_ENTERABLE',
  p_attribute_02 => 'FIRST_ROWSET',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5116329072611020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TEST_RUN_ID',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Run ID:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_POPUP_LOV',
  p_lov=> 'select id            || '': '' ||'||chr(10)||
'       to_char(start_dtm,''YYYY-MM-DD HH24:MI:SS'')    DISPLAY'||chr(10)||
'      ,id                                            RETURN'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  runner_name  = :P0_TEST_RUNNER'||chr(10)||
' order by id desc',
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 30,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'NOT_ENTERABLE',
  p_attribute_02 => 'FIRST_ROWSET',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.'||chr(10)||
'30 Width = 9 ID + 2 Separator + 19 Date/Time');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5116511887615523 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TEST_CASE',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Case Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_POPUP_LOV',
  p_lov=> 'select testcase    DISPLAY'||chr(10)||
'      ,testcase    RETURN'||chr(10)||
' from  wt_testcase_runs'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
' order by testcase',
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'NOT_ENTERABLE',
  p_attribute_02 => 'FIRST_ROWSET',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5123905176304413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OLD_TEST_OWNER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 1,
  p_cMaxlength=> 1,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5124122837309434 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OLD_TEST_RUNNER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 1,
  p_cMaxlength=> 1,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5124303922313440 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OLD_TEST_RUN_ID',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 1,
  p_cMaxlength=> 1,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5156507341612883 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DBG',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 5109401519013442+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Page 0 Init Debug:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_DISPLAY_ONLY',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 2,
  p_rowspan=> 1,
  p_label_alignment=> 'ABOVE',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'VALUE',
  p_attribute_04 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'This item is initialized by the "Initialize Items" process.');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 5132717988076486 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_name => 'Submit After Test Owner Change'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'ITEM'
 ,p_triggering_element => 'P0_TEST_OWNER'
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'change'
  );
wwv_flow_api.create_page_da_action (
  p_id => 5133011351076491 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_event_id => 5132717988076486 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'REFRESH'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 5133128377079428 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_name => 'Submit After Test Runner Change'
 ,p_event_sequence => 20
 ,p_triggering_element_type => 'ITEM'
 ,p_triggering_element => 'P0_TEST_RUNNER'
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'change'
  );
wwv_flow_api.create_page_da_action (
  p_id => 5133404881079428 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_event_id => 5133128377079428 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'REFRESH'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 5133521236086857 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_name => 'Submit After Test Run ID Change'
 ,p_event_sequence => 30
 ,p_triggering_element_type => 'ITEM'
 ,p_triggering_element => 'P0_TEST_RUN_ID'
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'change'
  );
wwv_flow_api.create_page_da_action (
  p_id => 5133821690086857 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_event_id => 5133521236086857 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'REFRESH'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 5133928854089093 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_name => 'Submit After Test Case Change'
 ,p_event_sequence => 40
 ,p_triggering_element_type => 'ITEM'
 ,p_triggering_element => 'P0_TEST_CASE'
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'change'
  );
wwv_flow_api.create_page_da_action (
  p_id => 5134216946089093 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 0
 ,p_event_id => 5133928854089093 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'REFRESH'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00001
prompt  ...PAGE 1: Dashboard
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 1
 ,p_tab_set => 'TS1'
 ,p_name => 'Dashboard'
 ,p_alias => 'DASHBOARD'
 ,p_step_title => 'Home'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Home'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20181104171304'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'   num_owners   number;'||chr(10)||
'   num_runners  number;'||chr(10)||
'   num_dbouts   number;'||chr(10)||
'   num_cases    number;'||chr(10)||
'begin'||chr(10)||
'   --'||chr(10)||
'   with q1 as ('||chr(10)||
'   select runner_owner'||chr(10)||
'    from  wt_test_runs'||chr(10)||
'    where :P0_TEST_OWNER is NULL'||chr(10)||
'      or  :P0_TEST_OWNER = runner_owner'||chr(10)||
'    group by runner_owner'||chr(10)||
'   )'||chr(10)||
'   --'||chr(10)||
'   select count(*)'||chr(10)||
'    into  num_owners'||chr(10)||
'    from  q1;'||chr(10)||
'   with q1 as ('||chr(10)||
'   select runner_owner, runner_name'||chr(10)||
'    fr';

s:=s||'om  wt_test_runs'||chr(10)||
'    where :P0_TEST_OWNER is NULL'||chr(10)||
'      or  :P0_TEST_OWNER = runner_owner'||chr(10)||
'    group by runner_owner, runner_name'||chr(10)||
'   )'||chr(10)||
'   select count(*)'||chr(10)||
'    into  num_runners'||chr(10)||
'    from  q1;'||chr(10)||
'   --'||chr(10)||
'   with q1 as ('||chr(10)||
'   select dbout_owner, dbout_name, dbout_type'||chr(10)||
'    from  wt_test_runs'||chr(10)||
'    where :P0_TEST_OWNER is NULL'||chr(10)||
'      or  :P0_TEST_OWNER = runner_owner'||chr(10)||
'    group by dbout_owner, dbout_name, dbout_typ';

s:=s||'e'||chr(10)||
'   )'||chr(10)||
'   select count(*)'||chr(10)||
'    into  num_dbouts'||chr(10)||
'    from  q1;'||chr(10)||
'   --'||chr(10)||
'   with q1 as ('||chr(10)||
'   select runner_owner, runner_name, testcase'||chr(10)||
'    from  wt_test_runs  run'||chr(10)||
'          join wt_testcase_runs  case'||chr(10)||
'               on  case.test_run_id = run.id'||chr(10)||
'    where :P0_TEST_OWNER is NULL'||chr(10)||
'      or  :P0_TEST_OWNER = runner_owner'||chr(10)||
'    group by runner_owner, runner_name, testcase'||chr(10)||
'   )'||chr(10)||
'   select count(*)'||chr(10)||
'    into  num';

s:=s||'_cases'||chr(10)||
'    from  q1;'||chr(10)||
'   --'||chr(10)||
'   htp.p(''<b><br>&nbsp;'');'||chr(10)||
'   htp.p(''Number of Test Owners: '' || num_owners || ''<br>'');'||chr(10)||
'   htp.p(''<br>&nbsp;'');'||chr(10)||
'   htp.p(''Number of Test Runners: '' || num_runners || ''<br>'');'||chr(10)||
'   htp.p(''<br>&nbsp;'');'||chr(10)||
'   htp.p(''Number of Test Cases: '' || num_cases || ''<br>'');'||chr(10)||
'   htp.p(''<br>&nbsp;'');'||chr(10)||
'   htp.p(''Number of Tested DBOUTs: '' || num_dbouts || ''<br>'');'||chr(10)||
'   htp.p(''<br>&nbsp;</b>'');'||chr(10)||
'';

s:=s||'end;';

wwv_flow_api.create_page_plug (
  p_id=> 4846907308414925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Summary',
  p_region_name=>'',
  p_plug_template=> 4839912075414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_column_width => 'td width="320"',
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:1:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:1:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4854109180566690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Test Runners Status Summary',
  p_region_name=>'',
  p_plug_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4854324865566692+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4854109180566690+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DPie',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4854324865566692',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::::Left::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'::',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'::',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q_main as ('||chr(10)||
'select sum(res.passes)    PASS'||chr(10)||
'      ,sum(res.failures)  FAIL'||chr(10)||
'      ,sum(res.errors)    ERR'||chr(10)||
' from  wt_test_runs  tr'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = tr.id'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = tr.runner_owner )'||chr(10)||
'  and  tr.is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'), q1 as ('||chr(10)||
'select NULL       LINK'||chr(10)||
'      ,''PASS''     LABEL'||chr(10)||
'    ';

a1:=a1||'  ,pass       VALUE'||chr(10)||
' from  q_main'||chr(10)||
'union all'||chr(10)||
'select NULL       LINK'||chr(10)||
'      ,''FAIL''     LABEL'||chr(10)||
'      ,fail       VALUE'||chr(10)||
' from  q_main'||chr(10)||
'union all'||chr(10)||
'select NULL       LINK'||chr(10)||
'      ,''ERR''      LABEL'||chr(10)||
'      ,err        VALUE'||chr(10)||
' from  q_main'||chr(10)||
')'||chr(10)||
'select link, label, value'||chr(10)||
' from  q1'||chr(10)||
' order by label desc';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4854410354566693+wwv_flow_api.g_id_offset,
  p_chart_id => 4854324865566692+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4855306596029607 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'DBOUT Profiles Status Summary',
  p_region_name=>'',
  p_plug_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4855509614029610+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4855306596029607+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DPie',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4854324865566692',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::::Left::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#0099FF,#99FF99,#FF6699,#FFFF99',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'::',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'::',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q_main as ('||chr(10)||
'select sum(res.excluded_lines)   EXCL'||chr(10)||
'      ,sum(res.executed_lines)   EXEC'||chr(10)||
'      ,sum(res.notexec_lines)    NOTX'||chr(10)||
'      ,sum(res.unknown_lines)    UNKN'||chr(10)||
' from  wt_test_runs  tr'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = tr.id'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = runner_owner )'||chr(10)||
'  and  is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'), q1 as';

a1:=a1||' ('||chr(10)||
'select NULL    LINK'||chr(10)||
'      ,''EXCL''  LABEL'||chr(10)||
'      ,excl    VALUE'||chr(10)||
' from  q_main'||chr(10)||
'union all'||chr(10)||
'select NULL    LINK'||chr(10)||
'      ,''EXEC''  LABEL'||chr(10)||
'      ,exec    VALUE'||chr(10)||
' from  q_main'||chr(10)||
'union all'||chr(10)||
'select NULL    LINK'||chr(10)||
'      ,''NOTX''  LABEL'||chr(10)||
'      ,notx    VALUE'||chr(10)||
' from  q_main'||chr(10)||
'union all'||chr(10)||
'select NULL    LINK'||chr(10)||
'      ,''UNKN''  LABEL'||chr(10)||
'      ,unkn    VALUE'||chr(10)||
' from  q_main'||chr(10)||
')'||chr(10)||
'select link, label, value'||chr(10)||
' from  q1'||chr(10)||
' order by label';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4855610331029611+wwv_flow_api.g_id_offset,
  p_chart_id => 4855509614029610+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:1:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:1:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4857720139336331 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top Test Runner Failures',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4857903544336332+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4857720139336331+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#FFFF00',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Failures',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select tr.id                        LINK'||chr(10)||
'      ,tr.runner_owner || ''.'' ||'||chr(10)||
'       tr.runner_name               LABEL'||chr(10)||
'      ,res.failures                 VALUE'||chr(10)||
' from  wt_test_runs  tr'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = tr.id'||chr(10)||
'            and res.failures    > 0'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = tr.runner_owner )'||chr(10)||
'  and  tr.is_last_run = wtp';

a1:=a1||'lsql.get_last_run_flag'||chr(10)||
' order by res.failures desc, LABEL'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4858000738336332+wwv_flow_api.g_id_offset,
  p_chart_id => 4857903544336332+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4858315631526698 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top Test Runner Durations',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 4,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4858521402526708+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4858315631526698+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#3366FF',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>1,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Seconds',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>1,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select id                                     LINK'||chr(10)||
'      ,runner_owner || ''.'' || runner_name     LABEL'||chr(10)||
'      ,extract(day from (end_dtm - start_dtm)*86400*100)/100'||chr(10)||
'                                              VALUE'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = runner_owner )'||chr(10)||
'  and  is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'  and  extract(day from (end_dtm - start';

a1:=a1||'_dtm)*86400*100)/100 > 0'||chr(10)||
' order by VALUE desc, LABEL'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4858612747526709+wwv_flow_api.g_id_offset,
  p_chart_id => 4858521402526708+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4859830202458220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top Test Runner Age',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4860011375458221+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4859830202458220+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#CCCCCC',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>1,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Days',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>1,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select id                           LINK'||chr(10)||
'      ,runner_owner || ''.'' ||'||chr(10)||
'       runner_name                  LABEL'||chr(10)||
'      ,extract(day from (sysdate - start_dtm)*10)/10'||chr(10)||
'                                    VALUE'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = runner_owner )'||chr(10)||
'  and  is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'  and  start_dtm is not null'||chr(10)||
'  and  extract(day ';

a1:=a1||'from (sysdate - start_dtm)*10)/10 > 0'||chr(10)||
' order by VALUE desc, LABEL'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4860108666458221+wwv_flow_api.g_id_offset,
  p_chart_id => 4860011375458221+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4860309181584610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top DBOUT NotExec Lines',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_DBOUTS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4860500924584610+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4860309181584610+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#FF0066',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Source Lines',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select run.id                       LINK'||chr(10)||
'      ,run.dbout_owner || ''.'' ||'||chr(10)||
'       run.dbout_name  || ''('' ||'||chr(10)||
'       run.dbout_type  || '')''       LABEL'||chr(10)||
'      ,res.notexec_lines            VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id   = run.id'||chr(10)||
'            and res.notexec_lines > 0'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = run.ru';

a1:=a1||'nner_owner )'||chr(10)||
'  and  run.is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'  and  run.dbout_name is not null'||chr(10)||
' order by res.notexec_lines desc, LABEL'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4860628410584610+wwv_flow_api.g_id_offset,
  p_chart_id => 4860500924584610+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4861210200133728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top Test Case Failures',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4861429150133729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4861210200133728+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#FFFF00',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Failures',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''f?p='' || :APP_ID               ||'||chr(10)||
'          '':'' || ''6''                   ||     -- Page'||chr(10)||
'          '':'' || :APP_SESSION          ||'||chr(10)||
'          '':'' || :REQUEST              ||'||chr(10)||
'          '':'' || :DEBUG                ||'||chr(10)||
'          '':'' || ''N''                   ||     -- CLear Cache'||chr(10)||
'          '':'' || ''P0_TEST_RUN_ID''      || '','' ||'||chr(10)||
'                 ''P0_TEST_CASE''        ||     -- Item Names'||chr(10)||
'        ';

a1:=a1||'  '':'' || run.id                || '','' ||'||chr(10)||
'                 tc.testcase           ||     -- Item Values'||chr(10)||
'          '':'' || V(''PRINTER_FRIENDLY'')    LINK'||chr(10)||
'      ,run.runner_owner || ''.'' ||'||chr(10)||
'       run.runner_name  || '':'' ||'||chr(10)||
'       tc.testcase                        LABEL'||chr(10)||
'      ,tc.failures                        VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  tc'||chr(10)||
'            on  tc.test_run_';

a1:=a1||'id = run.id'||chr(10)||
'            and tc.failures    > 0'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = runner_owner )'||chr(10)||
'  and  is_last_run = wtplsql.get_last_run_flag'||chr(10)||
' order by failures desc, TESTCASE'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4861511054133729+wwv_flow_api.g_id_offset,
  p_chart_id => 4861429150133729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4861614487144344 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Top DBOUT LineExec Times',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 6,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P1_NUM_RUNNERS > 0',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4861806074144344+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1,
  p_region_id => 4861614487144344+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>150,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#3366FF',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Milliseconds',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>90,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select res.test_run_id                  LINK'||chr(10)||
'      ,run.dbout_owner || ''.'' ||'||chr(10)||
'       run.dbout_name  || ''('' ||'||chr(10)||
'       run.dbout_type  || '')''           LABEL'||chr(10)||
'      ,res.max_executed_usecs/1000      VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id        = run.id'||chr(10)||
'            and res.max_executed_usecs > 0'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :';

a1:=a1||'P0_TEST_OWNER = run.runner_owner )'||chr(10)||
'  and  run.is_last_run = wtplsql.get_last_run_flag'||chr(10)||
' order by VALUE desc, LABEL'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4861925325144344+wwv_flow_api.g_id_offset,
  p_chart_id => 4861806074144344+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select log_id'||chr(10)||
'      ,start_date'||chr(10)||
'      ,job_name'||chr(10)||
'      ,status'||chr(10)||
'      ,inst'||chr(10)||
'      ,session_id'||chr(10)||
'      ,os_pid'||chr(10)||
'      ,error_num'||chr(10)||
'      ,additional_info'||chr(10)||
' from  wt_scheduler_jobs'||chr(10)||
' where status not in (''SUCCEEDED'',''FAILED'')'||chr(10)||
'  and  (   :P0_TEST_OWNER is null'||chr(10)||
'        or job_name like :P0_TEST_OWNER || ''$%'' )';

wwv_flow_api.create_report_region (
  p_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_name=> 'Incomplete Test Runner Jobs',
  p_region_name=>'',
  p_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 51,
  p_report_attributes=>'style="color:#0088FF"',
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_LEFT',
  p_csv_output=> 'N',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5037626427564981 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'LOG_ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Log ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5039813342816631 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'START_DATE',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Start Date',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5037901990564982 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'JOB_NAME',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Job Name',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4881232628476372 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'STATUS',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Status',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5038027139564982 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'INST',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Inst',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5038112499564982 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'SESSION_ID',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Session ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5039922124816631 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'OS_PID',
  p_column_display_sequence=> 7,
  p_column_heading=> 'OS PID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5040017675816631 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'ERROR_NUM',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Error Num',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5038421217564982 + wwv_flow_api.g_id_offset,
  p_region_id=> 4868303731390297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'ADDITIONAL_INFO',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Additional Info',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select id'||chr(10)||
'      ,runner_owner || ''.'' ||'||chr(10)||
'       runner_name             TEST_RUNNER'||chr(10)||
'      ,dbout_owner || ''.'' ||'||chr(10)||
'       dbout_name  || ''('' ||'||chr(10)||
'       dbout_type  || '')''      DBOUT_PROFILED'||chr(10)||
'      ,start_dtm'||chr(10)||
'      ,error_message'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where (   :P0_TEST_OWNER is NULL'||chr(10)||
'        or :P0_TEST_OWNER = runner_owner )'||chr(10)||
'  and  is_last_run = wtplsql.get_last_run_flag'||chr(10)||
'  and  error_message is not nul';

s:=s||'l';

wwv_flow_api.create_report_region (
  p_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_name=> 'Test Runner Errors',
  p_region_name=>'',
  p_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 52,
  p_report_attributes=>'style="color:#FF0000"',
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_LEFT',
  p_csv_output=> 'N',
  p_prn_output=> 'N',
  p_prn_format=> 'PDF',
  p_prn_output_show_link=> 'Y',
  p_prn_output_link_text=> 'Print',
  p_prn_content_disposition=> 'ATTACHMENT',
  p_prn_document_header=> 'APEX',
  p_prn_units=> 'INCHES',
  p_prn_paper_size=> 'LETTER',
  p_prn_width_units=> 'PERCENTAGE',
  p_prn_width=> 11,
  p_prn_height=> 8.5,
  p_prn_orientation=> 'HORIZONTAL',
  p_prn_page_header_font_color=> '#000000',
  p_prn_page_header_font_family=> 'Helvetica',
  p_prn_page_header_font_weight=> 'normal',
  p_prn_page_header_font_size=> '12',
  p_prn_page_footer_font_color=> '#000000',
  p_prn_page_footer_font_family=> 'Helvetica',
  p_prn_page_footer_font_weight=> 'normal',
  p_prn_page_footer_font_size=> '12',
  p_prn_header_bg_color=> '#9bafde',
  p_prn_header_font_color=> '#ffffff',
  p_prn_header_font_family=> 'Helvetica',
  p_prn_header_font_weight=> 'normal',
  p_prn_header_font_size=> '10',
  p_prn_body_bg_color=> '#efefef',
  p_prn_body_font_color=> '#000000',
  p_prn_body_font_family=> 'Helvetica',
  p_prn_body_font_weight=> 'normal',
  p_prn_body_font_size=> '10',
  p_prn_border_width=> .5,
  p_prn_page_header_alignment=> 'CENTER',
  p_prn_page_footer_alignment=> 'CENTER',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
 
-- maintain plug_column_width attribute for 2.2 and greater
begin
execute immediate 'begin wwv_flow_api.set_region_column_width (
  p_id=>4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_page_id=>1,
  p_plug_column_width=>''style="color:red"''); end;';
exception when others then null;
end;
/
 
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4871606819864244 + wwv_flow_api.g_id_offset,
  p_region_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Test Run ID',
  p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#ID#',
  p_column_linktext=>'#ID#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>2,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '20',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4869808842509943 + wwv_flow_api.g_id_offset,
  p_region_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'TEST_RUNNER',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Test Runner Package',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '20',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4869907123509943 + wwv_flow_api.g_id_offset,
  p_region_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'DBOUT_PROFILED',
  p_column_display_sequence=> 3,
  p_column_heading=> 'DB Object Under Test',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '20',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4870003732509943 + wwv_flow_api.g_id_offset,
  p_region_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'START_DTM',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Start Date/Time',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '20',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4870105383509943 + wwv_flow_api.g_id_offset,
  p_region_id=> 4869425043509942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'ERROR_MESSAGE',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Error Message',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '20',
  p_column_comment=>'');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4852128982276097 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_branch_action=> 'f?p=&FLOW_ID.:1:&SESSION.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5111815015291792 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_computation_sequence => 10,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'Y',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00002
prompt  ...PAGE 2: Run Test
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 2
 ,p_tab_set => 'TS1'
 ,p_name => 'Run Test'
 ,p_alias => 'RUNTEST'
 ,p_step_title => 'Run Test'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Run Test'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20181104135425'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'   last_run_id   number;'||chr(10)||
'begin'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   if     :P2_DB_LINK_HOST is null'||chr(10)||
'      and :P0_TEST_OWNER is not null'||chr(10)||
'   then'||chr(10)||
'      htp.p(''<font color=#ff0000><b>*** DB Link is missing. ***<b></font>'');'||chr(10)||
'      htp.p(''<br>'');'||chr(10)||
'      htp.p(''<br>'');'||chr(10)||
'   end if;'||chr(10)||
'   htp.p('' &nbsp; <b>Last Run ID: </b>'');'||chr(10)||
'   select id into last_run_id'||chr(10)||
'    from  wt_test_runs'||chr(10)||
'    where runner_own';

s:=s||'er = :P0_TEST_OWNER'||chr(10)||
'     and  runner_name  = :P0_TEST_RUNNER'||chr(10)||
'     and  is_last_run = ''Y'';'||chr(10)||
'   -- last_run_id cannot be null, or NO_DATA_FOUND'||chr(10)||
'   --   would have been raised (ID is a Primary Key)'||chr(10)||
'   if last_run_id != nvl(:P0_TEST_RUN_ID,-1)'||chr(10)||
'   then'||chr(10)||
'      htp.p(''<a href="f?p='' || :APP_ID               ||'||chr(10)||
'                        '':'' || ''3''                   ||     -- Page'||chr(10)||
'                        '':'' |';

s:=s||'| :APP_SESSION          ||'||chr(10)||
'                        '':'' || :REQUEST              ||'||chr(10)||
'                        '':'' || :DEBUG                ||'||chr(10)||
'                        '':'' || ''N''                   ||     -- CLear Cache'||chr(10)||
'                        '':'' || ''P0_TEST_RUN_ID''      ||     -- Item Names'||chr(10)||
'                        '':'' || last_run_id           ||     -- Item Values'||chr(10)||
'                        '':'' || V(''PRI';

s:=s||'NTER_FRIENDLY'') ||'||chr(10)||
'                       ''">'' || last_run_id           ||'||chr(10)||
'                                  '' (Click to View)'' || ''</a><br>'');'||chr(10)||
'   else'||chr(10)||
'      htp.p(''Same ID<br>'');'||chr(10)||
'   end if;'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'exception when NO_DATA_FOUND'||chr(10)||
'then'||chr(10)||
'   htp.p(''Last Test Run Not found<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 4847515458414925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_plug_name=> 'Run Test',
  p_region_name=>'',
  p_plug_template=> 4839912075414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_column_width => 'td width="320"',
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select log_id'||chr(10)||
'      ,start_date'||chr(10)||
'      ,job_name'||chr(10)||
'      ,status'||chr(10)||
'      ,inst'||chr(10)||
'      ,session_id'||chr(10)||
'      ,os_pid'||chr(10)||
'      ,error_num'||chr(10)||
'      ,additional_info'||chr(10)||
' from  wt_scheduler_jobs'||chr(10)||
'-- where job_name like :APP_USER || ''$%''';

wwv_flow_api.create_page_plug (
  p_id=> 4885513244116318 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_plug_name=> 'DBMS_SCHEDULER Jobs',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select log_id'||chr(10)||
'      ,start_date'||chr(10)||
'      ,job_name'||chr(10)||
'      ,status'||chr(10)||
'      ,inst'||chr(10)||
'      ,session_id'||chr(10)||
'      ,os_pid'||chr(10)||
'      ,error_num'||chr(10)||
'      ,additional_info'||chr(10)||
' from  wt_scheduler_jobs'||chr(10)||
'-- where job_name like :APP_USER || ''$%''';

wwv_flow_api.create_worksheet(
  p_id=> 4885631457116318+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_region_id=> 4885513244116318+wwv_flow_api.g_id_offset,
  p_name=> 'List of APEX PLSQL Jobs',
  p_folder_id=> null, 
  p_alias=> '',
  p_report_id_item=> '',
  p_max_row_count=> '10000',
  p_max_row_count_message=> 'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.',
  p_no_data_found_message=> 'No data found.',
  p_max_rows_per_page=>'10',
  p_search_button_label=>'',
  p_page_items_to_submit=>'',
  p_sort_asc_image=>'',
  p_sort_asc_image_attr=>'',
  p_sort_desc_image=>'',
  p_sort_desc_image_attr=>'',
  p_sql_query => a1,
  p_status=>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving=>'Y',
  p_allow_save_rpt_public=>'N',
  p_allow_report_categories=>'N',
  p_show_nulls_as=>'-',
  p_pagination_type=>'ROWS_X_TO_Y',
  p_pagination_display_pos=>'BOTTOM_LEFT',
  p_show_finder_drop_down=>'Y',
  p_show_display_row_count=>'N',
  p_show_search_bar=>'Y',
  p_show_search_textbox=>'Y',
  p_show_actions_menu=>'Y',
  p_report_list_mode=>'TABS',
  p_show_detail_link=>'N',
  p_show_select_columns=>'Y',
  p_show_rows_per_page=>'Y',
  p_show_filter=>'Y',
  p_show_sort=>'Y',
  p_show_control_break=>'Y',
  p_show_highlight=>'Y',
  p_show_computation=>'Y',
  p_show_aggregate=>'Y',
  p_show_chart=>'Y',
  p_show_group_by=>'Y',
  p_show_notify=>'N',
  p_show_calendar=>'N',
  p_show_flashback=>'Y',
  p_show_reset=>'Y',
  p_show_download=>'Y',
  p_show_help=>'Y',
  p_download_formats=>'CSV:HTML:EMAIL',
  p_allow_exclude_null_values=>'N',
  p_allow_hide_extra_columns=>'N',
  p_icon_view_enabled_yn=>'N',
  p_icon_view_columns_per_row=>1,
  p_detail_view_enabled_yn=>'N',
  p_owner=>'WTP');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5032410666172454+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'LOG_ID',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Log ID',
  p_report_label           =>'Log ID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5039132211784254+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'START_DATE',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>'Start Date',
  p_report_label           =>'Start Date',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5032729825172455+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'JOB_NAME',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Job Name',
  p_report_label           =>'Job Name',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4885819894116324+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'STATUS',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5039226462784262+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'INST',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Inst',
  p_report_label           =>'Inst',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5040419669875210+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'SESSION_ID',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Session ID',
  p_report_label           =>'Session ID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5040526819875210+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'OS_PID',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'OS PID',
  p_report_label           =>'OS PID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5039401783784262+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ERROR_NUM',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Error Num',
  p_report_label           =>'Error Num',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5033208190172456+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ADDITIONAL_INFO',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Additional Info',
  p_report_label           =>'Additional Info',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'LOG_ID:START_DATE:JOB_NAME:STATUS:INST:SESSION_ID:OS_PID:ERROR_NUM:ADDITIONAL_INFO';

wwv_flow_api.create_worksheet_rpt(
  p_id => 4886308472128052+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'48864',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>10,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'LOG_ID',
  p_sort_direction_1        =>'DESC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'DESC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 5039623254809995+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_worksheet_id => 4885631457116318+wwv_flow_api.g_id_offset,
  p_report_id => 4886308472128052+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'=',
  p_expr                    =>'RUNNING',
  p_condition_sql           =>'"STATUS" = #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# = ''RUNNING''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 5024330300632423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_plug_name=> 'Test Runner Jobs Setup',
  p_region_name=>'',
  p_plug_template=> 4839912075414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select proc.owner             TEST_RUNNER_OWNER'||chr(10)||
'      ,dbl.db_link'||chr(10)||
'      ,dbl.username'||chr(10)||
'      ,dbl.host'||chr(10)||
'      ,dbl.created'||chr(10)||
'      ,case when dbl.username is null'||chr(10)||
'            then'||chr(10)||
'               ''<font color=#ff0000><b>Username missing</b></font>'''||chr(10)||
'            when dbl.host is null'||chr(10)||
'            then'||chr(10)||
'               ''<font color=#ff0000><b>Host value missing</b></font>'''||chr(10)||
'            when dbl.db_link || ''.';

s:=s||''' not like dbl.username || ''.%'''||chr(10)||
'            then'||chr(10)||
'               ''<font color=#ff0000><b>DB Link != Username</b></font>'''||chr(10)||
'            else'||chr(10)||
'               ''<font color=##00cc66>Good Link</font>'''||chr(10)||
'            end              LINK_STATUS'||chr(10)||
' from  wt_qual_test_runners_vw  proc'||chr(10)||
'  left join user_db_links  dbl'||chr(10)||
'            on  dbl.db_link  = proc.owner'||chr(10)||
'            or  dbl.username = proc.owner'||chr(10)||
' group by proc.';

s:=s||'owner'||chr(10)||
'      ,dbl.db_link'||chr(10)||
'      ,dbl.username'||chr(10)||
'      ,dbl.host'||chr(10)||
'      ,dbl.created';

wwv_flow_api.create_report_region (
  p_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_name=> 'All Test Runner Owners',
  p_region_name=>'',
  p_template=> 4840201642414912+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 30,
  p_display_column=> 1,
  p_display_point=> 'BEFORE_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P2_SHOW_OWNERS',
  p_display_when_cond2=> 'Y',
  p_display_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5182216515391627 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'TEST_RUNNER_OWNER',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Test Runner Owner',
  p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P0_TEST_OWNER:#TEST_RUNNER_OWNER#',
  p_column_linktext=>'#TEST_RUNNER_OWNER#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5181215424303709 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'DB_LINK',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Db Link',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5181332039303709 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'USERNAME',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Username',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5181428671303709 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'HOST',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Host',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5181522703303709 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'CREATED',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Created',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5181806987351019 + wwv_flow_api.g_id_offset,
  p_region_id=> 5180621438298420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'LINK_STATUS',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Link Status',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 5173925590382378 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 2,
  p_button_sequence=> 10,
  p_button_plug_id => 4847515458414925+wwv_flow_api.g_id_offset,
  p_button_name    => 'RUN_TEST',
  p_button_image   => 'template:'||to_char(4838226535414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Run Test',
  p_button_position=> 'ABOVE_BOX',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_button_condition=> 'P2_DB_LINK_HOST',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 4943012566012609 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 2,
  p_button_sequence=> 20,
  p_button_plug_id => 4847515458414925+wwv_flow_api.g_id_offset,
  p_button_name    => 'P3_TEST_ALL',
  p_button_image   => 'template:'||to_char(4838306817414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Run All Tests for This Owner',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:confirmDelete(''Run all Tests for Owner &P0_TEST_OWNER.'', ''TEST_ALL'')',
  p_button_execute_validations=>'Y',
  p_button_condition=> 'P2_DB_LINK_HOST',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5182629852433290 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 2,
  p_button_sequence=> 30,
  p_button_plug_id => 5180621438298420+wwv_flow_api.g_id_offset,
  p_button_name    => 'P2_TEST_ALL_SEQ',
  p_button_image   => 'template:'||to_char(4838306817414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Run All Tests for All Owners Sequentially',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:confirmDelete(''Run all Tests for all Owners, one after another'', ''TEST_ALL_SEQ'')',
  p_button_execute_validations=>'Y',
  p_button_condition=> 'P2_DB_LINK_HOST',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5183117778458242 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 2,
  p_button_sequence=> 40,
  p_button_plug_id => 5180621438298420+wwv_flow_api.g_id_offset,
  p_button_name    => 'P2_TEST_ALL_PAR',
  p_button_image   => 'template:'||to_char(4838306817414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Run All Tests for All Owners in Parallel',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:confirmDelete(''Run all Tests for all Owners with all Owners running at the same time'', ''TEST_ALL_PAR'')',
  p_button_execute_validations=>'Y',
  p_button_condition=> 'P2_DB_LINK_HOST',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4941327317931667 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_branch_condition=> 'TEST_ALL',
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> 'Created 07-JUL-2018 11:52 by WTP');
 
wwv_flow_api.create_page_branch(
  p_id=>4877001457701994 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_branch_action=> 'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4884208416023999 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_JOBS_PARAMETER',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_DISPLAY_ONLY',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'PLSQL',
  p_attribute_03 => 'begin'||chr(10)||
'   htp.p(''<b>Job Queue Process Parameter:<b><br>'');'||chr(10)||
'   htp.p(''<ul>'');'||chr(10)||
'   for buff in ('||chr(10)||
'      select inst_id, value'||chr(10)||
'       from  sys.gv_$parameter'||chr(10)||
'       where name = ''job_queue_processes'''||chr(10)||
'       order by inst_id )'||chr(10)||
'   loop'||chr(10)||
'      -- Set these as list items'||chr(10)||
'      htp.p(''<li>'');'||chr(10)||
'      if buff.value > 0'||chr(10)||
'      then'||chr(10)||
'         htp.p(''<font color=#00cc66>Instance '' || buff.inst_id ||'||chr(10)||
'                                          '': '' || buff.value   ||'||chr(10)||
'                                  ''</font>'');'||chr(10)||
'      else'||chr(10)||
'         htp.p(''<font color=#ff0000><b>Instance '' || buff.inst_id ||'||chr(10)||
'                                             '': '' || buff.value   ||'||chr(10)||
'                                   ''</b></font>'');'||chr(10)||
'      end if;'||chr(10)||
'      htp.p(''</li>'');'||chr(10)||
'   end loop;'||chr(10)||
'   htp.p(''</ul>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'end;',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5026010934853871 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_RESET_DB_LINK',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default=> 'RESET_DB_LINK',
  p_prompt=>'Reset DB Link',
  p_source=>'RESET_DB_LINK',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_display_when=>'P0_TEST_OWNER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_is_persistent=> 'N',
  p_button_execute_validations=>'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5027508136976108 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_PASSWORD',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Password:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_PASSWORD',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 15,
  p_cMaxlength=> 128,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_display_when=>'P0_TEST_OWNER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5028532733058845 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_NEW_DB_LINK_HOST',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New DB Link Host:',
  p_source=>'''//localhost:1521/'' || SYS_CONTEXT(''USERENV'',''SERVICE_NAME'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'NATIVE_TEXT_FIELD',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 20,
  p_cMaxlength=> 50,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_display_when=>'P0_TEST_OWNER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5029510053130586 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_DB_LINK_HOST',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DB Link Host:',
  p_pre_element_text=>'<font color=##00cc66>',
  p_post_element_text=>'</font>',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_DISPLAY_ONLY',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_display_when=>'P0_TEST_OWNER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'VALUE',
  p_attribute_04 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => 'Set by a page computation before header.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5044818450655759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_DB_LINK_NAME',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 5024330300632423+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DB Link Name:',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_DISPLAY_ONLY',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_display_when=>'P0_TEST_OWNER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'PLSQL',
  p_attribute_03 => 'begin'||chr(10)||
'   htp.p(:P0_TEST_OWNER);'||chr(10)||
'end;',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5179801820226564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_SHOW_OWNERS',
  p_data_type=> 'VARCHAR',
  p_is_required=> true,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4847515458414925+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Show All Test Runner Owners:',
  p_source=>'N',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_RADIOGROUP',
  p_named_lov=> 'Y_OR_N',
  p_lov=> '.'||to_char(4923728354614299 + wwv_flow_api.g_id_offset)||'.',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => '2',
  p_attribute_02 => 'SUBMIT',
  p_attribute_03 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5112015839301513 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_computation_sequence => 10,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'Y',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5174632347422111 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_computation_sequence => 10,
  p_computation_item=> 'P2_DB_LINK_HOST',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select host'||chr(10)||
' from  user_db_links'||chr(10)||
' where db_link || ''.'' like :P0_TEST_OWNER || ''.%'''||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'   run_str  varchar2(2000) := ''wtplsql.test_run@'' ||'||chr(10)||
'                               :P0_TEST_OWNER     || ''('''''' ||'||chr(10)||
'                               :P0_TEST_RUNNER    || '''''')'' ;'||chr(10)||
'BEGIN'||chr(10)||
'   DBMS_SCHEDULER.CREATE_JOB'||chr(10)||
'      (job_name    =>  substr(:P0_TEST_OWNER || ''$'' || :P0_TEST_RUNNER, 1, 30)'||chr(10)||
'      ,job_type    =>  ''PLSQL_BLOCK'''||chr(10)||
'      ,job_action  =>  ''begin '' || run_str || ''; commit; end;'''||chr(10)||
'  ';

p:=p||'    ,comments    =>  run_str'||chr(10)||
'      ,enabled     =>  TRUE);'||chr(10)||
'   COMMIT;'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 4876513059692293 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'RUN_TEST',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'RUN_TEST',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'   run_str  varchar2(2000) := ''wtplsql.test_all@'' || :P0_TEST_OWNER;'||chr(10)||
'BEGIN'||chr(10)||
'   DBMS_SCHEDULER.CREATE_JOB'||chr(10)||
'      (job_name    =>  substr(:P0_TEST_OWNER || ''$TEST$ALL'', 1, 30)'||chr(10)||
'      ,job_type    =>  ''PLSQL_BLOCK'''||chr(10)||
'      ,job_action  =>  ''begin '' || run_str || ''; commit; end;'''||chr(10)||
'      ,comments    =>  run_str'||chr(10)||
'      ,enabled     =>  TRUE);'||chr(10)||
'   COMMIT;'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 4941719483938905 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'TEST_ALL',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to submit job (&P2_LAST_JOB_ID.)',
  p_process_when=>'TEST_ALL',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> 'Successful submitted job &P2_LAST_JOB_ID.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'   run_str  varchar2(32000);'||chr(10)||
'BEGIN'||chr(10)||
'   -- String all the "Test Alls" into one PL/SQL Block'||chr(10)||
'   for buff in ('||chr(10)||
'      select proc.owner             TEST_OWNER'||chr(10)||
'       from  wt_qual_test_runners_vw  proc'||chr(10)||
'             join user_db_links  dbl'||chr(10)||
'                  on  dbl.db_link  = proc.owner'||chr(10)||
'                  and dbl.db_link || ''.'' like dbl.username || ''.%'''||chr(10)||
'                  and dbl.username is not n';

p:=p||'ull'||chr(10)||
'                  and dbl.host     is not null'||chr(10)||
'       group by proc.owner'||chr(10)||
'       order by proc.owner )'||chr(10)||
'   loop'||chr(10)||
'      run_str := run_str || ''wtplsql.test_all@'' || buff.TEST_OWNER || '';'' || CHR(10);'||chr(10)||
'   end loop;'||chr(10)||
'   -- Create 1 Scheduler Job'||chr(10)||
'   DBMS_SCHEDULER.CREATE_JOB'||chr(10)||
'      (job_name    =>  ''TEST_ALL_SEQ'''||chr(10)||
'      ,job_type    =>  ''PLSQL_BLOCK'''||chr(10)||
'      ,job_action  =>  ''begin'' || CHR(10) || run_str ';

p:=p||'|| ''commit;'' || CHR(10) || ''end;'''||chr(10)||
'      ,comments    =>  ''Sequential Tests for All Owners'''||chr(10)||
'      ,enabled     =>  TRUE);'||chr(10)||
'   COMMIT;'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 5183316524467299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'TEST_ALL_SEQ',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to submit job (&P2_LAST_JOB_ID.)',
  p_process_when=>'TEST_ALL_SEQ',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> 'Successfully submitted job &P2_LAST_JOB_ID.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'   run_str  varchar2(32000);'||chr(10)||
'BEGIN'||chr(10)||
'   for buff in ('||chr(10)||
'      select proc.owner             TEST_OWNER'||chr(10)||
'       from  wt_qual_test_runners_vw  proc'||chr(10)||
'             join user_db_links  dbl'||chr(10)||
'                  on  dbl.db_link || ''.'' like proc.owner   || ''.%'''||chr(10)||
'                  and dbl.db_link || ''.'' like dbl.username || ''.%'''||chr(10)||
'                  and dbl.username is not null'||chr(10)||
'                  and dbl.host  ';

p:=p||'   is not null'||chr(10)||
'       group by proc.owner )'||chr(10)||
'   loop'||chr(10)||
'      -- Create a Scheduler Job for each Test Owner'||chr(10)||
'      run_str := ''wtplsql.test_all@'' || buff.TEST_OWNER;'||chr(10)||
'      DBMS_SCHEDULER.CREATE_JOB'||chr(10)||
'         (job_name    =>  substr(buff.TEST_OWNER || ''$PAR$TEST$ALL'', 1, 30)'||chr(10)||
'         ,job_type    =>  ''PLSQL_BLOCK'''||chr(10)||
'         ,job_action  =>  ''begin '' || run_str || ''; commit; end;'''||chr(10)||
'         ,comments    => ';

p:=p||' buff.TEST_OWNER || '': Parallel Tests for All Owners'''||chr(10)||
'         ,enabled     =>  TRUE);'||chr(10)||
'   end loop;'||chr(10)||
'   COMMIT;'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 5184104609728862 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'TEST_ALL_PAR',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to submit job (&P2_LAST_JOB_ID.)',
  p_process_when=>'TEST_ALL_PAR',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> 'Successful submitted job &P2_LAST_JOB_ID.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'   --'||chr(10)||
'   begin'||chr(10)||
'      execute immediate ''drop database link '' || :P0_TEST_OWNER;'||chr(10)||
'   exception when OTHERS then'||chr(10)||
'      if SQLERRM = ''ORA-02024: database link not found'''||chr(10)||
'      then'||chr(10)||
'         null;  -- Ignore Exception'||chr(10)||
'      else'||chr(10)||
'         raise;'||chr(10)||
'      end if;'||chr(10)||
'   end;'||chr(10)||
'   --'||chr(10)||
'   execute immediate ''create database link '' || :P0_TEST_OWNER       ||'||chr(10)||
'                              '' connect to '' || :P0_TE';

p:=p||'ST_OWNER       ||'||chr(10)||
'                           '' identified by '' || :P2_PASSWORD         ||'||chr(10)||
'                                 '' using '''''' || :P2_NEW_DB_LINK_HOST || '''''''';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5027926237038111 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 90,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'RESET_DB_LINK',
  p_process_sql_clob => p, 
  p_process_error_message=> '#SQLERRM#',
  p_process_when=>'RESET_DB_LINK',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 2
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00003
prompt  ...PAGE 3: Test Runner
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 3
 ,p_tab_set => 'TS1'
 ,p_name => 'Test Runner'
 ,p_alias => 'TESTRUNNER'
 ,p_step_title => 'Test Runner'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Test Runner'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_step_template => 4837525507414910 + wwv_flow_api.g_id_offset
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20180911035321'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'   cursor main is'||chr(10)||
'      select round(extract(day from (tr.end_dtm -'||chr(10)||
'                                     tr.start_dtm'||chr(10)||
'                                    )*86400*100'||chr(10)||
'                          )/100,2'||chr(10)||
'                  )                       DURATION'||chr(10)||
'            ,tr.dbout_owner'||chr(10)||
'            ,tr.dbout_name'||chr(10)||
'            ,tr.dbout_type'||chr(10)||
'            ,tr.trigger_offset'||chr(10)||
'            ,tr.error_messag';

s:=s||'e'||chr(10)||
'            ,count(tc.testcase)           NUM_TESTCASES'||chr(10)||
'       from  wt_test_runs  tr'||chr(10)||
'        left join wt_testcase_runs  tc'||chr(10)||
'             on  tc.test_run_id = tr.id'||chr(10)||
'       where tr.id = :P0_TEST_RUN_ID'||chr(10)||
'      group by round(extract(day from (tr.end_dtm -'||chr(10)||
'                                       tr.start_dtm'||chr(10)||
'                                      )*86400*100'||chr(10)||
'                            )/100,2'||chr(10)||
'     ';

s:=s||'               )'||chr(10)||
'            ,tr.dbout_owner'||chr(10)||
'            ,tr.dbout_name'||chr(10)||
'            ,tr.dbout_type'||chr(10)||
'            ,tr.trigger_offset'||chr(10)||
'            ,tr.error_message;'||chr(10)||
'   buff  main%ROWTYPE;'||chr(10)||
'   num_runs   number;'||chr(10)||
'begin'||chr(10)||
'   --'||chr(10)||
'   open main;'||chr(10)||
'   fetch main into buff;'||chr(10)||
'   close main;'||chr(10)||
'   --'||chr(10)||
'   select count(runner_name)'||chr(10)||
'    into  num_runs'||chr(10)||
'    from  wt_test_runs'||chr(10)||
'    where runner_owner = :P0_TEST_OWNER'||chr(10)||
'     and  r';

s:=s||'unner_name  = :P0_TEST_RUNNER;'||chr(10)||
'   --'||chr(10)||
'   htp.p(''<b>'');'||chr(10)||
'   htp.p(''&nbsp;Duration (secs): '' || buff.duration || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;Num Testcases: '' || buff.num_testcases || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;Num Test Runs: '' || num_runs || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;DBOUT Owner: '' || buff.dbout_owner || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;DBOUT N';

s:=s||'ame: '' || buff.dbout_name || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;DBOUT Type: '' || buff.dbout_type || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''&nbsp;Trigger Offset: '' || buff.trigger_offset || ''<br>'');'||chr(10)||
'   htp.p(''</b>'');'||chr(10)||
'   --'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 4848108018414926 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Summary',
  p_region_name=>'',
  p_plug_template=> 4839912075414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_column_width => 'td width="320"',
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4927702379997301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Test Runner Status',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4927915384997301+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4927702379997301+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DPie',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4927915384997301',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::::Left::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'::',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'::',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select NULL             LINK'||chr(10)||
'      ,''PASS''           LABEL'||chr(10)||
'      ,sum(res.passes)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL               LINK'||chr(10)||
'      ,''FAIL''             LABEL'||chr(10)||
'      ,sum(res.failures)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'    ';

a1:=a1||'        on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL             LINK'||chr(10)||
'      ,''ERR''            LABEL'||chr(10)||
'      ,sum(res.errors)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
')'||chr(10)||
'select link, label, value'||chr(10)||
' from  q1'||chr(10)||
' order by label desc';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4928017042997302+wwv_flow_api.g_id_offset,
  p_chart_id => 4927915384997301+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4930902107252669 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'DBOUT Profile Status',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4931121643252671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4930902107252669+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DPie',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4927915384997301',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::::Left::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#0099FF,#99FF99,#FF6699,#FFFF99',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'::',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'::',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select NULL                 LINK'||chr(10)||
'      ,''EXCL''               LABEL'||chr(10)||
'      ,sum(excluded_lines)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL                 LINK'||chr(10)||
'      ,''EXEC''               LABEL'||chr(10)||
'      ,sum(executed_lines)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_r';

a1:=a1||'un_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL                LINK'||chr(10)||
'      ,''NOTX''              LABEL'||chr(10)||
'      ,sum(notexec_lines)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL                LINK'||chr(10)||
'      ,''UNKN''              LABEL'||chr(10)||
'     ';

a1:=a1||' ,sum(unknown_lines)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
')'||chr(10)||
'select link, label, value'||chr(10)||
' from  q1'||chr(10)||
' order by label';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4931210998252672+wwv_flow_api.g_id_offset,
  p_chart_id => 4931121643252671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4932622090476124 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Test Runner Status Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_display_when_cond2=>'Y',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4932831378476124+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4932622090476124+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'Stacked2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4932831378476124',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:Left::V:Y:Circle:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id   LINK'||chr(10)||
'      ,''ID'' || run.id    LABEL'||chr(10)||
'      ,res.passes        PASS'||chr(10)||
'      ,res.failures      FAIL'||chr(10)||
'      ,res.errors        ERROR'||chr(10)||
'      ,rownum            RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  run.runner_name  = :P0_TEST_RUNNER'||chr(10)||
' order by run.id'||chr(10)||
'), q';

a1:=a1||'2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
')'||chr(10)||
'select link, label, pass, fail, error'||chr(10)||
' from  q1'||chr(10)||
' where rnum > (select num_rows from q2) - 10';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4932905763476124+wwv_flow_api.g_id_offset,
  p_chart_id => 4932831378476124+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Main',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4934122379722218 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'DBOUT Profile Status Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_display_when_cond2=>'Y',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4934324926722219+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4934122379722218+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'Stacked2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4932831378476124',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:Left::V:Y:Circle:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#0099FF,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id     LINK'||chr(10)||
'      ,''ID'' || run.id      LABEL'||chr(10)||
'      ,res.executed_lines  EXEC'||chr(10)||
'      ,res.excluded_lines  EXCL'||chr(10)||
'      ,res.unknown_lines   UNKN'||chr(10)||
'      ,res.notexec_lines   NOTX'||chr(10)||
'      ,rownum              RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  run.runner_na';

a1:=a1||'me  = :P0_TEST_RUNNER'||chr(10)||
' order by run.id'||chr(10)||
'), q2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
')'||chr(10)||
'select link'||chr(10)||
'      ,label'||chr(10)||
'      ,exec'||chr(10)||
'      ,excl'||chr(10)||
'      ,unkn'||chr(10)||
'      ,notx'||chr(10)||
' from  q1'||chr(10)||
' where rnum > (select num_rows from q2) - 10';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4934601765722219+wwv_flow_api.g_id_offset,
  p_chart_id => 4934324926722219+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4935906636831213 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Top Test Case Failures',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4936119233831213+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4935906636831213+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4857903544336332',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#FFFF00',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Failures',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''f?p='' || :APP_ID               ||'||chr(10)||
'          '':'' || ''6''                   ||     -- Page'||chr(10)||
'          '':'' || :APP_SESSION          ||'||chr(10)||
'          '':'' || :REQUEST              ||'||chr(10)||
'          '':'' || :DEBUG                ||'||chr(10)||
'          '':'' || ''N''                   ||     -- CLear Cache'||chr(10)||
'          '':'' || ''P0_TEST_RUN_ID''      || '','' ||'||chr(10)||
'                 ''P0_TEST_CASE''        ||     -- Item Names'||chr(10)||
'        ';

a1:=a1||'  '':'' || tc.test_run_id        || '','' ||'||chr(10)||
'                 tc.testcase           ||     -- Item Values'||chr(10)||
'          '':'' || V(''PRINTER_FRIENDLY'')    LINK'||chr(10)||
'      ,run.runner_owner || ''.'' ||'||chr(10)||
'       run.runner_name  || '':'' ||'||chr(10)||
'       tc.testcase                        LABEL'||chr(10)||
'      ,tc.failures                        VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  tc'||chr(10)||
'            on  tc.test_run_';

a1:=a1||'id = run.id'||chr(10)||
' where run.id = :P0_TEST_RUN_ID'||chr(10)||
'  and  tc.failures > 0'||chr(10)||
' order by failures desc, tc.testcase'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4936205597831214+wwv_flow_api.g_id_offset,
  p_chart_id => 4936119233831213+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4946418865544258 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Test Runner Duration Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 4,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4946607806544261+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4946418865544258+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4946607806544261',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'6',
  p_custom_colors          =>'',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>2,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Seconds',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>2,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id   LINK'||chr(10)||
'      ,''ID'' || run.id    LABEL'||chr(10)||
'      ,extract(day from (run.end_dtm - run.start_dtm)*86400*100)/100'||chr(10)||
'                         SECONDS'||chr(10)||
'      ,rownum            RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  run.runner_name  = :P0_TEST_RUNNER'||chr(10)||
' order by ';

a1:=a1||'id'||chr(10)||
'), q2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
')'||chr(10)||
'select link'||chr(10)||
'      ,label'||chr(10)||
'      ,seconds'||chr(10)||
' from  q1'||chr(10)||
' where rnum > (select num_rows from q2) - 10';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4946720535544262+wwv_flow_api.g_id_offset,
  p_chart_id => 4946607806544261+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4948217713035992 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'LineExec Long Duration Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 6,
  p_plug_display_column=> 3,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4948428749035997+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4948217713035992+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4948428749035997',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'6',
  p_custom_colors          =>'',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'MicroSeconds',
  p_y_axis_min             =>0,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id'||chr(10)||
'      ,res.max_executed_usecs'||chr(10)||
'      ,rownum                  RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_test_run_stats  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'  left join wt_dbout_profiles  prof'||chr(10)||
'            on  prof.test_run_id = run.id'||chr(10)||
'            and prof.max_usecs   = res.max_executed_usecs'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  run.runner_na';

a1:=a1||'me  = :P0_TEST_RUNNER'||chr(10)||
' order by id'||chr(10)||
'), q2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
'), q3 as ('||chr(10)||
'select test_run_id'||chr(10)||
'      ,max_usecs'||chr(10)||
'      ,min(line) line'||chr(10)||
' from  wt_dbout_profiles'||chr(10)||
' group by test_run_id'||chr(10)||
'      ,max_usecs'||chr(10)||
')'||chr(10)||
'select q1.test_run_id                LINK'||chr(10)||
'      ,''ID''    || q1.test_run_id ||'||chr(10)||
'       '',Line'' || q3.line            LABEL'||chr(10)||
'      ,q1.max_executed_usecs         VALUE'||chr(10)||
' from  q1 '||chr(10)||
'  left join';

a1:=a1||' q3'||chr(10)||
'            on  q3.test_run_id = q1.test_run_id'||chr(10)||
'            and q3.max_usecs   = q1.max_executed_usecs'||chr(10)||
' where q1.rnum > (select num_rows from q2) - 10'||chr(10)||
' order by q1.test_run_id'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4948500124035997+wwv_flow_api.g_id_offset,
  p_chart_id => 4948428749035997+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FL';

s:=s||'ASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataT';

s:=s||'ext=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:3:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'     ';

s:=s||'  allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</objec';

s:=s||'t>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4948625219180073 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Top Test Case Long Duration',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P3_SHOW_TREND=''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4948812894180073+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 4948625219180073+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4948812894180073',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H::V:Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'6',
  p_custom_colors          =>'',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'MilliSeconds',
  p_y_axis_min             =>0,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''f?p='' || :APP_ID               ||'||chr(10)||
'          '':'' || ''6''                   ||     -- Page'||chr(10)||
'          '':'' || :APP_SESSION          ||'||chr(10)||
'          '':'' || :REQUEST              ||'||chr(10)||
'          '':'' || :DEBUG                ||'||chr(10)||
'          '':'' || ''N''                   ||     -- CLear Cache'||chr(10)||
'          '':'' || ''P0_TEST_RUN_ID''      || '','' ||'||chr(10)||
'                 ''P0_TEST_CASE''        ||     -- Item Names'||chr(10)||
'        ';

a1:=a1||'  '':'' || test_run_id           || '','' ||'||chr(10)||
'                 testcase              ||     -- Item Values'||chr(10)||
'          '':'' || V(''PRINTER_FRIENDLY'')    LINK'||chr(10)||
'      ,testcase                           LABEL'||chr(10)||
'      ,tot_interval_msecs                 VALUE'||chr(10)||
' from  wt_testcase_runs'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
' order by tot_interval_msecs desc'||chr(10)||
'';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4948907337180074+wwv_flow_api.g_id_offset,
  p_chart_id => 4948812894180073+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>10,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select test_run_id'||chr(10)||
'      ,result_seq       SEQ'||chr(10)||
'      ,executed_dtm     EXECUTED_DATE_TIME'||chr(10)||
'      ,interval_msecs   MSECS'||chr(10)||
'      ,assertion'||chr(10)||
'      ,status'||chr(10)||
'      ,details'||chr(10)||
'      ,testcase'||chr(10)||
'      ,message'||chr(10)||
' from  wt_results'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID';

wwv_flow_api.create_page_plug (
  p_id=> 4949525229387041 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Test Runner Results Details',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select test_run_id'||chr(10)||
'      ,result_seq       SEQ'||chr(10)||
'      ,executed_dtm     EXECUTED_DATE_TIME'||chr(10)||
'      ,interval_msecs   MSECS'||chr(10)||
'      ,assertion'||chr(10)||
'      ,status'||chr(10)||
'      ,details'||chr(10)||
'      ,testcase'||chr(10)||
'      ,message'||chr(10)||
' from  wt_results'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID';

wwv_flow_api.create_worksheet(
  p_id=> 4949624635387041+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_region_id=> 4949525229387041+wwv_flow_api.g_id_offset,
  p_name=> 'Test Runner Results Details',
  p_folder_id=> null, 
  p_alias=> '',
  p_report_id_item=> '',
  p_max_row_count=> '10000',
  p_max_row_count_message=> 'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.',
  p_no_data_found_message=> 'No data found.',
  p_max_rows_per_page=>'',
  p_search_button_label=>'',
  p_page_items_to_submit=>'',
  p_sort_asc_image=>'',
  p_sort_asc_image_attr=>'',
  p_sort_desc_image=>'',
  p_sort_desc_image_attr=>'',
  p_sql_query => a1,
  p_status=>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving=>'Y',
  p_allow_save_rpt_public=>'N',
  p_allow_report_categories=>'N',
  p_show_nulls_as=>'-',
  p_pagination_display_pos=>'BOTTOM_RIGHT',
  p_show_finder_drop_down=>'Y',
  p_show_display_row_count=>'N',
  p_show_search_bar=>'Y',
  p_show_search_textbox=>'Y',
  p_show_actions_menu=>'Y',
  p_report_list_mode=>'TABS',
  p_show_detail_link=>'N',
  p_show_select_columns=>'Y',
  p_show_rows_per_page=>'Y',
  p_show_filter=>'Y',
  p_show_sort=>'Y',
  p_show_control_break=>'Y',
  p_show_highlight=>'Y',
  p_show_computation=>'Y',
  p_show_aggregate=>'Y',
  p_show_chart=>'Y',
  p_show_group_by=>'Y',
  p_show_notify=>'N',
  p_show_calendar=>'N',
  p_show_flashback=>'Y',
  p_show_reset=>'Y',
  p_show_download=>'Y',
  p_show_help=>'Y',
  p_download_formats=>'CSV:HTML:EMAIL',
  p_allow_exclude_null_values=>'N',
  p_allow_hide_extra_columns=>'N',
  p_icon_view_enabled_yn=>'N',
  p_icon_view_columns_per_row=>1,
  p_detail_view_enabled_yn=>'N',
  p_owner=>'WTP');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5046210513880502+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TEST_RUN_ID',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Test Run ID',
  p_report_label           =>'Test Run ID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4951219968424536+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'SEQ',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Seq',
  p_report_label           =>'Seq',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4951309893424536+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'EXECUTED_DATE_TIME',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>'Executed Date/Time',
  p_report_label           =>'Executed Date/Time',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4951430855424536+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSECS',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Msecs',
  p_report_label           =>'Msecs',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4950228064387045+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ASSERTION',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Assertion',
  p_report_label           =>'Assertion',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4950325498387045+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'STATUS',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4950430581387045+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DETAILS',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Details',
  p_report_label           =>'Details',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4950523632387045+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TESTCASE',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Testcase',
  p_report_label           =>'Testcase',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P0_TEST_RUN_ID,P0_TEST_CASE:#TEST_RUN_ID#,#TESTCASE#',
  p_column_linktext        =>'#TESTCASE#',
  p_column_link_attr       =>'title="Go To Test Case #TESTCASE#" style="color:blue"',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4950607731387045+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MESSAGE',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Message',
  p_report_label           =>'Message',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'TEST_RUN_ID:SEQ:EXECUTED_DATE_TIME:MSECS:STATUS:TESTCASE:ASSERTION:MESSAGE:DETAILS';

wwv_flow_api.create_worksheet_rpt(
  p_id => 4950724292387987+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'49508',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>100000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'SEQ',
  p_sort_direction_1        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 5046424584891526+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_report_id => 4950724292387987+wwv_flow_api.g_id_offset,
  p_name                    =>'Highlight Errors',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'=',
  p_expr                    =>'ERR',
  p_condition_sql           =>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''ERR''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF5588',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 5046501496891526+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_report_id => 4950724292387987+wwv_flow_api.g_id_offset,
  p_name                    =>'Highlight Failures',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'=',
  p_expr                    =>'FAIL',
  p_condition_sql           =>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''FAIL''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 5046315838891526+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 4949624635387041+wwv_flow_api.g_id_offset,
  p_report_id => 4950724292387987+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'!=',
  p_expr                    =>'PASS',
  p_condition_sql           =>'"STATUS" != #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# != ''PASS''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'begin'||chr(10)||
'   for buff in (select error_message from wt_test_runs'||chr(10)||
'                 where id = :P0_TEST_RUN_ID'||chr(10)||
'                  and  error_message is not null)'||chr(10)||
'   loop'||chr(10)||
'      htp.p(''<font color=##ff0000><b>Test Runner Error Message:</b></font> '' ||'||chr(10)||
'            buff.error_message || ''<br>'');'||chr(10)||
'   end loop;'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<b>Test Results Details Search:</b><b';

s:=s||'r>'');'||chr(10)||
'end;'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 4957623889633835 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Test Run Error Message',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4971511333490098 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Code Coverage Details',
  p_region_name=>'',
  p_plug_template=> 4839416734414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select dbout_name'||chr(10)||
' from  wt_test_runs'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'  and  dbout_name is not null',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4952328298578419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Code Coverage Search',
  p_region_name=>'',
  p_parent_plug_id=>4971511333490098 + wwv_flow_api.g_id_offset,
  p_plug_template=> 4840023588414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select line'||chr(10)||
'      ,status'||chr(10)||
'      ,total_occur'||chr(10)||
'      ,round(min_usecs)             MIN_USECS'||chr(10)||
'      ,case when total_occur = 0 then 0'||chr(10)||
'            else round(total_usecs/total_occur)'||chr(10)||
'       end                          AVG_USECS'||chr(10)||
'      ,round(max_usecs)             MAX_USECS'||chr(10)||
'      ,replace(htf.escape_sc(rtrim(text,CHR(10))),''  '','' &nbsp;'')'||chr(10)||
'                                    TEXT'||chr(10)||
' from  wt_dbout_profil';

s:=s||'es'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
' -- and  status != ''IGNR'''||chr(10)||
'  and  (   instr(upper("STATUS"),upper(nvl(:P3_SEARCH,"STATUS"))) > 0'||chr(10)||
'        OR instr(upper("TEXT"),upper(nvl(:P3_SEARCH,"TEXT"))) > 0    )'||chr(10)||
'';

wwv_flow_api.create_report_region (
  p_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_name=> 'Code Coverage Report',
  p_region_name=>'',
  p_parent_plug_id=>4971511333490098 + wwv_flow_api.g_id_offset,
  p_template=> 4839912075414912+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 60,
  p_report_attributes=>'style="font-family: monospace"',
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P3_DBOUT_NAME',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 4963602874586482+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_item=> 'P3_ROWS',
  p_query_num_rows_type=> 'ROW_RANGES_IN_SELECT_LIST',
  p_query_row_count_max=> '5000',
  p_pagination_display_position=> 'BOTTOM_LEFT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'Create CVS File',
  p_prn_output=> 'N',
  p_prn_format=> 'PDF',
  p_prn_output_show_link=> 'Y',
  p_prn_output_link_text=> 'Print',
  p_prn_content_disposition=> 'ATTACHMENT',
  p_prn_document_header=> 'APEX',
  p_prn_units=> 'INCHES',
  p_prn_paper_size=> 'LETTER',
  p_prn_width_units=> 'PERCENTAGE',
  p_prn_width=> 11,
  p_prn_height=> 8.5,
  p_prn_orientation=> 'HORIZONTAL',
  p_prn_page_header_font_color=> '#000000',
  p_prn_page_header_font_family=> 'Helvetica',
  p_prn_page_header_font_weight=> 'normal',
  p_prn_page_header_font_size=> '12',
  p_prn_page_footer_font_color=> '#000000',
  p_prn_page_footer_font_family=> 'Helvetica',
  p_prn_page_footer_font_weight=> 'normal',
  p_prn_page_footer_font_size=> '12',
  p_prn_header_bg_color=> '#9bafde',
  p_prn_header_font_color=> '#ffffff',
  p_prn_header_font_family=> 'Helvetica',
  p_prn_header_font_weight=> 'normal',
  p_prn_header_font_size=> '10',
  p_prn_body_bg_color=> '#efefef',
  p_prn_body_font_color=> '#000000',
  p_prn_body_font_family=> 'Helvetica',
  p_prn_body_font_weight=> 'normal',
  p_prn_body_font_size=> '10',
  p_prn_border_width=> .5,
  p_prn_page_header_alignment=> 'CENTER',
  p_prn_page_footer_alignment=> 'CENTER',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_exp_filename=> '&P3_DBOUT_OWNER..&P3_DBOUT_NAME.(&P3_DBOUT_TYPE.)#&P3_TEST_RUN_ID..csv',
  p_plug_query_exp_separator=> ',',
  p_plug_query_exp_enclosed_by=> '"',
  p_plug_query_strip_html=> 'N',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956416987578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'LINE',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Line',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956504864578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'STATUS',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Status',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956610572578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'TOTAL_OCCUR',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Total<br>Occur',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956712638578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'MIN_USECS',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Min<br>Usecs',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956829235578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'AVG_USECS',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Avg<br>Usecs',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4956928135578441 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'MAX_USECS',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Max<br>Usecs',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'RIGHT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4957019564578442 + wwv_flow_api.g_id_offset,
  p_region_id=> 4952405887578432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'TEXT',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Text',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '14',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 4939204461575007 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 3,
  p_button_sequence=> 10,
  p_button_plug_id => 4848108018414926+wwv_flow_api.g_id_offset,
  p_button_name    => 'P3_DELETE',
  p_button_image   => 'template:'||to_char(4838306817414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'DELETE Runner Results All Runs',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:confirmDelete(''Confirm DELETE of all Test Results for '' + document.getElementById(''P0_TEST_OWNER'').value + ''.'' + document.getElementById(''P0_TEST_RUNNER'').value, ''DELETE'')',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5168718571973414 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 3,
  p_button_sequence=> 20,
  p_button_plug_id => 4848108018414926+wwv_flow_api.g_id_offset,
  p_button_name    => 'RUN_NOW',
  p_button_image   => 'template:'||to_char(4838226535414911+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Run Now & Wait',
  p_button_position=> 'TOP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_button_condition=> 'select host'||chr(10)||
' from  user_db_links'||chr(10)||
' where :P0_TEST_OWNER = :APP_USER'||chr(10)||
'  and  db_link || ''.'' like :P0_TEST_OWNER || ''.%'''||chr(10)||
'  and  :P0_TEST_RUNNER is not null',
  p_button_condition_type=> 'EXISTS',
  p_button_comment=>'Warning: The web page will not return until the test runner has completed.',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4956122682578439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:3:&SESSION.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>4923132166541430 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4924510262627933 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_SHOW_TREND',
  p_data_type=> 'VARCHAR',
  p_is_required=> true,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 4848108018414926+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Show Trend:',
  p_source=>'N',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_RADIOGROUP',
  p_named_lov=> 'Y_OR_N',
  p_lov=> '.'||to_char(4923728354614299 + wwv_flow_api.g_id_offset)||'.',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => '2',
  p_attribute_02 => 'SUBMIT',
  p_attribute_03 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4939603900584303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_ROWS_DELETED_MSG',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 4848108018414926+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_HIDDEN',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4954902281578436 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_SEARCH',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4952328298578419+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_prompt=>'Search',
  p_display_as=> 'NATIVE_TEXT_FIELD',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_attribute_01 => 'Y',
  p_attribute_02 => 'N',
  p_attribute_03 => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4955118227578437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_ROWS',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 4952328298578419+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Display',
  p_source=>'500',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_SELECT_LIST',
  p_named_lov=> 'P3_Report Row Per Page',
  p_lov=> '.'||to_char(4952509356578433 + wwv_flow_api.g_id_offset)||'.',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'NONE',
  p_attribute_02 => 'N',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4955319672578437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_GO',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 4952328298578419+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default=> 'GO',
  p_prompt=>'Go',
  p_source=>'GO',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(4838226535414911 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4955512070578437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_RESET',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 4952328298578419+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default=> 'RESET',
  p_prompt=>'Reset',
  p_source=>'RESET',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(4838226535414911 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5113008183346610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_computation_sequence => 20,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'Y',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_da_event (
  p_id => 4931927743335808 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 3
 ,p_name => 'Submit After LOV Change'
 ,p_event_sequence => 10
 ,p_triggering_element_type => 'ITEM'
 ,p_triggering_element => 'P3_GOTO_RUN_ID'
 ,p_bind_type => 'bind'
 ,p_bind_event_type => 'change'
  );
wwv_flow_api.create_page_da_action (
  p_id => 4932206270335808 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_page_id => 3
 ,p_event_id => 4931927743335808 + wwv_flow_api.g_id_offset
 ,p_event_result => 'TRUE'
 ,p_action_sequence => 10
 ,p_execute_on_page_init => 'N'
 ,p_action => 'NATIVE_SUBMIT_PAGE'
 ,p_attribute_01 => 'REFRESH'
 ,p_stop_execution_on_error => 'Y'
 );
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'reset_pagination';

wwv_flow_api.create_page_process(
  p_id     => 4955700238578438 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'RESET_PAGINATION',
  p_process_name=> 'Reset Pagination',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to reset pagination.',
  p_process_when=>'GO,P3_SEARCH,RESET',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'P3_SEARCH,P3_ROWS';

wwv_flow_api.create_page_process(
  p_id     => 4955926050578438 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Reset report search',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to clear cache.',
  p_process_when_button_id=>4955512070578437 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'   run_str  varchar2(2000) := ''wtplsql.test_run@'' ||'||chr(10)||
'                               :P0_TEST_OWNER     || ''('''''' ||'||chr(10)||
'                               :P0_TEST_RUNNER    || '''''')'' ;'||chr(10)||
'begin'||chr(10)||
'   execute immediate ''begin '' || run_str || ''; end;'';'||chr(10)||
'   begin'||chr(10)||
'      select max(id)'||chr(10)||
'       into  :P0_TEST_RUN_ID'||chr(10)||
'       from  wt_test_runs'||chr(10)||
'       where runner_owner = :P0_TEST_OWNER'||chr(10)||
'        and  runner_name  = ';

p:=p||':P0_TEST_RUNNER;'||chr(10)||
'   exception when NO_DATA_FOUND'||chr(10)||
'   then'||chr(10)||
'      null;  -- Do Nothing'||chr(10)||
'   end;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5168825843975543 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'RUN_NOW',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>5168718571973414 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'   num_runs   number := 0;'||chr(10)||
'   num_stats  number := 0;'||chr(10)||
'   num_tcase  number := 0;'||chr(10)||
'   num_res    number := 0;'||chr(10)||
'   num_profs  number := 0;'||chr(10)||
'   procedure load_msg is begin'||chr(10)||
'      :P3_ROWS_DELETED_MSG := num_runs  || '' WT_TEST_RUNS, ''      ||'||chr(10)||
'                              num_stats || '' WT_TEST_RUN_STATS, '' ||'||chr(10)||
'                              num_tcase || '' wt_testcase_runs, '' ||'||chr(10)||
'                   ';

p:=p||'           num_res   || '' WT_RESULTS, ''        ||'||chr(10)||
'                              num_profs || '' WT_DBOUT_PROFILES''   ;'||chr(10)||
'   end load_msg;'||chr(10)||
'begin'||chr(10)||
'   load_msg;'||chr(10)||
'   for buff in ('||chr(10)||
'      select id from wt_test_runs'||chr(10)||
'       where runner_owner = :P0_TEST_OWNER'||chr(10)||
'        and  runner_name  = :P0_TEST_RUNNER )'||chr(10)||
'   loop'||chr(10)||
'      --'||chr(10)||
'      delete from wt_test_run_stats'||chr(10)||
'       where test_run_id = buff.id;'||chr(10)||
'      num_stats :';

p:=p||'= num_stats + SQL%ROWCOUNT;'||chr(10)||
'      --'||chr(10)||
'      delete from wt_testcase_runs'||chr(10)||
'       where test_run_id = buff.id;'||chr(10)||
'      num_tcase := num_tcase + SQL%ROWCOUNT;'||chr(10)||
'      --'||chr(10)||
'      delete from wt_results'||chr(10)||
'       where test_run_id = buff.id;'||chr(10)||
'      num_res := num_res + SQL%ROWCOUNT;'||chr(10)||
'      --'||chr(10)||
'      delete from wt_dbout_profiles'||chr(10)||
'       where test_run_id = buff.id;'||chr(10)||
'      num_profs := num_profs + SQL%ROWCOUNT;'||chr(10)||
'     ';

p:=p||' --'||chr(10)||
'      delete from wt_test_runs'||chr(10)||
'       where id = buff.id;'||chr(10)||
'      num_runs := num_runs + SQL%ROWCOUNT;'||chr(10)||
'      --'||chr(10)||
'      load_msg;'||chr(10)||
'      --'||chr(10)||
'   end loop;'||chr(10)||
'   :P0_TEST_RUN_ID  := NULL;'||chr(10)||
'   :P0_TEST_RUNNER  := NULL;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4927320293945637 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 10,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Test Runs',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to delete rows (&P3_ROWS_DELETED_MSG.)',
  p_process_when=>'DELETE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> 'Successfully deleted &P3_ROWS_DELETED_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 3
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00004
prompt  ...PAGE 4: DBOUT Profile
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 4
 ,p_tab_set => 'TS1'
 ,p_name => 'DBOUT Profile'
 ,p_alias => 'DBOUTPROFILE'
 ,p_step_title => 'DBOUT Profile'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'DBOUT Profile'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20180829211824'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select r.dbout_owner'||chr(10)||
'      ,r.dbout_name'||chr(10)||
'      ,r.dbout_type'||chr(10)||
'      ,s.code_coverage*100            CODE_COVERAGE'||chr(10)||
'      ,r.id                           TEST_RUN_ID'||chr(10)||
'      ,r.runner_owner'||chr(10)||
'      ,r.runner_name'||chr(10)||
'      ,r.start_dtm'||chr(10)||
'      ,r.end_dtm'||chr(10)||
'      ,s.profiled_lines'||chr(10)||
'      ,s.executed_lines'||chr(10)||
'      ,s.ignored_lines'||chr(10)||
'      ,s.excluded_lines'||chr(10)||
'      ,s.notexec_lines'||chr(10)||
'      ,s.unknown_lines'||chr(10)||
'      ,s.min_exec';

s:=s||'uted_usecs'||chr(10)||
'      ,s.avg_executed_usecs'||chr(10)||
'      ,s.max_executed_usecs'||chr(10)||
'      ,round(s.tot_executed_usecs,3)  TOT_EXECUTED_USECS'||chr(10)||
'      ,r.trigger_offset'||chr(10)||
'      ,r.error_message'||chr(10)||
' from  wt_test_runs  r'||chr(10)||
'       join wt_test_run_stats  s'||chr(10)||
'            on  s.test_run_id = r.id'||chr(10)||
' where r.dbout_name is not null';

wwv_flow_api.create_page_plug (
  p_id=> 5058029495145138 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_plug_name=> 'DBOUT Profile',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select r.dbout_owner'||chr(10)||
'      ,r.dbout_name'||chr(10)||
'      ,r.dbout_type'||chr(10)||
'      ,s.code_coverage*100            CODE_COVERAGE'||chr(10)||
'      ,r.id                           TEST_RUN_ID'||chr(10)||
'      ,r.runner_owner'||chr(10)||
'      ,r.runner_name'||chr(10)||
'      ,r.start_dtm'||chr(10)||
'      ,r.end_dtm'||chr(10)||
'      ,s.profiled_lines'||chr(10)||
'      ,s.executed_lines'||chr(10)||
'      ,s.ignored_lines'||chr(10)||
'      ,s.excluded_lines'||chr(10)||
'      ,s.notexec_lines'||chr(10)||
'      ,s.unknown_lines'||chr(10)||
'      ,s.min_exec';

a1:=a1||'uted_usecs'||chr(10)||
'      ,s.avg_executed_usecs'||chr(10)||
'      ,s.max_executed_usecs'||chr(10)||
'      ,round(s.tot_executed_usecs,3)  TOT_EXECUTED_USECS'||chr(10)||
'      ,r.trigger_offset'||chr(10)||
'      ,r.error_message'||chr(10)||
' from  wt_test_runs  r'||chr(10)||
'       join wt_test_run_stats  s'||chr(10)||
'            on  s.test_run_id = r.id'||chr(10)||
' where r.dbout_name is not null';

wwv_flow_api.create_worksheet(
  p_id=> 5058117729145138+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_region_id=> 5058029495145138+wwv_flow_api.g_id_offset,
  p_name=> 'DBOUT Profile',
  p_folder_id=> null, 
  p_alias=> '',
  p_report_id_item=> '',
  p_max_row_count=> '10000',
  p_max_row_count_message=> 'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.',
  p_no_data_found_message=> 'No data found.',
  p_max_rows_per_page=>'',
  p_search_button_label=>'',
  p_page_items_to_submit=>'',
  p_sort_asc_image=>'',
  p_sort_asc_image_attr=>'',
  p_sort_desc_image=>'',
  p_sort_desc_image_attr=>'',
  p_sql_query => a1,
  p_base_pk1=>'TEST_RUN_ID',
  p_status=>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving=>'Y',
  p_allow_save_rpt_public=>'N',
  p_allow_report_categories=>'N',
  p_show_nulls_as=>'-',
  p_pagination_type=>'ROWS_X_TO_Y',
  p_pagination_display_pos=>'BOTTOM_LEFT',
  p_show_finder_drop_down=>'Y',
  p_show_display_row_count=>'N',
  p_show_search_bar=>'Y',
  p_show_search_textbox=>'Y',
  p_show_actions_menu=>'Y',
  p_report_list_mode=>'TABS',
  p_show_detail_link=>'Y',
  p_show_select_columns=>'Y',
  p_show_rows_per_page=>'Y',
  p_show_filter=>'Y',
  p_show_sort=>'Y',
  p_show_control_break=>'Y',
  p_show_highlight=>'Y',
  p_show_computation=>'Y',
  p_show_aggregate=>'Y',
  p_show_chart=>'Y',
  p_show_group_by=>'Y',
  p_show_notify=>'N',
  p_show_calendar=>'N',
  p_show_flashback=>'Y',
  p_show_reset=>'Y',
  p_show_download=>'Y',
  p_show_help=>'Y',
  p_download_formats=>'CSV:HTML:EMAIL',
  p_detail_link_text=>'<img src="#IMAGE_PREFIX#menu/pencil16x16.gif" alt="" />',
  p_allow_exclude_null_values=>'Y',
  p_allow_hide_extra_columns=>'Y',
  p_icon_view_enabled_yn=>'N',
  p_icon_view_columns_per_row=>1,
  p_detail_view_enabled_yn=>'N',
  p_owner=>'WTP');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058332650145140+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DBOUT_OWNER',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'DB Object Under Test Owner',
  p_report_label           =>'DBOUT<br>Owner',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058422778145140+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DBOUT_NAME',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'DB Object Under Test Name',
  p_report_label           =>'DBOUT<br>Name',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'LEFT',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058500986145140+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DBOUT_TYPE',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'DB Object Under Test Type',
  p_report_label           =>'DBOUT<br>Type',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'CENTER',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058603676145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'CODE_COVERAGE',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Code Coverage Percent',
  p_report_label           =>'Code<br>Cvrg<br>Pct',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_format_mask            =>'999.9',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058729192145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TEST_RUN_ID',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Test Run ID',
  p_report_label           =>'Test<br>Run<br>ID',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#TEST_RUN_ID#',
  p_column_linktext        =>'#TEST_RUN_ID#',
  p_column_link_attr       =>'title="Go To Test Run ID #TEST_RUN_ID#" style="color:blue"',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058806330145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'RUNNER_OWNER',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Test Runner Owner',
  p_report_label           =>'Test<br>Runner<br>Owner',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5058915547145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'RUNNER_NAME',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Test Runner Name',
  p_report_label           =>'Test<br>Runner<br>Name',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'LEFT',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059009515145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'START_DTM',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Start Date/Time',
  p_report_label           =>'Start<br>Date<br>Time',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'CENTER',
  p_format_mask            =>'DD-MON-YYYY HH24:MI:SS',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059121065145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'END_DTM',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'End Date/Time',
  p_report_label           =>'End<br>Date<br>Time',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'CENTER',
  p_format_mask            =>'DD-MON-YYYY HH24:MI:SS',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059220275145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'PROFILED_LINES',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Profiled Source Lines',
  p_report_label           =>'Profiled<br>Source<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059315222145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'EXECUTED_LINES',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>'Executed Source Lines',
  p_report_label           =>'Executed<br>Source<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059411706145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'IGNORED_LINES',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Ignored Source Lines',
  p_report_label           =>'Ignored<br>Source<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059518034145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'EXCLUDED_LINES',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Excluded Source Lines',
  p_report_label           =>'Excluded<br>Source<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059610513145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'NOTEXEC_LINES',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Not Executed Source Lines',
  p_report_label           =>'Not<br>Executed<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059710978145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'UNKNOWN_LINES',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Unknown Source Lines',
  p_report_label           =>'Unknown<br>Source<br>Lines',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059811323145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MIN_EXECUTED_USECS',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'Minimum Executed Microsecs',
  p_report_label           =>'Minimum<br>Executed<br>Microsecs',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5059913789145141+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'AVG_EXECUTED_USECS',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
  p_column_label           =>'Average Executed Microsecs',
  p_report_label           =>'Avgerage<br>Executed<br>Microsecs',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5060023226145142+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MAX_EXECUTED_USECS',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'Maximum Executed Microsecs',
  p_report_label           =>'Maximum<br>Executed<br>Microsecs',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5060123834145142+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TOT_EXECUTED_USECS',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'Total Executed Microsecs',
  p_report_label           =>'Total<br>Executed<br>Microsecs',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5060204482145142+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TRIGGER_OFFSET',
  p_display_order          =>20,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'T',
  p_column_label           =>'Trigger Offset',
  p_report_label           =>'Trigger<br>Offset',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'RIGHT',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5060309927145142+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ERROR_MESSAGE',
  p_display_order          =>21,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'U',
  p_column_label           =>'Error Message',
  p_report_label           =>'Error<br>Message',
  p_sync_form_label        =>'N',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'LEFT',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'DBOUT_OWNER:DBOUT_NAME:DBOUT_TYPE:CODE_COVERAGE:TEST_RUN_ID:RUNNER_OWNER:RUNNER_NAME:START_DTM:MAX_EXECUTED_USECS:ERROR_MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 5060410372145412+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'50605',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'TEST_RUN_ID',
  p_sort_direction_1        =>'DESC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'DBOUT_OWNER:DBOUT_NAME:DBOUT_TYPE:CODE_COVERAGE:TEST_RUN_ID:RUNNER_OWNER:RUNNER_NAME:START_DTM:END_DTM:PROFILED_LINES:EXECUTED_LINES:IGNORED_LINES:EXCLUDED_LINES:NOTEXEC_LINES:UNKNOWN_LINES:MIN_EXECUTED_USECS:AVG_EXECUTED_USECS:MAX_EXECUTED_USECS:TOT_EXECUTED_USECS:TRIGGER_OFFSET:ERROR_MESSAGE';

wwv_flow_api.create_worksheet_rpt(
  p_id => 5062402397417566+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_worksheet_id => 5058117729145138+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_ALTERNATIVE',
  p_name                    =>'All Columns',
  p_report_seq              =>10,
  p_report_alias            =>'50625',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'TEST_RUN_ID',
  p_sort_direction_1        =>'DESC',
  p_sort_column_2           =>'0',
  p_sort_direction_2        =>'ASC',
  p_sort_column_3           =>'0',
  p_sort_direction_3        =>'ASC',
  p_sort_column_4           =>'0',
  p_sort_direction_4        =>'ASC',
  p_sort_column_5           =>'0',
  p_sort_direction_5        =>'ASC',
  p_sort_column_6           =>'0',
  p_sort_direction_6        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5113829569371666 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 4,
  p_computation_sequence => 30,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'N',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 4
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00005
prompt  ...PAGE 5: About
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 5
 ,p_tab_set => 'TS1'
 ,p_name => 'About'
 ,p_alias => 'ABOUT'
 ,p_step_title => 'About'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20180825100311'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select install_dtm'||chr(10)||
'      ,action'||chr(10)||
'      ,text'||chr(10)||
' from  wt_version';

wwv_flow_api.create_report_region (
  p_id=> 4906213947718211 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5,
  p_name=> 'wtPLSQL Core Installation History:',
  p_region_name=>'',
  p_template=> 4838619911414911+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 30,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4906513668718218 + wwv_flow_api.g_id_offset,
  p_region_id=> 4906213947718211 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'INSTALL_DTM',
  p_column_display_sequence=> 1,
  p_column_heading=> 'INSTALL_DTM',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4906620342718218 + wwv_flow_api.g_id_offset,
  p_region_id=> 4906213947718211 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'ACTION',
  p_column_display_sequence=> 2,
  p_column_heading=> 'ACTION',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4906723875718218 + wwv_flow_api.g_id_offset,
  p_region_id=> 4906213947718211 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'TEXT',
  p_column_display_sequence=> 3,
  p_column_heading=> 'TEXT',
  p_column_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<b>&APP_VERSION.</b><br>'||chr(10)||
'<br>'||chr(10)||
'<br>'||chr(10)||
''||chr(10)||
'Use <a href="https://github.com/DDieterich/wtPLSQL/issues">GitHub “issues”</a> for support. (A free GitHub account will be required to create a new issue.  Issues can be searched without an account.)<br>'||chr(10)||
'<br>'||chr(10)||
'<br>'||chr(10)||
''||chr(10)||
'Find more information at <a href="https://ddieterich.github.io/wtPLSQL/">wtPLSQL Website</a>.<br>'||chr(10)||
'<br>'||chr(10)||
'<br>';

wwv_flow_api.create_page_plug (
  p_id=> 4907318411766797 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5,
  p_plug_name=> 'About',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT_WITH_SHORTCUTS',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<br>'||chr(10)||
'<br>';

wwv_flow_api.create_page_plug (
  p_id=> 4907909454792629 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5,
  p_plug_name=> 'Version',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 4843113555414914+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4907225553759367 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5,
  p_name=>'P5_WT_VERSION',
  p_data_type=> 'VARCHAR',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4907909454792629+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'wtPLSQL Core Version',
  p_source=>'begin'||chr(10)||
'   for buff in (select text from wt_version'||chr(10)||
'                 where install_dtm ='||chr(10)||
'                       (select max(install_dtm)'||chr(10)||
'                         from  wt_version) )'||chr(10)||
'   loop'||chr(10)||
'      return buff.text;'||chr(10)||
'   end loop;'||chr(10)||
'   return '''';'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'NATIVE_DISPLAY_ONLY',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'VALUE',
  p_attribute_04 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5112710130337711 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5,
  p_computation_sequence => 20,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'N',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00006
prompt  ...PAGE 6: Test Cases
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 6
 ,p_tab_set => 'TS1'
 ,p_name => 'Test Cases'
 ,p_alias => 'TESTCASES'
 ,p_step_title => 'Test Cases'
 ,p_allow_duplicate_submissions => 'Y'
 ,p_step_sub_title => 'Test Cases'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_step_template => 4837525507414910 + wwv_flow_api.g_id_offset
 ,p_page_is_public_y_n => 'N'
 ,p_protection_level => 'N'
 ,p_cache_page_yn => 'N'
 ,p_cache_timeout_seconds => 21600
 ,p_cache_by_user_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20180901170818'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'   total_elapsed   number;'||chr(10)||
'   num_runs        number;'||chr(10)||
'begin'||chr(10)||
'   --'||chr(10)||
'   select max(tot_interval_msecs)  -- Need Group Function for NULL'||chr(10)||
'     into total_elapsed'||chr(10)||
'    from  wt_testcase_runs'||chr(10)||
'    where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
'     and  testcase    = :P0_TEST_CASE;'||chr(10)||
'   --'||chr(10)||
'   select count(tr.id)  -- Need Group Function for NULL'||chr(10)||
'    into  num_runs'||chr(10)||
'    from  wt_test_runs  tr'||chr(10)||
'          join wt_te';

s:=s||'stcase_stats  tc'||chr(10)||
'               on  tc.test_run_id = tr.id'||chr(10)||
'               and tc.testcase    = :P0_TEST_CASE'||chr(10)||
'    where tr.runner_owner = :P0_TEST_OWNER'||chr(10)||
'     and  tr.runner_name  = :P0_TEST_RUNNER;'||chr(10)||
'   --'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''Test Case Duration (msec): '' || total_elapsed || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''Number of Test Runs: '' || num_runs || ''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   --'||chr(10)||
'end;'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 4978906587323161 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Summary',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_column_width => 'td width="320"',
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select result_seq       SEQ'||chr(10)||
'      ,executed_dtm     EXECUTED_DATE_TIME'||chr(10)||
'      ,interval_msecs   MSECS'||chr(10)||
'      ,assertion'||chr(10)||
'      ,status'||chr(10)||
'      ,details'||chr(10)||
'      ,testcase'||chr(10)||
'      ,message'||chr(10)||
' from  wt_results'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
'  and  testcase    = :P0_TEST_CASE';

wwv_flow_api.create_page_plug (
  p_id=> 4982202570323168 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Test Case Results Details',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select result_seq       SEQ'||chr(10)||
'      ,executed_dtm     EXECUTED_DATE_TIME'||chr(10)||
'      ,interval_msecs   MSECS'||chr(10)||
'      ,assertion'||chr(10)||
'      ,status'||chr(10)||
'      ,details'||chr(10)||
'      ,testcase'||chr(10)||
'      ,message'||chr(10)||
' from  wt_results'||chr(10)||
' where test_run_id = :P0_TEST_RUN_ID'||chr(10)||
'  and  testcase    = :P0_TEST_CASE';

wwv_flow_api.create_worksheet(
  p_id=> 4982411530323169+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_region_id=> 4982202570323168+wwv_flow_api.g_id_offset,
  p_name=> 'Test Runner Results Details',
  p_folder_id=> null, 
  p_alias=> '',
  p_report_id_item=> '',
  p_max_row_count=> '10000',
  p_max_row_count_message=> 'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.',
  p_no_data_found_message=> 'No data found.',
  p_max_rows_per_page=>'',
  p_search_button_label=>'',
  p_page_items_to_submit=>'',
  p_sort_asc_image=>'',
  p_sort_asc_image_attr=>'',
  p_sort_desc_image=>'',
  p_sort_desc_image_attr=>'',
  p_sql_query => a1,
  p_status=>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving=>'Y',
  p_allow_save_rpt_public=>'N',
  p_allow_report_categories=>'N',
  p_show_nulls_as=>'-',
  p_pagination_display_pos=>'BOTTOM_RIGHT',
  p_show_finder_drop_down=>'Y',
  p_show_display_row_count=>'N',
  p_show_search_bar=>'Y',
  p_show_search_textbox=>'Y',
  p_show_actions_menu=>'Y',
  p_report_list_mode=>'TABS',
  p_show_detail_link=>'N',
  p_show_select_columns=>'Y',
  p_show_rows_per_page=>'Y',
  p_show_filter=>'Y',
  p_show_sort=>'Y',
  p_show_control_break=>'Y',
  p_show_highlight=>'Y',
  p_show_computation=>'Y',
  p_show_aggregate=>'Y',
  p_show_chart=>'Y',
  p_show_group_by=>'Y',
  p_show_notify=>'N',
  p_show_calendar=>'N',
  p_show_flashback=>'Y',
  p_show_reset=>'Y',
  p_show_download=>'Y',
  p_show_help=>'Y',
  p_download_formats=>'CSV:HTML:EMAIL',
  p_allow_exclude_null_values=>'N',
  p_allow_hide_extra_columns=>'N',
  p_icon_view_enabled_yn=>'N',
  p_icon_view_columns_per_row=>1,
  p_detail_view_enabled_yn=>'N',
  p_owner=>'WTP');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4983029951323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'SEQ',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Seq',
  p_report_label           =>'Seq',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4983107465323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'EXECUTED_DATE_TIME',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>'Executed Date/Time',
  p_report_label           =>'Executed Date/Time',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4983222398323174+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MSECS',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Msecs',
  p_report_label           =>'Msecs',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4982519401323172+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ASSERTION',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Assertion',
  p_report_label           =>'Assertion',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4982626816323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'STATUS',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4982730180323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DETAILS',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Details',
  p_report_label           =>'Details',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4982829265323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TESTCASE',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Testcase',
  p_report_label           =>'Testcase',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4982913874323173+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'MESSAGE',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Message',
  p_report_label           =>'Message',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_highlighting     =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_allow_group_by         =>'Y',
  p_allow_hide             =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_tz_dependent           =>'N',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
declare
    rc1 varchar2(32767) := null;
begin
rc1:=rc1||'SEQ:MSECS:STATUS:TESTCASE:ASSERTION:MESSAGE:DETAILS';

wwv_flow_api.create_worksheet_rpt(
  p_id => 4983313754323174+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_report_alias            =>'49834',
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>100000,
  p_report_columns          =>rc1,
  p_sort_column_1           =>'SEQ',
  p_sort_direction_1        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 4983615236323175+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_report_id => 4983313754323174+wwv_flow_api.g_id_offset,
  p_name                    =>'Highlight Errors',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'=',
  p_expr                    =>'ERR',
  p_condition_sql           =>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''ERR''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FF5588',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 4983707104323175+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_report_id => 4983313754323174+wwv_flow_api.g_id_offset,
  p_name                    =>'Highlight Failures',
  p_condition_type          =>'HIGHLIGHT',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'=',
  p_expr                    =>'FAIL',
  p_condition_sql           =>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) ',
  p_condition_display       =>'#APXWS_COL_NAME# = ''FAIL''  ',
  p_enabled                 =>'Y',
  p_highlight_sequence      =>10,
  p_row_bg_color            =>'#FFFF99',
  p_column_format           =>'');
end;
/
begin
wwv_flow_api.create_worksheet_condition(
  p_id => 4983512775323175+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_worksheet_id => 4982411530323169+wwv_flow_api.g_id_offset,
  p_report_id => 4983313754323174+wwv_flow_api.g_id_offset,
  p_condition_type          =>'FILTER',
  p_allow_delete            =>'Y',
  p_column_name             =>'STATUS',
  p_operator                =>'!=',
  p_expr                    =>'PASS',
  p_condition_sql           =>'"STATUS" != #APXWS_EXPR#',
  p_condition_display       =>'#APXWS_COL_NAME# != ''PASS''  ',
  p_enabled                 =>'Y',
  p_column_format           =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'begin'||chr(10)||
'   for buff in (select error_message from wt_test_runs'||chr(10)||
'                 where id = :P0_TEST_RUN_ID'||chr(10)||
'                  and  error_message is not null)'||chr(10)||
'   loop'||chr(10)||
'      htp.p(''<font color=##ff0000><b>Test Runner Error Message:</b></font> '' ||'||chr(10)||
'            buff.error_message || ''<br>'');'||chr(10)||
'   end loop;'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<br>'');'||chr(10)||
'   htp.p(''<b>Test Results Details Search:</b><b';

s:=s||'r>'');'||chr(10)||
'end;'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 4983829548323176 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Test Run Error Message',
  p_region_name=>'',
  p_plug_template=> 4839831975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4987121729323182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Test Case Status',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4987320221323183+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 6,
  p_region_id => 4987121729323182+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DPie',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4927915384997301',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:::::Left::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'::',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>null,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'::',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select NULL             LINK'||chr(10)||
'      ,''PASS''           LABEL'||chr(10)||
'      ,sum(res.passes)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'            and res.testcase = :P0_TEST_CASE'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL               LINK'||chr(10)||
'      ,''FAIL''             LABEL'||chr(10)||
'      ,sum(res.failures)  VALUE'||chr(10)||
' from  wt_test_runs';

a1:=a1||'  run'||chr(10)||
'       join wt_testcase_runs  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'            and res.testcase = :P0_TEST_CASE'||chr(10)||
' where id = :P0_TEST_RUN_ID'||chr(10)||
'union all'||chr(10)||
'select NULL             LINK'||chr(10)||
'      ,''ERR''            LABEL'||chr(10)||
'      ,sum(res.errors)  VALUE'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'            and res.testcase = :P0_TEST_CASE'||chr(10)||
'';

a1:=a1||' where id = :P0_TEST_RUN_ID'||chr(10)||
')'||chr(10)||
'select link, label, value'||chr(10)||
' from  q1'||chr(10)||
' order by label desc';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4987425886323183+wwv_flow_api.g_id_offset,
  p_chart_id => 4987320221323183+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'',
  p_show_action_link          =>'N',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4987511974323183 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Test Case Status Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 21,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P6_SHOW_TREND=''Y''',
  p_plug_display_when_cond2=>'Y',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4987702388323183+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 6,
  p_region_id => 4987511974323183+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'Stacked2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4932831378476124',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:Left::V:Y:Circle:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'%',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'0',
  p_custom_colors          =>'#99FF99,#FFFF99,#FF6699',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'Test Run ID',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'',
  p_y_axis_min             =>0,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id                    LINK'||chr(10)||
'      ,res.test_run_id                    LABEL'||chr(10)||
'      ,res.passes                         PASS'||chr(10)||
'      ,res.failures                       FAIL'||chr(10)||
'      ,res.errors                         ERR'||chr(10)||
'      ,rownum                             RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'    ';

a1:=a1||'        and res.testcase = :P0_TEST_CASE'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  and  run.runner_name  = :P0_TEST_RUNNER'||chr(10)||
' order by run.id'||chr(10)||
'), q2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
')'||chr(10)||
'select link'||chr(10)||
'      ,label'||chr(10)||
'      ,pass'||chr(10)||
'      ,fail'||chr(10)||
'      ,err'||chr(10)||
' from  q1'||chr(10)||
' where rnum > (select num_rows from q2) - 10';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4988016280323183+wwv_flow_api.g_id_offset,
  p_chart_id => 4987702388323183+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'    codebase="#HOST_PROTOCOL#://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'    width="#WIDTH#"'||chr(10)||
'    height="#HEIGHT#"'||chr(10)||
'    id="#CHART_NAME#"'||chr(10)||
'    align="top">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SES';

s:=s||'SION.:FLOW_FLASH_CHART5_R#REGION_ID#">'||chr(10)||
'<param name="quality" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&wa';

s:=s||'itingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEMPLATES#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/anychart_5/swf/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:&FLOW_PAGE_ID.:&APP_SESSION.:FLOW_FLASH_CHART5_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScript';

s:=s||'Access="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="#HOST_PROTOCOL#://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="initText=#FLASH_INIT#&xmlLoadingText=#FLASH_LOADING#&resourcesLoadingText=#FLASH_RESOURCES#&noDataText=#FLASH_NO_DATA#&waitingForDataText=#FLASH_WAITING#&templatesLoadingText=#FLASH_TEM';

s:=s||'PLATES#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 4988130280323184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 6,
  p_plug_name=> 'Test Case Duration Trend',
  p_region_name=>'',
  p_plug_template=> 4839217975414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 22,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'BEFORE_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART5',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P6_SHOW_TREND=''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart5(
  p_id => 4988311601323184+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 6,
  p_region_id => 4988130280323184+wwv_flow_api.g_id_offset,
  p_default_chart_type     =>'2DColumn',
  p_chart_title            =>'',
  p_chart_name             =>'chart_4946607806544261',
  p_chart_width            =>300,
  p_chart_height           =>200,
  p_chart_animation        =>'N',
  p_display_attr           =>':H:N::Y:N:N::V:Y:None:::N:::Default',
  p_dial_tick_attr         =>':::::::::::',
  p_gantt_attr             =>'Y:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:Rhomb:Rhomb:Full:30:15:5:Y:I:N:S:E',
  p_map_attr               =>'Orthographic:RegionBounds:REGION_NAME',
  p_map_source             =>'',
  p_margins                =>':::',
  p_omit_label_interval    => null,
  p_bgtype                 =>'Trans',
  p_bgcolor1               =>'',
  p_bgcolor2               =>'',
  p_gradient_rotation      =>null,
  p_grid_bgtype            =>'',
  p_grid_bgcolor1          =>'',
  p_grid_bgcolor2          =>'',
  p_grid_gradient_rotation =>null,
  p_color_scheme           =>'6',
  p_custom_colors          =>'',
  p_map_undef_color_scheme =>'',
  p_map_undef_custom_colors =>'',
  p_x_axis_title           =>'Test Run ID',
  p_x_axis_min             =>null,
  p_x_axis_max             =>null,
  p_x_axis_decimal_place   =>null,
  p_x_axis_prefix          =>'',
  p_x_axis_postfix         =>'',
  p_x_axis_label_rotation  =>'',
  p_x_axis_label_font      =>'Tahoma:10:#000000',
  p_x_axis_major_interval  =>null,
  p_x_axis_minor_interval  =>null,
  p_y_axis_title           =>'Milliseconds',
  p_y_axis_min             =>0,
  p_y_axis_max             =>null,
  p_y_axis_decimal_place   =>null,
  p_y_axis_prefix          =>'',
  p_y_axis_postfix         =>'',
  p_y_axis_label_rotation  =>'',
  p_y_axis_label_font      =>'Tahoma:10:#000000',
  p_y_axis_major_interval  =>null,
  p_y_axis_minor_interval  =>null,
  p_async_update           =>'N',
  p_async_time             =>null,
  p_legend_title           =>'',
  p_legend_title_font      =>'',
  p_names_font             => null,
  p_names_rotation         => null,
  p_values_font            =>'Arial:10:#000000',
  p_values_rotation        =>null,
  p_values_prefix          =>'',
  p_values_postfix         =>'',
  p_hints_font             =>'Tahoma:10:#000000',
  p_legend_font            =>'Arial:10:#000000',
  p_grid_labels_font       =>'',
  p_chart_title_font       =>'Tahoma:14:#000000',
  p_x_axis_title_font      =>'Tahoma:14:#000000',
  p_x_axis_title_rotation  =>'',
  p_y_axis_title_font      =>'Tahoma:14:#000000',
  p_y_axis_title_rotation  =>'',
  p_gauge_labels_font      =>'Tahoma:10:',
  p_use_chart_xml          =>'N',
  p_chart_xml              => a1);
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'with q1 as ('||chr(10)||
'select res.test_run_id                    LINK'||chr(10)||
'      ,res.test_run_id                    LABEL'||chr(10)||
'      ,res.tot_interval_msecs             MILLISECONDS'||chr(10)||
'      ,rownum                             RNUM'||chr(10)||
' from  wt_test_runs  run'||chr(10)||
'       join wt_testcase_runs  res'||chr(10)||
'            on  res.test_run_id = run.id'||chr(10)||
'            and res.testcase = :P0_TEST_CASE'||chr(10)||
' where run.runner_owner = :P0_TEST_OWNER'||chr(10)||
'  a';

a1:=a1||'nd  run.runner_name  = :P0_TEST_RUNNER'||chr(10)||
' order by id'||chr(10)||
'), q2 as ('||chr(10)||
'select count(*) num_rows from q1'||chr(10)||
')'||chr(10)||
'select link'||chr(10)||
'      ,label'||chr(10)||
'      ,milliseconds'||chr(10)||
' from  q1'||chr(10)||
' where rnum > (select num_rows from q2) - 10';

wwv_flow_api.create_flash_chart5_series(
  p_id => 4988419037323184+wwv_flow_api.g_id_offset,
  p_chart_id => 4988311601323184+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_type               =>'Bar',
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15,
  p_action_link               =>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P0_TEST_RUN_ID:#LINK#',
  p_show_action_link          =>'C',
  p_action_link_checksum_type =>'');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4990208512323191 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_branch_action=> 'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4979721568323165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_name=>'P6_SHOW_TREND',
  p_data_type=> 'VARCHAR',
  p_is_required=> true,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 4978906587323161+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type=> 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Show Trend:',
  p_source=>'N',
  p_source_type=> 'STATIC',
  p_display_as=> 'NATIVE_RADIOGROUP',
  p_named_lov=> 'Y_OR_N',
  p_lov=> '.'||to_char(4923728354614299 + wwv_flow_api.g_id_offset)||'.',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT-CENTER',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'YES',
  p_protection_level => 'N',
  p_escape_on_http_output => 'Y',
  p_attribute_01 => '2',
  p_attribute_02 => 'SUBMIT',
  p_attribute_03 => 'Y',
  p_show_quick_picks=>'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5113216840349039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 6,
  p_computation_sequence => 20,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'Y',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'reset_pagination';

wwv_flow_api.create_page_process(
  p_id     => 4989314029323189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 6,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'RESET_PAGINATION',
  p_process_name=> 'Reset Pagination',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to reset pagination.',
  p_process_when=>'GO,P6_SEARCH,RESET',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'P6_SEARCH,P6_ROWS';

wwv_flow_api.create_page_process(
  p_id     => 4989512951323189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 6,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Reset report search',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to clear cache.',
  p_process_when_button_id=>4985222849323178 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 6
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00101
prompt  ...PAGE 101: Login
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 101
 ,p_name => 'Login'
 ,p_alias => 'LOGIN'
 ,p_step_title => 'Login'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'AUTO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'OFF'
 ,p_step_template => 4836711590414909 + wwv_flow_api.g_id_offset
 ,p_page_is_public_y_n => 'N'
 ,p_cache_page_yn => 'N'
 ,p_last_updated_by => 'WTP'
 ,p_last_upd_yyyymmddhh24miss => '20180828203310'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4845720626414921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'wtPLSQL - White Box Testing for Oracle''s PL/SQL',
  p_region_name=>'',
  p_plug_template=> 4839304121414912+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4845806651414922 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_USERNAME',
  p_data_type=> '',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4845720626414921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'Username',
  p_display_as=> 'NATIVE_TEXT_FIELD',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 2,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_attribute_01 => 'N',
  p_attribute_02 => 'N',
  p_attribute_03 => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4845920534414922 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PASSWORD',
  p_data_type=> '',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 4845720626414921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'Password',
  p_display_as=> 'NATIVE_PASSWORD',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line=> 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'RIGHT',
  p_field_alignment=> 'LEFT',
  p_field_template=> 4843803724414915+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_attribute_01 => 'Y',
  p_attribute_02 => 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4846006439414922 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_LOGIN',
  p_data_type=> '',
  p_is_required=> false,
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 4845720626414921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default=> 'Login',
  p_prompt=>'Login',
  p_source=>'LOGIN',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(4838226535414911 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line=> 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan=> 1,
  p_rowspan=> 1,
  p_label_alignment=> 'LEFT',
  p_field_alignment=> 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5113529438362167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_computation_sequence => 30,
  p_computation_item=> 'P0_DISPLAY',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'N',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'owa_util.mime_header(''text/html'', FALSE);'||chr(10)||
'owa_cookie.send('||chr(10)||
'    name=>''LOGIN_USERNAME_COOKIE'','||chr(10)||
'    value=>lower(:P101_USERNAME));'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4846217300414922 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'wwv_flow_custom_auth_std.login('||chr(10)||
'    P_UNAME       => :P101_USERNAME,'||chr(10)||
'    P_PASSWORD    => :P101_PASSWORD,'||chr(10)||
'    P_SESSION_ID  => v(''APP_SESSION''),'||chr(10)||
'    P_FLOW_PAGE   => :APP_ID||'':1'''||chr(10)||
'    );';

wwv_flow_api.create_page_process(
  p_id     => 4846117403414922 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Login',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'101';

wwv_flow_api.create_page_process(
  p_id     => 4846420685414923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear Page(s) Cache',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'   :P0_TEST_OWNER := :APP_USER;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5166510581225261 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Test Owner',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v varchar2(255) := null;'||chr(10)||
'    c owa_cookie.cookie;'||chr(10)||
'begin'||chr(10)||
'   c := owa_cookie.get(''LOGIN_USERNAME_COOKIE'');'||chr(10)||
'   :P101_USERNAME := c.vals(1);'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4846327512414923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 101
--
 
begin
 
null;
end;
null;
 
end;
/

prompt  ...lists
--
--application/shared_components/navigation/breadcrumbs
prompt  ...breadcrumbs
--
 
begin
 
wwv_flow_api.create_menu (
  p_id=> 4846524976414923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> ' Breadcrumb');
 
wwv_flow_api.create_menu_option (
  p_id=>4847624895414926 + wwv_flow_api.g_id_offset,
  p_menu_id=>4846524976414923 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>20,
  p_short_name=>'Run Test',
  p_long_name=>'',
  p_link=>'f?p=700:2:&SESSION.',
  p_page_id=>2,
  p_also_current_for_pages=> '');
 
wwv_flow_api.create_menu_option (
  p_id=>4848215650414926 + wwv_flow_api.g_id_offset,
  p_menu_id=>4846524976414923 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>30,
  p_short_name=>'Test Runner',
  p_long_name=>'',
  p_link=>'f?p=700:3:&SESSION.',
  p_page_id=>3,
  p_also_current_for_pages=> '');
 
null;
 
end;
/

prompt  ...page templates for application: 700
--
--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 4836711590414909
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="login">'||chr(10)||
'  <div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'  <div id="login-main">#REGION_POSITION_02##BOX_BODY##REGION_POSITION_03#</div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4836711590414909 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0"',
  p_theme_id  => 7,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_template_comment => '18');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_left_sidebar_fixed_width_div_based
prompt  ......Page template 4836803791414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        &nbsp;'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="';

c3:=c3||'topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col-sb-left">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="main-sb-left">'||chr(10)||
'      #BOX_BODY##REGION_POSITION_03#'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4836803791414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs - Left Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_left_and_right_sidebar_fixed_width_div_left_and_optional_table_based_right
prompt  ......Page template 4836929045414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        &nbsp;'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="';

c3:=c3||'topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="three-col">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="two-col-tbl">'||chr(10)||
'      <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'        <tbody>'||chr(10)||
'          <tr>'||chr(10)||
'            <td class="';

c3:=c3||'tbl-main" width="100%">#BOX_BODY#</td>'||chr(10)||
'            <td class="tbl-sidebar">#REGION_POSITION_03#</td>     '||chr(10)||
'          </tr>'||chr(10)||
'        </tbody>'||chr(10)||
'      </table>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4836929045414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs - Left and Right Sidebar (fixed-width / DIV left and optional table-based right)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_right_sidebar_fixed_width_div_based
prompt  ......Page template 4837019193414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        &nbsp;'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="';

c3:=c3||'topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col">'||chr(10)||
'    <div id="sidebar">#REGION_POSITION_03#</div>     '||chr(10)||
'    <div id="main">#REGION_POSITION_02##BOX_BODY#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4837019193414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs - Right Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_right_sidebar_optional_table_based
prompt  ......Page template 4837131094414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        &nbsp;'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="';

c3:=c3||'topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'    <tbody>'||chr(10)||
'      <tr>'||chr(10)||
'        <td class="tbl-main" width="100%">#REGION_POSITION_02##BOX_BODY#</td>'||chr(10)||
'        <td class="tbl-sidebar">#REGION_POSITION_03#</td>    ';

c3:=c3||' '||chr(10)||
'      </tr>'||chr(10)||
'    </tbody>'||chr(10)||
'  </table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4837131094414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs - Right Sidebar (optional / table-based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_error_page_template => '<div class="error_container">'||chr(10)||
'	<div class="rounded-corner-region-blank">'||chr(10)||
'		<div class="rc-gray-top">'||chr(10)||
'			<div class="rc-gray-top-r"></div>'||chr(10)||
'		</div>'||chr(10)||
'		<div class="rc-body">'||chr(10)||
'			<div class="rc-body-r">'||chr(10)||
'				<div class="rc-content-main">'||chr(10)||
'					<div class="sErrorText">'||chr(10)||
'					<strong>#INTERNAL_MESSAGE#</strong>'||chr(10)||
'					<strong>#MESSAGE#</strong>'||chr(10)||
'					<p>'||chr(10)||
'						<button onclick="#BACK_LINK#" class="button-default" type="button">'||chr(10)||
'						  <span>#OK#</span>'||chr(10)||
'						</button>'||chr(10)||
'					</p>'||chr(10)||
'					</div>'||chr(10)||
'					<div class="clear"></div>'||chr(10)||
'				</div>'||chr(10)||
'			</div>'||chr(10)||
'		</div>'||chr(10)||
'		<div class="rc-bottom">'||chr(10)||
'			<div class="rc-bottom-r"></div>'||chr(10)||
'		</div>'||chr(10)||
'	</div>'||chr(10)||
'</div>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_left_sidebar_fixed_width_div_based
prompt  ......Page template 4837222651414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div';

c3:=c3||' id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col-sb-left">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="main-sb-left">'||chr(10)||
'      #BOX_BODY##REGION_POSITION_03#'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4837222651414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs - Left Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_left_and_right_sidebar_fixed_width_div_left_and_optional_table_based_right
prompt  ......Page template 4837316808414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div';

c3:=c3||' id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="three-col">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="two-col-tbl">'||chr(10)||
'      <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'        <tbody>'||chr(10)||
'          <tr>'||chr(10)||
'            <td cl';

c3:=c3||'ass="tbl-main" width="100%">#BOX_BODY#</td>'||chr(10)||
'            <td class="tbl-sidebar">#REGION_POSITION_03#</td>     '||chr(10)||
'          </tr>'||chr(10)||
'        </tbody>'||chr(10)||
'      </table>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4837316808414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs - Left and Right Sidebar (fixed-width / DIV left and optional table-based right)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_right_sidebar_fixed_width_div_based
prompt  ......Page template 4837413408414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div';

c3:=c3||' id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col">'||chr(10)||
'    <div id="sidebar">#REGION_POSITION_03#</div>     '||chr(10)||
'    <div id="main">#REGION_POSITION_02##BOX_BODY#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4837413408414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs - Right Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> '',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 8,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_right_sidebar_optional_table_based
prompt  ......Page template 4837525507414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <div class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div';

c3:=c3||' id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'    <tbody>'||chr(10)||
'      <tr>'||chr(10)||
'        <td class="tbl-main" width="100%">#REGION_POSITION_02##BOX_BODY#</td>'||chr(10)||
'        <td class="tbl-sidebar">#REGION_POSITION_03#</td';

c3:=c3||'>     '||chr(10)||
'      </tr>'||chr(10)||
'    </tbody>'||chr(10)||
'  </table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4837525507414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs - Right Sidebar (optional / table-based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="navbar-link">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> '',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 4837613823414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'<link rel="shortcut icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'#HEAD#'||chr(10)||
'<link rel="stylesheet" href="';

c1:=c1||'#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD# class="pop-up-body">#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top"><div class="t1messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_01##REGION_POSITION_02##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4837613823414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 7,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 4837724123414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-';

c1:=c1||'->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'    <tbody>'||chr(10)||
'      <tr>'||chr(10)||
'        <td class="tbl-sidebar" style="padding-right: 1';

c3:=c3||'0px;">#REGION_POSITION_02#</td>     '||chr(10)||
'        <td class="tbl-main" width="100%">#BOX_BODY#</td>'||chr(10)||
'        <td class="tbl-sidebar">#REGION_POSITION_03#</td>     '||chr(10)||
'      </tr>'||chr(10)||
'    </tbody>'||chr(10)||
'  </table>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4837724123414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '',
  p_navigation_bar=> '',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 7,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_left_sidebar_fixed_width_div_based
prompt  ......Page template 4837820641414910
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
' #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--';

c1:=c1||'[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<';

c1:=c1||'!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'  <div id="parent-tabs">'||chr(10)||
'    <div class="tab-holder">#PARENT_TAB_CELLS#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <d';

c3:=c3||'iv class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col-sb-left">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="main-sb-left">'||chr(10)||
'      #BOX_BODY##REGION_POSITION_03#'||chr(10)||
'   ';

c3:=c3||' </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4837820641414910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs - Left Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<div class="current"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<div class="noncurrent"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_left_and_right_sidebar_fixed_width_div_left_and_optional_table_based_right
prompt  ......Page template 4837929553414911
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
' #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]--';

c1:=c1||'>'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'  <div id="parent-tabs">'||chr(10)||
'    <div class="tab-holder">#PARENT_TAB_CELLS#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <d';

c3:=c3||'iv class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="three-col">'||chr(10)||
'    <div id="left-sidebar">#REGION_POSITION_02#</div>'||chr(10)||
'    <div id="two-col-tbl">'||chr(10)||
'      <table class="tbl-body" cellspacing="0" c';

c3:=c3||'ellpadding="0" border="0" summary="">'||chr(10)||
'        <tbody>'||chr(10)||
'          <tr>'||chr(10)||
'            <td class="tbl-main" width="100%">#BOX_BODY#</td>'||chr(10)||
'            <td class="tbl-sidebar">#REGION_POSITION_03#</td>     '||chr(10)||
'          </tr>'||chr(10)||
'        </tbody>'||chr(10)||
'      </table>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4837929553414911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs - Left and Right Sidebar (fixed-width / DIV left and optional table-based right)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<div class="current"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<div class="noncurrent"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_right_sidebar_fixed_width_div_based
prompt  ......Page template 4838023662414911
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
' #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]--';

c1:=c1||'>'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'  <div id="parent-tabs">'||chr(10)||
'    <div class="tab-holder">#PARENT_TAB_CELLS#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <d';

c3:=c3||'iv class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <div id="two-col">'||chr(10)||
'    <div id="sidebar">#REGION_POSITION_03#</div>     '||chr(10)||
'    <div id="main">#REGION_POSITION_02##BOX_BODY#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4838023662414911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs - Right Sidebar (fixed-width / DIV based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<div class="current"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<div class="noncurrent"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_right_sidebar_optional_table_based
prompt  ......Page template 4838107174414911
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'||chr(10)||
'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'  <title>#TITLE#</title>'||chr(10)||
'  <link rel="icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
'  <link rel="shortcut icon" href="#IMAG';

c1:=c1||'E_PREFIX#favicon.ico" type="image/x-icon">'||chr(10)||
' #HEAD#'||chr(10)||
'  <link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css" />'||chr(10)||
'  <!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie.css" type="text/css" /><![endif]-->'||chr(10)||
'  <!--[if IE 6]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie6.css" type="text/css" /><![endif]--';

c1:=c1||'>'||chr(10)||
'  <!--[if IE 7]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0_ie7.css" type="text/css" /><![endif]-->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'<!--[if lte IE 6]><div id="outdated-browser">#OUTDATED_BROWSER#</div><![endif]-->'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<div id="footer"><div class="content">'||chr(10)||
'<div id="customize">#CUSTOMIZE#</div>'||chr(10)||
'<div class="app-version">#APP_VERSION#</div>'||chr(10)||
'  #REGION_POSITION_05#'||chr(10)||
'</div></div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="header">'||chr(10)||
'  <div id="logo"><a href="#HOME_LINK#">#LOGO##REGION_POSITION_06#</a></div>'||chr(10)||
'  #REGION_POSITION_07#'||chr(10)||
'  <div id="navbar">'||chr(10)||
'    <div class="app-user">#WELCOME_USER#</div>'||chr(10)||
'    #NAVIGATION_BAR#'||chr(10)||
'    #REGION_POSITION_08#'||chr(10)||
'  </div>'||chr(10)||
'  <div id="parent-tabs">'||chr(10)||
'    <div class="tab-holder">#PARENT_TAB_CELLS#</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="tabs">'||chr(10)||
'  <div class="frame">'||chr(10)||
'    <div class="bg">'||chr(10)||
'      <d';

c3:=c3||'iv class="tab-holder">'||chr(10)||
'        #TAB_CELLS#'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'||chr(10)||
'<div id="topbar">#REGION_POSITION_01##REGION_POSITION_04#</div>'||chr(10)||
'<div id="messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div id="body">'||chr(10)||
'  <table class="tbl-body" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'    <tbody>'||chr(10)||
'      <tr>'||chr(10)||
'        <td class="tbl-main" width="100%">#REGI';

c3:=c3||'ON_POSITION_02##BOX_BODY#</td>'||chr(10)||
'        <td class="tbl-sidebar">#REGION_POSITION_03#</td>     '||chr(10)||
'      </tr>'||chr(10)||
'    </tbody>'||chr(10)||
'  </table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 4838107174414911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs - Right Sidebar (optional / table-based)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="success" id="success-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''success-message'')" style="float:right;" class="remove-message" alt="" />'||chr(10)||
'  #SUCCESS_MESSAGE#'||chr(10)||
'</div>',
  p_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div class="#TAB_STATUS#"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<div class="current"><div>'||chr(10)||
'#TAB_LABEL##TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<div class="noncurrent"><div>'||chr(10)||
'<a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#'||chr(10)||
'</div></div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="notification" id="notification-message">'||chr(10)||
'  <img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''notification-message'')"  style="float:right;" class="remove-message" alt="" />#MESSAGE#'||chr(10)||
'</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<div class="navbar-entry"><a href="#LINK#" class="t1NavigationBar">#TEXT#</a></div>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

prompt  ...button templates
--
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 4838226535414911
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<button value="#LABEL#" onclick="#LINK#" class="button-default" type="button">'||chr(10)||
'  <span>#LABEL#</span>'||chr(10)||
'</button>';

wwv_flow_api.create_button_templates (
  p_id=>4838226535414911 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1_hot_button
prompt  ......Button Template 4838306817414911
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<button value="#LABEL#" onclick="#LINK#" class="button-alt1" type="button">'||chr(10)||
'  <span>#LABEL#</span>'||chr(10)||
'</button>';

wwv_flow_api.create_button_templates (
  p_id=>4838306817414911 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1 - Hot Button',
  p_translate_this_template => 'N',
  p_theme_id  => 7,
  p_theme_class_id => 4,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 4838412442414911
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<button value="#LABEL#" onclick="#LINK#" class="button-alt2" type="button">'||chr(10)||
'  <span>#LABEL#</span>'||chr(10)||
'</button>';

wwv_flow_api.create_button_templates (
  p_id=>4838412442414911 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 7,
  p_theme_class_id => 5,
  p_template_comment       => 'XP Square FFFFFF');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 4838512495414911
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<button value="#LABEL#" onclick="#LINK#" class="button-alt3" type="button">'||chr(10)||
'  <span>#LABEL#</span>'||chr(10)||
'</button>';

wwv_flow_api.create_button_templates (
  p_id=>4838512495414911 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_template_comment       => 'Standard Button');
end;
/
---------------------------------------
prompt  ...region templates
--
--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 4838619911414911
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4838619911414911 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="borderless-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="bl-top">'||chr(10)||
'    <div class="bl-title">#TITLE#</div>'||chr(10)||
'    <div class="bl-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="bl-body">#BODY#</div>'||chr(10)||
'</div>'||chr(10)||
'<div class="clear"></div>'
 ,p_page_plug_template_name => 'Borderless Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 7
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Use this region template when you want to contain content without a border.'||chr(10)||
''||chr(10)||
'TITLE=YES'||chr(10)||
'BUTTONS=YES'||chr(10)||
'100% WIDTH=NO'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4838619911414911 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 4838728225414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4838728225414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="bracketed-region brackets" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="bk-top">'||chr(10)||
'    <div class="bk-top-r">'||chr(10)||
'      <div class="bk-title">#TITLE#</div>'||chr(10)||
'      <div class="bk-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="bk-body">#BODY#</div>'||chr(10)||
'  <div class="bk-bottom">'||chr(10)||
'    <div class="bk-bott'||
'om-r">&nbsp;</div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Bracketed Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 18
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Use this region template when you want to contain content with a bracket UI.'||chr(10)||
''||chr(10)||
'TITLE=YES'||chr(10)||
'BUTTONS=YES'||chr(10)||
'100% WIDTH=NO'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4838728225414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 4838801336414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4838801336414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="breadcrumb-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>#BODY#</div>'
 ,p_page_plug_template_name => 'Breadcrumb Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 6
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Use this region template to contain breadcrumb menus.  Breadcrumb menus are implemented using breadcrumbs.  Breadcrumb menus are designed to displayed in #REGION_POSITION_01#'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4838801336414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 4838905909414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4838905909414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-blank" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top">'||chr(10)||
'    <div class="rc-gray-top-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-body">'||chr(10)||
'    <div class="rc-body-r">'||chr(10)||
'      <div class="rc-content-main">'||chr(10)||
'        <div class="rc-left">'||chr(10)||
'          #TITLE#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="rc-right">'||chr(10)||
'          #CLOSE##COPY##DELETE##CHANGE##EDIT##PREVIOUS##N'||
'EXT##CREATE##EXPAND#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="clear"></div>'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-bottom">'||chr(10)||
'    <div class="rc-bottom-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Button Region with Title'
 ,p_theme_id => 7
 ,p_theme_class_id => 4
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4838905909414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 4839013563414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839013563414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-blank" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top">'||chr(10)||
'    <div class="rc-gray-top-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-body">'||chr(10)||
'    <div class="rc-body-r">'||chr(10)||
'      <div class="rc-content-main">'||chr(10)||
'        <div class="rc-left">'||chr(10)||
'          #BODY#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="rc-right">'||chr(10)||
'          #CLOSE##COPY##DELETE##CHANGE##EDIT##PREVIOUS##NE'||
'XT##CREATE##EXPAND#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="clear"></div>'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-bottom">'||chr(10)||
'    <div class="rc-bottom-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Button Region without Title'
 ,p_theme_id => 7
 ,p_theme_class_id => 17
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839013563414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_list
prompt  ......region template 4839116402414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839116402414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'    <div class="rc-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r"><div class="rc-content-main">'||chr(10)||
'     <div class="'||
'rc-image"><img src="#IMAGE_PREFIX#themes/theme_7/images/report_icon.png" alt="" /></div>'||chr(10)||
'      <div class="rc-content">#BODY#</div>'||chr(10)||
'<div class="clear"></div>'||chr(10)||
'</div>'||chr(10)||
'</div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Chart List'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 29
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839116402414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 4839217975414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839217975414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="rc-content-main">#BODY#<div cl'||
'ass="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Chart Region'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 30
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839217975414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 4839304121414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839304121414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="rc-content-main">'||chr(10)||
'#BODY#<div c'||
'lass="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Form Region'
 ,p_plug_table_bgcolor => '#f7f7e7'
 ,p_theme_id => 7
 ,p_theme_class_id => 8
 ,p_plug_heading_bgcolor => '#f7f7e7'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839304121414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 4839416734414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839416734414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="hide-show-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="hide-show-top">'||chr(10)||
'    <div class="hide-show-title"><a style="margin-left:5px;" href="javascript:hideShow(''region#REGION_SEQUENCE_ID#'',''shIMG#REGION_SEQUENCE_ID#'',''#IMAGE_PREFIX#themes/theme_7/images/right_arrow.png'',''#IMAGE_PREFIX#themes/theme_7/images/down_arrow.png'');" class="t1HideandShowRegionLink"><img src='||
'"#IMAGE_PREFIX#themes/theme_7/images/right_arrow.png" '||chr(10)||
'  id="shIMG#REGION_SEQUENCE_ID#" alt="" /></a> #TITLE#</div>'||chr(10)||
'    <div class="hide-show-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="hide" id="region#REGION_SEQUENCE_ID#">#BODY#</div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Hide and Show Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 1
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Gray Head, white body'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839416734414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 4839509274414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839509274414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="navigation-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'    <h3>#TITLE#</h3>'||chr(10)||
'  <div>'||chr(10)||
'    #BODY#'||chr(10)||
'  </div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Navigation Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 5
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839509274414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 4839603421414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839603421414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="navigation-region-alt" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>#BODY#</div>'
 ,p_page_plug_template_name => 'Navigation Region, Alternative 1'
 ,p_theme_id => 7
 ,p_theme_class_id => 16
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839603421414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/nested_region
prompt  ......region template 4839728718414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839728718414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-nested" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'	<div class="nr-top">'||chr(10)||
'		<div class="nr-top-r">'||chr(10)||
'    <div class="nr-title">#TITLE#</div>'||chr(10)||
'    <div class="nr-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'		</div>'||chr(10)||
'	</div>'||chr(10)||
'	<div class="nr-body">'||chr(10)||
'		<div class="nr-content-main">'||chr(10)||
'			#BODY#'||chr(10)||
'			<div class="clear"></div'||
'>'||chr(10)||
'		</div>'||chr(10)||
'	</div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Nested Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 22
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Use this region template when you want to contain content without a border.'||chr(10)||
''||chr(10)||
'TITLE=YES'||chr(10)||
'BUTTONS=YES'||chr(10)||
'100% WIDTH=NO'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839728718414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_titles
prompt  ......region template 4839831975414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839831975414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="borderless-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="bl-body">#BODY#</div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Region without Buttons and Titles'
 ,p_theme_id => 7
 ,p_theme_class_id => 19
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839831975414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 4839912075414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4839912075414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="borderless-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="bl-top">'||chr(10)||
'    <div class="bl-title">&nbsp;</div>'||chr(10)||
'    <div class="bl-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="bl-body">#BODY#</div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Region without Title'
 ,p_theme_id => 7
 ,p_theme_class_id => 11
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4839912075414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_filter_single_row
prompt  ......region template 4840023588414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840023588414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<table class="apex_finderbar" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_top" valign="top"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8" alt=""  class="spacer" alt="" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle"><img src="#IMAGE_PREFIX#htmldb/builder/builder_f'||
'ind.png" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle" style="">#BODY#</td>'||chr(10)||
'<td class="apex_finderbar_left" rowspan="3" width="10"><br /></td>'||chr(10)||
'<td class="apex_finderbar_buttons" rowspan="3" valign="middle" nowrap="nowrap"><span class="apex_close">#CLOSE#</span><span>#EDIT##CHANGE##DELETE##CREATE##CREATE2##COPY##PREVIOUS##NEXT##EXPAND##HELP#</span></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="'||
'apex_finderbar_left_middle"><br /></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_bottom" valign="bottom"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8"  class="spacer" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>'
 ,p_page_plug_template_name => 'Report Filter - Single Row'
 ,p_theme_id => 7
 ,p_theme_class_id => 31
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840023588414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_list
prompt  ......region template 4840108515414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840108515414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-alt" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'    <div class="rc-content-main">'||chr(10)||
'    '||
'#BODY#'||chr(10)||
'    </div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Report List'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 29
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840108515414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 4840201642414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840201642414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="rc-content-main">#BODY#<div cl'||
'ass="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div> '
 ,p_page_plug_template_name => 'Reports Region'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 9
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840201642414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 4840330674414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840330674414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region float-left-100pct" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="rc-content-m'||
'ain">#BODY#<div class="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'||chr(10)||
''
 ,p_page_plug_template_name => 'Reports Region 100% Width'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 13
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840330674414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 4840430420414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840430420414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-alt" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="rc-content-main">#BODY#<di'||
'v class="clear"></div>'||chr(10)||
'<div class="clear"></div>'||chr(10)||
'</div>'||chr(10)||
'</div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Reports Region, Alternative 1'
 ,p_plug_table_bgcolor => '#ffffff'
 ,p_theme_id => 7
 ,p_theme_class_id => 10
 ,p_plug_heading_bgcolor => '#ffffff'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => 'Red Theme'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840430420414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 4840501966414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840501966414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="sidebar-region">'||chr(10)||
'<div class="rounded-corner-region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div class="r'||
'c-content-main">#BODY#<div class="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div> '||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Sidebar Region'
 ,p_plug_table_bgcolor => '#f7f7e7'
 ,p_theme_id => 7
 ,p_theme_class_id => 2
 ,p_plug_heading_bgcolor => '#f7f7e7'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => '<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tl_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'          <td bgcolor="#000000" height="1"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tr_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#FF0000" height="16">'||chr(10)||
'            <table border="0" cellpadding="0" cellspacing="0" width="100%">'||chr(10)||
'              <tr>'||chr(10)||
'                <td align=middle valign="top">'||chr(10)||
'                  <div align="center">'||chr(10)||
'                     <font color="#ffffff" face="Arial, Helvetica, sans-serif" size="1">'||chr(10)||
'                      <b>#TITLE# </b></font></div>'||chr(10)||
'                </td>'||chr(10)||
'              </tr>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'   <tr>'||chr(10)||
'   <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'   <td valign="top" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="146" height="1" border="0" alt="" /><br />'||chr(10)||
'            <table border="0" cellpadding="1" cellspacing="0" width="146" summary="">'||chr(10)||
'              <tr>'||chr(10)||
'                <td colspan="2">'||chr(10)||
'                  <table border="0" cellpadding="2" cellspacing="0" width="124" summary="">'||chr(10)||
'                    <tr>'||chr(10)||
'                      <td>&nbsp;</td>'||chr(10)||
'                      <td valign="top" width="106">'||chr(10)||
'                        <P><FONT face="arial, helvetica" size="1">'||chr(10)||
'                            #BODY#'||chr(10)||
'                           </font>'||chr(10)||
'                        </P>'||chr(10)||
'                      </td>'||chr(10)||
'                    </tr>'||chr(10)||
'                  </table>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'          <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'      </table>'||chr(10)||
'      <table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#bl_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'          <td bgcolor="#ffffff" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#br_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#000000" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
''
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840501966414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 4840606092414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840606092414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="sidebar-region">'||chr(10)||
'<div class="rounded-corner-region-alt" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div clas'||
's="rc-content-main">#BODY#<div class="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div> '||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Sidebar Region, Alternative 1'
 ,p_plug_table_bgcolor => '#f7f7e7'
 ,p_theme_id => 7
 ,p_theme_class_id => 3
 ,p_plug_heading_bgcolor => '#f7f7e7'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840606092414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_2
prompt  ......region template 4840710757414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840710757414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="sidebar-region">'||chr(10)||
'<div class="rounded-corner-region-alt2" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'<div cla'||
'ss="rc-content-main">#BODY#<div class="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div> '||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Sidebar Region, Alternative 2'
 ,p_plug_table_bgcolor => '#f7f7e7'
 ,p_theme_id => 7
 ,p_theme_class_id => 3
 ,p_plug_heading_bgcolor => '#f7f7e7'
 ,p_plug_font_size => '-1'
 ,p_translate_this_template => 'N'
 ,p_template_comment => '<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tl_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'          <td bgcolor="#000000" height="1"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tr_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#FF0000" height="16">'||chr(10)||
'            <table border="0" cellpadding="0" cellspacing="0" width="100%">'||chr(10)||
'              <tr>'||chr(10)||
'                <td align=middle valign="top">'||chr(10)||
'                  <div align="center">'||chr(10)||
'                     <font color="#ffffff" face="Arial, Helvetica, sans-serif" size="1">'||chr(10)||
'                      <b>#TITLE# </b></font></div>'||chr(10)||
'                </td>'||chr(10)||
'              </tr>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'   <tr>'||chr(10)||
'   <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'   <td valign="top" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="146" height="1" border="0" alt="" /><br />'||chr(10)||
'            <table border="0" cellpadding="1" cellspacing="0" width="146" summary="">'||chr(10)||
'              <tr>'||chr(10)||
'                <td colspan="2">'||chr(10)||
'                  <table border="0" cellpadding="2" cellspacing="0" width="124" summary="">'||chr(10)||
'                    <tr>'||chr(10)||
'                      <td>&nbsp;</td>'||chr(10)||
'                      <td valign="top" width="106">'||chr(10)||
'                        <P><FONT face="arial, helvetica" size="1">'||chr(10)||
'                            #BODY#'||chr(10)||
'                           </font>'||chr(10)||
'                        </P>'||chr(10)||
'                      </td>'||chr(10)||
'                    </tr>'||chr(10)||
'                  </table>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'          <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'      </table>'||chr(10)||
'      <table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#bl_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'          <td bgcolor="#ffffff" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#br_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#000000" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
''
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840710757414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/top_bar
prompt  ......region template 4840807393414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840807393414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-blank" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top">'||chr(10)||
'    <div class="rc-gray-top-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-body">'||chr(10)||
'    <div class="rc-body-r">'||chr(10)||
'      <div class="rc-content-main">'||chr(10)||
'        <div class="rc-left">'||chr(10)||
'          #BODY#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="rc-right">'||chr(10)||
'          #CLOSE##COPY##DELETE##CHANGE##EDIT##PREVIOUS##NE'||
'XT##CREATE##EXPAND#'||chr(10)||
'        </div>'||chr(10)||
'        <div class="clear"></div>'||chr(10)||
'      </div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="rc-bottom">'||chr(10)||
'    <div class="rc-bottom-r"></div>'||chr(10)||
'  </div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Top Bar'
 ,p_theme_id => 7
 ,p_theme_class_id => 21
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840807393414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 4840913627414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4840913627414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-wizard" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'<div class="rc-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-main">#BODY#<div cla'||
'ss="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Wizard Region'
 ,p_theme_id => 7
 ,p_theme_class_id => 12
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4840913627414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 4841016262414912
 
begin
 
wwv_flow_api.create_plug_template (
  p_id => 4841016262414912 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_template => 
'<div class="rounded-corner-region-wizard" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'  <div class="rc-gray-top"><div class="rc-gray-top-r">'||chr(10)||
'    <div class="rc-title">#TITLE#</div>'||chr(10)||
'<div class="rc-buttons">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>'||chr(10)||
'  </div></div>'||chr(10)||
'  <div class="rc-body"><div class="rc-body-r">'||chr(10)||
'<div class="rc-content-main">#BODY#<div cla'||
'ss="clear"></div></div></div></div>'||chr(10)||
'  <div class="rc-bottom"><div class="rc-bottom-r"></div></div>'||chr(10)||
'</div>'
 ,p_page_plug_template_name => 'Wizard Region with Icon'
 ,p_theme_id => 7
 ,p_theme_class_id => 20
 ,p_translate_this_template => 'N'
  );
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4841016262414912 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

prompt  ...List Templates
--
--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 4841113607414912
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<button value="#TEXT#" onclick="javascript:location.href=''#LINK#''" class="button-alt1" type="button">'||chr(10)||
'  <span>#TEXT#</span>'||chr(10)||
'</button>';

t2:=t2||'<button value="#TEXT#" onclick="javascript:location.href=''#LINK#''" class="button-default" type="button">'||chr(10)||
'  <span>#TEXT#</span>'||chr(10)||
'</button>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4841113607414912 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 7,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<div class="button-list">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_tree
prompt  ......list template 4841206791414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>4841206791414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Tree',
  p_theme_id  => 7,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/hierarchical_expanding
prompt  ......list template 4841305748414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>4841305748414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Hierarchical Expanding',
  p_theme_id  => 7,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 4841426973414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="list-item-current">'||chr(10)||
'  <div class="list-item-image"><a href="#LINK#" class="current"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ></a></div>'||chr(10)||
'  <div class="list-item-label"><a href="#LINK#" class="current">#TEXT#</a></div>'||chr(10)||
'</div>';

t2:=t2||'<div class="list-item-current">'||chr(10)||
'  <div class="list-item-image"><a href="#LINK#" class="current"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ></a></div>'||chr(10)||
'  <div class="list-item-label"><a href="#LINK#" class="current">#TEXT#</a></div>'||chr(10)||
'</div>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4841426973414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 7,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<div class="horizontal-images-list">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 4841525373414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4841525373414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="horizontal-links-list">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu
prompt  ......list template 4841628580414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_7/images/menu-small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" />'||chr(10)||
'</li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_7/images/menu-small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" alt="" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" alt="" / ></a></li>';

wwv_flow_api.create_list_template (
  p_id=>4841628580414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu',
  p_theme_id  => 7,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image
prompt  ......list template 4841701587414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#" id="#LIST_ITEM_ID#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR#  /></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt="" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#" id="#LIST_ITEM_ID#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR#  "/></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt="" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#" id="#LIST_ITEM_ID#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR#  /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt="" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom3(this,''S#LIST_ITEM_ID#'',''#LIST_ITEM_ID#'',false)" />'||chr(10)||
'<a href="#LINK#" class="dhtmlBottom">#TEXT#</a>'||chr(10)||
'</div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#" id="#LIST_ITEM_ID#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR#  /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom3(this,''S#LIST_ITEM_ID#'',''#LIST_ITEM_ID#'',false)" />'||chr(10)||
'<a href="#LINK#" class="dhtmlBottom">#TEXT#</a>'||chr(10)||
'</div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''S#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''S#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>4841701587414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image',
  p_theme_id  => 7,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="S#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 4841804704414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="active"><a href="#LINK#"><span>#TEXT#</span></a></li>';

t2:=t2||'<li><a href="#LINK#"><span>#TEXT#</span></a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4841804704414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 7,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<div class="sHorizontalTabs">'||chr(10)||
'	<div class="sHorizontalTabsInner">'||chr(10)||
'		<ul>',
  p_list_template_after_rows=>'		</ul>'||chr(10)||
'	</div>'||chr(10)||
'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 4841925462414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="list-item-current">'||chr(10)||
'  <div class="list-item-image"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ></div>'||chr(10)||
'  <div class="list-item-label"><a href="#LINK#" class="current">#TEXT#</a></div>'||chr(10)||
'</div>';

t2:=t2||'<div class="list-item">'||chr(10)||
'  <div class="list-item-image"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ></div>'||chr(10)||
'  <div class="list-item-label"><a href="#LINK#" class="current">#TEXT#</a></div>'||chr(10)||
'</div>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4841925462414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 7,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<div class="vertical-images-list">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 4842002006414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842002006414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="vertical-ordered-List">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 4842129542414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="active"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842129542414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 7,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<ul class="vertical-sidebar-list">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 4842217442414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842217442414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="vertical-unordered-list-with-bullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_without_bullets
prompt  ......list template 4842305846414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842305846414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List without Bullets',
  p_theme_id  => 7,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="vertical-unordered-list-without-bullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_bar_horizontal_train
prompt  ......list template 4842416341414913
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'    <li class="#LIST_STATUS#">'||chr(10)||
'      <span>#TEXT#</span>'||chr(10)||
'    </li>';

t2:=t2||'    <li class="#LIST_STATUS#">'||chr(10)||
'      <span>#TEXT#</span>'||chr(10)||
'    </li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842416341414913 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress Bar, Horizontal Train',
  p_theme_id  => 7,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<div class="sHorizontalProgressList">'||chr(10)||
'  <ul>',
  p_list_template_after_rows=>'  </ul>'||chr(10)||
'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 4842501315414914
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="current">#TEXT#</li>';

t2:=t2||'<li class="non-current">#TEXT#</li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4842501315414914 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 7,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<div class="wizard-progress-list" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#><ul>',
  p_list_template_after_rows=>'</ul></div>',
  p_between_items=>'<li class="progress-indicator">&nbsp;</li>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

prompt  ...report templates
--
--application/shared_components/user_interface/templates/report/borderless_report
prompt  ......report template 4842613113414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4842613113414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless Report',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr>'||chr(10)||
'<td><table class="report-borderless" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="header"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#ccc',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4842613113414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/fixed_headers
prompt  ......report template 4842709891414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data" #COLUMN_WIDTH#><p #COLUMN_WIDTH#>#COLUMN_VALUE#</p></td>';

c2:=c2||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data-alt" #COLUMN_WIDTH#><p #COLUMN_WIDTH#>#COLUMN_VALUE#</p></td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4842709891414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Fixed Headers',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#" class="report-holder">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><div class="fixed-header-report"><table cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</tbody></table></div><div class="CSV">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_before_column_heading=>'<thead>'||chr(10)||
'',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="header" #COLUMN_WIDTH#>#COLUMN_HEADER#</th>',
  p_after_column_heading=>'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>'||chr(10)||
'',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_mouse_over=>'#d6dae4',
  p_row_style_checked=>'#d6dae4',
  p_theme_id  => 7,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4842709891414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>'||chr(10)||
'');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 4842813330414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4842813330414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" cellspacing="0" border="0" class="report-standard" summary="">',
  p_row_template_after_rows =>'</table><div class="CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="header">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#ccc',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4842813330414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 4842926860414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<li>#COLUMN_VALUE#</li>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4842926860414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr><td><ul class="t1OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'NOT_CONDITIONAL',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'NOT_CONDITIONAL',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4842926860414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'OMIT',
  p_row_template_after_last =>'OMIT');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/search_results_report_link_text_link_target_detail1_detail2_last_modified
prompt  ......report template 4843007415414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<li>'||chr(10)||
'<span class="title"><a href="#2#">#1#</a></span>'||chr(10)||
'<span class="description"><span class="last_modified">#5#</span>#3#</span>'||chr(10)||
'<span class="type">#4#</span>'||chr(10)||
'</li>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843007415414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Search Results Report (link_text, link_target, detail1, detail2, last_modified)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>' <ul class="sSearchResultsReport">',
  p_row_template_after_rows =>' </ul> '||chr(10)||
'#PAGINATION#',
  p_row_template_table_attr =>'',
  p_row_template_type =>'NAMED_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_7/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="pagination"><img src="#IMAGE_PREFIX#themes/theme_7/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>'||chr(10)||
'',
  p_next_set_template=>'<a href="#LINK#" class="pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_7/paginate_next.gif" alt="Next"></a>'||chr(10)||
'',
  p_previous_set_template=>'<a href="#LINK#" class="pagination"><img src="#IMAGE_PREFIX#themes/theme_7/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 4843113555414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843113555414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" border="0" cellspacing="0" summary="" class="report-standard">',
  p_row_template_after_rows =>'</table><div class="CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="header">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_mouse_over=>'#DDD',
  p_row_style_checked=>'#ccc',
  p_theme_id  => 7,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4843113555414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 4843205265414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td class="data"#ALIGNMENT#>#COLUMN_VALUE#</td>';

c2:=c2||'<td class="dataalt"#ALIGNMENT#>#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843205265414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#" class="report-holder">#TOP_PAGINATION#<tr><td>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" class="report-standard-alternatingrowcolors" summary="" >',
  p_row_template_after_rows =>'</table><div class="CSV">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="header"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 7,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4843205265414914 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>'||chr(10)||
'');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/two_column_portlet
prompt  ......report template 4843314147414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<div class="report-row">'||chr(10)||
'  <div class="report-col-hdr">#1#</div>'||chr(10)||
'  <div class="report-col-val">#2#</div>'||chr(10)||
'</div>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843314147414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Two Column Portlet',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div class="two-col-report-portlet" #REPORT_ATTRIBUTES# id="#REGION_ID#">',
  p_row_template_after_rows =>'</div>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'NAMED_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_theme_id  => 7,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs_div
prompt  ......report template 4843416487414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<div class="report-row">'||chr(10)||
'  <div class="report-col-hdr">#COLUMN_HEADER#</div>'||chr(10)||
'  <div class="report-col-val">#COLUMN_VALUE#</div>'||chr(10)||
'</div>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843416487414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs - Div',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div class="two-col-report-portlet">',
  p_row_template_after_rows =>'</div>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_theme_id  => 7,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs_table
prompt  ......report template 4843512470414914
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr><th class="header">#COLUMN_HEADER#</th><td class="data">#COLUMN_VALUE#</td></tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4843512470414914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs - Table',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr><td><table cellpadding="0" cellspacing="0" border="0" summary="" class="ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 7,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/borderless_report_with_colors
prompt  ......report template 4963602874586482
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data" style="background-color: #FF5588;">#COLUMN_VALUE#</td>';

c2:=c2||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data" style="background-color: #FFFF99;">#COLUMN_VALUE#</td>';

c3:=c3||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data" style="background-color: #99CCFF;">#COLUMN_VALUE#</td>';

c4:=c4||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="data">#COLUMN_VALUE#</td>';

wwv_flow_api.create_row_template (
  p_id=> 4963602874586482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless Report with Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '''#STATUS#''=''NOTX''',
  p_row_template2=> c2,
  p_row_template_condition2=> '''#STATUS#''=''UNKN''',
  p_row_template3=> c3,
  p_row_template_condition3=> '''#STATUS#''=''IGNR'' or ''#STATUS#''=''EXCL''',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr>'||chr(10)||
'<td><table class="report-borderless" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="header"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'NOT_CONDITIONAL',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT#</a>',
  p_previous_page_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="sPaginationNext">#PAGINATION_NEXT_SET#</a>',
  p_previous_set_template=>'<a href="#LINK#" class="sPaginationPrev">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#ccc',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4963602874586482 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

prompt  ...label templates
--
--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 4843631236414915
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4843631236414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="no-label">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 7,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional
prompt  ......label template 4843706770414915
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4843706770414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="optional">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_with_help
prompt  ......label template 4843803724414915
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4843803724414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional with help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><a class="optional-w-help" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required
prompt  ......label template 4843906688414915
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4843906688414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><img src="#IMAGE_PREFIX#themes/theme_7/images/required.gif" alt="#VALUE_REQUIRED#" tabindex="999" /><span class="required">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 7,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_with_help
prompt  ......label template 4844030761414915
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4844030761414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required with help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><img src="#IMAGE_PREFIX#themes/theme_7/images/required.gif" alt="#VALUE_REQUIRED#" tabindex="999" /><a class="required-w-help" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

prompt  ...breadcrumb templates
--
--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 4844109108414915
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 4844109108414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'<div id="breadcrumbs"><ul class="breadcrumb-list">',
  p_current_page_option=>'<li class="current">#NAME#</li>',
  p_non_current_page_option=>'<li class="noncurrent"><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'<li class="sep">&rsaquo;</li>',
  p_after_last=>'</ul></div><div class="clear"></div>',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 4844228117414915
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 4844228117414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t1HierarchicalMenu">',
  p_current_page_option=>'<li class="t1current">#NAME#</li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/popuplov
prompt  ...popup list of values templates
--
prompt  ......template 4844920567414917
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 4844920567414917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#list_gray.gif',
  p_popup_icon_attr=>'width="13" height="13" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="shortcut icon" href="#IMAGE_PREFIX#favicon.ico" type="image/x-icon"><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_7/css/theme_4_0.css" type="text/css">'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" class="pop-up-lov"',
  p_before_field_text=>'<div class="t1PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t1PopupBody">',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ...calendar templates
--
--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 4844317242414915
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4844317242414915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="Today">',
  p_weekend_title_format=> '<div class="WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="WeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="DayCalendar">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="Today">',
  p_daily_time_open_format => '<th class="Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_cust_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="MonthTitle">#WTITLE#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_cust_day_of_week_format => '<th class="DayOfWeek">#IDAY#</th>',
  p_cust_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="Calendar">',
  p_cust_month_close_format => '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_cust_week_title_format => '',
  p_cust_week_open_format => '<tr>',
  p_cust_week_close_format => '</tr> ',
  p_cust_day_title_format => '<div class="DayTitle">#DD#</div>',
  p_cust_day_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="Day" valign="top">',
  p_cust_day_close_format => '</td>',
  p_cust_today_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="Today">',
  p_cust_daily_title_format => '',
  p_cust_daily_open_format => '',
  p_cust_daily_close_format => '',
  p_cust_nonday_title_format => '<div class="NonDayTitle">#DD#</div>',
  p_cust_nonday_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="NonDay" valign="top">',
  p_cust_nonday_close_format => '</td>',
  p_cust_weekend_title_format => '<div class="WeekendDayTitle">#DD#</div>',
  p_cust_weekend_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="WeekendDay">',
  p_cust_weekend_close_format => '</td>',
  p_cust_hour_open_format => '<tr>',
  p_cust_hour_close_format => '</tr>',
  p_cust_time_title_format => '#TIME#',
  p_cust_time_open_format => '<th class="Hour">',
  p_cust_time_close_format => '<br /></th>',
  p_cust_wk_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_cust_wk_day_of_week_format => '<th class="DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_cust_wk_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="WeekCalendar">',
  p_cust_wk_month_close_format => '</table></td></tr></table>',
  p_cust_wk_week_title_format => '',
  p_cust_wk_week_open_format => '',
  p_cust_wk_week_close_format => '',
  p_cust_wk_day_title_format => '',
  p_cust_wk_day_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="Day" valign="top">',
  p_cust_wk_day_close_format => '<br /></td>',
  p_cust_wk_today_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="Today" valign="top">',
  p_cust_wk_weekend_title_format => '',
  p_cust_wk_weekend_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" valign="top" class="NonDay">',
  p_cust_wk_weekend_close_format => '<br /></td>',
  p_cust_month_day_height_pix => '75',
  p_cust_month_day_height_per => '',
  p_cust_week_day_width_pix => '',
  p_cust_week_day_width_per => '14',
  p_theme_id  => 7,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 4844531208414916
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4844531208414916 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th valign="bottom" class="DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="Day" valign="top" height="100" height="100">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="Today">',
  p_weekend_title_format=> '<div class="WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="WeekCalendarAlternative1">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="DayCalendarAlternative1Holder"> <tr><td class="MonthTitle">#IMONTH# #DD#, #YYYY#</td></tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="DayCalendarAlternative1">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="Today">',
  p_daily_time_open_format => '<th class="Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_cust_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="MonthTitle">#WTITLE#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_cust_day_of_week_format => '<th valign="bottom" class="DayOfWeek">#IDAY#</th>',
  p_cust_month_open_format => '<table border="0" cellpadding="0" cellspacing="4" summary="0" class="CalendarAlternative1">'||chr(10)||
'',
  p_cust_month_close_format => '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_cust_week_title_format => '',
  p_cust_week_open_format => '<tr>',
  p_cust_week_close_format => '</tr>',
  p_cust_day_title_format => '<div class="DayTitle">#DD#</div>',
  p_cust_day_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="Day" valign="top" height="100" height="100">',
  p_cust_day_close_format => '</td>',
  p_cust_today_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="Today">',
  p_cust_daily_title_format => '',
  p_cust_daily_open_format => '',
  p_cust_daily_close_format => '',
  p_cust_nonday_title_format => '<div class="NonDayTitle">#DD#</div>',
  p_cust_nonday_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="NonDay" valign="top">',
  p_cust_nonday_close_format => '</td>',
  p_cust_weekend_title_format => '<div class="WeekendDayTitle">#DD#</div>',
  p_cust_weekend_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="WeekendDay">',
  p_cust_weekend_close_format => '</td>',
  p_cust_hour_open_format => '<tr>',
  p_cust_hour_close_format => '</tr>',
  p_cust_time_title_format => '#TIME#',
  p_cust_time_open_format => '<th class="Hour">',
  p_cust_time_close_format => '<br /></th>',
  p_cust_wk_month_title_format => '<table cellspacing="4" cellpadding="0" border="0" summary="" class="WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_cust_wk_day_of_week_format => '<th class="DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_cust_wk_month_open_format => '<table border="0" cellpadding="0" cellspacing="4" summary="0" class="WeekCalendarAlternative1">'||chr(10)||
'',
  p_cust_wk_month_close_format => '</table></td></tr></table>',
  p_cust_wk_week_title_format => '',
  p_cust_wk_week_open_format => '',
  p_cust_wk_week_close_format => '',
  p_cust_wk_day_title_format => '',
  p_cust_wk_day_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="Day" valign="top">',
  p_cust_wk_day_close_format => '<br /></td>',
  p_cust_wk_today_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="Today" valign="top">',
  p_cust_wk_weekend_title_format => '',
  p_cust_wk_weekend_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" valign="top" class="NonDay">',
  p_cust_wk_weekend_close_format => '<br /></td>',
  p_cust_month_day_height_pix => '100',
  p_cust_month_day_height_per => '',
  p_cust_week_day_width_pix => '100',
  p_cust_week_day_width_per => '',
  p_theme_id  => 7,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calendar
prompt  ......template 4844722889414916
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4844722889414916 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="day-of-week">#DY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="small-calendar-holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="month-title">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="" class="small-calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_day_title_format=> '<div class="day-title">#DD#</div>',
  p_day_open_format=> '<td class="day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="today">',
  p_weekend_title_format=> '<div class="weekend-day-title">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="weekend-day">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="non-day-title">#DD#</div>',
  p_nonday_open_format => '<td class="non-day" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="DayOfWeek">#DY#<br />#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="SmallWeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="Day" valign="top"><div class="inner">',
  p_weekly_day_close_format => '</div></td>',
  p_weekly_today_open_format => '<td class="t1Today" valign="top"><div class="inner">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="NonDay"><div class="inner">',
  p_weekly_weekend_close_format => '</div></td>',
  p_weekly_time_open_format => '<th class="Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="DayOfWeek">#DY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="SmallDayCalendarHolder"> <tr> <td class="MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="SmallDayCalendar">',
  p_daily_month_close_format => '</table></td></tr></table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="Today">',
  p_daily_time_open_format => '<th class="Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_cust_month_title_format => '<table cellspacing="2" cellpadding="0" border="0" summary="" class="small-calendar-holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="month-title">#WTITLE#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_cust_day_of_week_format => '<th class="day-of-week">#DY#</th>',
  p_cust_month_open_format => '<table border="0" cellpadding="0" cellspacing="2" summary="" class="small-calendar">',
  p_cust_month_close_format => '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_cust_week_title_format => '',
  p_cust_week_open_format => '<tr>',
  p_cust_week_close_format => '</tr>',
  p_cust_day_title_format => '<div class="day-title">#DD#</div>',
  p_cust_day_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="day" valign="top">',
  p_cust_day_close_format => '</td>',
  p_cust_today_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="today">',
  p_cust_daily_title_format => '',
  p_cust_daily_open_format => '',
  p_cust_daily_close_format => '',
  p_cust_nonday_title_format => '<div class="non-day-title">#DD#</div>',
  p_cust_nonday_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" class="non-day" valign="top">',
  p_cust_nonday_close_format => '</td>',
  p_cust_weekend_title_format => '<div class="weekend-day-title">#DD#</div>',
  p_cust_weekend_open_format => '<td style="#COL_HEIGHT_PIX# #COL_HEIGHT_PER#" valign="top" class="weekend-day">',
  p_cust_weekend_close_format => '</td>',
  p_cust_hour_open_format => '<tr>',
  p_cust_hour_close_format => '</tr>',
  p_cust_time_title_format => '#TIME#',
  p_cust_time_open_format => '<th class="Hour">',
  p_cust_time_close_format => '<br /></th>',
  p_cust_wk_month_title_format => '<table cellspacing="2" cellpadding="0" border="0" summary="" class="SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_cust_wk_day_of_week_format => '<th class="DayOfWeek">#DY#<br />#MM#/#DD#</th>',
  p_cust_wk_month_open_format => '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="SmallWeekCalendar">',
  p_cust_wk_month_close_format => '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_cust_wk_week_title_format => '',
  p_cust_wk_week_open_format => '',
  p_cust_wk_week_close_format => '',
  p_cust_wk_day_title_format => '',
  p_cust_wk_day_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="Day" valign="top">',
  p_cust_wk_day_close_format => '<br /></td>',
  p_cust_wk_today_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" class="t1Today" valign="top">',
  p_cust_wk_weekend_title_format => '',
  p_cust_wk_weekend_open_format => '<td style="#COL_WIDTH_PIX# #COL_WIDTH_PER#" valign="top" class="NonDay">',
  p_cust_wk_weekend_close_format => '<br /></td>',
  p_cust_month_day_height_pix => '14',
  p_cust_month_day_height_per => '14',
  p_cust_week_day_width_pix => '40',
  p_cust_week_day_width_per => '14',
  p_theme_id  => 7,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

prompt  ...application themes
--
--application/shared_components/user_interface/themes/modern_blue
prompt  ......theme 4845000128414917
begin
wwv_flow_api.create_theme (
  p_id =>4845000128414917 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 7,
  p_theme_name=>'Modern Blue',
  p_default_page_template=>4837525507414910 + wwv_flow_api.g_id_offset,
  p_error_template=>4837131094414910 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>4837724123414910 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>4836711590414909 + wwv_flow_api.g_id_offset,
  p_default_button_template=>4838226535414911 + wwv_flow_api.g_id_offset,
  p_default_region_template=>4840201642414912 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>4839217975414912 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>4839304121414912 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>4840201642414912 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>4840201642414912 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>4840913627414912 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>4838801336414912 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>4839116402414912 + wwv_flow_api.g_id_offset,
  p_default_irr_template=>4839831975414912 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>4843113555414914 + wwv_flow_api.g_id_offset,
  p_default_label_template=>4843803724414915 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>4844109108414915 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>4844317242414915 + wwv_flow_api.g_id_offset,
  p_default_list_template=>4842217442414913 + wwv_flow_api.g_id_offset,
  p_default_option_label=>4843803724414915 + wwv_flow_api.g_id_offset,
  p_default_required_label=>4844030761414915 + wwv_flow_api.g_id_offset);
end;
/
 
prompt  ...build options used by application 700
--
 
begin
 
null;
 
end;
/

--application/shared_components/globalization/messages
prompt  ...messages used by application: 700
--
--application/shared_components/globalization/dyntranslations
prompt  ...dynamic translations used by application: 700
--
--application/shared_components/globalization/language
prompt  ...Language Maps for Application 700
--
 
begin
 
null;
 
end;
/

prompt  ...Shortcuts
--
prompt  ...web services (9iR2 or better)
--
prompt  ...shared queries
--
prompt  ...report layouts
--
prompt  ...authentication schemes
--
--application/shared_components/security/authentication/application_express
prompt  ......scheme 4845116734414920
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'-BUILTIN-';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 4845116734414920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Application Express',
  p_description=>'Use internal Application Express account credentials and login page in this application.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
end;
null;
 
end;
/

--application/shared_components/security/authentication/database
prompt  ......scheme 4845226213414920
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1:=s1||'-DATABASE-';

s2 := null;
s3 := null;
s4 := null;
s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 4845226213414920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE',
  p_description=>'Use database authentication (user identified by DAD).',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
end;
null;
 
end;
/

--application/shared_components/security/authentication/database_account
prompt  ......scheme 4845319779414920
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'return false; end;--';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 4845319779414920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE ACCOUNT',
  p_description=>'Use database account credentials.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
end;
null;
 
end;
/

prompt  ...plugins
--
--application/end_environment
commit;
commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt  ...done
