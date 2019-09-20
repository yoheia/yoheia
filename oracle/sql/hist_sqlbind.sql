set pagesize 50000
set linesize 32767
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '%'

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS';

col spool_file_name new_value spool_file_name for a100
select 'dba_hist_sqlbind_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

select
	a.sql_id,
	b.begin_interval_time,
	a.name,
	a.value_string
from
	dba_hist_sqlbind a,
	dba_hist_snapshot b
where
	a.sql_id in ('xxx', 'yyy ) -- Your SQL ID here
	and a.was_captured='YES'
	and a.snap_id=b.snap_id
	and a.dbid=b.dbid
	and a.instance_number=b.instance_number
order by
	a.sql_id,
	a.snap_id,
	a.name;

spool off