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

CREATE TABLE row_filtering_test (id NUMBER, c CHAR(1000), vc VARCHAR2(1000));

INSERT /*+ APPEND */ INTO row_filtering_test
SELECT rownum, TO_CHAR(rownum), TO_CHAR(rownum)
FROM
    (SELECT 1 FROM dual CONNECT BY LEVEL <= 1000)
  , (SELECT 1 FROM dual CONNECT BY LEVEL <= 1000)
/

-- CREATE TABLE row_filtering_test AS
-- SELECT rownum r, LPAD('x',1000,'x') c1
-- FROM
--     (SELECT 1 FROM dual CONNECT BY LEVEL <= 1000)
--   , (SELECT 1 FROM dual CONNECT BY LEVEL <= 1000)
-- /
-- 
@gts row_filtering_test

ALTER SESSION SET "_serial_direct_read"=ALWAYS;

--VAR snapper REFCURSOR
--@snapper4 stats,begin 1 1 &mysid

SELECT /*+ MONITOR */ COUNT(*) FROM row_filtering_test WHERE id <= 500000;

SELECT /*+ MONITOR */ COUNT(*) FROM row_filtering_test WHERE id <= (SELECT 500000 FROM dual);

--@snapper4 stats,end 1 1 &mysid
@xp &mysid

CREATE TABLE row_filtering_helper (v NUMBER);
INSERT INTO row_filtering_helper VALUES (500000);
COMMIT;

SELECT /*+ MONITOR */ COUNT(*) FROM row_filtering_test WHERE r <= (SELECT v FROM row_filtering_helper);


SELECT /*+ MONITOR */ COUNT(*) FROM row_filtering_test WHERE id <= 500000 AND c = vc;



