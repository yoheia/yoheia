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


drop table a;
drop table b;

create table A(col11 number, col12 number);
create table B(col21 number, col22 number);

insert into a values (-3,-7);
insert into a values (null,-1);
insert into b values ( -7,-3);

update a set col11 =
    (select avg(b.col22) keep (dense_rank first order by (col22)) 
     FROM b where b.col21= a.col12)
/

