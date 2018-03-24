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

-- A-Times were misestimated with the default sampling 
-- ALTER SESSION SET "_rowsource_statistics_sampfreq"=1; 
ALTER SESSION SET "_serial_direct_read"=ALWAYS;

SELECT /*+ MONITOR test2a */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/
@getprev
@xpi &prev_sql_id
@xia &prev_sql_id &prev_child_number

-- @ash/asqlmon &prev_sql_id &prev_child_number
-- @sqlidx &prev_sql_id &prev_child_number

SELECT /*+ MONITOR NO_PUSH_SUBQ(@"SEL$2") test2b */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/
@getprev
-- @ash/asqlmon &prev_sql_id &prev_child_number
-- @sqlidx &prev_sql_id &prev_child_number
@xpi &prev_sql_id
@xia &prev_sql_id &prev_child_number

-- ALTER SESSION SET "_rowsource_statistics_sampfreq"=128;


SELECT /*+ MONITOR OPT_PARAM('cell_offload_processing', 'false') test3a */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/

SELECT /*+ MONITOR NO_PUSH_SUBQ(@"SEL$2") OPT_PARAM('cell_offload_processing', 'false') test3b */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/


SELECT /*+ MONITOR PUSH_SUBQ(@"SEL$2") OPT_PARAM('cell_offload_processing', 'true') test4a */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/

SELECT /*+ MONITOR NO_PUSH_SUBQ(@"SEL$2") OPT_PARAM('cell_offload_processing', 'true') test4b */
    SUM(LENGTH(object_name)) + SUM(LENGTH(object_type)) + SUM(LENGTH(owner))
FROM
    test_objects_100m o
WHERE
    o.owner = (SELECT u.username FROM test_users u WHERE user_id = 13)
/



