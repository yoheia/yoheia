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
select 'dba_hist_seg_stat_'||to_char(sysdate,'YYYYMMDD-HH24MISS') ||'.csv' spool_file_name from dual;
spool &spool_file_name

select c.begin_interval_time, c.end_interval_time, a.*, b.*
	from dba_hist_seg_stat a, 
		dba_hist_seg_stat_obj b, 
		dba_hist_snapshot c
	where a.dbid = c.dbid
		and a.instance_number = c.instance_number
		and a.snap_id = c.snap_id
		and a.dbid = b.dbid
		and a.ts# = b.ts#
		and a.obj# = b.obj#
		and owner = 'SCOTT'
		and object_name = 'EMP';

spool off