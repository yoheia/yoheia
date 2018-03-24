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

SELECT /*+ MONITOR PARALLEL(4) */
    c.customer_id
  , c.cust_first_name
  , c.cust_last_name
  , c.credit_limit
  , o.order_mode
  , avg(oi.unit_price)
FROM
    soe.customers   c
  , soe.orders      o
  , soe.order_items oi
WHERE
-- join
    c.customer_id = o.customer_id
AND o.order_id    = oi.order_id
-- filter
AND o.order_mode = 'direct'
GROUP BY
    c.customer_id
  , c.cust_first_name
  , c.cust_last_name
  , c.credit_limit
  , o.order_mode
HAVING
    sum(oi.unit_price) > c.credit_limit * 1000
/

