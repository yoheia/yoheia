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

--DROP TABLE t;
--CREATE TABLE t (a CHAR(100)) PCTFREE 99 PCTUSED 1 TABLESPACE users;
--@seg2 T
--@gts T

TRUNCATE TABLE t;

INSERT /*+ APPEND */ INTO t SELECT 'x' FROM dual CONNECT BY LEVEL <= 1000;
--@dump 4 99316 Start
--@dump 4 99317 Start

ALTER SYSTEM FLUSH BUFFER_CACHE;

COMMIT;
--@dump 4 99316 Start
--@dump 4 99317 Start

--@ev 10203 2
--@ev 10200 1
--@ev 10046 8

SELECT COUNT(*) FROM t;
--@dump 4 99316 Start
--@dump 4 99317 Start
