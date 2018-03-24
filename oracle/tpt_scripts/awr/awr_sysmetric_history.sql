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
  , metric_name
  , metric_unit
  , value
FROM
    dba_hist_snapshot
NATURAL JOIN
    dba_hist_sysmetric_history
WHERE
    metric_name LIKE '&1'
--    metric_name IN ('Physical Reads Per Sec')
--    metric_name IN ('Host CPU Utilization (%)')
--    metric_name IN ('Logons Per Sec')
AND begin_interval_time > SYSDATE - 15
ORDER BY
    metric_name
  , begin_time
/

