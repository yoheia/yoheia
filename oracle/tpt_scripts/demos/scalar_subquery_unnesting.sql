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
CREATE TABLE test_users  AS SELECT * FROM all_users;
CREATE TABLE test_objects AS SELECT * FROM all_objects;
@gts test_users
@gts test_objects

@53on 

SELECT /*+ GATHER_PLAN_STATISTICS */
    u.username
  , (SELECT MAX(created) FROM test_objects o WHERE o.owner = u.username)
FROM
    test_users u
WHERE
    username LIKE 'S%'
/

@53off
@xall
@53on

-- ALTER SESSION SET "_optimizer_unnest_scalar_sq" = FALSE;

SELECT /*+ GATHER_PLAN_STATISTICS NO_UNNEST(@ssq) */
    u.username
  , (SELECT /*+ QB_NAME(ssq) */ MAX(created) FROM test_objects o WHERE o.owner = u.username)
FROM
    test_users u
WHERE
    username LIKE 'S%'
/

@53off
@xall

