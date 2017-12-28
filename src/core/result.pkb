create or replace package body result
as

   TYPE results_nt_type is table of results%ROWTYPE;
   g_results_nt      results_nt_type := results_nt_type(null);
   g_results_rec     results%ROWTYPE;

----------------------
--  Private Procedures
----------------------


---------------------
--  Public Procedures
---------------------

procedure initialize
      (in_test_run_id   in test_runs.id%TYPE)
is
begin
   g_results_rec.test_run_id  := in_test_run_id;
   g_results_rec.result_seq   := 0;
   g_results_rec.executed_dtm := systimestamp;
   g_results_nt := results_nt_type(null);
end initialize;

procedure finalize
is
begin
   forall i in 1 .. g_results_nt.COUNT
      insert into results values g_results_nt(i);
   g_results_nt := results_nt_type(null);
   g_results_rec.test_run_id := NULL;
end finalize;

procedure save
      (in_assertion      in results.assertion%TYPE
      ,in_status         in results.status%TYPE
      ,in_details        in results.details%TYPE
      ,in_testcase       in results.testcase%TYPE
      ,in_message        in results.message%TYPE
      ,in_error_message  in results.error_message%TYPE)
is
   l_current_tstamp  timestamp;
begin
   if g_results_rec.test_run_id IS NULL
   then
      DBMS_OUTPUT.PUT_LINE(in_status    || ' - ' ||
                           in_testcase  || ': ' ||
                           in_assertion || ' "' ||
                           in_message   || '" ' ||
                           in_details   );
      return;
   end if;
   -- Set the time and elapsed
   l_current_tstamp := systimestamp;
   g_results_rec.elapsed_msecs := extract(day from (
                                  l_current_tstamp - g_results_rec.executed_dtm
                                  ) * 86400 * 1000);
   g_results_rec.executed_dtm  := l_current_tstamp;
   -- Set the IN variables
   g_results_rec.assertion     := in_assertion;
   g_results_rec.status        := in_status;
   g_results_rec.details       := in_details;
   g_results_rec.testcase      := in_testcase;
   g_results_rec.message       := in_message;
   g_results_rec.error_message := in_error_message;
   -- Increment, Extend, and Load
   g_results_rec.result_seq    := g_results_rec.result_seq + 1;
   g_results_nt.extend;
   g_results_nt(g_results_rec.result_seq) := g_results_rec;
end save;

end result;
