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

COL sqlfna_name HEAD NAME
BREAK ON sqlfna_name SKIP 1 ON func_id

SELECT
    f.name           sqlfna_name
  , f.func_id
  , f.analytic
  , f.aggregate
  , f.offloadable
--  , f.usage
  , f.minargs
  , f.maxargs
  , a.argnum
  , a.datatype
  , a.descr
--  , f.descr 
FROM
    v$sqlfn_metadata f
  , v$sqlfn_arg_metadata a
WHERE 
    a.func_id = f.func_id
AND UPPER(f.name) LIKE UPPER('&1')
ORDER BY
    f.name
  , f.func_id
  , f.analytic
  , f.aggregate
  , a.argnum
/

