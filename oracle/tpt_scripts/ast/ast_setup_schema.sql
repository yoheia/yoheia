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

DROP TABLE test_objects;
DROP TABLE test_objects10;
DROP TABLE test_objects100;
DROP TABLE test_users;
DROP TABLE indexed_objects;
DROP TABLE dummy1;
DROP TABLE dummy2;
DROP TABLE indexed_source;

CREATE TABLE test_objects AS SELECT * FROM dba_objects;
CREATE TABLE test_objects10 AS SELECT * FROM test_objects WHERE rownum <= 10;
CREATE TABLE test_objects100 AS SELECT * FROM test_objects WHERE rownum <= 100;
CREATE TABLE test_users   AS SELECT * FROM all_users;

CREATE TABLE indexed_objects AS SELECT * FROM dba_objects;
CREATE UNIQUE INDEX pk_obj_id ON indexed_objects (object_id);
CREATE INDEX idx_owner_name ON indexed_objects(owner,object_name);

CREATE TABLE dummy1 AS SELECT 1 a, 'one' b FROM dual;
CREATE TABLE dummy2 AS SELECT 1 a, 'one' b FROM dual;

CREATE TABLE indexed_source AS SELECT * FROM dba_source;
CREATE INDEX idx1_indexed_source ON indexed_source (owner,name,line);


EXEC DBMS_STATS.SET_PARAM('METHOD_OPT', 'FOR ALL COLUMNS SIZE REPEAT');

--EXEC DBMS_STATS.GATHER_SCHEMA_STATS('AST');
EXEC DBMS_STATS.GATHER_SCHEMA_STATS(user);

-- deterministic PL/SQL functions can utilize PL/SQL function result caching
CREATE OR REPLACE FUNCTION my_multiply(a IN NUMBER, b IN NUMBER) RETURN NUMBER AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('x');
    RETURN a * b;
END;
/

CREATE OR REPLACE FUNCTION my_multiply_d (a IN NUMBER, b IN NUMBER) RETURN NUMBER
    DETERMINISTIC
AS
BEGIN
    RETURN a * b;
END;
/

CREATE OR REPLACE FUNCTION my_sqrt (a IN NUMBER) RETURN NUMBER 
AS
BEGIN
    RETURN SQRT(a);
END;
/

-- select max(my_sqrt(mod(rownum,100))) from dual connect by level<=100000;
CREATE OR REPLACE FUNCTION my_sqrt_d (a IN NUMBER) RETURN NUMBER 
    DETERMINISTIC
AS
BEGIN
    RETURN SQRT(a);
END;
/




-- additional stuff in scott and other standard demo schemas

create or replace view scott.high_pay_depts as
select 
    * 
from 
    scott.dept d 
where 
    exists (select 1 
            from
                scott.emp e
            where 
                e.deptno = d.deptno
            and e.sal > 4500
    )
/

