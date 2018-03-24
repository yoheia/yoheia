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

column sqlt_sql_text	heading SQL_TEXT format a100 word_wrap

select 
	hash_value, 
    sql_id,
--	old_hash_value,
	child_number chld#, 
--	plan_hash_value plan_hash, 
	optimizer_mode opt_mode,
	sql_text sqlt_sql_text
from 
	v$sql 
where 
	lower(sql_text) like lower('%&1%')
--and	hash_value != (select sql_hash_value from v$session where sid = (select sid from v$mystat where rownum = 1))
/

