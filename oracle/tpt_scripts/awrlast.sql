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
VAR inst_num NUMBER
VAR eid NUMBER
VAR bid NUMBER

BEGIN
SELECT dbid, USERENV('instance') INTO :dbid, :inst_num FROM v$database;
SELECT MAX(snap_id) INTO :eid FROM dba_hist_snapshot WHERE dbid = :dbid AND instance_number = :inst_num;
SELECT MAX(snap_id) INTO :bid FROM dba_hist_snapshot WHERE dbid = :dbid AND instance_number = :inst_num AND snap_id < :eid;
END;
/

SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(:dbid, :inst_num, :bid, :eid));
