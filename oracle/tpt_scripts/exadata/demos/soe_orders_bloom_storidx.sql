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

-- the small_orders table below is a table with one order only (for demo purposes,
-- so that scanning the large orders_table wouldn't affect measurements). The idea
-- is to demonstrate that even without any direct filter predicates against the "fact"
-- table ORDER_ITEMS, the bloom filter min/max values can also be used for avoiding IO
-- with storage indexes.
--
-- You can create your SMALL_ORDERS table (from SwingBench Order Entry SOE schema):
--   CREATE TABLE soe.small_orders AS SELECT * FROM soe.orders WHERE rownum = 1;
--

SELECT /*+ MONITOR LEADING(o) FULL(o) FULL(oi) PARALLEL(4) PX_JOIN_FILTER(oi) */
    o.*
  , oi.*
FROM
    soe.small_orders o -- one row only
  , soe.order_items oi
WHERE
-- join conditions
    o.order_id    = oi.order_id
/

