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

prompt Display active sessions current SQLs

select
    sql_id
  , sql_hash_value
  , sql_child_number
  , count(*)
from
    v$session
where
    status='ACTIVE'
and type !='BACKGROUND'
and sid != (select sid from v$mystat where rownum=1)
group by
    sql_id
  , sql_hash_value
  , sql_child_number
order by
    count(*) desc
/

