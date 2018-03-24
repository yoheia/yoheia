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

-- experimental script - it will only capture a tiny portion of disk reread waits
-- due to relatively infrequent sampling of ASH

SELECT
    SUM(rereads) 
  , t.tablespace_name
  , ts.block_size
  , o.owner
  , o.object_name
FROM 
    (SELECT current_obj#, p1, p2, TO_CHAR(p1)||':'||TO_CHAR(p2), COUNT(*) rereads 
     FROM v$active_session_history 
     WHERE 
         sample_time < SYSDATE-1/24 
     AND event = 'db file sequential read' 
     GROUP BY 
         current_obj#, p1, p2 
     HAVING
         COUNT(*) > 1
    ) a
  , dba_data_files t
  , dba_tablespaces ts 
  , dba_objects o
WHERE 
    a.p1 = t.file_id 
AND t.tablespace_name = ts.tablespace_name 
AND a.current_obj# = o.object_id (+)
GROUP BY 
    t.tablespace_name
  , ts.block_size 
  , o.owner
  , o.object_name
ORDER BY SUM(rereads) DESC
/
