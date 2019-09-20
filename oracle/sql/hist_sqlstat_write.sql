set pagesize 10000
set linesize 200
col sql_id for a13
col sql_text for a60
col program for a40
col module for a20
col user for a10
col min_begin_interval_time for a23
col max_begin_interval_time for a23

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS';

select a.sql_id,
	min(dbms_lob.substr(c.sql_text,60,1)) sql_text,
	sum(a.buffer_gets_delta) gets,
	round(sum(a.physical_write_bytes_delta) / 1024 / 1024, 1) "WRITE(MB)",
	sum(a.executions_delta) exec,
	min(b.begin_interval_time) min_begin_interval_time, 
	max(b.begin_interval_time) max_begin_interval_time 
from dba_hist_sqlstat a, dba_hist_snapshot b, dba_hist_sqltext c
where a.dbid = b.dbid and
	a.instance_number = b.instance_number and
	a.snap_id = b.snap_id and
	a.dbid = c.dbid and
	a.sql_id = c.sql_id and
	b.begin_interval_time between
		to_timestamp('2019-08-01 21:00:00', 'YYYY-MM-DD HH24:MI:SS') and
		to_timestamp('2019-08-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
	and a.physical_WRITE_bytes_delta > 0
group by a.sql_id
order by 4 desc;
