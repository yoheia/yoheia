set arraysize 500
set pagesize 50000
set linesize 32767
set trimout on
set trimspool on
set termout off
set feedback off
set colsep '|'

alter session set NLS_DATE_FORMAT='YYYY-MM-DD HH24MISS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24MISS';

col spool_file_name new_value spool_file_name for a100
select 'user_part_col_statistics_'||to_char(sysdate,'YYYYMMDD-HH24MISS') ||'.csv' spool_file_name from dual;
spool &spool_file_name

select * from user_part_col_statistics;

spool off

