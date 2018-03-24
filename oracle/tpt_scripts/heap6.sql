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

--select
--    /*+ ordered use_nl(hp) */
--    hp.*
--from
--    x$ksmsp sp
--  , x$ksmhp hp
--where
--    sp.ksmchptr = hp.ksmchds
--/
--
--COL sql_text FOR A80 TRUNCATE
--SELECT * FROM (
--    SELECT 
--        sql_id
--      , sharable_mem
--      , persistent_mem
--      , runtime_mem
--      , sql_text
--    FROM
--        V$SQL
--    ORDER BY
--        sharable_mem DESC
--)
--WHERE rownum <=10
--/
--
--COL sql_text CLEAR

SELECT 
    chunk_com, 
    alloc_class, 
    sum(chunk_size) totsize,
    count(*),
    count (distinct chunk_size) diff_sizes,
    round(avg(chunk_size)) avgsz,
    min(chunk_size) minsz,
    max(chunk_size) maxsz
FROM 
    v$sql_shared_memory 
WHERE 
    sql_id = '&1'
GROUP BY
    chunk_com,
    alloc_class
ORDER BY
    totsize DESC    
/
