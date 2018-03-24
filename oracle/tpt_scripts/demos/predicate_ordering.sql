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

set echo on

create or replace function f(x in number) return number as
begin
   dbms_output.put_line('F='||to_char(x));
   return x;
end;
/

set serverout on size 1000000

select * from dual
where 
   rownum = f(2)
or rownum = f(1)
/

create table t (a, b) as select 1, 1 from dual connect by level <= 100000;
insert into t values (1,2);
commit;

@gts t

truncate table t;
insert into t values (1,2);
commit;

--exec dbms_stats.set_table_stats(user, 'T', numrows=>1000000, numblks=>10000, avgrlen=>10, no_invalidate=>false);

select * from t where b=f(2) or a=f(1);

set echo off serverout off

/

@x

