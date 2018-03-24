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

PROMPT Top allocation reason by PGA memory usage

COL wrkasum_operation_type FOR A30
 
SELECT
    operation_type wrkasum_operation_type
  , policy
  , ROUND(SUM(actual_mem_used)/1048576) actual_pga_mb
  , ROUND(SUM(work_area_size)/1048576)  allowed_pga_mb
  , ROUND(SUM(tempseg_size)/1048576)    temp_mb
  , MAX(number_passes)                  num_passes
  , COUNT(DISTINCT qcinst_id||','||qcsid)   num_qc
  , COUNT(DISTINCT inst_id||','||sid)   num_sessions
FROM
    gv$sql_workarea_active
WHERE
    &1
GROUP BY 
    operation_type
  , policy
ORDER BY 
    actual_pga_mb DESC NULLS LAST
/

PROMPT Top SQL_ID by TEMP usage...

 SELECT
     sql_id
   , policy
   , ROUND(SUM(actual_mem_used)/1048576) actual_pga_mb
   , ROUND(SUM(work_area_size)/1048576)  allowed_pga_mb
   , ROUND(SUM(tempseg_size)/1048576)    temp_mb
   , MAX(number_passes)                  num_passes
   , COUNT(DISTINCT qcinst_id||','||qcsid)   num_qc
   , COUNT(DISTINCT inst_id||','||sid)   num_sessions
 FROM
     gv$sql_workarea_active
 WHERE
     &1
 GROUP BY 
     sql_id
   , policy
 ORDER BY 
     temp_mb DESC NULLS LAST
/

