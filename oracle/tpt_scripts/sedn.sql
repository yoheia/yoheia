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

col sed_name head EVENT_NAME for a45
col sed_p1 head PARAMETER1 for a30
col sed_p2 head PARAMETER2 for a30
col sed_p3 head PARAMETER3 for a30
col sed_event# head EVENT# for 99999

select 
	event# sed_event#, 
	name sed_name, 
	parameter1 sed_p1, 
	parameter2 sed_p2, 
	parameter3 sed_p3 
from 
	v$event_name 
where 
	event# in (&1)
order by 
	sed_name
/
