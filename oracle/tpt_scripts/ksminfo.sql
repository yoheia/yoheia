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
    "AREA NAME"                               -- VARCHAR2(32)
  , "NUMAPG"                                  -- NUMBER
  , "PAGESIZE" / 1024 mempage_kb                 -- NUMBER
  , ROUND("SEGMENT SIZE" / 1048576) segsize_mb -- NUMBER
  , ROUND("SIZE" / 1048576) area_size_mb            -- NUMBER
  , ROUND("REMAINING ALLOC SIZE" / 1048576) remain_mb                   -- NUMBER
  , "SHMID"                                   -- NUMBER
  , "SEGMENT DISTRIBUTED"                     -- VARCHAR2(20)
  , "AREA FLAGS"                              -- NUMBER
  , "SEGMENT DEFERRED"                        -- VARCHAR2(20)
  , "SEG_START ADDR"                          -- RAW(8)
  , "START ADDR"                              -- RAW(8)
FROM
    x$ksmssinfo
/

