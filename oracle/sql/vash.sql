set pagesize 50000
set linesize 2000
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '|'

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';

col spool_file_name new_value spool_file_name for a100
select 'vash_'|| to_char(sysdate,'YYYYMMDD-HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

select * from v$active_session_history order by sample_id;

spool off

