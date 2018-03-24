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
-- File name:   rowsource_events.sql
-- Purpose:     Display top ASH time (count of ASH samples) grouped by 
--              exeution plan rowsource type and session serial/parallel
--              status.
--
--              This allows to find out if your parallel slaves are doing
--              buffered full table scan IOs.
--              
-- Author:      Tanel Poder
-- Copyright:   (c) http://blog.tanelpoder.com
--              
-- Usage:       
--     @rowsource_events.sql
--
-- Other:
--     Requires Oracle 11g+
--
--------------------------------------------------------------------------------
SELECT * FROM (
SELECT 
    COUNT(*) seconds
  , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) pct
  , sql_plan_operation||' '||sql_plan_options plan_line
  , CASE WHEN qc_session_id IS NULL THEN 'SERIAL' ELSE 'PARALLEL' END is_parallel
  , session_state
  , wait_class
  , event
FROM 
    gv$active_session_history
WHERE
    sql_plan_operation LIKE '&1'
AND sql_plan_options   LIKE '&2'
AND sample_time > SYSDATE - 1/24
GROUP BY
    sql_plan_operation||' '||sql_plan_options 
  , CASE WHEN qc_session_id IS NULL THEN 'SERIAL' ELSE 'PARALLEL' END
  , session_state
  , wait_class
  , event
ORDER BY COUNT(*) DESC
)
WHERE rownum <= 20
/
