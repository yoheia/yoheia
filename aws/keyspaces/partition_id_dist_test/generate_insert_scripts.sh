#!/usr/bin/env bash
export LANG=C
BASE_DIR=$(cd $(dirname $0);pwd)

mkdir -p cqls

cat base_cdinsert.cql|while read LINE
do
	partition_id=`echo ${LINE}|perl -nle 's/^.*VALUES \((\d+),.*$/$1/g; printf("%07d",$_)'`
	for i in {1..10} ; do
    		echo ${LINE}
	done > "cqls/insert_${partition_id}.cql"
done

