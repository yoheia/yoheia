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

-- analyze index density (how many rows per leaf block)
-- using SYS_OP_LBID function

-- replace the first argument of SYS_OP_LBID number with the object_id of the index you are scanning
-- also you need to modify the table name and index name hint to query the table/index of your interest
-- make sure that the index is actually accessed in the execution plan (both fast full scan and range/full
-- scans do work, but fast full scan is the fastest if you want to scan through the entire index segment)
-- 
-- additionally, you can use SAMPLE BLOCK syntax (below) to sample only some index blocks (when using
-- fast full scan)


COL blocks_histogram HEAD "Log(2,blocks) Histogram" FOR A30

SELECT
     LPAD(NVL(TO_CHAR(rows_per_block), 'Total:'), 15, ' ') num_rows_in_blk
   , blocks
   , NVL2(rows_per_block, LPAD('#', LOG(2,blocks), '#'), null) blocks_histogram
FROM (
    SELECT 
        CEIL(num_rows/10) * 10 rows_per_block
      , COUNT(*) blocks
    FROM (
        SELECT /*+ INDEX_FFS(o IDX3_INDEXED_OBJECTS) */ 
            count(*)                            num_rows
        FROM 
            indexed_objects o  -- SAMPLE BLOCK (1000) o
        WHERE 
            owner IS NOT NULL 
        GROUP BY 
            SYS_OP_LBID( 78363, 'L', o.ROWID)
    )
    GROUP BY ROLLUP 
       ( CEIL(num_rows/10) * 10 )
    ORDER BY
        CEIL(num_rows/10) * 10 
)
/

                              
