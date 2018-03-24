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
CREATE TABLE t AS SELECT * FROM dba_objects;
CREATE INDEX i1 ON t(MOD(object_id,4), object_id);
@gts t

SELECT /*+ INDEX_SS(t) */ * FROM t WHERE object_id = 12345;
@x

CREATE INDEX i2 ON t(MOD(SYS_CONTEXT('USERENV','SID'),4), object_id);
SELECT /*+ INDEX_SS(t) */ * FROM t WHERE object_id = 12345;
@x

ALTER TABLE t ADD x NUMBER NULL;
ALTER TABLE t MODIFY x DEFAULT MOD(SYS_CONTEXT('USERENV','SID'),16);

CREATE INDEX i3 ON t(x,object_id);
SELECT * FROM t WHERE object_id = 12345;
@x

