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

-- metalink bug 7340448
-- oracle 10.2.0.4 

drop table t;
drop table t1;
drop table t2;


create table t ( pat varchar2(10) );

begin
  for i in 1 .. 1000 loop
    insert into t values('abcdedghi');
  end loop;
end;
/

commit;

create table t1 ( pk number , val varchar2(100) );

begin
  for i in 1 .. 1000 loop
    insert into t1 values(i,'a');
  end loop;
end;
/

commit;

create table t2 as
select /*+ USE_NL(t) ordered */
    pk, val, pat
from 
    t1,t
where 
    regexp_like(val,pat)
/
