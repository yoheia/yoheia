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
select 'hist_sqltext_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

select a.snap_id,
	b.begin_interval_time,
	a.sql_id,
	dbms_lob.substr(c.sql_text,4000,1) sql_text
from dba_hist_sqlstat a,
	dba_hist_snapshot b,
	dba_hist_sqltext c
where a.dbid = b.dbid and
	a.instance_number = b.instance_number and
	a.snap_id = b.snap_id and
	a.dbid = c.dbid and
	a.sql_id = c.sql_id;

spool off
