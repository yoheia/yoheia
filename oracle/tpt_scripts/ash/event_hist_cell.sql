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

-- this scripts uses "ASH math" by Graham Wood, Uri Shaft and John Beresniewicz
-- for estimating the event counts (and average durations):
--   http://www.aioug.org/sangam12/Presentations/20130.pdf (ASH Architecture and Advanced Usage)

COL evh_event HEAD WAIT_EVENT for A50 TRUNCATE
COL evh_graph HEAD "Estimated|Time Graph" JUST CENTER FOR A12
COL pct_evt_time HEAD "% Event|Time"
COL evh_est_total_sec HEAD "Estimated|Total Sec" FOR 9,999,999.9
COL evh_millisec HEAD "Wait time|bucket ms+" FOR A15 JUST RIGHT
COL evh_event HEAD "Wait Event"
COL evh_sample_count HEAD "Num ASH|Samples"
COL evh_est_event_count HEAD "Estimated|Total Waits"
COL evh_cell_path HEAD "Cell Path" FOR A16

BREAK ON evh_event SKIP 1 ON evh_cell_path SKIP 1 NODUPLICATES

PROMPT Showing only CELL wait events as they have the wait_event.p1 = v$cell.cell_hashval link...

SELECT
    e.*
  , ROUND ( 100 * RATIO_TO_REPORT(evh_est_total_sec) OVER (PARTITION BY evh_event) , 1 ) pct_evt_time
  , '|'||RPAD(NVL(RPAD('#', ROUND (10 * RATIO_TO_REPORT(evh_est_total_sec) OVER (PARTITION BY evh_event)), '#'),' '), 10)||'|' evh_graph
FROM (
    SELECT 
        event evh_event
      , c.cell_path evh_cell_path
      , LPAD('< ' || CASE WHEN time_waited = 0 THEN 0 ELSE CEIL(POWER(2,CEIL(LOG(2,time_waited/1000)))) END, 15) evh_millisec
      , COUNT(*)  evh_sample_count
      , ROUND(SUM(CASE WHEN time_waited >= 1000000 THEN 1 WHEN time_waited = 0 THEN 0 ELSE 1000000 / time_waited END),1) evh_est_event_count
      , ROUND(CASE WHEN time_waited = 0 THEN 0 ELSE CEIL(POWER(2,CEIL(LOG(2,time_waited/1000)))) END * SUM(CASE WHEN time_waited >= 1000000 THEN 1 WHEN time_waited = 0 THEN 0 ELSE 1000000 / time_waited END) / 1000,1) evh_est_total_sec
    FROM 
        V$ACTIVE_SESSION_HISTORY a
      , v$cell c
        --dba_hist_active_sess_history
    WHERE 
        c.cell_hashval = a.p1
    AND regexp_like(a.event, '&1') 
    AND &2
    AND a.sample_time BETWEEN &3 AND &4
    AND a.session_state = 'WAITING' -- not really needed as "event" for ON CPU will be NULL in ASH, but added just for clarity
    AND a.time_waited > 0 
    GROUP BY
        event
      , c.cell_path
      , CASE WHEN time_waited = 0 THEN 0 ELSE CEIL(POWER(2,CEIL(LOG(2,time_waited/1000)))) END -- evh_millisec
) e
ORDER BY
    evh_event
  , evh_cell_path
  , evh_millisec
/

