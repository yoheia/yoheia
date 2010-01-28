#!/bin/bash
export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)

IVAL=5
DURATION=12
LOG_DIR=${BASE_DIR}/log

if [ ! -d ${LOG_DIR} ]
	then mkdir ${LOG_DIR} || { echo "can't create ${LOG_DIR}."; exit 1;  }
fi

DATE=`date '+%Y-%m-%d-%H%M%S'`

# vmstat
vmstat ${IVAL} ${DURATION} > ${LOG_DIR}/${HOSTNAME}-vmstat-${DATE}.log  2>&1 &

# top -n <number of output lines> -n <count> -d <interval>
top -bc -n ${DURATION} -d ${IVAL} > ${LOG_DIR}/${HOSTNAME}-top-${DATE}.log 2>&1 &

# iostat
iostat -mtx ${IVAL} ${DURATION} > ${LOG_DIR}/${HOSTNAME}-iostat-${DATE}.log 2>&1 &

# sar -n
sar -n DEV ${IVAL} ${DURATION} > ${LOG_DIR}/${HOSTNAME}-sar-n-${DATE}.log 2>&1 &

# delete expired files
if [ "${BASE_DIR}/${LOG_DIR}" ]; then
        find "${BASE_DIR}/${LOG_DIR}" -name '*.log' -mtime +14 -exec rm -f {} \;
fi

exit 0
