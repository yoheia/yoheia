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
   o1.NAME,
   s.fts_statnam,
   s.fts_staval,
   s.fts_preval
FROM 
    x$ksolsfts s,
    OBJ$ o1,
    OBJ$ o2
WHERE 
    s.fts_objd = o1.dataobj#
AND s.fts_objd = o2.obj#
AND fts_statnam IN (
      SELECT st_name FROM x$ksolsstat WHERE BITAND(st_flag, 2) = 2
) 
AND (s.fts_staval != 0 OR  s.fts_preval != 0)
/
