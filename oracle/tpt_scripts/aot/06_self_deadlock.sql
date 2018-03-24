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

SET TIMING ON

DROP TABLE t_lock;
CREATE TABLE t_lock AS SELECT * FROM dual;

@pd enqueue_deadlock

DECLARE
    PROCEDURE p IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        j VARCHAR2(100);
    BEGIN
        --UPDATE t_lock SET dummy = 'Z';
        SELECT dummy INTO j FROM t_lock FOR UPDATE WAIT 6;
    END;
BEGIN
    UPDATE t_lock SET dummy = 'Z';
    p();
END;
/
