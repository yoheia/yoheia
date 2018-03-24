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
-- File name:   sgastatx
-- Purpose:     Show shared pool stats by sub-pool from X$KSMSS
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @sgastatx <statistic name>
-- 	        @sgastatx "free memory"
--	        @sgastatx cursor
--
-- Other:       The other script for querying V$SGASTAT is called sgastat.sql
--              
--              
--
--------------------------------------------------------------------------------

COL sgastatx_subpool HEAD SUBPOOL FOR a30

PROMPT
PROMPT -- All allocations:

SELECT
    'shared pool ('||NVL(DECODE(TO_CHAR(ksmdsidx),'0','0 - Unused',ksmdsidx), 'Total')||'):'  sgastatx_subpool
  , SUM(ksmsslen) bytes
  , ROUND(SUM(ksmsslen)/1048576,2) MB
FROM 
    x$ksmss
WHERE
    ksmsslen > 0
--AND ksmdsidx > 0 
GROUP BY ROLLUP
   ( ksmdsidx )
ORDER BY
    sgastatx_subpool ASC
/

BREAK ON sgastatx_subpool SKIP 1
PROMPT -- Allocations matching "&1":

SELECT 
    subpool sgastatx_subpool
  , name
  , SUM(bytes)                  
  , ROUND(SUM(bytes)/1048576,2) MB
FROM (
    SELECT
        'shared pool ('||DECODE(TO_CHAR(ksmdsidx),'0','0 - Unused',ksmdsidx)||'):'      subpool
      , ksmssnam      name
      , ksmsslen      bytes
    FROM 
        x$ksmss
    WHERE
        ksmsslen > 0
    AND LOWER(ksmssnam) LIKE LOWER('%&1%')
)
GROUP BY
    subpool
  , name
ORDER BY
    subpool    ASC
  , SUM(bytes) DESC
/

BREAK ON sgastatx_subpool DUP
