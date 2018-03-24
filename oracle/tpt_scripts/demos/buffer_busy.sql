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

-- DROP TABLE tbb;
-- DROP SEQUENCE tbb_seq;
-- 
-- CREATE SEQUENCE tbb_seq NOCACHE;
-- 
-- CREATE TABLE tbb (
--      id         NUMBER PRIMARY KEY
--    , val        NUMBER
--    , entry_date DATE
-- );
-- 
-- CREATE INDEX tbb_entry ON tbb(entry_date);
-- 
-- INSERT INTO tbb VALUES (0, 123, sysdate);
-- COMMIT;

DECLARE
   tmp_id NUMBER;
BEGIN

    WHILE TRUE LOOP

        SELECT MIN(id) INTO tmp_id FROM tbb;

        INSERT INTO tbb VALUES (tbb_seq.NEXTVAL, 123, sysdate);

        BEGIN
            DELETE FROM tbb WHERE id = tmp_id;
        EXCEPTION
            WHEN no_data_found THEN NULL;
        END;

        COMMIT;

    END LOOP;

END;
/





