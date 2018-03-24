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

col aot_hash_owner head OWNER for a12
col aot_hash_name head NAME word_wrap for a30
col aot_hash_dblink head DBLINK for a12

SELECT
    kglnaown aot_hash_OWNER
  , kglnaobj aot_hash_NAME
  , kglnadlk aot_hash_DBLINK
  , kglnahsh HASH_VALUE
  , TO_CHAR(kglnahsh, 'xxxxxxxx') HASH_HEX
  , kglnahsv MD5_HASH
  , kglobt03 SQL_ID
  , kglobt30 PLAN_HASH
  , kglobt31 LIT_HASH
  , kglobt46 OLD_HASH
FROM
    x$kglob
WHERE
    lower(kglnaobj) like lower('&1')
/
