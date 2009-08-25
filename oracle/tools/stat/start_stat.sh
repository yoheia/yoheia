#!/bin/sh

ORACLE_USER=oracle
LANG=C
export LANG
BASE_DIR=`cd \`dirname $0\`;pwd`

# get os statistics
${BASE_DIR}/osstat/osstat.sh > /dev/null 2>&1 &

# get info from v$session_wait
su - ${ORACLE_USER} -c "${BASE_DIR}/session_wait9/exec_session_wait.sh" > /dev/null 2>&1 &

# get info from v$sysstat
su - ${ORACLE_USER} -c "${BASE_DIR}/sysstat9/exec_sysstat.sh" > /dev/null 2>&1 &

# statspack: get snapshot
su - ${ORACLE_USER} -c "${BASE_DIR}/statspack/snap.sh" > /dev/null 2>&1 &
