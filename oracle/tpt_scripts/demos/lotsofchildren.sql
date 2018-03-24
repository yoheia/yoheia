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

EXEC EXECUTE IMMEDIATE 'drop table t_children'; EXCEPTION WHEN OTHERS THEN NULL;

CREATE TABLE t_children AS SELECT rownum a, 'zzz' b FROM dual CONNECT BY LEVEL<=1000;

CREATE INDEX i_children ON t_children(a);

-- deliberately gathering a histogram 
EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'T_CHILDREN',method_opt=>'FOR COLUMNS A SIZE 254');

-- this is the crap setting 
ALTER SESSION SET cursor_sharing = similar;

@saveset

SET PAGES 0 HEAD OFF TRIMOUT OFF TRIMSPOOL OFF ARRAYSIZE 5000 TERMOUT OFF
SPOOL tmp_lotschildren.sql
SELECT 'SELECT COUNT(*) FROM t_children WHERE a = '||TO_CHAR(ABS(DBMS_RANDOM.RANDOM))||';'
FROM dual CONNECT BY LEVEL <= 100000;
SPOOL OFF

@loadset

PROMPT Now run @tmp_lotschildren.sql

-- this hack is not working, must use plain SQL instead of plsql
-- ALTER SESSION SET session_cached_cursors = 0;
-- ALTER SESSION SET "_close_cached_open_cursors" = TRUE;
-- ALTER SESSION SET plsql_optimize_level = 0;
-- 
-- DECLARE
--     j NUMBER;
--     x NUMBER;
-- BEGIN
--     EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM t_children WHERE a = '||TO_CHAR(ABS(DBMS_RANDOM.RANDOM)) INTO j;
--     x:=x+j;
--     COMMIT;
-- END;
-- /

