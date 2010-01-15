prompt specify user name which you want to create;
define user_name = &user_name
prompt specify user's passord which you want to create;
define user_passwd = &user_passwd

set echo off
set pagesize 0
set head off
set feed off
set verify off

col spool_file_name new_value spool_file_name format a100
select 'create_user_'||lower('&&user_name')||'.sql' spool_file_name from dual;
spool &spool_file_name

select '-- drop user.' from dual;
select '--DROP USER '||upper('&&user_name') ||' CASCADE;' from dual;
select '' from dual;

select '-- create user.' from dual;
select 'CREATE USER '|| upper('&&user_name') || CHR(10) ||
                'IDENTIFIED BY &&user_passwd '|| CHR(10) ||
                DECODE(DEFAULT_TABLESPACE, NULL, '', 'DEFAULT TABLESPACE '||DEFAULT_TABLESPACE||CHR(10)) ||
                DECODE(TEMPORARY_TABLESPACE, NULL, '', 'TEMPORARY TABLESPACE '||TEMPORARY_TABLESPACE||CHR(10)) ||
                DECODE(ACCOUNT_STATUS, 'OPEN', 'ACCOUNT UNLOCK', 'ACCOUNT LOCK') || CHR(10) ||
                DECODE(PROFILE, NULL, '', 'PROFILE '||PROFILE||CHR(10)) || ';'
        from dba_users where username = upper('&&user_name');
select '' from dual;

select '-- quota.' from dual;
select 'ALTER USER '|| upper('&&user_name') ||' QUOTA '|| DECODE(MAX_BYTES, -1, 'UNLIMITED', MAX_BYTES) ||' ON '|| TABLESPACE_NAME ||';'
        from dba_ts_quotas where username = upper('&&user_name');
select '' from dual;

select '-- grant system privilege to user.' from dual;
select 'GRANT '||PRIVILEGE||' TO '|| upper('&&user_name') || DECODE(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';'
        from dba_sys_privs where grantee = upper('&&user_name');
select '' from dual;

select '--grant object privilege to user.' from dual;
select 'GRANT '||PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME||' TO '|| upper('&&user_name') || DECODE(GRANTABLE,'YES',' WITH GRANT OPTION','')||';'
        from dba_tab_privs where grantee = upper('&&user_name');
select '' from dual;

select '--grant role to user.' from dual;
select 'GRANT '||GRANTED_ROLE||' TO '|| upper('&&user_name') || DECODE(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION', '')||';'
        from DBA_ROLE_PRIVS where GRANTEE = upper('&&user_name');
select '' from dual;

spool off
exit