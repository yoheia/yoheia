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
VAR inst_id NUMBER

COL bdate NEW_VALUE def_bdate
COL edate NEW_VALUE def_edate

SET TERMOUT OFF

SELECT
    TO_CHAR(SYSDATE-1/24, 'YYYY-MM-DD HH24:MI') bdate
  , TO_CHAR(SYSDATE     , 'YYYY-MM-DD HH24:MI') edate
FROM
    dual
/

SET TERMOUT ON

ACCEPT bdate DATE FORMAT 'YYYY-MM-DD HH24:MI' DEFAULT '&def_bdate' PROMPT "Enter begin time [&def_bdate]: " 
ACCEPT edate DATE FORMAT 'YYYY-MM-DD HH24:MI' DEFAULT '&def_edate' PROMPT "Enter   end time [&def_edate]: " 

BEGIN
SELECT inst_id, dbid INTO :inst_id, :dbid FROM gv$database;
END;
/


PROMPT Spooling into ash_report.txt
SPOOL ash_report.txt
SET TERMOUT OFF PAGESIZE 0 HEADING OFF LINESIZE 1000 TRIMSPOOL ON TRIMOUT ON TAB OFF

SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.ASH_REPORT_TEXT(:dbid, :inst_id, TO_DATE('&bdate', 'YYYY-MM-DD HH24:MI'), TO_DATE('&edate', 'YYYY-MM-DD HH24:MI'), null, null, null, null ));

SPOOL OFF
SET TERMOUT ON PAGESIZE 5000 HEADING ON
PROMPT Done.

HOST &_start ash_report.txt
