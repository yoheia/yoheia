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

DROP TABLE t;

CREATE TABLE t (a int, b varchar2(100))
PARTITION BY RANGE (a) (
  PARTITION p1 VALUES LESS THAN (10)
 ,PARTITION p2 VALUES LESS THAN (20)
)
/

INSERT INTO t SELECT 5, 'axxxxxxxxxxxxxxxxx' FROM dual;
INSERT INTO t SELECT 5, 'bxxxxxxxxxxxxxxxxx' FROM dual;
INSERT INTO t SELECT 5, 'cxxxxxxxxxxxxxxxxx' FROM dual;

INSERT INTO t SELECT 15, 'axxxxxxxxxxxxxxxxx' FROM dual;
INSERT INTO t SELECT 15, 'bxxxxxxxxxxxxxxxxx' FROM dual;
INSERT INTO t SELECT 15, 'cxxxxxxxxxxxxxxxxx' FROM dual CONNECT BY LEVEL <= 10000;

CREATE INDEX i1 ON t(a) LOCAL;
CREATE INDEX i2 ON t(b) LOCAL;

@gts t

