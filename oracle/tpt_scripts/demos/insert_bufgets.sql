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

desc sydney_demo1
desc sydney_demo2
desc sydney_demo3

alter session set plsql_optimize_level=0;

set timing on
exec for i in 1..&1 loop insert into sydney_demo1 values (0); end loop;

set timing off termout off
rollback;
alter system checkpoint;
set timing on  termout on

exec for i in 1..&1 loop insert into sydney_demo2 values (0); end loop;

set timing off termout off
rollback;
alter system checkpoint;
set timing on  termout on

exec for i in 1..&1 loop insert into sydney_demo3 values (0); end loop;

set timing off termout off
rollback;
alter system checkpoint;
set timing on  termout on

set timing off

























--create table sydney_demo1 (a int) tablespace system;
--create table sydney_demo2 (a int) tablespace users;
--create table sydney_demo3 (a int) tablespace users2;
