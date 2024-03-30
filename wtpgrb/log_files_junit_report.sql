
--
--  Create JUnit XML Report of Database Log Files for "wtpgrb" Schema
--

--Element    | Description
-------------|-------------
--TestSuite  | install_SYS, install_SYSTEM, and install_wtpgrb
--Hostname   | Database Name
--Property   | name="Source Version" value="https://github.com/DMSTEX/DMSTEX.git at f2c736d0cc6fd80d961414dcae37df2bed0d69e2 (Branch: main)"
--Testcase   | Script Name
--Classname  | "Schema Name"."Object Type"
--Assertions | Number of PL/SQL Statements
--Status     | PASS/FAIL/ERROR/DISABLE
--Time       | Testcase Duration
--Timestamp  | Testcase Runtime (ISO 8601 format)
--Errors     | Number of Test Errors

declare
   --
   -- Process CLOB Contents from odbcapture_installation_logs
   line_txt    varchar2(4000);
   so_far      pls_integer;
   end_pos     pls_integer;
   --
   -- Varchar2 Associative Array
   TYPE vc2_aa_type is table of varchar2(4000)
      index by pls_integer;
   --
   -- Testcases
   TYPE tc_rec_type is record
      (schema_name     varchar2(128)
      ,script_ext      varchar2(10)  -- Script Name Extension
      ,num_statements  number(3)     -- Number of statements executed in a script
      ,status          varchar2(10)  -- PASS/FAIL
      ,duration_secs   number(5)
      ,t_timestamp     varchar2(20)  -- 2014-01-21T16:17:18
      ,error_message   varchar2(4000)
      ,tc_err_aa       vc2_aa_type
      ,tc_sys_out_aa   vc2_aa_type
      );
   TYPE tc_aa_type is table of tc_rec_type
      index by varchar2(256);     -- Testcase Name (Script Name with Path)
   tc_aa         tc_aa_type;
   tc_name       varchar2(256);   -- Testcase Name (Script Name with Path)
   prev_tc_name  varchar2(256);   -- Previous Testcase Name
   --
   tc_buff_aa      vc2_aa_type;      -- Buffer Array for Testcases
   sys_buff_aa     vc2_aa_type;      -- Buffer Array for System
   sys_err         boolean := FALSE; -- System Error Found
   --
   total_tests     number(4);
   total_errors    number(4);
   total_duration  number(6);
   --
   procedure initialize_testcase (in_buff in varchar2) is begin
      -- === DBI Started: "ODBCAPTURE/OBJ_INSTALL_COMMENTS_TAB.tab"
            tc_name              := replace(substr(in_buff, 18, 256),'"','');
      tc_aa(tc_name).schema_name := substr(tc_name, 1, instr(tc_name,'/',1)-1);
      tc_aa(tc_name).script_ext  := substr(tc_name, instr(tc_name,'.',-1)+1,10);
      tc_aa(tc_name).status      := 'PASS';
   end initialize_testcase;
   --
   procedure finalize_testcase (in_buff in varchar2) is begin
      if tc_name is null then return; end if;
      tc_aa(tc_name).t_timestamp   := substr(in_buff,22,19);
      tc_aa(tc_name).duration_secs := substr(in_buff,60,length(in_buff)-60-40);
      total_duration := total_duration + tc_aa(tc_name).duration_secs;
      if regexp_like(tc_name, '[.]cdl$')
      then
         tc_buff_aa(tc_buff_aa.COUNT + 1) := '### SQL*Loader Log File: ' || replace(tc_name,'.cdl','.log');
         begin
            select substr(replace(contents,CHR(10)||CHR(10),CHR(10)),1,4000)
             into  tc_buff_aa(tc_buff_aa.COUNT + 1)
             from  odbcapture_installation_logs
             where file_name = replace(tc_name,'.cdl','.log');
         exception when others then
            tc_buff_aa(tc_buff_aa.COUNT + 1) := SQLERRM;
         end;
      end if;
      if tc_aa(tc_name).status = 'FAIL'
      then
         tc_aa(tc_name).num_statements := 1;
         total_errors := total_errors + 1;
         if tc_buff_aa.COUNT > 0
         then
            for i in tc_buff_aa.FIRST .. tc_buff_aa.LAST
            loop
               tc_aa(tc_name).tc_err_aa(i) := tc_buff_aa(i);
            end loop;
         end if;
      else
         tc_aa(tc_name).num_statements := tc_buff_aa.COUNT;
         if tc_buff_aa.COUNT > 0
         then
            for i in tc_buff_aa.FIRST .. tc_buff_aa.LAST
            loop
               tc_aa(tc_name).tc_sys_out_aa(i) := tc_buff_aa(i);
            end loop;
         end if;
      end if;
      total_tests  := total_tests + 1;
      prev_tc_name := tc_name;
      tc_buff_aa.DELETE;
      tc_name := '';
   end finalize_testcase;
   --
   procedure process_contents_line (in_txt in varchar2) is
      ldr_txt    varchar2(4000);
   begin
      if in_txt is null then return; end if;
      case
         when regexp_like(in_txt, '^=== DBI Started: ')
         then
            if tc_name is not null
            then
               tc_buff_aa(tc_buff_aa.COUNT + 1) := 'Unexpected Testcase End: ' || in_txt;
               finalize_testcase('');
               initialize_testcase(in_txt);
               tc_buff_aa(tc_buff_aa.COUNT + 1) := in_txt;
            else
               initialize_testcase(in_txt);
               tc_buff_aa(tc_buff_aa.COUNT + 1) := in_txt;
            end if;
         when regexp_like(in_txt, '^=== DBI Completed at ')
         then
            -- === DBI Completed at 2024-03-05T02:54:49 for a duration of 1.25 seconds (started at 2024-03-05T02:54:48)
            if tc_name is not null
            then
               tc_buff_aa(tc_buff_aa.COUNT + 1) := in_txt;
               finalize_testcase(in_txt);
            else
               sys_err := TRUE;
               sys_buff_aa(sys_buff_aa.COUNT + 1) := 'Unexpected Testcase End: ' || in_txt;
            end if;
         when regexp_like(in_txt, '^(-- ){0,1}(PL[/]SQL:|(PLS|OCI|ORA|SP2|SQL|TNS)-[[:digit:]])')
         then
            -- (-- ){0,1}:  "-- " may or may not be present
            -- PL/SQL:      PL/SQL Message
            -- PLS-"digit"  PL/SQL Errors
            -- OCI-"digit"  Oracle Call Interface
            -- ORA-"digit"  Oracle Database Errors
            -- SP2-"digit"  SQL*Plus Errors
            -- SQL-"digit"  SQL Errors
            -- TNS-"digit"  Transparent Network Substrate Errors
            if tc_name is not null
            then
               tc_buff_aa(tc_buff_aa.COUNT + 1) := in_txt;
               tc_aa(tc_name).status := 'FAIL';
               if tc_aa(tc_name).error_message is null
               then
                  tc_aa(tc_name).error_message := in_txt;
               end if;
            else
               sys_err := TRUE;
               sys_buff_aa(sys_buff_aa.COUNT + 1) := '(' || prev_tc_name || ') ' || in_txt;
            end if;
         else
            if tc_name is not null
            then
               tc_buff_aa(tc_buff_aa.COUNT + 1) := in_txt;
            else
               sys_buff_aa(sys_buff_aa.COUNT + 1) := '(' || prev_tc_name || ') ' || in_txt;
            end if;
      end case;
   end process_contents_line;
   --
   procedure p (in_txt in varchar2) is begin
      dbms_output.put_line(in_txt);
   end p;
