/*
$Id:$

example: 

$ sqlplus scott/tiger @getcol.sql
Enter value for table_name: emp
$ perl -i -ne 'if(/,$/){s/\n//;print;}' emp.txt

*/
set echo off
set heading off
set feedback off
set pagesize 0
set trimout on
set trimspool on

col spool_file_name new_value spool_file_name for a100
select '&&table_name'||'.txt' spool_file_name from dual;

spool &spool_file_name
select column_name||',' from user_tab_columns where table_name = upper('&&table_name') order by column_id;
spool off
exit
