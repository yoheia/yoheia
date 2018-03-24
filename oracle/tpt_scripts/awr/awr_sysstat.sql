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

COL begin_interval_time FOR A30
COL end_interval_time FOR A30
COL stat_name FOR A50

SELECT
    begin_interval_time, end_interval_time, stat_name
  , CASE WHEN value - LAG(value) OVER (PARTITION BY stat_name ORDER BY begin_interval_time) < 0 THEN value ELSE value - LAG(value) OVER (PARTITION BY stat_name ORDER BY begin_interval_time) END value
FROM
     dba_hist_sysstat
   NATURAL JOIN
     dba_hist_snapshot
WHERE
    stat_name LIKE '&1'
AND begin_interval_time > SYSDATE-7
ORDER BY
    begin_interval_time, stat_name
/

