#!/bin/bash

export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)

bash ${BASE_DIR}/pgbench_wrapper.sh mydbinstance.cnaamhj3erpx.ap-northeast-1.rds.amazonaws.com mydb awsuser Password

