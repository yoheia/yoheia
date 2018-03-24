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
-- File name:   swg.sql
-- Purpose:     Display given Session Wait info grouped by state and event
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @sw <sid>
--              @sw 52,110,225
-- 	        	@sw "select sid from v$session where username = 'XYZ'"
--              @sw &mysid
--
--------------------------------------------------------------------------------

col sw_event 	head EVENT for a40 truncate
col sw_p1transl head P1TRANSL for a42
col sw_sid		head SID for 999999

select 
	count(*),
	CASE WHEN state != 'WAITING' THEN 'WORKING'
	     ELSE 'WAITING'
	END AS state, 
	CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
	     ELSE event
	END AS sw_event
FROM 
	v$session_wait 
WHERE 
	sid IN (&1)
GROUP BY
	CASE WHEN state != 'WAITING' THEN 'WORKING'
	     ELSE 'WAITING'
	END, 
	CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
	     ELSE event
	END
ORDER BY
	1 DESC, 2 DESC
/



