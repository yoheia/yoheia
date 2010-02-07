#!/bin/bash
export LANG=C
export NLS_LANG=American_America.JA16SJISTILDE
BASE_DIR=$(cd $(dirname $0);pwd)
BASE_NAME=$(basename $0)

if [ "$1" ]; then
	echo "usage: ${BASE_NAME} dump_file"
	exit 1
fi

CURR_TS=`date '+%Y%m%d%H%M%S'`
ORA_USER=system
ORA_PASS=manager
FROM_USER=scott
TO_USER=scott
DMP_FILE=
LOG_FILE=

sqlplus / as sysdba <<EOF
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
nohup imp ${ORA_USER}/${ORA_PASS} fromuser=${FROM_USER} touser=${TO_USER} buffer=51380224 commit=y ignore=y file=${DMP_FILE} log=${LOG_FILE} 2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%S'`] Exporting ${ORA_SCHEMA} schema to ${BASE_DIR}/${DMP_FILE} ..."
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Please check ${BASE_DIR}/${LOG_FILE} for more details."
sleep 1
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Exp proccess -> `ps -f|egrep \" [e]xp \"`"

exit
