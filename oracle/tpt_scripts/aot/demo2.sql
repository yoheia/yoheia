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

--------------------------------------------------------------------------------
--
-- File name:   demo2.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--              Makes a single fetch to generate lots of LIOs by
--              nested looping over full table scans.
--              Requires lotslios.sql script from TPT scripts.
--
-- Author:      Tanel Poder ( http://www.tanelpoder.com )
-- Copyright:   (c) Tanel Poder
--
--------------------------------------------------------------------------------

prompt Starting Demo2...

-- @@lotslios 1000000000000

--------------------------------------------------------------------------------
--
-- File name:   demos/bind_peeking_nested_loops.sql
-- Purpose:     this script demos how a "wrong" bind variable value
--              can cause an execution plan to be compiled which is 
--              very inefficient for the next execution with different bind variable
--              values (with large number of matching rows) 
--              the second execution of the query takes very long time to complete
--              despite adaptive bind variable peeking, which would kick in during the 
--              next (3rd) execution
--
--              This problem happens even on Oracle 11.2 despite adaptive bind peeking
--              and cardinality feedback (due design, not a bug)
--              
-- Author:      Tanel Poder (tanel@e2sn.com)
-- Copyright:   (c) http://tech.e2sn.com
--
--------------------------------------------------------------------------------

DROP TABLE t1;
DROP TABLE t2;
DROP TABLE t3;

CREATE TABLE t1 AS SELECT * FROM dba_objects;
CREATE TABLE t2 AS SELECT * FROM dba_objects;
CREATE TABLE t3 AS SELECT * FROM dba_objects;

CREATE INDEX i1 ON t1(owner);
CREATE INDEX i2 ON t2(owner);
CREATE INDEX i3 ON t3(owner);

EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'T1',cascade=>TRUE, method_opt=>'FOR ALL INDEXED COLUMNS SIZE 254');
EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'T2',cascade=>TRUE, method_opt=>'FOR ALL INDEXED COLUMNS SIZE 254');
EXEC DBMS_STATS.GATHER_TABLE_STATS(user,'T3',cascade=>TRUE, method_opt=>'FOR ALL INDEXED COLUMNS SIZE 254');

ALTER SESSION SET OPTIMIZER_INDEX_COST_ADJ=1;

VAR v VARCHAR2(100)

EXEC :v:='SCOTT'

SET TIMING ON

--PROMPT Running query first time, this should be fast (and should use nested loops execution plan)

SELECT
    MIN(t1.created), MAX(t1.created)
FROM
    t1
  , t2
  , t3
WHERE
    t1.object_id = t2.object_id
AND t2.object_id = t3.object_id
AND t1.owner = :v
AND t2.owner = :v
AND t3.owner = :v
/

SET TIMING OFF

--SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(null,null,'ALLSTATS LAST ADVANCED'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(null,null));

EXEC :v:='SYS'

SET TIMING ON

PROMPT Running the "report"...
--PROMPT Now running the same query with different bind variables (this query should take very long time)

SELECT
    MIN(t1.created), MAX(t1.created)
FROM
    t1
  , t2
  , t3
WHERE
    t1.object_id = t2.object_id
AND t2.object_id = t3.object_id
AND t1.owner = :v
AND t2.owner = :v
AND t3.owner = :v
/

