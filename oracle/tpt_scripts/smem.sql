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
-- File name:   smem.sql 
-- Purpose:     Show process memory usage breakdown - lookup by session ID
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @smem <SID>
-- 	        
--	        
-- Other:       Uses v$process_memory which is available from Oracle 10g onwards
--
--------------------------------------------------------------------------------
PROMPT Display session &1 memory usage from v$process_memory....
SELECT
    s.sid,pm.*
FROM 
    v$session s
  , v$process p
  , v$process_memory pm
WHERE
    s.paddr = p.addr
AND p.pid = pm.pid
AND s.sid IN (&1)
ORDER BY
    sid
  , category
/
