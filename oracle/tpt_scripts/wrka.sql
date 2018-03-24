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

prompt Show Active workarea memory usage for where &1....

COL wrka_operation_type HEAD OPERATION_TYPE FOR A30

SELECT 
    inst_id
  , sid
  , qcinst_id
  , qcsid
  , sql_id
--  , sql_exec_start -- 11g+
  , operation_type wrka_operation_type
  , operation_id plan_line
  , policy
  , ROUND(active_time/1000000,1) active_sec
  , actual_mem_used
  , max_mem_used
  , work_area_size
  , number_passes
  , tempseg_size
  , tablespace
FROM 
    gv$sql_workarea_active 
WHERE 
    &1
ORDER BY
    sid
  , sql_hash_value
  , operation_id
/
