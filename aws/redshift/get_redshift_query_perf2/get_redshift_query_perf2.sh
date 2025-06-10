#!/usr/bin/env bash

export LC_ALL=C
BASE_NAME=$(basename $0)
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y%m%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

PG_HOST=${PG_HOST:-rs-ra3-4xl-4n.cjgngrodev0n.us-east-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
PG_FETCH_COUNT=${PG_FETCH_COUNT:-1000}
SQL_SCRIPT_QUERY_PERF=${SQL_SCRIPT_QUERY_PERF:-get_redshift_query_perf2.sql}
SQL_SCRIPT_QUERY_PERF_ALL=${SQL_SCRIPT_QUERY_PERF_ALL:-get_redshift_query_perf2_all.sql}
LOG_DIR=${LOG_DIR:-log}
CSV_DIR=${CSV_DIR:-csv}
QUERY_ID=$1

# create log directory, if not exist.
mkdir -p ${LOG_DIR} ${CSV_DIR}/${QUERY_ID} ${CSV_DIR}/all/${CURRENT_DATE}

export PAGER='less -S'

if [ -z "$1" ]; then
        psql -v FETCH_COUNT=$PG_FETCH_COUNT "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -aA -f ${SQL_SCRIPT_QUERY_PERF_ALL} -v current_date=${CURRENT_DATE}\
       >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_all.log" 2>&1
else
        psql -v FETCH_COUNT=$PG_FETCH_COUNT "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -aA -f ${SQL_SCRIPT_QUERY_PERF} -v query_id=${QUERY_ID} \
       >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${QUERY_ID}.log" 2>&1
fi
