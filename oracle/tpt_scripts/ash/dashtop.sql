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

--------------------------------------------------------------------------------
--
-- File name:   dashtop.sql
-- Purpose:     Display top ASH time (count of ASH samples) grouped by your
--              specified dimensions
--              
-- Author:      Tanel Poder
-- Copyright:   (c) http://blog.tanelpoder.com
--              
-- Usage:       
--     @dashtop <grouping_cols> <filters> <fromtime> <totime>
--
-- Example:
--     @dashtop username,sql_id session_type='FOREGROUND' sysdate-1/24 sysdate
--
-- Other:
--     This script uses only the AWR's DBA_HIST_ACTIVE_SESS_HISTORY, use
--     @dashtop.sql for accessiong the V$ ASH view
--              
--------------------------------------------------------------------------------
COL "%This" FOR A6
--COL p1     FOR 99999999999999
--COL p2     FOR 99999999999999
--COL p3     FOR 99999999999999
COL p1text FOR A20 word_wrap
COL p2text FOR A20 word_wrap
COL p3text FOR A20 word_wrap
COL p1hex  FOR A17
COL p2hex  FOR A17
COL p3hex  FOR A17
COL event  FOR A30
COL sql_opname FOR A15
COL top_level_call_name FOR A25

SELECT * FROM (
    SELECT /*+ LEADING(a) USE_HASH(u) */
        10 * COUNT(*)                                                      "TotalSeconds"
      , ROUND(COUNT(*) / ((CAST(&4 AS DATE) - CAST(&3 AS DATE)) * 86400), 1) AAS
      , LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
      , &1
--      , 10 * SUM(CASE WHEN wait_class IS NULL           THEN 1 ELSE 0 END) "CPU"
--      , 10 * SUM(CASE WHEN wait_class ='User I/O'       THEN 1 ELSE 0 END) "User I/O"
--      , 10 * SUM(CASE WHEN wait_class ='Application'    THEN 1 ELSE 0 END) "Application"
--      , 10 * SUM(CASE WHEN wait_class ='Concurrency'    THEN 1 ELSE 0 END) "Concurrency"
--      , 10 * SUM(CASE WHEN wait_class ='Commit'         THEN 1 ELSE 0 END) "Commit"
--      , 10 * SUM(CASE WHEN wait_class ='Configuration'  THEN 1 ELSE 0 END) "Configuration"
--      , 10 * SUM(CASE WHEN wait_class ='Cluster'        THEN 1 ELSE 0 END) "Cluster"
--      , 10 * SUM(CASE WHEN wait_class ='Idle'           THEN 1 ELSE 0 END) "Idle"
--      , 10 * SUM(CASE WHEN wait_class ='Network'        THEN 1 ELSE 0 END) "Network"
--      , 10 * SUM(CASE WHEN wait_class ='System I/O'     THEN 1 ELSE 0 END) "System I/O"
--      , 10 * SUM(CASE WHEN wait_class ='Scheduler'      THEN 1 ELSE 0 END) "Scheduler"
--      , 10 * SUM(CASE WHEN wait_class ='Administrative' THEN 1 ELSE 0 END) "Administrative"
--      , 10 * SUM(CASE WHEN wait_class ='Queueing'       THEN 1 ELSE 0 END) "Queueing"
--      , 10 * SUM(CASE WHEN wait_class ='Other'          THEN 1 ELSE 0 END) "Other"
      , TO_CHAR(MIN(sample_time), 'YYYY-MM-DD HH24:MI:SS') first_seen
      , TO_CHAR(MAX(sample_time), 'YYYY-MM-DD HH24:MI:SS') last_seen
    FROM
        (SELECT
             a.*
           , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p1 ELSE null END, '0XXXXXXXXXXXXXXX') p1hex
           , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p2 ELSE null END, '0XXXXXXXXXXXXXXX') p2hex
           , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p3 ELSE null END, '0XXXXXXXXXXXXXXX') p3hex
        FROM dba_hist_active_sess_history a) a
      , dba_users u
    WHERE
        a.user_id = u.user_id (+)
    AND &2
    AND sample_time BETWEEN &3 AND &4
    AND dbid = (SELECT dbid FROM v$database)
    AND snap_id IN (SELECT snap_id FROM dba_hist_snapshot WHERE sample_time BETWEEN &3 AND &4) -- for partition pruning
    GROUP BY
        &1
    ORDER BY
        "TotalSeconds" DESC
       , &1
)
WHERE
    ROWNUM <= 20
/

