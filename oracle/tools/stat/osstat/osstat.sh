#!/bin/sh

LANG=C
export LANG
LC_ALL=C
export LC_ALL

IVAL=1
DURATION=60
DIR=`dirname $0`/log

PLATFORM=`uname`
COMMENT=$@

if [ ! -d ${DIR} ]
	then mkdir ${DIR}
fi

while :
do
	# date for filename
	DATE=`date '+%Y%m%d-%H%M%S'`

	# comment
	echo ${COMMENT} > ${DIR}/${DATE}.about.txt

	# netstat -na
	COUNT1=0
	while [ $COUNT1 -lt $DURATION ]
	do
		(echo `date '+%H:%M:%S'`;netstat -na) >> ${DIR}/${DATE}.netstat-na.log
		sleep $IVAL
		COUNT=`expr $COUNT1 + 1`
	done &

	# ps -ef
	COUNT2=0
	while [ $COUNT2 -lt $DURATION ]
	do
		(echo `date '+%H:%M:%S'`;ps -ef) >> ${DIR}/${DATE}.ps-ef.log
		sleep $IVAL
		COUNT=`expr $COUNT2 + 1`
	done &

	# vmstat
	vmstat ${IVAL} ${DURATION} | \
		while read line; do echo `date '+%H:%M:%S'` $line; done \
		> ${DIR}/${DATE}.vmstat.log &
	PID="$! ${PID}"

	# sar -b
	sar -b ${IVAL} ${DURATION} | \
		while read line; do echo `date '+%H:%M:%S'` $line; done \
		> ${DIR}/${DATE}.sar-b.log &
	PID="$! ${PID}"

	# sar -u
	sar -u ${IVAL} ${DURATION} | \
		while read line; do echo `date '+%H:%M:%S'` $line; done \
		> ${DIR}/${DATE}.sar-u.log &
	PID="$! ${PID}"

	# HP-UX
	case $PLATFORM in "HP-UX")
		# top -n <number of output lines> -s <interval> -d <count> 
		top -n 50 -s ${IVAL} -d ${DURATION} -f ${DIR}/${DATE}.top.log &
		# iostat
		iostat -t ${IVAL} ${DURATION} |\
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.iostat-t.log &
		PID="$! ${PID}"
		# sar -A
		sar -A ${IVAL} ${DURATION} |\
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.sar-A.log &
		PID="$! ${PID}"
		# netstat -s
		netstat -s > ${DIR}/${DATE}.netstat-s.log &
		PID="$! ${PID}"
	esac
	# Solaris
	case $PLATFORM in "SunOS")
		# prstat -n <number of output lines> <interval> <count>
		prstat -n 50 ${IVAL} ${DURATION} | \
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.prstat.log &
		# vmstat -p
		# -p: report paging activity in details.
		vmstat -p ${IVAL} ${DURATION} | \
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.vmstat-p.log &
		PID="$! ${PID}"
		# iostat
		# -x: Report extended disk statistics.
		# -n: disk names to display in the cXtYdZsN format.
		# -C:  When the -x option is also selected,  report extended  disk statistics aggregated by controller id.
		# -M: Display data throughput in MB/sec instead of KB/sec.
		# -m: Report file system mount points.
		# -p: For each disk, report per-partition  statistics in addition to per-device statistics.
		iostat -xnCMmp ${IVAL} ${DURATION} |\
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.iostat.log &
		PID="$! ${PID}"
		# mpstat
		mpstat ${IVAL} ${DURATION} |\
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.mpstat.log &
		PID="$! ${PID}"
		# netstat
		netstat -s ${IVAL} ${DURATION} |\
			while read line; do echo `date '+%H:%M:%S'` $line; done \
			> ${DIR}/${DATE}.netstat.log &
		PID="$! ${PID}"
	esac

	sleep ${DURATION}

done
