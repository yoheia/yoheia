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

DROP TABLE cons_demo;

CREATE TABLE cons_demo (owner varchar2(100), object_name varchar2(128));

INSERT /*+ APPEND */ INTO cons_demo SELECT owner, object_name FROM dba_objects;
COMMIT;

SELECT COUNT(*) FROM cons_demo;
@x

CREATE INDEX idx1_cons_demo ON cons_demo(owner);

SELECT COUNT(*) FROM cons_demo;
@x

SELECT /*+ INDEX(cons_demo cons_demo(owner)) */ COUNT(*) FROM cons_demo;

ALTER TABLE cons_demo MODIFY owner NOT NULL NOVALIDATE;

INSERT INTO cons_demo VALUES (null, 'x');

SELECT COUNT(*) FROM cons_demo;
@x

ALTER TABLE cons_demo MODIFY owner NULL;
--ALTER TABLE cons_demo MODIFY owner NOT NULL VALIDATE;
--ALTER TABLE cons_demo MODIFY owner NOT NULL DEFERRABLE INITIALLY DEFERRED VALIDATE;
ALTER TABLE cons_demo MODIFY owner NOT NULL DEFERRABLE VALIDATE;

SELECT COUNT(*) FROM cons_demo;
@x


DROP TABLE cons_demo2;

CREATE TABLE cons_demo2 AS SELECT * FROM scott.emp;

ALTER TABLE cons_demo2 ADD CONSTRAINT c2 CHECK (SAL > 500);

SELECT * FROM cons_demo2 WHERE sal = 100;

@x

