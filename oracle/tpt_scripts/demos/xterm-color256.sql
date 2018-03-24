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

-- oracle 11.2+

SELECT
  LISTAGG (CHR(27)||'[48;5;'||
              ( 16 + MOD(r,6) + MOD(TRUNC(r/6),6)*6 + MOD(TRUNC(r/36),6)*6*6 )||'m'||
              LPAD(16 + MOD(r,6) + MOD(TRUNC(r/6),6)*6 + MOD(TRUNC(r/36),6)*6*6,4)||
              CHR(27)||'[0m'
  ) WITHIN GROUP (ORDER BY MOD(TRUNC(r/6),6))
FROM
    (SELECT rownum r FROM dual CONNECT BY LEVEL <= 216)
GROUP BY
    MOD(TRUNC(r/36),6)
/
