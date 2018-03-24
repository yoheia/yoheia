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

select 
     owner, object_type, status, count(*)
from
     indexed_objects o 
where 
    owner = 'SYS' 
and object_type = 'JAVA CLASS'
and created > sysdate - 3650
group by
    owner,object_type,status
order by
    status
/


-- Then re-create the index with also the column that we sort/group by
--   drop index idx2_indexed_objects;
--   create index idx2_indexed_objects on indexed_objects (owner, object_type, created, status);

-- And try tho swap the last 2 columns in end of the index:
--   drop index idx2_indexed_objects;
--   create index idx2_indexed_objects on indexed_objects (owner, object_type, status, created);