begin
   --
   prev_tc_name := 'Initializing';
   -- JUnit XML Format for Jenkins: "https://llg.cubic.org/docs/junit/"
   p('<?xml version="1.0" encoding="UTF-8"?>');
   p('<testsuites>');
   for buf1 in (select rownum                                        TS_ID
                      ,l.file_name
                      ,to_char(l.load_dtm,'YYYY-MM-DD') || 'T' ||
                       to_char(l.load_dtm,'HH24:MI:SS')              TSTAMP
                      ,db.db_unique_name
                      ,l.contents
                 from  odbcapture_installation_logs  l
                 cross join v$database  db
                 where l.install_type = 'wtpgrb'
                  and  l.file_name like 'install%'
                  and  l.load_dtm > trunc(sysdate,'DD') - 2
                 order by l.file_name, l.load_dtm)
   loop
      -- Initialize
      tc_aa.DELETE;
      tc_buff_aa.DELETE;
      sys_buff_aa.DELETE;
      tc_name        := '';
      total_tests    := 0;
      total_errors   := 0;
      total_duration := 0;
      -- Fill the Testcase Array
      so_far := 0;
      loop
         end_pos := instr(buf1.contents, chr(10), so_far + 1);
         exit when end_pos = 0;
         line_txt := substr(buf1.contents, so_far + 1, end_pos - so_far - 1);
         process_contents_line(line_txt);
         so_far := end_pos;
      end loop;
      line_txt := substr(buf1.contents, so_far + 1, 4000);
      process_contents_line(line_txt);
      -- testsuite can appear multiple times, if contained in a testsuites element. It can also be the root element.
      p('  <testsuite name="'      || buf1.file_name      || '"' || -- Full (class) name of the test for non-aggregated testsuite documents.  Class name without the package for aggregated testsuites documents. Required
                    ' tests="'     ||      total_tests    || '"' || -- The total number of tests in the suite, required.
                    ' errors="'    ||      total_errors   || '"' || -- The total number of tests in the suite that errored. An errored test is one that had an unanticipated problem, for example an unchecked throwable; or a problem with the implementation of the test. optional
                    ' hostname="'  || buf1.db_unique_name || '"' || -- Host on which the tests were executed. 'localhost' should be used if the hostname cannot be determined. optional
                    ' id="'        || buf1.TS_ID          || '"' || -- Starts at 0 for the first testsuite and is incremented by 1 for each following testsuite
                    ' time="'      ||      total_duration || '"' || -- Time taken (in seconds) to execute the tests in the suite. optional
                    ' timestamp="' || buf1.TSTAMP         || '"' || -- when the test was executed in ISO 8601 format (2014-01-21T16:17:18). Timezone may not be specified. optional
                    '>');
      tc_name := tc_aa.FIRST;
      while tc_name is not null
      loop
         -- testcase can appear multiple times, see /testsuites/testsuite@tests
            p('    <testcase name="'       ||       DBMS_XMLGEN.CONVERT(tc_name)                || '"' || -- Name of the test method, required.
                           ' assertions="' ||                     tc_aa(tc_name).num_statements || '"' || -- number of assertions in the test case. optional
                           ' classname="'  || DBMS_XMLGEN.CONVERT(tc_aa(tc_name).schema_name)   || '.' ||
                                              DBMS_XMLGEN.CONVERT(tc_aa(tc_name).script_ext)    || '"' || -- Full class name for the class the test method is in. required
                           ' status="'     ||                     tc_aa(tc_name).status         || '"' ||
                           ' time="'       ||                     tc_aa(tc_name).duration_secs  || '"' || -- Time taken (in seconds) to execute the test. optional
                           '>');
         if tc_aa(tc_name).status = 'PASS'
         then
            if tc_aa(tc_name).tc_sys_out_aa.COUNT > 0
            then
               -- Data that was written to standard out while the test was executed. optional
               p('      <system-out>');
               for i in tc_aa(tc_name).tc_sys_out_aa.FIRST .. tc_aa(tc_name).tc_sys_out_aa.LAST
               loop
                  p(DBMS_XMLGEN.CONVERT(tc_aa(tc_name).tc_sys_out_aa(i)));
               end loop;
               p('      </system-out>');
           end if;
         else
            -- Indicates that the test errored. An errored test is one that had an unanticipated problem. For example an unchecked throwable or a problem with the implementation of the test. Contains as a text node relevant data for the error, for example a stack trace. optional
            p('      <error message="' || DBMS_XMLGEN.CONVERT(tc_aa(tc_name).error_message) || '">' );  -- The error message. e.g., if a java exception is thrown, the return value of getMessage()
            if tc_aa(tc_name).tc_err_aa.COUNT > 0
            then
               for i in tc_aa(tc_name).tc_err_aa.FIRST .. tc_aa(tc_name).tc_err_aa.LAST
               loop
                  p(DBMS_XMLGEN.CONVERT(tc_aa(tc_name).tc_err_aa(i)));
               end loop;
            end if;
            p('      </error>');
         end if;
         p('    </testcase>');
         exit when tc_name = tc_aa.LAST;
         tc_name := tc_aa.NEXT(tc_name);
      end loop;
      if sys_buff_aa.COUNT > 0
      then
         if sys_err
         then
            -- Data that was written to standard error while the test suite was executed. optional
            p('    <system-err>');
            for i in sys_buff_aa.FIRST .. sys_buff_aa.LAST
            loop
               p(DBMS_XMLGEN.CONVERT(sys_buff_aa(i)));
            end loop;
            p('    </system-err>');
         else
            -- Data that was written to standard out while the test suite was executed. optional
            p('    <system-out>');
            for i in sys_buff_aa.FIRST .. sys_buff_aa.LAST
            loop
               p(DBMS_XMLGEN.CONVERT(sys_buff_aa(i)));
            end loop;
            p('    </system-out>');
         end if;
      end if;
      p('  </testsuite>');
   end loop;
   p('</testsuites>');
end;
/
