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

-- TODO: not working yet
-- LEADING hint sets the order properly but not the ORDERED hint

drop table t1;
drop table t2;

create table t1 as select * from all_objects;
create table t2 as select * from all_objects;

create index i1 on t2(object_id);

exec dbms_stats.gather_table_stats(user,'T1');
exec dbms_stats.gather_table_stats(user,'T2');

-- ordered hint "ignored" starting from 11.2.0.1 thanks to distinct aggregation transformation

select /*+ ORDERED */ t1.owner, count(distinct t2.object_type) from t2, t1 where t1.object_id = t2.object_id group by t1.owner;
@x

select /*+ ORDERED NO_TRANSFORM_DISTINCT_AGG */ t1.owner, count(distinct t2.object_type) from t2, t1 where t1.object_id = t2.object_id group by t1.owner;
@x

