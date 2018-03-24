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

COL "MIN(first_load_time)" FOR A20
COL "MAX(last_load_time)" FOR A20

PROMPT ==============================================================================================
PROMPT == SQLs not using bind variables (check the SQL texts of top offenders)                     ==
PROMPT ==============================================================================================

SELECT
    COUNT(*) total_children
  , COUNT(DISTINCT sql_id) distinct_sqlids
  , COUNT(DISTINCT plan_hash_value) distinct_plans
  , plan_hash_value
  , MIN(sql_id)
  , MAX(sql_id)
  , MIN(first_load_time)
  , MAX(last_load_time)
FROM v$sql
GROUP BY plan_hash_value
HAVING COUNT(DISTINCT sql_id) > 50
ORDER BY COUNT(*) DESC
/

PROMPT ==============================================================================================
PROMPT == SQLs with many child cursors under a parent (use nonshared*.sql to find the reasons)     ==
PROMPT ==============================================================================================

SELECT 
    COUNT(*) total_children
  , COUNT(DISTINCT sql_id) distinct_sqlids
  , COUNT(DISTINCT plan_hash_value) distinct_plans
  , sql_id
  , MIN(plan_hash_value)
  , MAX(plan_hash_value)
  , MIN(first_load_time)
  , MAX(last_load_time)
FROM v$sql
GROUP BY sql_id
HAVING COUNT(*) > 50
ORDER BY COUNT(*) DESC
/

