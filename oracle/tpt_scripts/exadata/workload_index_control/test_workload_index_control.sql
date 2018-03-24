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

-- DROP TABLE test_users;
-- DROP TABLE test_objects;

CREATE TABLE test_users AS SELECT * FROM all_users;
CREATE TABLE test_objects AS SELECT * FROM all_objects;

CREATE INDEX i_test_users ON test_users (username);
CREATE INDEX i_test_objects ON test_objects (owner);

EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'TEST_USERS');
EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'TEST_OBJECTS');

PROMPT ==================================================================================
PROMPT This plan should use indexes as they are visible and available:
PROMPT ==================================================================================

SELECT
    SUM(u.user_id) + SUM(o.object_id)
FROM
    test_users u
  , test_objects o
WHERE 
    u.username = o.owner
AND u.username LIKE 'S%'
AND o.owner LIKE 'S%'
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);

PROMPT ==================================================================================
PROMPT Making indexes invisible. The plan should use FULL TABLE scans now:
PROMPT ==================================================================================

ALTER INDEX i_test_users INVISIBLE;
ALTER INDEX i_test_objects INVISIBLE;
ALTER SESSION SET optimizer_use_invisible_indexes = false;

SELECT
    SUM(u.user_id) + SUM(o.object_id)
FROM
    test_users u
  , test_objects o
WHERE 
    u.username = o.owner
AND u.username LIKE 'S%'
AND o.owner LIKE 'S%'
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);

PROMPT ==================================================================================
PROMPT Setting optimizer_use_invisible_indexes = TRUE. The plan should use indexes again:
PROMPT ==================================================================================

ALTER SESSION SET optimizer_use_invisible_indexes = true;

SELECT
    SUM(u.user_id) + SUM(o.object_id)
FROM
    test_users u
  , test_objects o
WHERE 
    u.username = o.owner
AND u.username LIKE 'S%'
AND o.owner LIKE 'S%'
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);


