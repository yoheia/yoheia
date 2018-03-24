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

-- Script written based on Alex Nuijten's finding:
--  http://nuijten.blogspot.com/2015/06/deadlock-with-virtual-column.html
--
--  This should be reproducible all the way up to 12.1.0.2 versions (like the Oracle 12cR1 Developer VM)

DROP TABLE t_dl;
CREATE TABLE t_dl AS SELECT dummy a, rownum b FROM dual;

CREATE OR REPLACE FUNCTION VC (p_a in t_dl.a%TYPE ,p_b in t_dl.b%TYPE) RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
    RETURN p_a || p_b;
END vc;
/

ALTER TABLE t_dl ADD c AS (vc (a, b));

TRUNCATE TABLE t_dl;


-- Back in Oracle 9i days you could have used this too (not anymore):

-- SQL> CREATE OR REPLACE PROCEDURE p1 AS BEGIN p2; END;
--   2  /
-- 
-- Warning: Procedure created with compilation errors.
-- 
-- SQL> 
-- SQL> CREATE OR REPLACE PROCEDURE p2 AS BEGIN p1; END;
--   2  /
-- 
-- Warning: Procedure created with compilation errors.
--  
-- SQL> ALTER PROCEDURE p1 COMPILE;
-- ALTER PROCEDURE p1 COMPILE
-- *
-- ERROR at line 1:
-- ORA-04020: deadlock detected while trying to lock object SYS.P1

