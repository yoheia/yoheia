set pagesize 10000
set linesize 300
col text for a80
col parsing_schema_name for a20

select * from (
	select
		a.parsing_schema_name,
		a.sql_id,
		sum(a.plsexec_time_total) plsql_time,
		dbms_lob.substr(b.sql_text,80,1) text
	from dba_hist_sqlstat a, dba_hist_sqltext b
	where a.sql_id = b.sql_id
		and a.parsing_schema_name not in ('DBSNMP', 'SYS', 'APEX_040200')
	group by a.parsing_schema_name, a.sql_id, dbms_lob.substr(b.sql_text,80,1)
	order by plsql_time desc)
where rownum <= 50;
