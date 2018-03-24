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
-- File name:   measure_io.sql (v0.1)
-- Purpose:     Measure IO reasons and "sizes" from v$iostat_function_detail
--              
-- Author:      Tanel Poder
-- Copyright:   (c) http://blog.tanelpoder.com | @tanelpoder
--              
-- Usage:       @measuire_io "SELECT your query here"
--
--
-- Other:       This script uses the v$iostat_function_detail view that is available
--              from Oracle 11.2 - and it contains instance-wide data.
--
--              The script adds a COUNT(*) around your query, so this may change
--              your query's execution plan.
--              
--------------------------------------------------------------------------------

WITH sq1   AS (SELECT * FROM v$iostat_function_detail)
   , sq2   AS (SELECT * FROM v$iostat_function_detail)
   , mainq AS (SELECT COUNT(*) FROM (&1))
SELECT /*+ LEADING(sq1,mainq) */
    sq1.function_name
  , sq1.filetype_name
  , NULLIF(sq2.small_read_reqs       - sq1.small_read_reqs       , 0 ) sm_rd_iops
  , NULLIF(sq2.large_read_reqs       - sq1.large_read_reqs       , 0 ) lg_rd_iops
  , NULLIF(sq2.small_write_reqs      - sq1.small_write_reqs      , 0 ) sm_wr_iops
  , NULLIF(sq2.large_write_reqs      - sq1.large_write_reqs      , 0 ) lg_wr_iops
  , NULLIF(sq2.small_read_megabytes  - sq1.small_read_megabytes  , 0 ) sm_rd_mb
  , NULLIF(sq2.large_read_megabytes  - sq1.large_read_megabytes  , 0 ) lg_rd_mb
  , NULLIF(sq2.small_write_megabytes - sq1.small_write_megabytes , 0 ) sm_wr_mb
  , NULLIF(sq2.large_write_megabytes - sq1.large_write_megabytes , 0 ) lg_wr_mb
  , ROUND ((sq2.small_read_megabytes  - sq1.small_read_megabytes ) / NULLIF(sq2.small_read_reqs  - sq1.small_read_reqs  , 0 ) * 1024 , 1 ) avg_sm_rd_rq_kb
  , ROUND ((sq2.large_read_megabytes  - sq1.large_read_megabytes ) / NULLIF(sq2.large_read_reqs  - sq1.large_read_reqs  , 0 ) * 1024 , 1 ) avg_lg_rd_rq_kb
  , ROUND ((sq2.small_write_megabytes - sq1.small_write_megabytes) / NULLIF(sq2.small_write_reqs - sq1.small_write_reqs , 0 ) * 1024 , 1 ) avg_sm_wr_rq_kb
  , ROUND ((sq2.large_write_megabytes - sq1.large_write_megabytes) / NULLIF(sq2.large_write_reqs - sq1.large_write_reqs , 0 ) * 1024 , 1 ) avg_lg_wr_rq_kb
FROM
    sq1
  , mainq
  , sq2
WHERE
    sq1.function_id=sq2.function_id
AND sq1.filetype_id=sq2.filetype_id
/
