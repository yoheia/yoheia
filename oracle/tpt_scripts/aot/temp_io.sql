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

ALTER SESSION SET workarea_size_policy=MANUAL;
ALTER SESSION SET sort_area_size=40960;
ALTER SESSION SET sort_area_retained_size=40960;

VAR c REFCURSOR

DECLARE
    t VARCHAR2(4000);
BEGIN
    LOOP
        OPEN :c FOR SELECT TO_CHAR(rownum)||LPAD('x',3900,'x') text FROM dual CONNECT BY LEVEL <=1000 ORDER BY text;
        FETCH :c INTO t;
        CLOSE :c;
    END LOOP;
END;
/

