define owner_name = &owner_name
define object_type = &object_type

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
select 'create_'||lower('&&object_type')||'_'||lower('&&owner_name')||'.sql' spool_file_name from dual;
spool &spool_file_name

select dbms_lob.substr(dbms_metadata.get_ddl(upper('&&object_type'), object_name, owner),3999,1)||'/'
		from all_objects
	where owner = upper('&&owner_name') 
		and object_type = upper('&&object_type');

spool off
exit