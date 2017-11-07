#!/bin/bash
export LANG=C

HOST=$1
DB=$2
USER=$3
PASSWORD=$4

DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_NAME=$(basename $0)
STEM="${BASE_NAME%.*}"
LOG_DIR=log

mkdir -p ${LOG_DIR}

echo "[`date '+%Y-%m-%d %H:%M:%S'`] Starting ${BASE_NAME}"|tee -a ${LOG_DIR}/${STEM}_${DATE}.out
pgbench -V|tee -a ${LOG_DIR}/${STEM}_${DATE}.out

expect -c "
set timeout 20
spawn bash -c \"pgbench -r -c 10 -j 10 -t 10000 -U ${USER} -h ${HOST} -d ${DB} 2>${LOG_DIR}/${STEM}_${DATE}.err\"
expect \"Password: \"
send \"${PASSWORD}\n\"
interact"|tee -a ${LOG_DIR}/${STEM}_${DATE}.out

echo "[`date '+%Y-%m-%d %H:%M:%S'`] ${BASE_NAME} finished!"|tee -a ${LOG_DIR}/${STEM}_${DATE}.out

exit 0
