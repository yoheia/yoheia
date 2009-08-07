#!/bin/sh
 
IVAL=1
DURATION=60
DIR=./log
 
SH_PID=$$
PID=${SH_PID}
COMMENT=$@
 
if [ ! -d ${DIR} ]
then mkdir ${DIR}
fi
 
LANG=C; export LANG
LC_ALL=C; export LC_ALL
 
echo "Ctrl-C to stop this."
 
while :
do DATE=`date '+%Y%m%d-%H%M%S'`
 
echo ${COMMENT} > ${DIR}/${DATE}.about.txt
 
# network configurations
netstat -nr > ${DIR}/${DATE}.netstat-nr.log &
netstat -a > ${DIR}/${DATE}.netstat.log &
 
# process list
ps -ef > ${DIR}/${DATE}.ps-ef.log
 
# top -n <number of output lines> -s <interval> -d <count>
top -n 50 -s 1 -d 60 > ${DIR}/${DATE}.top.log &
 
# vmstat
vmstat ${IVAL} ${DURATION} > ${DIR}/${DATE}.vmstat.log &
PID="$! ${PID}" # $!: The PID of last process started in background 
 
# swapinfo
swapinfo -a > ${DIR}/${DATE}.swapinfo.log &
PID="$! ${PID}"
 
# iostat
iostat -t ${IVAL} ${DURATION} > ${DIR}/${DATE}.iostat.log &
PID="$! ${PID}"
 
# sar
sar -A ${IVAL} ${DURATION} > ${DIR}/${DATE}.sar.log &
PID="$! ${PID}"
 
# netstat
netstat -s > ${DIR}/${DATE}.netstat.log &
PID="$! ${PID}"

# kill process when Ctrl+c(signal 2) pressed
# The trap command argument is to be read  and  executed  when 
# the shell receives numeric or symbolic signal(s) (n).
trap "kill -9 ${PID}
echo 'script done' " 2
 
sleep ${DURATION}

 
PID=${SH_PID}

 
done
