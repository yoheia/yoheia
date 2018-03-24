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

-- This hard crashes the target process in 10.2.0.3 Solaris with SEGV

DROP VIEW v1;
DROP FUNCTION f1;


CREATE OR REPLACE FUNCTION f1 RETURN NUMBER AS
BEGIN
    RETURN 1;
END;
/


CREATE OR REPLACE view v1 AS SELECT f1 FROM dual;

CREATE OR REPLACE FUNCTION f1 RETURN NUMBER AS 
    i NUMBER;
BEGIN 
    SELECT f1 INTO i FROM v1;
    RETURN i;
END;
/

CREATE OR REPLACE view v1 AS SELECT f1 FROM dual;

