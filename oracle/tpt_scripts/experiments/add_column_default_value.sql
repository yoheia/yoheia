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

DROP TABLE t;

CREATE TABLE t (a int) TABLESPACE users;
INSERT /*+ APPEND */ INTO t SELECT rownum FROM dba_source;
COMMIT;
--ALTER TABLE t ADD b INT DEFAULT 123 NOT NULL;

PAUSE Hit enter to add column
ALTER TABLE t ADD c VARCHAR2(100) DEFAULT 'taneltest' NOT NULL;
PAUSE Hit enter to change default value
ALTER TABLE t MODIFY c VARCHAR2(100) DEFAULT 'not testing anymore';


