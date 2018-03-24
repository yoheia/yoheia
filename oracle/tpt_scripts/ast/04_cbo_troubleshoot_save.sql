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

SELECT /*+ leading (dep e o)
           NO_SWAP_JOIN_INPUTS(@"SEL$5488CC2B" "C"@"MAIN")
           opt_param('_optimizer_use_feedback', 'false')
           qb_name(main)
    */
    dep.department_name
  , e.first_name
  , e.last_name
  , prod.product_name
  , c.cust_first_name
  , c.cust_last_name
  , SUM(oi.quantity)
  , sum(oi.unit_price * oi.quantity) total_price
FROM
    hr.departments dep  -- 1
  , hr.employees   e    -- 1
  , oe.orders      o    -- ?
  , oe.order_items oi   -- ?
  , oe.products    prod -- 1
  , oe.customers   c    -- 1
  , oe.promotions  prom -- ?
WHERE
   -- joins
    o.order_id          = oi.order_id
AND oi.product_id       = prod.product_id 
AND o.promotion_id      = prom.promo_id (+)
AND o.customer_id       = c.customer_id
AND o.sales_rep_id      = e.employee_id
AND dep.department_id   = e.department_id
   -- filters
AND dep.department_name   = 'Sales'             -- 1 row
AND e.first_name        = 'William'           -- 1 row
AND e.last_name         = 'Smith'
AND prod.product_name   = 'Mobile Web Phone'  -- 1 row (view)
AND c.cust_first_name   = 'Gena'              --
AND c.cust_last_name    = 'Harris'            -- 1 row
GROUP BY
    dep.department_name
  , e.first_name
  , e.last_name
  , prod.product_name
  , c.cust_first_name
  , c.cust_last_name
 ORDER BY
    total_price
/ 
