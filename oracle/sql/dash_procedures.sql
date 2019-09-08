set pagesize 10000
set linesize 300
col owner for a10
col object_name for a40
col procedure_name for a40
col object_type for a20

select distinct b.owner, b.object_name, b.procedure_name, b.object_type
from dba_hist_active_sess_history a, dba_procedures b
where a.plsql_entry_object_id = b.object_id
and a.plsql_entry_subprogram_id = b.subprogram_id;