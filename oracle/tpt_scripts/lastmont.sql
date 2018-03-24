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

COL partial_sql_text FOR A40
SELECT
    SUBSTR(sql_text,1,40) partial_sql_text
  , sql_exec_start
  , sql_id
  , ROUND(elapsed_time/1000) ela_ms
  , ROUND(cpu_time/1000)     cpu_ms
  , buffer_gets              lios
  , ROUND(physical_read_bytes/1024/1024,2)      rd_mb
  , ROUND(physical_write_bytes/1024/1024,2)     wr_mb
FROM
    v$sql_monitor
WHERE
    sid = SYS_CONTEXT('USERENV','SID')
AND (sql_id, last_refresh_time) IN (
                         SELECT sql_id, MAX(last_refresh_time) 
                         FROM v$sql_monitor
                         WHERE sid = SYS_CONTEXT('USERENV','SID')
                         AND sql_text LIKE '&1'
                         GROUP BY sql_id
                        )
ORDER BY
    sql_exec_start
  , sql_exec_id
/

