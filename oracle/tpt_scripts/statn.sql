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

select 
	n.statistic# stat#,
	trim(to_char(s.statistic#, 'XXXX')) hex#,
	n.statistic# * 8 offset,
	n.name, 
	s.value
from v$mystat s, v$statname n
where s.statistic#=n.statistic#
and (
    lower(n.name) like lower('%&1%') 
or  lower(to_char(s.statistic#)) like lower('&1')
or  lower(trim(to_char(s.statistic#, 'XXXX'))) like lower('&1')
or  to_char(n.statistic# * 8) like '%&1%'
)
/



