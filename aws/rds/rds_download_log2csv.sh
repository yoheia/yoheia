#!/bin/bash
export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)
BASE_NAME=$(basename $0)
DB_INSTANCE_IDENTIFIER=$1
TARGET_DATE=$2

if [ -z "$DB_INSTANCE_IDENTIFIER" ]; then
        echo "usage: ${BASE_NAME} db_instance_identifier [target_date]"
        echo "example: ${BASE_NAME} aurora-postgres-116-instance-1 2020-04-01"
        exit 1
fi

if [ -z "$TARGET_DATE" ]; then
        TARGET_DATE=$(date --date "1 days ago" +%Y-%m-%d)
fi
export TARGET_DATE

set -u
OUTPUT="./log"
if [ ! -d ${OUTPUT} ]
        then mkdir ${OUTPUT}
fi

logs_json=`aws rds describe-db-log-files --db-instance-identifier ${DB_INSTANCE_IDENTIFIER}|jq '.DescribeDBLogFiles[]|select(.LogFileName|contains(env.TARGET_DATE))'|jq . -s`
len=$(echo $logs_json | jq length)
for i in $( seq 0 $(($len - 1)) )
do
        row=$(echo $logs_json | jq .[$i])
        logfilename=`echo $row | jq -r ".LogFileName"`
        size=`echo $row | jq -r ".Size"` 
        if [ ${size} -gt 1000000 ]; then
                echo "" 
                echo "WARN: ${logfilename} is over 1M ${size}. Please check this logfile is copmletion."
                echo ""
        else
                echo ${logfilename}
        fi

        # 保存用のファイル名用意
        savefile=`echo ${logfilename}| sed -e "s/\//-/g"`
    
        aws rds download-db-log-file-portion --db-instance-identifier ${DB_INSTANCE_IDENTIFIER} \
        --log-file-name ${logfilename} --starting-token 0 --output text \
        > ${OUTPUT}/${savefile}
    
        perl -lane '/(connection authorized|disconnection|password authentication failed)/ and print qq/"$F[0] $F[1]","$F[7]", "$F[2]"/' ${OUTPUT}/${savefile} >  ${OUTPUT}/${savefile}.csv
done