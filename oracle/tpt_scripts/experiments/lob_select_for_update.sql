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

DROP TABLE tlob;
CREATE TABLE tlob (a INT, b CLOB);

INSERT INTO tlob VALUES(1, LPAD('x',2048,'x'));
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;
UPDATE tlob SET b = b||b;

COMMIT;

SELECT DBMS_LOB.GETLENGTH(b) FROM tlob;

DROP TABLE tdummy;
CREATE table tdummy AS SELECT * FROM all_objects;

DELETE tdummy; 

ALTER SYSTEM CHECKPOINT;
ALTER SYSTEM SWITCH LOGFILE;

SELECT * FROM tlob WHERE a=1 FOR UPDATE;
COMMIT;

@log

ALTER SYSTEM SWITCH LOGFILE;

