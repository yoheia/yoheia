#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y%m%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

SQL_DIR=${SQL_DIR:-sql}
CSV_DIR=${CSV_DIR:-csv}
LOG_DIR=${LOG_DIR:-log}

PG_HOST=${PG_HOST:-rs-ra3-4xl-4n.cjgngrodev0n.us-east-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-tpch_3tb}
PG_PORT=${PG_PORT:-5439}

mkdir -p ${CSV_DIR} ${LOG_DIR}

echo `date '+%Y-%m-%d-%H:%M:%S'` > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

find ${SQL_DIR} -type f -name '*.sql'|while read LINE
do
	FILE_STEM=`basename ${LINE%.*}`
	psql -aA "host=${PG_HOST} user=${PG_USER} dbname=${PG_DB} port=${PG_PORT}" -f ${LINE} -o ${CSV_DIR}/${FILE_STEM}_${CURRENT_DATE}.csv
done | tee -a "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

echo "finishied!"