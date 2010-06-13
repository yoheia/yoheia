DEFINE user_name = &user_name

set echo off
set verify off
set feed off
set pagesize 50000
set linesize 200
col grantee for a30
col privilege for a30
col owner for a10
col table_name for a30
col grantable for a10

set head off
select CHR(10)||'--User' from dual;
set head on
select default_tablespace, temporary_tablespace, account_status, profile
	from dba_users
	where username = upper('&&user_name');

set head off
select CHR(10)||'--Quotas' from dual;
set head on
select tablespace_name, decode(max_bytes, -1, 'UNLIMITED', max_bytes) quota 
	from dba_ts_quotas 
	where username = upper('&&user_name')
	order by tablespace_name;

set head off
select CHR(10)||'--System privilege' from dual;
set head on
select privilege, admin_option 
	from dba_sys_privs 
	where grantee = upper('&&user_name')
	order by privilege;

set head off
select CHR(10)||'--Object privilege' from dual;
set head on
select grantee, privilege, owner, table_name, grantable 
	from dba_tab_privs 
	where grantee = upper('&&user_name')
	order by grantee, privilege, owner, table_name;

set head off
select CHR(10)||'--Role' from dual;
set head on
select grantee, granted_role, admin_option 
	from dba_role_privs 
	where grantee = upper('&&user_name')
	order by grantee, granted_role;

