prompt specify user name which you want to create;
define grantee = &grantee
prompt specify user name whom you want to copy privallege from;
define from_user_name = &from_user_name

set echo off
set pagesize 0
set head off
set feed off
set verify off

col spool_file_name new_value spool_file_name format a100
select 'grant_privilege_to_'||lower('&&grantee')||'.sql' spool_file_name from dual;
spool &spool_file_name

select '-- grant system privilege to user.' from dual;
select 'GRANT '||PRIVILEGE||' TO '|| upper('&&grantee') || DECODE(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';'
        from dba_sys_privs where grantee = upper('&&from_user_name');
select '' from dual;

select '--grant object privilege to user.' from dual;
select 'GRANT '||PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME||' TO '|| upper('&&grantee') || DECODE(GRANTABLE,'YES',' WITH GRANT OPTION','')||';'
        from dba_tab_privs where grantee = upper('&&from_user_name');
select '' from dual;

select '--grant role to user.' from dual;
select 'GRANT '||GRANTED_ROLE||' TO '|| upper('&&grantee') || DECODE(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION', '')||';'
        from DBA_ROLE_PRIVS where GRANTEE = upper('&&from_user_name');
select '' from dual;

select 'exit' from dual;

spool off
exit
