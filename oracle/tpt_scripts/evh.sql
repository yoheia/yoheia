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

-- EST_TIME_S column is a rough ESTIMATE of total wait time consumed by waits in a latency bucket
-- it assumes random distribution of event latencies between adjacent buckets which may not be the
-- case in reality

COL evh_event HEAD WAIT_EVENT
COL evh_est_time HEAD "EST_TIME_S*"
COL wait_count_graph FOR A22
COL evh_wait_time_milli HEAD WAIT_TIME_MILLI FOR A15 JUST RIGHT
BREAK ON evh_event SKIP 1

SELECT
    event             evh_event 
  , LPAD('< ' ||wait_time_milli, 15)  evh_wait_time_milli
  , wait_count 
  , CASE WHEN wait_count = 0 THEN NULL ELSE ROUND(wait_time_milli * wait_count * CASE WHEN wait_time_milli = 1 THEN 0.5 ELSE 0.75 END / 1000, 3) END evh_est_time
  , last_update_time   -- 11g
fROM
    v$event_histogram
WHERE
    regexp_like(event, '&1', 'i')
ORDER BY
    event
  , wait_time_milli
/
