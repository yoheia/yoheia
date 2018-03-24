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

-- DROP TABLE t;
-- CREATE TABLE t (a NUMBER, b CHAR(2000));
-- 
-- CREATE INDEX i ON t(a,b) PCTFREE 0;
-- 
-- ALTER SESSION SET plsql_optimize_level = 0;
-- EXEC FOR i IN 1..50000 LOOP INSERT INTO t VALUES (i, 'x'); END LOOP;

-- modified version, based on http://sai-oracle.blogspot.com/2009/04/beware-of-index-contention-after-mass.html

CREATE TABLESPACE tmp_freelist_ts DATAFILE 'tmp_freelist_ts.dbf' SIZE 100M AUTOEXTEND ON EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M SEGMENT SPACE MANAGEMENT MANUAL;

DROP TABLE idx1;
DROP TABLE idx2;

CREATE TABLE idx1(a NUMBER) TABLESPACE tmp_freelist_ts;

CREATE INDEX idx1_idx ON idx1 (a) TABLESPACE tmp_freelist_ts PCTFREE 0;

INSERT INTO idx1 SELECT rownum FROM all_objects, all_objects WHERE ROWNUM <= 250000;

COMMIT;

CREATE TABLE idx2 TABLESPACE tmp_freelist_ts AS SELECT * FROM idx1 WHERE 1=2;

INSERT INTO idx2
SELECT * FROM idx1 WHERE rowid IN
(SELECT rid FROM
(SELECT rid, ROWNUM rn FROM
(SELECT rowid rid FROM idx1 WHERE a BETWEEN 10127 AND 243625 ORDER BY a)
)
WHERE MOD(rn, 250) = 0
)
/

COMMIT;

DELETE FROM idx1 WHERE a BETWEEN 10127 AND 243625;

COMMIT;

INSERT INTO idx1 SELECT * FROM idx2;

COMMIT;

INSERT INTO IDX1 SELECT 250000+ROWNUM FROM ALL_OBJECTS WHERE ROWNUM <= 126;

COMMIT;

SELECT SQL_ID, EXECUTIONS, BUFFER_GETS, DISK_READS, CPU_TIME, ELAPSED_TIME, ROWS_PROCESSED, SQL_TEXT FROM V$SQL
WHERE SQL_TEXT LIKE '%INSERT%IDX1%' AND SQL_TEXT NOT LIKE '%V$SQL%';

INSERT INTO IDX1 VALUES (251000);

COMMIT;

SELECT SQL_ID, EXECUTIONS, BUFFER_GETS, DISK_READS, CPU_TIME, ELAPSED_TIME, ROWS_PROCESSED, SQL_TEXT FROM V$SQL
WHERE SQL_TEXT LIKE '%INSERT%IDX1%' AND SQL_TEXT NOT LIKE '%V$SQL%';



