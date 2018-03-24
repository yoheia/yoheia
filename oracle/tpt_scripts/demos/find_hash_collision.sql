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

--------------------------------------------------------------------------------
--
-- File name:   demos/find_hash_collision.sql
-- Purpose:     Advanced Oracle Troubleshooting seminar demo script
--              for finding different SQL statements which have colliding hash
--              values
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @demos/find_hash_collision.sql
-- 	        
-- Other:       In theory it may take a lot of memory if iterating way too many
--              times before finding colliding hash value
--
-- NB! This script is not working properly yet! As GET_SQL_HASH function
--     isn't doing its job right
--
--------------------------------------------------------------------------------

SET SERVEROUT ON SIZE 1000000

DECLARE
    TYPE typ IS TABLE OF NUMBER INDEX BY VARCHAR2(10);
    t typ;
    i NUMBER := 0;
    h VARCHAR2(10);
    tmp NUMBER;
    tmp_raw RAW(16);
    str VARCHAR2(100):='select * from dual where rownum = ';
BEGIN
    WHILE TRUE LOOP
        h := TO_CHAR(DBMS_UTILITY.GET_SQL_HASH(str||TO_CHAR(i), tmp_raw, tmp));    

        IF t.EXISTS(h) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(10)||'Matching hash values found (hash='||TO_CHAR(h)||'):'||CHR(10)||CHR(10)||str||TO_CHAR(t(h))||CHR(10)||str||TO_CHAR(i));
            DBMS_OUTPUT.PUT_LINE('raw='||RAWTOHEX(tmp_raw));
            EXIT;
        ELSE
           t(h):=i;
           i:=i+1;
        END IF;
    END LOOP;
END;
/

SET SERVEROUT OFF
