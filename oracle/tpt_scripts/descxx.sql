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

-- descxx.sql requires the display_raw function which is included in the comment section below.
-- the display_raw function is taken from Greg Rahn's blog as I'm too lazy to write one myself
--     http://structureddata.org/2007/10/16/how-to-display-high_valuelow_value-columns-from-user_tab_col_statistics/
--
--create or replace function display_raw (rawval raw, type varchar2)
--return varchar2
--is
--   cn     number;
--   cv     varchar2(128);
--   cd     date;
--   cnv    nvarchar2(128);
--   cr     rowid;
--   cc     char(128);
--begin
--   if (type = 'NUMBER') then
--      dbms_stats.convert_raw_value(rawval, cn);
--      return to_char(cn);
--   elsif (type = 'VARCHAR2') then
--      dbms_stats.convert_raw_value(rawval, cv);
--      return to_char(cv);
--   elsif (type = 'DATE') then
--      dbms_stats.convert_raw_value(rawval, cd);
--      return to_char(cd);
--   elsif (type = 'NVARCHAR2') then
--      dbms_stats.convert_raw_value(rawval, cnv);
--      return to_char(cnv);
--   elsif (type = 'ROWID') then
--      dbms_stats.convert_raw_value(rawval, cr);
--      return to_char(cnv);
--   elsif (type = 'CHAR') then
--      dbms_stats.convert_raw_value(rawval, cc);
--      return to_char(cc);
--   else
--      return 'UNKNOWN DATATYPE';
--   end if;
--end;
--/
--
-- grant execute on display_raw to public;
-- create public synonym display_raw for display_raw;



COL desc_column_id 		HEAD "Col#" FOR A4
COL desc_column_name	        HEAD "Column Name" FOR A30
COL desc_data_type		HEAD "Type" FOR A25 WORD_WRAP
COL desc_nullable		HEAD "Null?" FOR A10
COL desc_low_value HEAD "Low Value" FOR A32
COL desc_high_value HEAD "High Value" FOR A32
COL desc_density        HEAD "Density" FOR 9.99999999999


-- prompt eXtended describe of &1

SELECT
--  table_name,
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
	density            desc_density,
	num_nulls,
    CASE WHEN histogram = 'NONE'  THEN null ELSE histogram END histogram,
	num_buckets,
	display_raw(low_value, data_type)   desc_low_value,
	display_raw(high_value, data_type)  desc_high_value
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
	column_id ASC
/

