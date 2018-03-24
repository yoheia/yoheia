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

SET HEADING OFF LINESIZE 10000 PAGESIZE 0 TRIMSPOOL ON TRIMOUT ON VERIFY OFF LONG 999999 LONGCHU

ACCEPT sqlid FORMAT A13 PROMPT "Enter sql_id: "

SET TERMOUT OFF
spool sqlmon_&sqlid..html

SELECT
  DBMS_SQLTUNE.REPORT_SQL_MONITOR(
     sql_id=>'&sqlid',
     report_level=>'ALL',
     type => 'ACTIVE') as report
FROM dual
/

SPOOL OFF
SET TERMOUT ON HEADING ON LINESIZE 999

PROMPT File spooled into sqlmon_&sqlid..html

