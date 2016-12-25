#!/bin/bash

. ~/.oraenvsharedb1
LANG=ja_JP.UTF-8
NLS_LANG=Japanese_Japan.AL32UTF8

BASE_NAME=$(basename $0)
STEM="${BASE_NAME%.*}"
DATE=`date '+%Y-%m-%d-%H%M%S'`
LOG_DIR=log
LOG_FILE="${STEM}_${DATE}.log"

mkdir -p ${LOG_DIR}
sqlplus /nolog <<EOF >"log/${LOG_FILE}"
	conn / as sysdba
	@exec_all_get_53_46_xplan
	exit
EOF

TRACE_DIR=`sqlplus -s <<EOF
	conn as sysdba
	set heading off
	set sqlblanklines off
	set pagesize 0
	set trimout on
	select value from V\\$DIAG_INFO where name = 'Diag Trace';
	exit
EOF`

echo "cd ${LOG_DIR} && find . -type f  -mmin -5 -name '*.log' -ls"
cd ${LOG_DIR} && find . -type f  -mmin -5 -name '*.log' -ls

echo "cd ${TRACE_DIR} && find . -type f  -mmin -5 -regex '.*_\(46\|53\)_.*\.trc' -ls"
cd ${TRACE_DIR} && find . -type f  -mmin -5 -regex '.*_\(46\|53\)_.*\.trc' -ls
