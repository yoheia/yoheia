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

column d_table_name heading TABLE_NAME format a30 
column d_comments heading COMMENTS format a80 word_wrap
break on d_table_name

prompt Show data dictionary views and x$ tables matching the expression "&1"...

select d.table_name d_table_name, d.comments d_comments
	from dict d
	where upper(d.table_name) like upper('%&1%')
union all
select t.table_name d_table_name, 'BASE TABLE' d_comments
	from dba_tables t
	where t.owner = 'SYS'
	and upper(t.table_name) like upper('%&1%')
/
select ft.name d_table_name, (select fvd.view_name 
			from v$fixed_view_definition fvd 
			where instr(upper(fvd.view_definition),upper(ft.name)) > 0
			and rownum = 1) used_in
	from v$fixed_table ft
	where ft.type in ('TABLE', 'VIEW')
	and replace(upper(ft.name),'V_$','V$') like upper('%&1%')
/

