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

select curno,status,pers_heap_mem,work_heap_mem from v$sql_cursor where status != 'CURNULL';
pause

var x refcursor
exec open :x for select * from all_objects order by dbms_random.random;
pause

declare r all_objects%rowtype; begin fetch :x into r; end;
/

pause

select curno,status,pers_heap_mem,work_heap_mem from v$sql_cursor where status != 'CURNULL';

set echo off
