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

col sql_sql_text head SQL_TEXT format a110 word_wrap
col sql_child_number head CH# for 9999

prompt Show SQL text, child cursors and execution stats for SQL hash value &1 child &2

select 
	hash_value,
	child_number	sql_child_number,
        plan_hash_value plan_hash,
	sql_text sql_sql_text
from 
	v$sql 
where 
	hash_value in (&1);

select 
	child_number	sql_child_number,
	address		parent_handle,
	child_address   object_handle,
	parse_calls parses,
	loads h_parses,
	executions,
	fetches,
	rows_processed,
	buffer_gets LIOS,
	disk_reads PIOS,
	sorts, 
--	address,
	cpu_time/1000 cpu_ms,
	elapsed_time/1000 ela_ms,
--	sharable_mem,
--	persistent_mem,
--	runtime_mem,
	users_executing
from 
	v$sql 
where 
	hash_value in (&1);
