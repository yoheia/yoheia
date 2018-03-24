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

-- get_compression_type runs recursive queries for every row analyzed, so it is extremely inefficient to run for analyzing many rows

SELECT
    COUNT(*)
  , DECODE( SYS.DBMS_COMPRESSION.GET_COMPRESSION_TYPE(USER, UPPER('&1'), ROWID),
      1, 'No Compression',
      2, 'Basic/OLTP Compression', 
      4, 'HCC Query High',
      8, 'HCC Query Low',
      16, 'HCC Archive High',
      32, 'HCC Archive Low',
      64, 'COMP_BLOCK ZFS?',
      'Unknown Compression Level'
    ) AS comp_type
FROM 
    &1
WHERE rownum <= &2
GROUP BY
    DECODE( SYS.DBMS_COMPRESSION.GET_COMPRESSION_TYPE(USER, UPPER('&1'), ROWID),
      1, 'No Compression',
      2, 'Basic/OLTP Compression', 
      4, 'HCC Query High',
      8, 'HCC Query Low',
      16, 'HCC Archive High',
      32, 'HCC Archive Low',
      64, 'COMP_BLOCK ZFS?',
      'Unknown Compression Level'
    )
/

