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

COL desc_column_id 		HEAD "Col#" FOR A4
COL desc_column_name	        HEAD "Column Name" FOR A30
COL desc_data_type		HEAD "Type" FOR A20 WORD_WRAP
COL desc_nullable		HEAD "Null?" FOR A10
COL desc_owner      HEAD Owner
COL desc_table_name HEAD Table_Name

--prompt eXtended describe of &1

break on desc_owner on desc_table_name skip 1

SELECT
  owner       desc_owner,
  table_name  desc_table_name,
	CASE WHEN hidden_column = 'YES' THEN 'H' ELSE ' ' END||
	LPAD(column_id,3)	desc_column_id,
	column_name	desc_column_name,
	CASE WHEN nullable = 'N' THEN 'NOT NULL' ELSE NULL END AS desc_nullable,
	data_type||CASE 
--					WHEN data_type = 'NUMBER' THEN '('||data_precision||CASE WHEN data_scale = 0 THEN NULL ELSE ','||data_scale END||')' 
					WHEN data_type = 'NUMBER' THEN '('||data_precision||','||data_scale||')' 
					ELSE '('||data_length||')'
				END AS desc_data_type,
--	data_default,
	num_distinct,
	density,
	num_nulls,
	num_buckets,
        -- histogram,
	low_value,
	high_value
	--,'--' desc_succeeded
FROM
	dba_tab_cols
WHERE
	upper(table_name) LIKE 
				upper(CASE 
					WHEN INSTR('&1','.') > 0 THEN 
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     )
AND	owner LIKE
		CASE WHEN INSTR('&1','.') > 0 THEN
			UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
		ELSE
			user
		END
ORDER BY
  owner,
  table_name,
	column_id
/

