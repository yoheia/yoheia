set pagesize 50000
set linesize 5000
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '|'

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS';

col spool_file_name new_value spool_file_name for a100
select 'dash_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

SELECT * FROM DBA_HIST_ACTIVE_SESS_HISTORY
        WHERE SAMPLE_TIME BETWEEN TO_TIMESTAMP('2016-11-30 9:00:00', 'YYYY/MM/DD HH24:MI:SS')
        AND TO_TIMESTAMP('2016-11-30 10:00:00', 'YYYY/MM/DD HH24:MI:SS');

spool off
