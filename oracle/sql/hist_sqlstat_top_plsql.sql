set pagesize 10000
set linesize 150
col text for a60
col parsing_schema_name for a20
col min_timestamp for a20
col max_timestamp for a20

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS';

select * from (
	select
		a.parsing_schema_name,
		a.sql_id,
		sum(a.plsexec_time_total) plsql_time,
		dbms_lob.substr(b.sql_text,60,1) text,
		min(c.BEGIN_INTERVAL_TIME) min_timestamp,
		max(c.BEGIN_INTERVAL_TIME) max_timestamp
	from dba_hist_sqlstat a, dba_hist_sqltext b, dba_hist_snapshot c
	where a.dbid = b.dbid
		and a.sql_id = b.sql_id
		and a.parsing_schema_name not in ('DBSNMP', 'SYS', 'APEX_040200')
		and a.dbid = c.dbid
		and a.snap_id = c.snap_id
		and a.instance_number = c.instance_number
	group by a.parsing_schema_name, a.sql_id, dbms_lob.substr(b.sql_text,60,1)
	order by plsql_time desc)
where rownum <= 50;
