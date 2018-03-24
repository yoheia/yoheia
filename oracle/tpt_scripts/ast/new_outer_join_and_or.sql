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

-- DROP TABLE s;
-- DROP TABLE t;
-- 
-- CREATE TABLE s AS SELECT * FROM dba_segments;
-- CREATE TABLE t AS SELECT * FROM dba_tables;
-- 
-- SET TIMING ON

-- SELECT COUNT(*) 
-- FROM
--     t
--   , s 
-- WHERE
--        (t.owner = s.owner AND t.table_name = s.segment_name) 
--     OR (t.owner = s.owner AND UPPER(t.table_name) = UPPER(s.segment_name))
-- /
-- 
-- @x

SELECT 
  /*+
      ALL_ROWS
      MERGE(@"SEL$2")
      FULL(@"SEL$64EAE176" "T"@"SEL$2")
      NO_ACCESS(@"SEL$64EAE176" "from$_subquery$_004"@"SEL$2")
      LEADING(@"SEL$64EAE176" "T"@"SEL$2" "from$_subquery$_004"@"SEL$2")
      USE_HASH(@"SEL$64EAE176" "from$_subquery$_004"@"SEL$2")
      FULL(@"SEL$1" "S"@"SEL$1")
  */
  COUNT(*) 
FROM
    t 
   LEFT OUTER JOIN
    s 
ON (
       (t.owner = s.owner AND t.table_name = s.segment_name) 
    OR (t.owner = s.owner AND UPPER(t.table_name) = UPPER(s.segment_name))
);

-- @x

-- SELECT COUNT(*) FROM (
--     SELECT * FROM t LEFT JOIN s ON (t.owner = s.owner AND t.table_name = s.segment_name)
--     UNION 
--     SELECT * FROM t LEFT JOIN s ON (t.owner = s.owner AND UPPER(t.table_name) = UPPER(s.segment_name))
-- );
-- 
-- @x

