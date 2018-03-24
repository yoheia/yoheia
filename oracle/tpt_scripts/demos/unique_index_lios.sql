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

drop table t;

create table t(a int, b char(100));

insert /*+ APPEND */ into t select rownum, object_name from all_objects;

create &1 index i on t(a);

exec dbms_stats.gather_table_stats(user,'T');

-- hard parse statement
set termout off
select a from t where a = 40000; 
set termout on

set autot trace stat

select a from t where a = 40000; 

set echo off autot off