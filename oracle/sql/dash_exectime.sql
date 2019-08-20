set pagesize 50000
set linesize 5000
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '%'

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS';

col spool_file_name new_value spool_file_name for a100
select 'dash-exectime_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

SELECT sql_id, sql_exec_id, trim(sql_exec_start) start_time, trim(max(sample_time)) end_time, trim(max(sample_time)-sql_exec_start) delta_time  FROM DBA_HIST_ACTIVE_SESS_HISTORY
	WHERE sql_exec_start is not null
	GROUP BY sql_id, sql_exec_id, sql_exec_start
	ORDER BY delta_time DESC;

spool off
