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

ALTER SESSION SET EVENTS 'immediate trace name trace_buffer_on level 1048576';

DECLARE
    j NUMBER;
BEGIN
    WHILE TRUE LOOP
      BEGIN
          SELECT /*+ INDEX_RS_ASC(t i_c_hotsos) */ data_object_id INTO j
          FROM t_c_hotsos t 
          WHERE object_id = 21230 - 5000 + TRUNC(DBMS_RANDOM.VALUE(0, 10000)); -- 21230
  
          --DBMS_LOCK.SLEEP(DBMS_RANDOM.VALUE(0,0.01));
      EXCEPTION
          WHEN OTHERS THEN NULL; -- Do not show this to Tom Kyte!!!
      END;
    END LOOP;
END;
/

ALTER SESSION SET EVENTS 'immediate trace name trace_buffer_off';

