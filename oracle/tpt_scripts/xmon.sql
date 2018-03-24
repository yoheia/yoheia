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

-- v$sql_plan_monitor IO figures buggy as of 12.1.0.1.0

COL xmon_plan_operation HEAD PLAN_LINE FOR A70


SELECT 
    process_name
  , plan_line_id id 
  , LPAD(' ',plan_depth) || plan_operation 
      ||' '||plan_options||' ' 
      ||plan_object_name xmon_plan_operation 
  , ROUND(physical_read_bytes / 1048576) phyrd_mb 
  , ROUND(io_interconnect_bytes / 1048576) ret_mb 
  , (1-(io_interconnect_bytes/NULLIF(physical_read_bytes,0)))*100 "SAVING%" 
  , otherstat_group_id
  , otherstat_1_id    
  , otherstat_1_type  
  , otherstat_1_value 
  , otherstat_2_id    
  , otherstat_2_type  
  , otherstat_2_value 
  , otherstat_3_id    
  , otherstat_3_type  
  , otherstat_3_value 
  , otherstat_4_id    
  , otherstat_4_type  
  , otherstat_4_value 
  , otherstat_5_id    
  , otherstat_5_type  
  , otherstat_5_value 
  , otherstat_6_id    
  , otherstat_6_type  
  , otherstat_6_value 
  , otherstat_7_id    
  , otherstat_7_type  
  , otherstat_7_value 
  , otherstat_8_id    
  , otherstat_8_type  
  , otherstat_8_value 
  , otherstat_9_id    
  , otherstat_9_type  
  , otherstat_9_value 
  , otherstat_10_id   
  , otherstat_10_type 
  , otherstat_10_value
FROM 
    v$sql_plan_monitor 
WHERE 
    sql_id = '&1'
AND sql_exec_start = (SELECT MAX(sql_exec_start) FROM v$sql_monitor WHERE sql_id='&1')
--AND process_name = 'ora'
/
