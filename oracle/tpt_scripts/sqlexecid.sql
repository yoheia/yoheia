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
    NVL(qc_instance_id, inst_id)           user_inst_id
  , MIN(TO_CHAR(sql_exec_id,'XXXXXXXX'))   min_sql_exec_id
  , MAX(TO_CHAR(sql_exec_id,'XXXXXXXX'))   max_sql_exec_id
FROM
    gv$active_session_history
GROUP BY
    NVL(qc_instance_id, inst_id)
ORDER BY
    user_inst_id
/

