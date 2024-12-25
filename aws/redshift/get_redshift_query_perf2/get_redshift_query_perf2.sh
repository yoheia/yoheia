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
SQL_SCRIPT_QUERY_PERF=${SQL_SCRIPT_QUERY_PERF:-get_redshift_query_perf2.sql}
LOG_DIR=${LOG_DIR:-log}
CSV_DIR=${CSV_DIR:-csv}
QUERY_ID=$1

# exit if query id is not passed
if [ -z "${QUERY_ID}" ]; then
        echo "usage: ${BASE_NAME} [query id]"
        echo "example: ${BASE_NAME} 5065383"
        exit 1
fi

# create log directory, if not exist.
mkdir -p ${LOG_DIR} ${CSV_DIR}/${QUERY_ID}

export PAGER='less -S'
psql "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -aA -f ${SQL_SCRIPT_QUERY_PERF} -v query_id=${QUERY_ID} \
       >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${QUERY_ID}.log" 2>&1

