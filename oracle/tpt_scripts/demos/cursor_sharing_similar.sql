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

create table t as 
select rownum a, 'zzz' b from dual connect by level<=1000;

create index i on t(a);

exec dbms_stats.gather_table_stats(user,'T',method_opt=>'FOR COLUMNS A SIZE 254');

@sqlt "select * from t where a ="


alter session set cursor_sharing = similar;

spool lotsofselects.sql

select 'select * from t where a = '||rownum||';' from dual connect by level<=10000;

spool off

@lotsofselects.sql
@hash


@sqlt "select * from t where a ="

--exec for i in 1 .. 10000 loop execute immediate 'delete t where a = '||to_char(i); end loop;
--declare j number; begin for i in 1..1000 loop select count(*) into  


