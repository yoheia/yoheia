define owner_name = &owner_name
define table_name = &table_name

set echo off
set termout off
set pagesize 0
set head off
set feed off
set verify off
set linesize 10000
set trimout on
set trimspool on

col spool_file_name new_value spool_file_name format a100
select 'create_'||lower('&&owner_name')||'_'||lower('&&table_name')||'.sql' spool_file_name from dual;
spool &spool_file_name

select dbms_lob.substr(dbms_metadata.get_ddl('TABLE', upper('&&table_name'), upper('&&owner_name')),3999,1)||'/'
		from dual;

select dbms_lob.substr(dbms_metadata.get_ddl('INDEX', index_name, owner),3999,1)||'/'
		from all_indexes 
		where table_owner =  upper('&&owner_name')
			and table_name = upper('&&table_name');

spool off
exit
