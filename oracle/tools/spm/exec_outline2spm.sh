#!/bin/sh

LANG=C
export LANG
NLS_LANG=American_America.JA16EUC
export NLS_LANG

LOG_DIR=log
BASE_DIR=`dirname $0`

if [ ! -d "${BASE_DIR}/${LOG_DIR}" ]
then
	mkdir "${BASE_DIR}/${LOG_DIR}"
fi

cd ${BASE_DIR}
./outline2spm.sh | sqlplus /nolog > ${BASE_DIR}/${LOG_DIR}/exec_outline2spm-`date '+%Y-%m-%d-%H%M%S'`.log 2>&1 &

exit
