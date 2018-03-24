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

-- Make sure that the USERS tablespace is ASSM-managed
DROP TABLE t;
CREATE TABLE t(a CHAR(100)) TABLESPACE users;

INSERT INTO t SELECT 'x' FROM dual CONNECT BY LEVEL <= 5000000;

COMMIT;

ALTER SESSION SET plsql_optimize_level = 0;

-- EXEC FOR i IN 1..1000 LOOP INSERT INTO t VALUES ('x'); END LOOP;

PROMPT Deleting all rows from t, do not commit...

DELETE t;

PROMPT Run this in another session, this should be very slow:
PROMPT   EXEC FOR i IN 1..1000 LOOP INSERT INTO t VALUES ('x'); END LOOP;;
PROMPT
