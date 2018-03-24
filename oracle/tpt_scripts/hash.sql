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
-- File name:   hash.sql
-- Purpose:     Show the hash value, SQL_ID and child number of previously
--              executed SQL in session
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @hash
-- 	        
--	        
-- Other:       Doesn't work on 9i for 2 reasons. There appears to be a bug
--              with v$session.prev_hash_value in 9.2.x and also there's no
--              SQL_ID nor CHILD_NUMBER column in V$SESSION in 9i.
--
--------------------------------------------------------------------------------

col hash_hex for a10

select 
    prev_hash_value                                hash_value
  , prev_sql_id                                    sql_id
  , prev_child_number                              child_number
  , lower(to_char(prev_hash_value, 'XXXXXXXX'))    hash_hex
from 
    v$session 
where 
    sid = (select sid from v$mystat where rownum = 1)
/
