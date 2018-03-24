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
CREATE TABLE t AS SELECT * FROM dual;
INSERT INTO t VALUES ('Y');
COMMIT;

PROMPT Sleeping for 3 seconds...
EXEC DBMS_LOCK.SLEEP(5);

PROMPT Running...
DECLARE
    j NUMBER;
    t NUMBER := 0;
    curscn NUMBER;
BEGIN
    SELECT current_scn INTO curscn FROM v$database;
    FOR i IN 1..1000 LOOP
        EXECUTE IMMEDIATE 'select count(*) from t as of scn '||curscn INTO j;
        t := t + j; 
        DBMS_OUTPUT.PUT_LINE(j);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(t);
END;
/

@topcur

