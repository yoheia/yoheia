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

.
-- 10g2+

prompt Display execution plan for last statement for this session from library cache...

-- select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST +COST +PEEKED_BINDS'));

-- this is 10gR1 command (or @x101.sql)
--
-- select * from table(dbms_xplan.display_cursor(null,null,'RUNSTATS_LAST'));

-- in 9.2 use @xm <hash_value> <child_number> 
-- <child_number> can be % if you want all children

def _x_temp_env=&_tpt_tempdir/env_&_tpt_tempfile..sql
def _x_temp_sql=&_tpt_tempdir/sql_&_tpt_tempfile..sql

set termout off
store set &_x_temp_env replace
save      &_x_temp_sql replace
set termout on

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST +PEEKED_BINDS +PARALLEL +PARTITION +COST +BYTES'))
where
    plan_table_output not in ('-----', 'Note')
and plan_table_output not like ('%- Warning: basic plan statistics not available. These are only collected when:%')
and plan_table_output not like ('%* hint _gather_plan_statistics_ is used for the statement or%')
and plan_table_output not like ('%* parameter _statistics_level_ is set to _ALL_, at session or system level%');

set termout off
@/&_x_temp_env
get &_x_temp_sql
set termout on 
