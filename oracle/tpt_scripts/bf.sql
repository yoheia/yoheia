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

SELECT 
  --  sqlhashv
  -- , flags
    qcinstid
  , qcsid
  , bfm
  , 'BF'||TRIM(TO_CHAR(bfid,'0999')) bf_id
  , len   bytes_total
  , len*8 bits_total
  , nset  bits_set
  , TO_CHAR(ROUND((nset/(len*8))*100,1),'999.0')||' %' pct_set
  , flt filtered
  , tot total_probed
  , active 
FROM 
    x$qesblstat
WHERE
    sqlhashv = DBMS_UTILITY.SQLID_TO_SQLHASH('&1')
ORDER BY
    bfid
/

