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

select /*+ index_rs(o o(owner)) */ avg(sysdate - created) days_old 
from
     indexed_objects o 
where 
    owner = 'SYS' 
and object_type = 'PACKAGE'
/

@x

-- Then create an index which satisfies the additional filter column...
--   create index idx2_indexed_objects on indexed_objects (owner, object_type);

-- Then re-create the index with also the column that includes the columns selected in the query
--   drop index idx2_indexed_objects;
--   create index idx2_indexed_objects on indexed_objects (owner, object_type, created);

