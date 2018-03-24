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

DROP TABLE t_commit;
CREATE TABLE t_commit AS SELECT 1 a FROM dual;

-- experiment with
ALTER SESSION  SET COMMIT_LOGGING = IMMEDIATE;
ALTER SESSION  SET COMMIT_WRITE = WAIT;

BEGIN
  FOR i IN 1..1000000 LOOP
    UPDATE t_commit SET a=a+1;
    COMMIT;
  END LOOP;
END;
/

