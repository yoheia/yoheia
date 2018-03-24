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

col segstat_statistic_name head STATISTIC_NAME for a35
col subobject_name for a20

SELECT * FROM (
  SELECT 
	owner, 
    object_name, 
    SUBOBJECT_NAME,   
	statistic_name segstat_statistic_name,
	value 
  FROM 
	v$segment_statistics 
  WHERE 
	lower(object_name) LIKE lower('&1')
  and lower(statistic_name) LIKE lower('&2')
   order by value desc
)
--WHERE rownum <= 40
/
