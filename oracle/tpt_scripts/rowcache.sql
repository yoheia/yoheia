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
-- File name:   rowcache.sql
-- Purpose:     Show parent rowcache entries mathcing an object name
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @rowcache <objectname>
-- 	            @rowcache dba_tables
--	        
-- Other:       Tested on Oracle 10.2 and 11.1, v$rowcache_parent doesnt seem
--              to return all rowcache entries in 9.2
--
--------------------------------------------------------------------------------

COL rowcache_cache_name HEAD CACHE_NAME FOR A20
COL rowcache_key HEAD KEY FOR A32 WRAP
COL rowcache_existent HEAD EXIST FOR A5

SELECT 
	INDX, HASH, ADDRESS,
	EXISTENT rowcache_existent, 
	CACHE#, 
	CACHE_NAME rowcache_cache_name,
--	LOCK_MODE, LOCK_REQUEST, TXN, SADDR, 
        RAWTOHEX(KEY) rowcache_key
FROM 
	v$rowcache_parent 
WHERE 
	RAWTOHEX(KEY) LIKE (
	    SELECT '%'||UPPER(REPLACE(SUBSTR(DUMP(UPPER('&1'),16),INSTR(DUMP(UPPER('&1'),16),': ')+2), ',', ''))||'%' 
	    FROM DUAL
	)
/
