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

SELECT * FROM (
SELECT 
    sql_id
  , executions
  , px_servers_executions  px_execs
  , physical_read_requests phyrd_rq
  , ROUND(physical_read_bytes/1048576) physrd_mb 
  , ROUND((physical_read_bytes / physical_read_requests) / 1024) avg_read_kb
  , optimized_phy_read_requests opt_phyrd_rq
  , ROUND(((physical_read_bytes / physical_read_requests) * optimized_phy_read_requests) / 1048576) est_optim_mb
  , ROUND(optimized_phy_read_requests / physical_read_requests * 100) opt_rq_pct
FROM 
    v$sql 
WHERE 
    optimized_phy_read_requests > 0 
ORDER BY 
    optimized_phy_read_requests DESC
)
WHERE
    rownum <= 20
/

