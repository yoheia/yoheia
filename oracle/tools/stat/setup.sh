#!/bin/sh

echo "This is setup script. Run only once by root user."

if [ "$LOGNAME" != root ]
then
	echo Run by root user !
	exit
fi

echo 'Do you really run this script [yn]?: '
read RUN
if [ "$RUN" != y ]; then
	exit
fi

echo 'Enter oracle user name [oracle]: '
read ORACLE_USER
if [ -z "${ORACLE_USER}" ]; then
	ORACLE_USER=oracle
fi
export ORACLE_USER

BASE_DIR=`cd \`dirname $0\`;pwd`
chown -R ${ORACLE_USER}:oinstall ${BASE_DIR}
perl -i -pe 's/^(ORACLE_USER=)(.*)$/$1$ENV{ORACLE_USER}/' start_stat.sh end_stat.sh
find ${BASE_DIR} -name \*.sh | xargs chmod u+x
