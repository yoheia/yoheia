------------------------------------------------------------------------------
--
-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
------------------------------------------------------------------------------

VAR dbid NUMBER

PROMPT Listing latest AWR snapshots ...
SELECT snap_id, end_interval_time 
FROM dba_hist_snapshot 
--WHERE begin_interval_time > TO_DATE('2011-06-07 07:00:00', 'YYYY-MM-DD HH24:MI:SS') 
WHERE end_interval_time > SYSDATE - 1
ORDER BY end_interval_time;

ACCEPT bid NUMBER PROMPT "Enter begin snapshot id: "
ACCEPT eid NUMBER PROMPT "Enter   end snapshot id: "

BEGIN
  SELECT dbid INTO :dbid FROM v$database;
END;
/

SET TERMOUT OFF PAGESIZE 0 HEADING OFF LINESIZE 1000 TRIMSPOOL ON TRIMOUT ON TAB OFF

SPOOL awr_local_inst_1.html
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, 1, &bid, &eid));

-- SPOOL awr_local_inst_2.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, 2, &bid, &eid));
-- 
-- SPOOL awr_local_inst_3.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, 3, &bid, &eid));

-- SPOOL awr_global.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_GLOBAL_REPORT_HTML(:dbid, CAST(null AS VARCHAR2(10)), &bid, &eid));

SPOOL OFF
SET TERMOUT ON PAGESIZE 5000 HEADING ON

