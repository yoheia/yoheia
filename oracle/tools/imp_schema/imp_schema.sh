#!/bin/bash
export LANG=C
export NLS_LANG=American_America.JA16SJISTILDE
BASE_DIR=$(cd $(dirname $0);pwd)
BASE_NAME=$(basename $0)

cd ${BASE_DIR}
test "$1" || { echo "Usage: ${BASE_NAME} dump_file"; exit 1; }
test -r "$1" || { echo "Can't read specified dump file: $1"; exit 1; } ; DMP_FILE=$1
test -d log || mkdir log

IMP_USER=system
IMP_PASS=manager

FROM_USER=scott
TO_USER=scott
TO_USER_PASS=tiger

TS=`date '+%Y%m%d-%H%M%S'`
CREATE_USER_SCRIPT="log/create_user_${TO_USER}_${TS}.sql"
LOG_FILE="log/${BASE_NAME%%.*}_${TS}.log"


# generate the sql script which drop and create specified user
${ORACLE_HOME}/bin/sqlplus -s / as sysdba @gen_create_user_script.sql ${TO_USER} ${TO_USER_PASS} ${CREATE_USER_SCRIPT} \
	|| { echo 'Failed to create a sql script.' ; exit 1; }

# drop and create specified user
${ORACLE_HOME}/bin/sqlplus -s / as sysdba @${CREATE_USER_SCRIPT} \
	|| { echo "Failed to execute ${CREATE_USER_SCRIPT}." ; exit 1; }

# import dump
nohup imp ${IMP_USER}/${IMP_PASS} fromuser=${FROM_USER} touser=${TO_USER} \
	buffer=51380224 commit=y ignore=y file=${DMP_FILE} > ${LOG_FILE} 2>&1 \
	|| { echo "Failed to import ${DMP_FILE} to ${TO_USER} schema." ; exit 1; } &

# show info
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Importing ${DMP_FILE} to ${TO_USER} schema ..."
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Please check ${LOG_FILE} for more details."
sleep 1
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Import proccess -> `ps -f|egrep \"[i]mp \"`"


exit 0
