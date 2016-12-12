set pagesize 50000
set linesize 32767
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '|'

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS';

col spool_file_name new_value spool_file_name for a100
select 'dba_hist_sqlstat_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

select b.begin_interval_time, b.end_interval_time, a.* 
	from dba_hist_sqlstat a, dba_hist_snapshot b
	where a.dbid = b.dbid and
		a.instance_number = b.instance_number and
		a.snap_id = b.snap_id and
		b.begin_interval_time between
			to_timestamp('2016-11-23 00:00:00', 'YYYY-MM-DD HH24:MI:SS') and
			to_timestamp('2016-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS');

spool off