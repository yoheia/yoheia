break on object_name on procedure_name on object_type skip page
set pagesize 1000
set linesize 300
col owner for a10
col object_name for a20
col procedure_name for a20
col object_type for a20
select 
	b.owner
	, b.object_name
	, a.session_id
	, a.session_serial#
	, b.procedure_name 
	, b.object_type
	, sum(a.TM_DELTA_TIME) as "TIME SPENT(ms)"
from 
	dba_hist_active_sess_history a
	, dba_procedures b
where 
	a.plsql_entry_object_id = b.object_id
	and a.plsql_entry_subprogram_id = b.subprogram_id
group by
	a.session_id
	,a.session_serial#
	,b.owner
	,b.object_name
	,b.procedure_name
	,b.object_type
order by
	b.owner
	, b.object_name
	,b.procedure_name
	,b.object_type
	,6 desc
/
