#!/bin/sh

SLEEP_SEC=3
LOOP_MAX=1200
COUNT=0

echo "/ as sysdba"
echo "set heading off"
echo "set feedback off"
echo "set pagesize 9999"
echo "set linesize 2000"

while [ $COUNT -lt $LOOP_MAX ]
do
 echo "@seswait9.sql"
 sleep $SLEEP_SEC
 COUNT=`expr $COUNT + 1`
done
