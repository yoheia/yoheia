set pagesize 10000
set linesize 200
col module for a20
col sql_text for a60
col schema for a10
col exec for 99999
col min_timestamp for a20
col max_timestamp for a20

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS';

select
	a.parsing_schema_name SCHEMA,
	a.sql_id,
	min(dbms_lob.substr(b.sql_text,60,1)) SQL_TEXT,
	min(a.module) module,
	round(sum(a.elapsed_time_delta / 1000 / 1000 / 60 ), 1) "Elapsed(min)",
	sum(a.executions_delta) exec,
	round(sum(a.buffer_gets_delta * 16 / 1024 / 1024), 1) "Gets(GB)",
	round(sum(a.physical_read_bytes_delta * 16 / 1024 / 1024), 1) "Reads(GB)",
	min(c.begin_interval_time) min_timestamp,
	max(c.begin_interval_time) max_timestamp
from dba_hist_sqlstat a, 
	dba_hist_sqltext b, 
	dba_hist_snapshot c
where a.dbid = b.dbid
	and a.sql_id = b.sql_id
	and a.parsing_schema_name not in ('DBSNMP', 'SYS', 'APEX_040200')
	and a.dbid = c.dbid
	and a.snap_id = c.snap_id
	and a.instance_number = c.instance_number
group by a.parsing_schema_name, a.sql_id
order by 5 desc
/

