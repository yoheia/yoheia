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

drop table t1;
drop table t2;

create table t1 as select * from dba_users;
create table t2 as select * from dba_objects;

select /*+ ordered use_nl(t2) gather_plan_statistics */
     t1.user_id, t1.username, sum(length(t2.object_name))
from t1, t2
where t1.username = t2.owner
and t1.username = 'SYSTEM'
group by t1.user_id, t1.username
/

@x

select /*+ ordered use_nl(t2) gather_plan_statistics */
     t1.user_id, t1.username, sum(length(t2.object_name))
from t1, t2
where t1.username = t2.owner
and t1.username like 'SYS%'
group by t1.user_id, t1.username
/

@x