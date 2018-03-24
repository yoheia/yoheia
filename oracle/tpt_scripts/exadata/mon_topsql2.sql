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

-- mon_topsql.sql ver2
-- added plan_hash_value support and ordered by descending date
-- script by Tanel Poder ( http://blog.tanelpoder.com )

SET LINES 999 PAGES 5000 TRIMSPOOL ON TRIMOUT ON TAB OFF 

COL pct FOR A10 JUST RIGHT
COL cpu_pct FOR 999.9
COL io_pct FOR 999.9

BREAK ON day SKIP 1

DEF days=7
DEF weekdays="mon,tue,wed,thu,fri,sat,sun"
DEF separator=","

WITH ash AS (
    SELECT 
        day
      , weekday
      , owner
      , object_name
      , procedure_name
      , sql_id
      , sql_plan_hash_value
      , distinct_days
      , total_seconds
      , io_seconds
      , cpu_seconds
      , LPAD(TRIM(TO_CHAR(RATIO_TO_REPORT(total_seconds) OVER (PARTITION BY day) * 100, '999.9'))||'%', 10) pct
      , RATIO_TO_REPORT(total_seconds) OVER (PARTITION BY day) * 100 pct_num
    FROM (
        SELECT
            TO_CHAR(sample_time, 'YYYY-MM-DD') day
          , TO_CHAR(sample_time, 'Dy') weekday
          , COUNT(DISTINCT TO_CHAR(sample_time, 'YYYY-MM-DD')) OVER (PARTITION BY sql_id) distinct_days
          , sql_id
          , sql_plan_hash_value 
          , p.owner
          , p.object_name
          , p.procedure_name
          , SUM(10) total_seconds
          , SUM(CASE WHEN wait_class = 'User I/O' THEN 10 ELSE 0 END) io_seconds
          , SUM(CASE WHEN wait_class IS NULL THEN 10 ELSE 0 END) cpu_seconds
        FROM
            dba_hist_active_sess_history a
          , dba_procedures p
        WHERE
            a.plsql_entry_object_id = p.object_id (+)
        AND a.plsql_entry_subprogram_id = p.subprogram_id (+)
        AND sample_time > SYSDATE - &days
        AND session_type != 'BACKGROUND' -- ignore for now
        AND LOWER(TO_CHAR(sample_time, 'Dy')) IN (
            SELECT
                LOWER(REGEXP_REPLACE(
                        REGEXP_SUBSTR( '&weekdays'||'&separator', '(.*?)&separator', 1, LEVEL )
                        , '&separator$'
                        , ''
                )) TOKEN
            FROM
               DUAL
            CONNECT BY
               REGEXP_INSTR( '&weekdays'||'&separator', '(.*?)&separator', 1, LEVEL ) > 0
        )
        GROUP BY
            sql_id
          , sql_plan_hash_value 
          , p.owner
          , p.object_name
          , p.procedure_name
          , TO_CHAR(sample_time, 'YYYY-MM-DD')
          , TO_CHAR(sample_time, 'Dy')
    )
)
, sqlstat AS (
    SELECT 
        TO_CHAR(begin_interval_time, 'YYYY-MM-DD') day
      , sql_id
      , plan_hash_value
      , SUM(executions_delta) executions
      , SUM(rows_processed_delta) rows_processed
      , SUM(disk_reads_delta) blocks_read
      , SUM(disk_reads_delta)*8/1024 mb_read
      , SUM(buffer_gets_delta) buffer_gets
      , SUM(iowait_delta)/1000000 awr_iowait_seconds
      , SUM(cpu_time_delta)/1000000 awr_cpu_seconds 
      , SUM(elapsed_time_delta)/1000000 awr_elapsed_seconds
    FROM
        dba_hist_snapshot
      NATURAL JOIN
        dba_hist_sqlstat
    WHERE
        begin_interval_time > SYSDATE - &days
    GROUP BY
        TO_CHAR(begin_interval_time, 'YYYY-MM-DD') 
      , sql_id
      , plan_hash_value
)
SELECT 
        day
      , weekday
      , pct
      , owner
      , object_name
      , procedure_name
      , sql_id
      , sql_plan_hash_value plan_hash
      , distinct_days
      , ROUND(total_seconds / 3600,1) total_hours
      , total_seconds
      , executions
      , ROUND(total_seconds / NULLIF(executions,0),2) seconds_per_exec
      , io_pct
      , cpu_pct
      , mb_read
      , ROUND(mb_read / NULLIF(executions,0),2) mb_per_exec
      , buffer_gets
      , ROUND(buffer_gets / NULLIF(executions,0),2) bufget_per_exec
      , CASE WHEN sql_id IS NOT NULL THEN 
            'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('''||sql_id||''','||CASE WHEN sql_plan_hash_value = 0 THEN 'NULL' ELSE TO_CHAR(sql_plan_hash_value) END||', format=>''ADVANCED''));'
        END extract_plan_from_awr
FROM (
    SELECT
        day
      , weekday
      , pct
      , owner
      , object_name
      , procedure_name
      , sql_id
      , sql_plan_hash_value
      , distinct_days
      , total_seconds
      , io_seconds/total_seconds*100 io_pct
      , cpu_seconds/total_seconds*100 cpu_pct
      , (SELECT executions FROM sqlstat s  WHERE ash.sql_id = s.sql_id AND ash.sql_plan_hash_value = s.plan_hash_value AND ash.day = s.day) executions
      , (SELECT mb_read FROM sqlstat s     WHERE ash.sql_id = s.sql_id AND ash.sql_plan_hash_value = s.plan_hash_value AND ash.day = s.day) mb_read
      , (SELECT buffer_gets FROM sqlstat s WHERE ash.sql_id = s.sql_id AND ash.sql_plan_hash_value = s.plan_hash_value AND ash.day = s.day) buffer_gets
    FROM 
        ash
    WHERE 
        ash.pct_num >= 1
)
ORDER BY
    day DESC
  , total_seconds DESC
/

