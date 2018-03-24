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

DROP TABLE tcoal;
DROP SEQUENCE scoal;
CREATE TABLE tcoal (id NUMBER, a VARCHAR2(100), b VARCHAR2(100)) TABLESPACE users;
CREATE INDEX icoal1 ON tcoal(id)   TABLESPACE users;
CREATE INDEX icoal2 ON tcoal(id,a) TABLESPACE users;
CREATE INDEX icoal3 ON tcoal(b)    TABLESPACE users;
CREATE SEQUENCE scoal CACHE 10000;

BEGIN FOR i IN 1..100 LOOP
    INSERT INTO tcoal SELECT scoal.NEXTVAL, DBMS_RANDOM.STRING('a', 20), DBMS_RANDOM.STRING('a', 20)
    FROM dual CONNECT BY LEVEL <= 10000;
    COMMIT;
    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL1');
    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL2');
    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL3');
END LOOP; END;
/

BEGIN FOR i in 1..100 LOOP
    DELETE FROM tcoal WHERE MOD(id,100)!=0 AND rownum <= 10000;
    INSERT INTO tcoal SELECT scoal.NEXTVAL, DBMS_RANDOM.STRING('a', 20), DBMS_RANDOM.STRING('a', 20)
    FROM dual CONNECT BY LEVEL <= 10000;

    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL1');
    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL2');
    DBMS_STATS.GATHER_INDEX_STATS(user, 'ICOAL3');
END LOOP; END;
/

