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

column cons_column_name heading COLUMN_NAME format a30
column R_CONSTRAINT_NAME for a30
column CONSTRAINT_NAME for a30

select
	co.owner,
	co.table_name,
	co.constraint_name,
	co.constraint_type,
	cc.column_name		cons_column_name,
	cc.position
from
	dba_constraints co,
	dba_cons_columns cc
where
	co.owner		= cc.owner
and	co.table_name		= cc.table_name
and	co.constraint_name	= cc.constraint_name
and	lower(co.table_name) 	like lower('&1')
order by
	owner,
	table_name,
	constraint_type,
	column_name,
	constraint_name,
	position
/

