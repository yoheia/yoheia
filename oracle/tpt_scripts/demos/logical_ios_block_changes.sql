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

drop table t;
exec dbms_random.seed(0);
create table t(a) tablespace users as select dbms_random.random from dual connect by level <= 10000;
create index i on t(a);
@gts t

@stat changes "update (select a from t where a < 10000) set a = a + 1"


drop table t;
exec dbms_random.seed(0);
create table t(a) tablespace users as select dbms_random.random from dual connect by level <= 10000;
create index i on t(a);
@gts t

@stat changes "update (select /*+ index(t) */ a from t where a < 10000) set a = a + 1"


drop table t;
exec dbms_random.seed(0);
create table t(a) tablespace users as select dbms_random.random from dual connect by level <= 10000 order by 1;
create index i on t(a);
@gts t

@stat changes "update (select /*+ index(t) */ a from t where a < 10000) set a = a + 1"
