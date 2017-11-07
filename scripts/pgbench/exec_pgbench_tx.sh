#!/bin/bash

export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)
DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_NAME=$(basename $0)
STEM="${BASE_NAME%.*}"
LOG_DIR=log

bash ${BASE_DIR}/pgbench_wrapper.sh {hostname} mydb awsuser {password}

