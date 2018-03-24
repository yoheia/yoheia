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

prompt Generate some load for &1 hours....

DECLARE
  j NUMBER;
  begin_date DATE := SYSDATE;
BEGIN
    WHILE TRUE LOOP
        SELECT SUM(LENGTH(TEXT)) INTO j FROM dba_source;
        DBMS_LOCK.SLEEP(60 * DBMS_RANDOM.VALUE(0,1));
    END LOOP;
END;
/

