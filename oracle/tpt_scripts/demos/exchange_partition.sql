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

--drop table mytab;
--drop table tmp;

-- this is our "source table"
create table mytab as select * from all_objects;
create index i on mytab(owner);

-- this is where we copy only needed rows:
create table tmp 
partition by range (owner) (
  partition p1 values less than (maxvalue)
)
as
select * from mytab 
where owner != 'SYS'
/

-- in order to do partition exchange, the physical structure of source table and target need to be the same (including indexes):
create index i_tmp on tmp(owner) local;

-- get rid of old rows
truncate table mytab;

-- exchange the tmp.p1 partition segment with mytab's segment
alter table tmp exchange partition p1 with table mytab including indexes;

-- you may need to run this to validate any constraints if they're in novalidate status
alter table mytab constraint <constraint_name> enable validate;
