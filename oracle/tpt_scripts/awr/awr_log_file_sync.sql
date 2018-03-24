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

SELECT
    CAST(begin_interval_time AS DATE) begin_time
  , AVG(CASE WHEN event_name = 'log file sync' THEN time_waited_micro/nullif(total_waits,0) END) avg_log_file_sync
  , AVG(CASE WHEN event_name = 'log file parallel write' THEN time_waited_micro/nullif(total_waits,0) END) avg_log_file_parallel_write
FROM
    dba_hist_snapshot
NATURAL JOIN
    dba_hist_system_event
WHERE
    event_name IN ('log file sync', 'log file parallel write')
AND begin_interval_time > SYSDATE - 15
GROUP BY CAST(begin_interval_time AS DATE)
ORDER BY
    begin_time
/

