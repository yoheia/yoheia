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

COL mys_value HEAD VALUE FOR 9999999999999999999

prompt Show current session's statistics from V$SESSTAT....

select 
	n.statistic# stat#,
	n.statistic# * 8 offset,
	n.name, 
	s.value mys_value,
  TRIM(
      CASE WHEN BITAND(class,  1) =   1 THEN 'USER  ' END ||
      CASE WHEN BITAND(class,  2) =   2 THEN 'REDO  ' END ||
      CASE WHEN BITAND(class,  4) =   4 THEN 'ENQ   ' END ||
      CASE WHEN BITAND(class,  8) =   8 THEN 'CACHE ' END ||
      CASE WHEN BITAND(class, 16) =  16 THEN 'OSDEP ' END ||
      CASE WHEN BITAND(class, 32) =  32 THEN 'PX    ' END ||
      CASE WHEN BITAND(class, 64) =  64 THEN 'SQLT  ' END ||
      CASE WHEN BITAND(class,128) = 128 THEN 'DEBUG ' END
   ) class_name
from v$mystat s, v$statname n
where s.statistic#=n.statistic#
and lower(n.name) like lower('%&1%')
/

