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

col long_opname head OPNAME for a40
col long_target head TARGET for a40
col long_units  head UNITS  for a10

prompt Show session long operations from v$session_longops for sid &1

select 
	sid, 
	serial#, 
	opname long_opname, 
	target long_target, 
	sofar, 
	totalwork, 
	units long_units, 
	time_remaining, 
	start_time, 
	elapsed_seconds 
/*, target_desc, last_update_time, username, sql_address, sql_hash_value */ 
from 
	v$session_longops
where
	sid in (select sid from v$session where &1)
and sofar != totalwork
/


