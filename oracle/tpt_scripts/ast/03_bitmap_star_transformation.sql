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

-- setting the 11.2 cardinality feedback option to false for demo stability purposes
exec execute immediate 'alter session set "_optimizer_use_feedback"=false'; exception when others then null;

SELECT  /*+ star_transformation */
    ch.channel_desc
  , co.country_iso_code co 
  , cu.cust_city
  , p.prod_category
  , sum(s.quantity_sold)
  , sum(s.amount_sold)
FROM
    sh.sales     s
  , sh.customers cu
  , sh.countries co
  , sh.products  p
  , sh.channels  ch
WHERE
    -- join
    s.cust_id     = cu.cust_id
AND cu.country_id = co.country_id
AND s.prod_id     = p.prod_id
AND s.channel_id  = ch.channel_id
    -- filter
AND ch.channel_class = 'Direct'  
AND co.country_iso_code = 'US'  
AND p.prod_category = 'Electronics'
GROUP BY
    ch.channel_desc
  , co.country_iso_code
  , cu.cust_city
  , p.prod_category
/

