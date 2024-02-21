#!/usr/bin/env bash
export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`

BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

mkdir -p logs


find cqls/ -type f -name 'ks_insert_*'|while read LINE
do
    for i in {1..23}
    do
        cqlsh cassandra.ap-northeast-1.amazonaws.com 9142 --ssl -f ${LINE} 2>&1 &
    done
done 
