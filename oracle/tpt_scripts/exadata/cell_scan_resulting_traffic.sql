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

DROP TABLE cell_traffic_test;
CREATE TABLE cell_traffic_test
PARALLEL 8
AS
SELECT 'TANEL_TEST' col, a.*, b.* FROM
    (SELECT ROWNUM r FROM dual CONNECT BY LEVEL <= 100) a
  , dba_objects b
ORDER BY
   DBMS_RANDOM.VALUE
-- b.owner, b.object_type
/
@gts cell_traffic_test

ALTER TABLE cell_traffic_test NOPARALLEL;

CREATE TABLE
