#!/bin/sh

SLEEP_SEC=5
LOOP_MAX=100
COUNT=0

echo "conn system/manager"
echo "set heading off"
echo "set feedback off"
echo "set pagesize 9999"
echo "set linesize 2000"

while [ $COUNT -lt $LOOP_MAX ]
do
 echo "@outline2spm.sql"
 sleep $SLEEP_SEC
 COUNT=`expr $COUNT + 1`
done
