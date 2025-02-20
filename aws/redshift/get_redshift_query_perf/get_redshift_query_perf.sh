#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

PG_HOST=${PG_HOST:-redshift-cluster-poc-central.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
SQL_SCRIPT_QUERY_PERF=${SQL_SCRIPT_QUERY_PERF:-get_redshift_query_perf.sql}
LOG_DIR=${LOG_DIR:-log}
QUERY_ID=${QUERY_ID}

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

psql "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -a -f ${SQL_SCRIPT_QUERY_PERF} -v query_id=${QUERY_ID} \
       >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${QUERY_ID}.log" 2>&1

