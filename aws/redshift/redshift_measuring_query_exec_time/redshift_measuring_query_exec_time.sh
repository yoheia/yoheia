#!/usr/bin/bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

PG_HOST=${PG_HOST:-redshift-cluster-2.********.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
SQL_SCRIPT=${SQL_SCRIPT:-redshift_measuring_query_exec_time.sql}
LOG_DIR=${LOG_DIR:-log}

INSTANCE_IDENTIFIER=${PG_HOST#.*}

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

aws redshift describe-clusters ${INSTANCE_IDENTIFIER}

psql "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -a -f $SQL_SCRIPT \
	> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1