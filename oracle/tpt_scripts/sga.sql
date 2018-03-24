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

prompt Show instance memory usage breakdown from v$memory_dynamic_components
COL mem_component HEAD COMPONENT FOR A35

SELECT
    component mem_component
  , ROUND(current_size/1048576) cur_mb
  , ROUND(min_size/1048576)     min_mb
  , ROUND(max_size/1048576)     max_mb
  , ROUND(user_specified_size/1048576)    spec_mb
  , oper_count
  , last_oper_type last_optype
  , last_oper_mode last_opmode
  , last_oper_time last_optime
  , granule_size/1048576        gran_mb
FROM
    v$sga_dynamic_components
/

  
