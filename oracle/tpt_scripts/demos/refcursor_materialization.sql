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

-- Connor McDonald's example

-- drop table t;
-- 
-- create table T
-- as select rownum x
-- from dual connect by level <= 10;
-- 
-- create or replace
-- type numlist is table of number;
-- /
-- 
-- create or replace function F(c sys_refcursor) return numlist pipelined is
--   n number;
-- begin
--   loop
--      fetch c into n;
--      exit when c%notfound;
--      pipe row (n);
--   end loop;
--   close c;
--   return;
-- end;
-- /
-- 

delete t;
commit;

variable rc refcursor;
lock table T in exclusive mode;

exec open :rc for select * from table(f(cursor(select * from t)));

commit;

insert into T values (11);

commit;

print rc

variable rc refcursor;
variable rc1 refcursor;

delete t;
commit;

lock table T in exclusive mode;

exec open :rc1 for select * from t;

exec open :rc for select * from table(f(:rc1));

commit;

insert into T values (11);

commit;

print rc

select * from dual;
	