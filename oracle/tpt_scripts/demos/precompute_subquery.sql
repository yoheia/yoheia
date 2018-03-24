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

set echo on

create table t1 as select rownum a from dual connect by level < 10;
create table t2 as select rownum+10 b from dual connect by level < 10;

exec dbms_stats.gather_table_stats(user,'T1');
exec dbms_stats.gather_table_stats(user,'T2');

--alter session set events '10053 trace name context forever';
--alter session set "_optimizer_trace"=all;
--alter session set events '10046 trace name context forever, level 4';

select * from t1;

select * from t2;


select a 
from   t1
where  a in (select b from t2);

@x

select a 
from   t1
where  a in (select /*+ PRECOMPUTE_SUBQUERY */b from t2);

@x

set echo off
