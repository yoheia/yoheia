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

SET ECHO ON
-- ALTER SESSION SET "_serial_direct_read"=ALWAYS;
-- ALTER SESSION SET "_cell_storidx_mode"=EVA; 

SELECT
    /*+ LEADING(c)
        NO_SWAP_JOIN_INPUTS(o)
        FULL(c)
        FULL(o)
        MONITOR
    */
    *
FROM
    soe.customers c
  , soe.orders o
WHERE
    o.customer_id = c.customer_id
--AND c.cust_email = 'florencio@ivtboge.com'
AND c.cust_email = 'anthony.pena@bellsouth.com'
/
SET ECHO OFF



-- 11.2.0.4 estrella@socxankh.com
