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

column col_owner head OWNER for a20
column col_table_name head TABLE_NAME for a30
column col_column_name head COLUMN_NAME for a30
column col_data_type head DATA_TYPE for a20

break on col_owner skip 1 on table_name

select 
	owner			col_owner,
	table_name		col_table_name,
	column_name		col_column_name,
	data_type		col_data_type,
	nullable,
	num_distinct,
	low_value,
	high_value,
	density,
	num_nulls,
	num_buckets
from
	dba_tab_columns
where
	lower(column_name) like lower('%&1%')
order by
	col_owner,
	col_table_name,
	col_column_name
/
