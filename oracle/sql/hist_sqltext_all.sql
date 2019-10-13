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
select 'hist_sqltext_all_'|| to_char(sysdate,'YYYY-MM-DD_HH24MISS') || '.csv' spool_file_name from dual;
spool &spool_file_name

select command_type, sql_id, dbms_lob.substr(sql_text,4000,1) sql_text from dba_hist_sqltext where dbid = 3144341035;

spool off

