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

break on snap_time

select
    s.snap_time
  , round(sum(m.allocated)/1048576) MB_ALLOC
  , round(sum(m.used)/1048576) MB_USED
  , count(distinct m.pid) processes
from
    STATS$PROCESS_MEMORY_ROLLUP m
  , STATS$SNAPSHOT s
where
    s.snap_id = m.snap_id
and s.dbid    = m.dbid
and s.instance_number = m.instance_number
group by
    s.snap_time
order by
    s.snap_time
/

select
    s.snap_time
  , m.category alloc_type
  , round(sum(m.allocated)/1048576) MB_ALLOC
  , round(sum(m.used)/1048576) MB_USED
  , count(distinct m.pid) processes
from
    STATS$PROCESS_MEMORY_ROLLUP m
  , STATS$SNAPSHOT s
where
    s.snap_id = m.snap_id
and s.dbid    = m.dbid
and s.instance_number = m.instance_number
group by
    s.snap_time
  , m.category
order by
    s.snap_time
  , m.category
/

