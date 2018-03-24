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

-- view merging

select * from dual;

select * from table(dbms_xplan.display_cursor);

create or replace view v as select * from dual;

select * from (select * from v);

alter session set "_simple_view_merging"=false;

select * from (select * from v);

alter session set "_simple_view_merging"=true;

select * from (select /*+ NO_MERGE */ * from v);

select * from (select rownum r, v.* from v);


-- scalar subqueries, run a subquery for populating a value in a single column or a row (9i+)

select owner, count(*) from test_objects o group by owner;

-- another way (excludes nulls if any)

select u.username, (select count(*) from test_objects o where u.username = o.owner) obj_count from test_users u;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


