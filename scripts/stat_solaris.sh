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
 
# prstat
# prstat -n <number of output lines> <interval> <count>
prstat -n 50 1 60 > ${DIR}/${DATE}.prstat.log &
 
# vmstat
vmstat ${IVAL} ${DURATION} > ${DIR}/${DATE}.vmstat.log &
PID="$! ${PID}" # $!: The PID of last process started in background 
 
# vmstat -p
# -p: report paging activity in details.
vmstat -p ${IVAL} ${DURATION} > ${DIR}/${DATE}.vmstat-p.log &
PID="$! ${PID}"
 
# iostat
# -x: Report extended disk statistics.
# -n: disk names to display in the cXtYdZsN format.
# -C:  When the -x option is also selected,  report extended  disk statistics aggregated by controller id.
# -M: Display data throughput in MB/sec instead of KB/sec.
# -m: Report file system mount points.
# -p: For each disk, report per-partition  statistics in addition to per-device statistics.
iostat -xnCMmp ${IVAL} ${DURATION} > ${DIR}/${DATE}.iostat.log &
PID="$! ${PID}"
 
# mpstat
mpstat ${IVAL} ${DURATION} > ${DIR}/${DATE}.mpstat.log &
PID="$! ${PID}"
 
# netstat
netstat -s ${IVAL} ${DURATION} > ${DIR}/${DATE}.netstat.log &
PID="$! ${PID}"

# kill process when Ctrl+c(signal 2) pressed
# The trap command argument is to be read  and  executed  when 
# the shell receives numeric or symbolic signal(s) (n).
trap "kill -9 ${PID}
echo 'script done' " 2
 
sleep ${DURATION}

 
PID=${SH_PID}

 
done
