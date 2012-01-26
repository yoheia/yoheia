#!/usr/bin/bash
export LANG=C
TARGET_DIR=$1

if [ ! -d "${TARGET_DIR}" ]
then
	echo "Directory(${TARGET_DIR}) does not exist!"
	exit 1
fi

echo 'started ...'

find "${TARGET_DIR}" -type f -name '*.vmstat'|while read LINE
do
echo "${LINE} -> ${LINE}.txt"
perl -nle '$.==3 and print qq/date $_/;$.>1 and /^([\d:]+)/ and print qq/$d $l/;$d=$1;$l=$_' ${LINE} > ${LINE}.txt
done

echo 'finished!'
exit 0
