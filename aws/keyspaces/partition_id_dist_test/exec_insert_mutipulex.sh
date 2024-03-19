#!/usr/bin/env bash
export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y%m%d-%H%M%S'`
LOG_DIR=${LOG_DIR:-log}

BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

mkdir -p ${LOG_DIR}

echo "${SCRIPT_BASE_NAME} started:" `date '+%Y-%m-%d-%H:%M:%S'` > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

find cqls/ -maxdepth 1 -type f -name 'ks_insert_*'|while read LINE
do
	for i in {01..35}
   	do
		LINE_BASE_NAME=$(basename ${LINE})
		echo "`date '+%Y-%m-%d-%H:%M:%S'`: ${SCRIPT_BASE_NAME} ${LINE_BASE_NAME} ${i}" >>"${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1
        	cqlsh cassandra.ap-northeast-1.amazonaws.com 9142 --ssl -f  cqls/base_insert.cql > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${LINE_BASE_NAME}_${i}_${CURRENT_DATE}.log" 2>&1 &
	done 
done

wait
echo "${SCRIPT_BASE_NAME} finished:" `date '+%Y-%m-%d-%H:%M:%S'` >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1
