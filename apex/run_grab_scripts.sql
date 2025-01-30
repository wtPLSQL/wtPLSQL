
Prompt Running Grab Scripts

execute FH2.clear_buffers;
execute COMMON_UTIL.update_view_tabs;
execute GRAB_SCRIPTS.all_scripts('grbsrc');
execute GRAB_SCRIPTS.all_scripts('grbras');
execute GRAB_SCRIPTS.all_scripts('grbsdo');
execute GRAB_SCRIPTS.all_scripts('grbdat');
execute GRAB_SCRIPTS.all_scripts('grbtst');
execute GRAB_SCRIPTS.all_scripts('grbtjsn');
execute GRAB_SCRIPTS.all_scripts('grbtsdo');
execute GRAB_SCRIPTS.all_scripts('grbtctx');
execute GRAB_SCRIPTS.all_scripts('grbtdat');
delete from zip_files where file_name = 'capture_files.zip';
execute FH2.write_scripts('capture_files.zip');
commit;

--select "FILE_BLOB" from "ZIP_FILES" where "FILE_NAME" = 'capture_files.zip';
