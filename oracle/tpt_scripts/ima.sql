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

COL "USED%" FOR A7 JUST RIGHT
PROMPT Querying GV$INMEMORY_AREA...

SELECT 
    inst_id
  , pool                    
  , ROUND(alloc_bytes/1048576) alloc_mb          
  , ROUND(used_bytes/1048576)  used_mb
  , LPAD(ROUND(used_bytes/NULLIF(alloc_bytes,0)*100,1)||'%',7) "USED%"
  , populate_status         
  , con_id                  
FROM
    gv$inmemory_area
ORDER BY
    pool
  , inst_id
/
