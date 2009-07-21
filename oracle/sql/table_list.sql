--$Id:$
set echo off
set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off

col spool_file_name new_value spool_file_name format a100
select 'table_list_'||to_char(sysdate,'YYYYMMDDHH24MISS') || '.csv' spool_file_name from dual;


spool &spool_file_name

select 'owner,table_name' header from dual;
select owner||','||table_name from dba_tables;

spool off

exit
