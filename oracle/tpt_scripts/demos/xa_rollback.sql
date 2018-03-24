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

DEF trans_id=&1

VAR begin_scn NUMBER;
VAR end_scn NUMBER;

EXEC :begin_scn := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;

ROLLBACK FORCE '&1';

EXEC :end_scn   := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;

-- noarchivelog:
DECLARE
    logfile VARCHAR2(1000);
BEGIN
    SELECT member INTO logfile FROM v$logfile WHERE group# = (SELECT group# FROM v$log WHERE status = 'CURRENT') AND rownum = 1;
    SYS.DBMS_LOGMNR.ADD_LOGFILE(logfile, DBMS_LOGMNR.NEW);
    SYS.DBMS_LOGMNR.START_LOGMNR(:begin_scn, :end_scn, OPTIONS=>DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);
END;
/

SELECT * FROM v$logmnr_contents;

SELECT scn,timestamp,xid,operation,seg_owner,seg_name,row_id,sql_redo FROM v$logmnr_contents;
-- then exit the session or close the logmnr session or run
-- EXEC SYS.DBMS_LOGMNR.END_LOGMNR;

