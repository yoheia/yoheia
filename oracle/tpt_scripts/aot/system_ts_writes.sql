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

DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

SET ECHO ON

CREATE TABLE t1(a INT) TABLESPACE users;
CREATE TABLE t2(a INT) TABLESPACE system;

ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM CHECKPOINT;

PAUSE

SET TIMING ON

EXEC FOR i IN 1..300000 LOOP INSERT INTO t1 VALUES(i); END LOOP;

ALTER SYSTEM CHECKPOINT;

EXEC FOR i IN 1..300000 LOOP INSERT INTO t2 VALUES(i); END LOOP;

SET TIMING OFF ECHO OFF
