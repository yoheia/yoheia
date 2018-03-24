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

PROMPT Show system default compilation environment, parameter &1

SELECT
--    pnum_qkscesyrow             
    pname_qkscesyrow            parameter
  , DECODE(BITAND(flags_qkscesyrow, 2), 0, 'NO', 'YES') isdefault
  , UPPER(pvalue_qkscesyrow)    value
FROM   x$qkscesys
WHERE
    LOWER(pname_qkscesyrow) LIKE LOWER('%&1%')
--    BITAND(flags_qkscesyrow, 8) = 0
--AND (BITAND(flags_qkscesyrow, 4) = 0 OR BITAND(flags_qkscesyrow, 2) = 0)
/
