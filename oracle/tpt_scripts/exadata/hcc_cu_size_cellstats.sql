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

-- small tables

-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_query_low';    EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_query_high';   EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_archive_low';  EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_archive_high'; EXCEPTION WHEN OTHERS THEN NULL;
-- 
-- CREATE TABLE t_hcc_query_low    COMPRESS FOR QUERY LOW AS SELECT * FROM dba_source;
-- CREATE TABLE t_hcc_query_high   COMPRESS FOR QUERY HIGH AS SELECT * FROM dba_source;
-- CREATE TABLE t_hcc_archive_low  COMPRESS FOR ARCHIVE LOW AS SELECT * FROM dba_source;
-- CREATE TABLE t_hcc_archive_high COMPRESS FOR ARCHIVE HIGH AS SELECT * FROM dba_source;

-- large tables

-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_query_low';    EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_query_high';   EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_archive_low';  EXCEPTION WHEN OTHERS THEN NULL;
-- EXEC EXECUTE IMMEDIATE 'drop table t_hcc_archive_high'; EXCEPTION WHEN OTHERS THEN NULL;
-- 
-- CREATE TABLE t_hcc_query_low    COMPRESS FOR QUERY LOW AS SELECT * FROM dba_objects, (SELECT 'x' text FROM dual CONNECT BY LEVEL <=10);
-- CREATE TABLE t_hcc_query_high   COMPRESS FOR QUERY HIGH AS SELECT * FROM dba_objects, (SELECT 'x' text FROM dual CONNECT BY LEVEL <=10);
-- CREATE TABLE t_hcc_archive_low  COMPRESS FOR ARCHIVE LOW AS SELECT * FROM dba_objects, (SELECT 'x' text FROM dual CONNECT BY LEVEL <=10);
-- CREATE TABLE t_hcc_archive_high COMPRESS FOR ARCHIVE HIGH AS SELECT * FROM dba_objects, (SELECT 'x' text FROM dual CONNECT BY LEVEL <=10);

EXEC exatest.snap

SELECT SUM(LENGTH(text)) query_low FROM t_hcc_query_low WHERE owner LIKE '%S%';
SELECT * FROM TABLE(exatest.diff('cell.*'));
--SELECT * FROM TABLE(exatest.diff('EHCC CUs Decompressed|EHCC.*Length Decompressed'));

SELECT SUM(LENGTH(text)) query_high FROM t_hcc_query_high WHERE owner LIKE '%S%';
SELECT * FROM TABLE(exatest.diff('cell.*'));
--SELECT * FROM TABLE(exatest.diff('EHCC CUs Decompressed|EHCC.*Length Decompressed'));

SELECT SUM(LENGTH(text)) archive_low FROM t_hcc_archive_low WHERE owner LIKE '%S%';
SELECT * FROM TABLE(exatest.diff('cell.*'));
--SELECT * FROM TABLE(exatest.diff('EHCC CUs Decompressed|EHCC.*Length Decompressed'));

SELECT SUM(LENGTH(text)) archive_high FROM t_hcc_archive_high WHERE owner LIKE '%S%';
SELECT * FROM TABLE(exatest.diff('cell.*'));
--SELECT * FROM TABLE(exatest.diff('EHCC CUs Decompressed|EHCC.*Length Decompressed'));

