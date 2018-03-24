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
    child_number chld
  , ROUND( physical_read_bytes             / 1048576 ) phyrd_mb
  , ROUND( physical_write_bytes            / 1048576 ) phywr_mb
  , ROUND( io_cell_offload_eligible_bytes  / 1048576 ) phyrd_offl_elig_mb
  , ROUND( io_cell_offload_returned_bytes  / 1048576 ) phyrd_offl_ret_mb
  , ROUND( io_interconnect_bytes           / 1048576 ) ic_total_traffic_mb
  , ROUND( io_cell_uncompressed_bytes      / 1048576 ) total_uncomp_mb
  , optimized_phy_read_requests               phyrd_optim_rq
FROM
    v$sql
WHERE
    sql_id = '&1'
AND child_number LIKE '&2'
@pr

