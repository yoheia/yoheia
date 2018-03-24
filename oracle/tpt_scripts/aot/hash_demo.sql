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

prompt Dropping and creating users...

drop user a cascade;
drop user aa cascade;

set echo on

create user A identified by x;
create user AA identified by x;
alter user a quota unlimited on users;
alter user aa quota unlimited on users;

-- about to create two tables under different usernames...
pause

create table A.AA(a int);
create table AA.A(a int);

-- about to run @aot/hash <object_name> commands for both tables...
pause

set echo off

@aot/hash a
@aot/hash aa

