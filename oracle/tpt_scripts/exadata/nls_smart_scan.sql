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

SET ECHO ON

-- DROP TABLE t;
-- CREATE TABLE t AS SELECT a.* FROM dba_objects a, dba_objects b WHERE rownum <= 10000000;
-- EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'T');

SET TIMING ON

SELECT /* test 1 */ SUM(LENGTH(owner)) FROM t WHERE owner > 'S';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);

ALTER SESSION SET nls_comp = LINGUISTIC;
ALTER SESSION SET nls_sort = BINARY_CI;

SELECT /* test 2 */ SUM(LENGTH(owner)) FROM t WHERE owner > 'S';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);

-- ALTER SESSION SET "_cursor_plan_hash_version"=2;
-- 
-- SELECT /* test 3 */ SUM(LENGTH(owner)) FROM t WHERE owner > 'S';
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);
-- 
-- ALTER SESSION SET nls_comp = BINARY;
-- ALTER SESSION SET nls_sort = BINARY;
-- 
-- SELECT /* test 4 */ SUM(LENGTH(owner)) FROM t WHERE owner > 'S';
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR);


SET ECHO OFF

