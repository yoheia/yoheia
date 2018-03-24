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

col source_owner for a20
col source_name for a25
col source_line head LINE# for 999999
col source_text for a100
col source_type noprint

break on type skip 1

select 
	owner	source_owner,
	type 	source_type,
	name	source_name,
	line	source_line, 
	text	source_text
from 
	dba_source
where 
	lower(owner) like lower('%&1%')
and	lower(name) like lower('%&2%')
and	lower(text) like lower('%&3%')
order by
	source_type,
	line
;
