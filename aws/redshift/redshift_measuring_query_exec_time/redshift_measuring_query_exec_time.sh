#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

PG_HOST=${PG_HOST:-redshift-cluster-2.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
SQL_SCRIPT_ENV_INFO=${SQL_SCRIPT_ENV_INFO:-get_env_info.sql}
SQL_SCRIPT_QUERY_PERF=${SQL_SCRIPT_QUERY_PERF:-exec_query_perf.sql}
LOG_DIR=${LOG_DIR:-log}
LOG_SUFFIX_ENV_INFO=${LOG_SUFFIX_ENV_INFO:-env_info}
LOG_SUFFIX_QUERY_PERF=${LOG_SUFFIX_QUERY_PERF:-query_perf}

INSTANCE_IDENTIFIER=${PG_HOST%%.*}

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

aws redshift describe-clusters --cluster-identifier ${INSTANCE_IDENTIFIER} \
        > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${LOG_SUFFIX_ENV_INFO}.log" 2>&1

psql "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -a -f ${SQL_SCRIPT_ENV_INFO} \
        >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${LOG_SUFFIX_ENV_INFO}.log" 2>&1

psql "host=$PG_HOST user=$PG_USER dbname=$PG_DB port=$PG_PORT" -a -f ${SQL_SCRIPT_QUERY_PERF} \
        > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_${LOG_SUFFIX_QUERY_PERF}.log" 2>&1