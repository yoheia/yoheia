#!/bin/sh

ORACLE_USER=oracle
LANG=C
export LANG
BASE_DIR=`cd \`dirname $0\`;pwd`

# statspack: get snapshot
su - ${ORACLE_USER} -c "${BASE_DIR}/statspack/snap.sh" > /dev/null 2>&1 &

# statspack: output report to file
su - ${ORACLE_USER} -c "${BASE_DIR}/statspack/output_report.sh" > /dev/null 2>&1 &

# kill following processes
#  -osstat.sh
#  -exec_session_wait.sh
#  -session_wait.sh
#  -exec_sysstat.sh
#  -sysstat.sh
ps -ef|perl -lane '/[o]sstat.sh|[s]ession_wait.sh|[s]ysstat.sh/ and kill(SIGKILL, $F[1])'
