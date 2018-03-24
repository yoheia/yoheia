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

set echo on

SELECT 
    ROUND(physical_read_bytes/1048576)    phyrd_mb
  , ROUND(io_interconnect_bytes/1048576)  ret_mb
  , (1-(io_interconnect_bytes / NULLIF(physical_read_bytes,0)))*100 "SAVING%"
FROM 
    v$sql 
WHERE 
    sql_id = '9n2fg7abbcfyx' 
AND child_number = 1;


SELECT 
    plan_line_id id
  , LPAD(' ',plan_depth) || plan_operation
      ||' '||plan_options||' '
      ||plan_object_name operation
  , ROUND(SUM(physical_read_bytes)   /1048576) phyrd_mb
  , ROUND(SUM(io_interconnect_bytes) /1048576) ret_mb
  , AVG(1-(io_interconnect_bytes / NULLIF(physical_read_bytes,0)))*100 "SAVING%"
FROM 
    v$sql_plan_monitor 
WHERE 
    sql_id = '&1' 
AND sql_exec_id = &2
GROUP BY 
    plan_line_id
  , LPAD(' ',plan_depth) || plan_operation
      ||' '||plan_options||' '
      ||plan_object_name
ORDER BY
    plan_line_id
/

set echo off

