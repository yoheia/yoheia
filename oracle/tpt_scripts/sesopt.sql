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

PROMPT Show compilation environment of session &1 parameter &2

SELECT
    sid_qksceserow              SID
--  , pnum_qksceserow             
  , pname_qksceserow            parameter
  , DECODE(BITAND(flags_qksceserow, 2), 0, 'NO', 'YES') isdefault
  , UPPER(pvalue_qksceserow)    value                                
FROM   x$qksceses
WHERE
    sid_qksceserow IN (&1)
AND LOWER(pname_qksceserow) LIKE LOWER('%&2%')
--    BITAND(flags_qksceserow, 8) = 0
--AND (BITAND(flags_qksceserow, 4) = 0 OR BITAND(flags_qksceserow, 2) = 0)
/
