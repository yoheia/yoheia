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

set echo on

select 
    t.owner, t.created, i.last_ddl_time
from 
    test_objects    t
  , indexed_objects i
where 
    t.object_id = i.object_id 
and t.owner = 'SH'  
and t.object_name like 'S%'
/

@xall


select /*+ LEADING(t,i) USE_NL(i) */
    t.owner, t.created, i.last_ddl_time
from 
    test_objects    t
  , indexed_objects i
where 
    t.object_id = i.object_id 
and t.owner = 'SH'  
and t.object_name like 'S%'
/

@xall


select /*+ LEADING(t,i) USE_NL(i) NO_NLJ_PREFETCH(i) */
    t.owner, t.created, i.last_ddl_time
from 
    test_objects    t
  , indexed_objects i
where 
    t.object_id = i.object_id 
and t.owner = 'SH'  
and t.object_name like 'S%'
/

@xall

select /*+ LEADING(t,i) USE_NL(i) NO_NLJ_BATCHING(i) */
    t.owner, t.created, i.last_ddl_time
from 
    test_objects    t
  , indexed_objects i
where 
    t.object_id = i.object_id 
and t.owner = 'SH'  
and t.object_name like 'S%'
/

@xall

select /*+ LEADING(t,i) USE_NL(i) NO_NLJ_PREFETCH(t) NO_NLJ_PREFETCH(i) NO_NLJ_BATCHING(t) NO_NLJ_BATCHING(i) */
    t.owner, t.created, i.last_ddl_time
from 
    test_objects    t
  , indexed_objects i
where 
    t.object_id = i.object_id 
and t.owner = 'SH'  
and t.object_name like 'S%'
/

@xall

set echo off
