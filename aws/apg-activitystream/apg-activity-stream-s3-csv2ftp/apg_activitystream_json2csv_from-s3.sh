#!/bin/bash
export LANG=C

export S3_BUCKET='s3_bucke_name'
export S3_PREFIX='aws-rds-das-cluster-***'
export LOCAL_DIR='./log'
export CSV_DIR='./csv'
export KMS_KEY_ID='***-***-***-***--***'
export KINESIS_STREAM_NAME='aws-rds-das-cluster-***'
export REGEION='ap-northeast-1'
export APG_CLUSTER_ID='cluster-***'

python apg_activitystream_json2csv_from-s3.py
