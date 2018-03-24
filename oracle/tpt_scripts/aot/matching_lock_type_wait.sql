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

-- show which locks' id1/id2 columns have matching columns in v$session_wait/ASH

select /*+ leading(e) */
    e.name
  , lt.type
  , lt.id1_tag
  , lt.id2_tag
  , lt.description lock_description
from
    v$lock_type lt
  , v$event_name e
where 
    substr(e.name, 6,2) = lt.type
and e.parameter2 = lt.id1_tag
and e.parameter3 = lt.id2_tag
and e.name like 'enq: %'
order by
    e.name
/

