#!/bin/bash
export LANG=C
export NLS_LANG=American_America.JA16SJISTILDE
BASE_DIR=$(cd $(dirname $0);pwd)
CURR_TS=`date '+%Y%m%d%H%M%S'`

ORA_USER=system
ORA_PASS=manager
ORA_SCHEMA=orcl
DMP_FILE=exp_${ORACLE_SID}_${CURR_TS}.dmp
LOG_FILE=exp_${ORACLE_SID}_${CURR_TS}.log

cd ${BASE_DIR}
nohup exp ${ORA_USER}/${ORA_PASS} owner=${ORA_SCHEMA} consistent=y direct=y recordlength=65536 file=${DMP_FILE} > ${LOG_FILE} 2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%S'`] Exporting ${ORA_SCHEMA} schema to ${BASE_DIR}/${DMP_FILE} ..."
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Please check ${BASE_DIR}/${LOG_FILE} for more details."
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Exp proccess -> `ps -f|egrep \" [e]xp \"`"

exit
