-- need to calculate delta from total redo size

set arraysize 500
set pagesize 50000
set linesize 32767
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '%'

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24MISS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24MISS';

col spool_file_name new_value spool_file_name for a100
select 'dba_hist_sysstat_redosize_'||to_char(sysdate,'YYYYMMDD-HH24MISS') ||'.csv' spool_file_name from dual;
spool &spool_file_name

select a.snap_id,
	b.begin_interval_time,
	b.end_interval_time,
	b.instance_number,
	a.stat_name,
	a.value
from dba_hist_sysstat a, dba_hist_snapshot b
	where a.stat_name = 'redo size' and
		a.dbid = b.dbid and
		a.instance_number = b.instance_number and
		a.snap_id = b.snap_id and
		b.begin_interval_time between
			to_timestamp('2018-03-09 15:00:00', 'yyyy-mm-dd hh24:mi:ss') and
			to_timestamp('2018-03-09 19:00:00', 'yyyy-mm-dd hh24:mi:ss')
order by a.snap_id;

spool off